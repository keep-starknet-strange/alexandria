.PHONY: default

# Configuration
ROOT_PROJECT = .
PROJECT_NAME = alexandria
BUILD_DIR = build

# Default target
default: test

# All relevant targets
all: build run test

TEST = cairo-test --starknet

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
	#cairo-run $(ROOT_PROJECT)

# Test the project
test:
	@echo "Testing everything..."
	$(TEST) $(ROOT_PROJECT)

test-data_structures:
	@echo "Testing data structures..."
	$(TEST) $(ROOT_PROJECT) --filter data_structures

test-encoding:
	@echo "Testing encoding..."
	$(TEST) $(ROOT_PROJECT) --filter encoding

test-linalg:
	@echo "Testing linalg"
	$(TEST) $(ROOT_PROJECT) --filter linalg

test-math:
	@echo "Testing math"
	$(TEST) $(ROOT_PROJECT) --filter math

test-numeric:
	@echo "Testing numeric"
	$(TEST) $(ROOT_PROJECT) --filter numeric

test-storage:
	@echo "Testing storage"
	cairo-test --starknet $(PROJECT_NAME)/storage

test-sorting:
	@echo "Testing sorting..."
	$(TEST) $(ROOT_PROJECT) --filter sorting

test-searching:
	@echo "Testing searching..."
	$(TEST) $(ROOT_PROJECT) --filter searching

test-storage: 
	@echo "Testing storage..."
	$(TEST) $(ROOT_PROJECT) --filter storage

# Special filter tests targets

# Run tests related to the stack
test-stack:
	@echo "Testing stack..."
	cairo-test $(ROOT_PROJECT) -f stack

# Format the project
format:
	@echo "Formatting everything..."
	cairo-format --recursive --print-parsing-errors $(ROOT_PROJECT)

# Check the formatting of the project
check-format:
	@echo "Checking formatting..."
	cairo-format --recursive --check $(ROOT_PROJECT)

# Clean the project
clean:
	@echo "Cleaning..."
	rm -rf $(BUILD_DIR)/*
	mkdir -p $(BUILD_DIR)


# FORCE is a special target that is always out of date
# It enable to force a target to be executed
FORCE:
