# -*- Makefile -*-
#
# $Id$
#
TARGETS = $(patsubst %.tex,%.pdf,slides.tex)
TARGETS_NOEXT = $(patsubst %.pdf,%,$(TARGETS))
DEPS_DIR = .deps
LATEXMK = latexmk -recorder -xelatex -dvi- -ps- -use-make -deps

all: $(TARGETS)

define pdfrule
$(1).pdf: $(1).tex
	test -e $$(DEPS_DIR) || mkdir $$(DEPS_DIR)
	$$(LATEXMK) -xelatex -dvi- -ps- -deps-out=$$(DEPS_DIR)/$$@P $$<
	sed -i -e '/\.out\\$$//d;/^[ ]\+\/usr\//d;/^[ ]\+\/var\//d' $$(DEPS_DIR)/$$@P
endef

$(foreach file,$(TARGETS),$(eval -include $(DEPS_DIR)/$(file)P))

$(foreach file,$(TARGETS_NOEXT),$(eval $(call pdfrule,$(file))))

clean:
	-latexmk -C $(TARGETS_NOEXT)
	rm -rf *.nav *.vrb *.snm *~

.PHONY: clean all
