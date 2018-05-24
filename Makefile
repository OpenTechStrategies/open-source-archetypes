# This is a document-specific Makefile.  Matters that are specific to
# this doc can be put here.  More general LaTeX building targets can
# go in OTS_DOCTOOLS_DIR/Makefile, which this one calls.

# By default, we build all .ltx files in this dir
SOURCE=$(wildcard *.ltx)
TARGETS=$(SOURCE:.ltx=.pdf)

### Try to find ots-doctools directory.  We look in the current dir, then
### for a $OTS_DOCTOOLS_DIR environment variable, then $OTSDIR/forms/latex,
### then ~/OTS/forms/latex, then /usr/local/src/ots-doctools
# If there's a local ots-doctools dir, use it
ifneq ("$(wildcard ots-doctools)","")
OTS_DOCTOOLS_DIR = ots-doctools
else
# Otherwise maybe one's defined in the environment
ifndef OTS_DOCTOOLS_DIR
ifneq ("$(wildcard $(OTSDIR)/forms/latex)","")
OTS_DOCTOOLS_DIR = $(OTSDIR)/forms/latex
else
ifneq ("$(wildcard ~/OTS/forms/latex)","")
OTS_DOCTOOLS_DIR = ~/OTS/forms/latex
else
ifneq ("$(wildcard /usr/local/src/ots-doctools)","")
OTS_DOCTOOLS_DIR = /usr/local/src/ots-doctools
endif
endif
endif
endif
endif


# If we didn't find the OTS Latex stuff, grab it from GitHub
ifndef OTS_DOCTOOLS_DIR
$(shell git submodule add https://github.com/OpenTechStrategies/ots-doctools)
OTS_DOCTOOLS_DIR=ots-doctools
endif

all: DEPS ${TARGETS}

# Handle OTS dependencies
.PHONY: DEPS
DEPS: otsreport.cls ots.sty otslogo.pdf

otsreport.cls: $(OTS_DOCTOOLS_DIR)/otsreport.cls
	ln -s $(OTS_DOCTOOLS_DIR)/otsreport.cls

ots.sty:  $(OTS_DOCTOOLS_DIR)/ots.sty
	ln -s $(OTS_DOCTOOLS_DIR)/ots.sty

otslogo.pdf:  $(OTS_DOCTOOLS_DIR)/otslogo.pdf
	ln -s $(OTS_DOCTOOLS_DIR)/otslogo.pdf

# Use the OTS-DOCTOOLS Makefile to turn .ltx into .pdf files
%.pdf: %.ltx
	$(MAKE) -f ${OTS_DOCTOOLS_DIR}/Makefile $@

clean:
	rm -f otsreport.cls ots.sty otslogo.pdf
	@# Delete PDFs that we do not care enough about to check into the repo
	@$(foreach x,${TARGETS}, git status -s ${x} | grep -q "M ${x}" || rm -f ${x};)
	$(MAKE) -f ${OTS_DOCTOOLS_DIR}/Makefile clean
	@# Remove ots-doctools submodule
	git submodule deinit -f ots-doctools
	rm -rf .git/modules/ots-doctools
	git rm -f ots-doctools
