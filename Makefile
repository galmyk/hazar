FC  := gfortran
LD  := gfortran

WARNS  := -Wall -Wextra
STD    := -std=f2003 -pedantic
FFLAGS := -g -fcheck=all -ffpe-trap=invalid,zero,overflow -ffpe-summary=denormal,underflow
LDFLAGS := -g -O0

ROOT_DIR  := $(shell pwd)
ORIG_DIR  := $(ROOT_DIR)/original
BUILD_DIR := build
REF_DIR   := $(BUILD_DIR)/reference

export

.PHONY: all
all: references

.PHONY: references
references: box file2ic seamount

.PHONY: box file2ic seamount
box file2ic seamount:
	@echo "build and run $@"
	mkdir -p $(REF_DIR)/$@
	make -C $(REF_DIR)/$@ -f $(ORIG_DIR)/Makefile $@

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
