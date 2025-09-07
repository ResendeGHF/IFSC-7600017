# Compiler
FC := gfortran

# Flags for strict Fortran 77 fixed-form (compile-only)
FFLAGS := -x f77 -std=legacy -ffixed-form -Wall -Wextra

LDFLAGS :=

# Directories
BUILD_DIR := build
SOURCE_DIR := src
#INCLUDES_DIR := includes
# FFLAGS += -I$(INCLUDES_DIR)

# All Fortran source files
SOURCES := $(wildcard $(SOURCE_DIR)/*.f77)

# Detect main source
MAIN_SOURCE := $(firstword $(wildcard $(SOURCE_DIR)/tarefa-*.f77))
MAIN_SOURCE := $(if $(MAIN_SOURCE),$(MAIN_SOURCE),$(firstword $(SOURCES)))

# Executable name
MAIN_BASE := $(notdir $(basename $(MAIN_SOURCE)))
MAIN_EXEC := $(if $(MAIN_BASE),$(MAIN_BASE).exe,program.exe)

# Objects
OBJECTS := $(patsubst $(SOURCE_DIR)/%.f77,$(BUILD_DIR)/%.o,$(SOURCES))

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

# Compile .f77 files to .o  (usa apenas FFLAGS)
$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.f77
	$(FC) $(FFLAGS) -c $< -o $@

# Link object files into the final executable (DONT USE -x f77/-ffixed-form HERE)
$(BUILD_DIR)/$(MAIN_EXEC): $(OBJECTS)
	$(FC) $(OBJECTS) $(LDFLAGS) -o $@

