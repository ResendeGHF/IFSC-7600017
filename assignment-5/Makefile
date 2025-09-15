# Compiler
FC := gfortran

# Fortran 77 fixed-form compile flags (compile-time only)
FFLAGS := -x f77 -std=legacy --pedantic -ffixed-form -fno-automatic -fno-implicit-none -Wall -Wextra

# Linker flags (keep compile-time flags OUT of here)
LDFLAGS :=

# Directories
BUILD_DIR := build
SOURCE_DIR := src
#INCLUDES_DIR := includes
#FFLAGS += -I$(INCLUDES_DIR)

# Sources / objects / executables (1:1 mapping)
SOURCES      := $(wildcard $(SOURCE_DIR)/*.f77)
OBJECTS      := $(patsubst $(SOURCE_DIR)/%.f77,$(BUILD_DIR)/%.o,$(SOURCES))
EXECUTABLES  := $(patsubst $(SOURCE_DIR)/%.f77,$(BUILD_DIR)/%.exe,$(SOURCES))

# Default program to run (first source). Override: make run PROG=name
DEFAULT_PROG := $(basename $(notdir $(firstword $(SOURCES))))
PROG ?= $(DEFAULT_PROG)

.PHONY: all run clean list

# Build everything: one exe per source
all: $(BUILD_DIR) $(EXECUTABLES)

# Helpful listing
list:
	@echo "Sources:     $(SOURCES)"
	@echo "Objects:     $(OBJECTS)"
	@echo "Executables: $(EXECUTABLES)"

# Run a specific program
run: $(BUILD_DIR)/$(PROG).exe
	./$< $(ARGS)

# Clean
clean:
	rm -rf $(BUILD_DIR)

# Ensure build dir exists
$(BUILD_DIR):
	mkdir -p $@

# Compile each .f77 to its own .o (compile-only flags here)
$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.f77 | $(BUILD_DIR)
	$(FC) $(FFLAGS) -c $< -o $@

# Link each .o to its own .exe (DO NOT use compile-time flags here)
$(BUILD_DIR)/%.exe: $(BUILD_DIR)/%.o
	$(FC) $< $(LDFLAGS) -o $@

