.PHONY: default

# Configuration
PROJECT_NAME = quaireaux
ENTRYPOINT = .
TEST_ENTRYPOINT = .
BUILD_DIR = build

# Default target
default: test

# All relevant targets
all: build run test

# Targets

# Compile the project
build: FORCE
	$(MAKE) clean format
	@echo "Building..."
	cairo-compile . > $(BUILD_DIR)/$(PROJECT_NAME).sierra

# Run the project
run:
	@echo "Running..."
	# TODO: enable when sample main is ready
	#cairo-run -p $(ENTRYPOINT)

# Test the project
test:
	@echo "Testing everything..."
	cairo-test -p $(TEST_ENTRYPOINT)

test-data_structure:
	@echo "Testing data structures..."
	cairo-test -p $(TEST_ENTRYPOINT)/quaireaux/data_structure

test-math:
	@echo "Testing math"
	cairo-test -p $(TEST_ENTRYPOINT)/quaireaux/math

test-sorting:
	@echo "Testing sorting..."
	cairo-test -p $(TEST_ENTRYPOINT)/quaireaux/sorting

test-utils:
	@echo "Testing utils..."
	cairo-test -p $(TEST_ENTRYPOINT)/quaireaux/utils

# Special filter tests targets

# Run tests related to the stack
test-stack:
	@echo "Testing stack..."
	cairo-test -p $(TEST_ENTRYPOINT) -f stack

# Format the project
format:
	@echo "Formatting everything..."
	cairo-format --recursive quaireaux

# Clean the project
clean:
	@echo "Cleaning..."
	rm -rf $(BUILD_DIR)/*
	mkdir -p $(BUILD_DIR)


# FORCE is a special target that is always out of date
# It enable to force a target to be executed
FORCE: