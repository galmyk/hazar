FFLAGS  += -std=legacy -w

.PHONY: all
all: box file2ic seamount

box file2ic seamount: pom2k.f pom2k.c pom2k.n
	cp $(ORIG_DIR)/grid.$@ grid
	cp $(ORIG_DIR)/params.$@ params
	$(LD) $(FFLAGS) -o $@ $<
	./$@ > pom2k.out

file2ic: $(ORIG_DIR)/IC.dat
	cp $< fort.40

pom2k.c pom2k.f pom2k.n:
	cp $(ORIG_DIR)/$@ .
