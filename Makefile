.PHONY: default

# Configuration
PROJECT_NAME = quaireaux
ENTRYPOINT = .
TEST_ENTRYPOINT = .
BUILD_DIR = build

# Default target
default: run

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
	cairo-run -p $(ENTRYPOINT)

# Test the project
test:
	@echo "Testing..."
	cairo-test -p $(TEST_ENTRYPOINT)

# Format the project
format:
	@echo "Formatting..."
	cairo-format src

# Clean the project
clean:
	@echo "Cleaning..."
	rm -rf $(BUILD_DIR)/*
	mkdir -p $(BUILD_DIR)

# Special filter tests targets

# Run tests related to the stack
test-stack:
	@echo "Testing stack..."
	cairo-test -p $(TEST_ENTRYPOINT) -f stack

# FORCE is a special target that is always out of date
# It enable to force a target to be executed
FORCE: