.PHONY: default

# Configuration
PROJECT_NAME = quaireaux
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
	#cairo-run -p $(PROJECT_NAME)

# Test the project
test:
	@echo "Testing everything..."
	cairo-test $(PROJECT_NAME)

test-data_structures:
	@echo "Testing data structures..."
	cairo-test $(PROJECT_NAME)/data_structures

test-math:
	@echo "Testing math"
	cairo-test $(PROJECT_NAME)/math

test-sorting:
	@echo "Testing sorting..."
	cairo-test $(PROJECT_NAME)/sorting

test-utils:
	@echo "Testing utils..."
	cairo-test $(PROJECT_NAME)/utils

# Special filter tests targets

# Run tests related to the stack
test-stack:
	@echo "Testing stack..."
	cairo-test $(PROJECT_NAME) -f stack

# Format the project
format:
	@echo "Formatting everything..."
	cairo-format --recursive --print-parsing-errors $(PROJECT_NAME)

# Check the formatting of the project
check-format:
	@echo "Checking formatting..."
	cairo-format --recursive --check $(PROJECT_NAME)

# Clean the project
clean:
	@echo "Cleaning..."
	rm -rf $(BUILD_DIR)/*
	mkdir -p $(BUILD_DIR)


# FORCE is a special target that is always out of date
# It enable to force a target to be executed
FORCE: