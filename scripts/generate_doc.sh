#!/bin/bash

#######################################
##to be executed in scripts folder#####
#######################################

set -e  # Exit immediately if a command exits with a non-zero status

# Get the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."
SCARB_TOML="$PROJECT_ROOT/Scarb.toml"
BACKUP_TOML="$PROJECT_ROOT/Scarb.toml.bak"

# Backup the original Scarb.toml
cp "$SCARB_TOML" "$BACKUP_TOML"

# Remove the "packages/macros" line from the workspace members
awk '
  BEGIN { skip=0 }
  /^\[workspace\]/ { in_workspace=1 }
  in_workspace && /^\[/ && !/^\[workspace\]/ { in_workspace=0 }
  in_workspace && /"packages\/macros"/ { next }
  { print }
' "$BACKUP_TOML" > "$SCARB_TOML"

# Run scarb doc from project root
cd "$PROJECT_ROOT"
scarb doc

# Restore original Scarb.toml
mv "$BACKUP_TOML" "$SCARB_TOML"

echo "✅ Documentation generated"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
DOC_ROOT="$PROJECT_ROOT/target/doc"
SUMMARY_BOOK="$PROJECT_ROOT/book"
SUMMARY_SRC="$SUMMARY_BOOK/src"
SUMMARY_MD="$SUMMARY_SRC/SUMMARY.md"

echo "🛠️ Generating unified Alexandria docs..."

rm -rf "$SUMMARY_BOOK"
mkdir -p "$SUMMARY_SRC"

# Initialize mdBook if needed
if [ ! -f "$SUMMARY_BOOK/book.toml" ]; then
    mdbook init --force book
    echo "[output.html.fold]" >> "$SUMMARY_BOOK/book.toml"
    echo "enable = true    # whether or not to enable section folding" >> "$SUMMARY_BOOK/book.toml"
    echo "level = 0         # the depth to start folding" >> "$SUMMARY_BOOK/book.toml"
    cd "$PROJECT_ROOT"
fi

echo "# Alexandria Standard Library" > "$SUMMARY_MD"
echo "" >> "$SUMMARY_MD"

for pkg_dir in "$PROJECT_ROOT"/packages/*; do
    [ -d "$pkg_dir" ] || continue
    pkg_name=$(basename "$pkg_dir")

    #skip macro package
    if [ "$pkg_name" = "macros" ]; then
        echo "⏭️ Skipping macros"
        continue
    fi

    echo "📦 Processing $pkg_name..."
    SRC_DIR="$DOC_ROOT/alexandria_$pkg_name/src"
    DEST_DIR="$SUMMARY_SRC/$pkg_name"
    PKG_SUMMARY="$SRC_DIR/SUMMARY.md"

    if [ -d "$SRC_DIR" ]; then
        mkdir -p "$DEST_DIR"
        cp "$SRC_DIR"/*.md "$DEST_DIR/"

        echo "" >> "$SUMMARY_MD"
        echo "## $pkg_name" >> "$SUMMARY_MD"
        # Add main link to sub-summary
        echo "- [$pkg_name]($pkg_name/SUMMARY.md)" >> "$SUMMARY_MD"
        if [ -f "$PKG_SUMMARY" ]; then
            while IFS= read -r line; do
                
              # Skip the "# Summary" line
                if [[ "$line" == "# Summary" ]]; then
                    continue
                fi

                # Replace ./ with package-prefixed paths
                if [[ "$line" =~ \[.*\]\(\.\/(.*)\) ]]; then
                    line=$(echo "$line" | sed -E "s|\(\.\/|\($pkg_name/|g")
                fi

                 # Add 4-space indentation unless it's an empty line
                if [[ -n "$line" ]]; then
                    echo "    $line" >> "$SUMMARY_MD"
                else
                    echo "" >> "$SUMMARY_MD"
                fi

            done < "$PKG_SUMMARY"
        else
            echo "⚠️ No SUMMARY.md found for $pkg_name"
        fi
    else
        echo "⚠️ No docs found for $pkg_name"
    fi
done

cd "$SUMMARY_BOOK"
mdbook build
echo "Open $SUMMARY_BOOK/book/index.html to see generated documentation"