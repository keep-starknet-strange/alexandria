#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."

cd "$PROJECT_ROOT"

REMOTE_URL="https://github.com/keep-starknet-strange/alexandria/"
DOC_SRC="target/doc/src"

# Generate markdown docs (without --build so we can customize before building)
scarb doc --workspace \
  --exclude alexandria_macros \
  --exclude alexandria_macros_tests \
  --remote-base-url "$REMOTE_URL"

# Detect sed in-place flag (macOS vs Linux)
if sed --version >/dev/null 2>&1; then
  SED_INPLACE=(sed -i)
else
  SED_INPLACE=(sed -i '')
fi

# Inject custom intro page
cp docs/intro.md "$DOC_SRC/intro.md"
"${SED_INPLACE[@]}" '1i\
[Introduction](./intro.md)
' "$DOC_SRC/SUMMARY.md"

# Remove core crate section (Cairo built-in, not excludable via --exclude)
"${SED_INPLACE[@]}" '/^- \[core\]/,/^- \[/{/^- \[core\]/d;/^- \[/!d;}' "$DOC_SRC/SUMMARY.md"

# Use our custom book.toml
cp docs/book.toml target/doc/book.toml

# Build mdBook
mdbook build target/doc

echo "Documentation generated at target/doc/book/index.html"
