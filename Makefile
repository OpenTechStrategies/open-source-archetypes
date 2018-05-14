# This is a document-specific Makefile.  Matters that are specific to
# this doc can be put here.  More general LaTeX building targets can
# go in OTSLTXDIR/Makefile, which this one calls.

# By default, we build all .ltx files in this dir
SOURCE=$(wildcard *.ltx)
TARGETS=$(SOURCE:.ltx=.pdf)

### Try to find otsltx directory.  We look in the current dir, then
### for a $OTSLTXDIR environment variable, then $OTSDIR/forms/latex,
### then ~/OTS/forms/latex, then /usr/local/src/otsltx
# If there's a local otsltx dir, use it
ifneq ("$(wildcard otsltx)","")
OTSLTXDIR = otsltx
else
# Otherwise maybe one's defined in the environment
ifndef OTSLTXDIR
ifneq ("$(wildcard $(OTSDIR)/forms/latex)","")
OTSLTXDIR = "$(OTSDIR)/forms/latex"
else
ifneq ("$(wildcard ~/OTS/forms/latex)","")
OTSLTXDIR = "~/OTS/forms/latex"
else
ifneq ("$(wildcard /usr/local/src/otsltx)","")
OTSLTXDIR = "/usr/local/src/otsltx"
endif
endif
endif
endif
endif

# If we didn't find the OTS Latex stuff, grab it from GitHub
ifndef OTSLTXDIR
$(shell git submodule add https://github.com/OpenTechStrategies/otsltx)
OTSLTXDIR=otsltx
endif

all: DEPS ${TARGETS}

# Handle OTS dependencies
.PHONY: DEPS
DEPS: otsreport.cls ots.sty otslogo.pdf

otsreport.cls: $(OTSLTXDIR)/otsreport.cls
	ln -s $(OTSLTXDIR)/otsreport.cls

ots.sty:  $(OTSLTXDIR)/ots.sty
	ln -s $(OTSLTXDIR)/ots.sty

otslogo.pdf:  $(OTSLTXDIR)/otslogo.pdf
	ln -s $(OTSLTXDIR)/otslogo.pdf

# Use the OTSLTX Makefile to turn .ltx into .pdf files
%.pdf: %.ltx
	$(MAKE) -f ${OTSLTXDIR}/Makefile $@

clean:
	rm -f otsreport.cls ots.sty otslogo.pdf
	@# Delete PDFs that we do not care enough about to check into the repo
	@$(foreach x,${TARGETS}, git status -s ${x} | grep -q "M ${x}" || rm -f ${x};)
	$(MAKE) -f ${OTSLTXDIR}/Makefile clean
	@# Remove otsltx submodule
	git submodule deinit -f otsltx
	rm -rf .git/modules/otsltx
	git rm -f otsltx
