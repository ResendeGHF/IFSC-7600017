# Compiler
FC := gfortran

# Flags for strict Fortran 77 fixed-form
FFLAGS = -x f77 -std=legacy -ffixed-form -Wall -Wextras

# Directories
BUILD_DIR := build
SOURCE_DIR := src
INCLUDES_DIR := includes

# Detect the main source file matching the pattern
MAIN_SOURCE := $(wildcard $(SOURCE_DIR)/tarefa-*-11223344.f77)
MAIN_BASE := $(notdir $(basename $(MAIN_SOURCE)))
MAIN_EXEC := $(MAIN_BASE).exe

# All Fortran source files
SOURCES := $(wildcard $(SOURCE_DIR)/*.f77)
OBJECTS := $(patsubst $(SOURCE_DIR)/%.f77,$(BUILD_DIR)/%.o,$(SOURCES))

# Include path if needed
FFLAGS := $(FFLAGS) -I$(INCLUDES_DIR)

# Phony targets
.PHONY: all run clean

# Build all
all: $(BUILD_DIR) $(BUILD_DIR)/$(MAIN_EXEC)

# Run the program
run: all
	./$(BUILD_DIR)/$(MAIN_EXEC) $(ARGS)

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)

# Create build directory
$(BUILD_DIR):
	mkdir -p $@

# Compile .f77 files to .o
$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.f77
	$(FC) $(FFLAGS) -c $< -o $@

# Link object files into the final executable
$(BUILD_DIR)/$(MAIN_EXEC): $(OBJECTS)
	$(FC) $(FFLAGS) $(OBJECTS) -o $@

