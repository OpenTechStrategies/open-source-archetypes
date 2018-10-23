# This is a document-specific Makefile.  Matters that are specific to
# this doc can be put here.  More general LaTeX building targets can
# go in OTS_DOCTOOLS_DIR/Makefile, which this one calls.

# By default, we build all .ltx files in this dir
SOURCE=$(wildcard *.ltx)
TARGETS=$(SOURCE:.ltx=.pdf)

### Try to find ots-doctools directory.  We look in the current dir,
### then for a $OTS_DOCTOOLS_DIR environment variable, then for
### /usr/local/src/ots-doctools/.
ifneq ("$(wildcard ots-doctools)","")
OTS_DOCTOOLS_DIR = ots-doctools
else
ifneq ("$(wildcard /usr/local/src/ots-doctools)","")
OTS_DOCTOOLS_DIR = /usr/local/src/ots-doctools
endif
endif


# If we didn't find the OTS Latex stuff, grab it from GitHub
ifndef OTS_DOCTOOLS_DIR
$(shell git clone https://github.com/OpenTechStrategies/ots-doctools)
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

distclean: clean
	@# Remove ots-doctools clone unless it has been modified.
	@(ots_doctools_is_clean="maybe";                                      \
          if [ -d ots-doctools ]; then                                        \
            cd ots-doctools;                                                  \
            if res=$$(git status --porcelain) && [ -z "$${res}" ]; then       \
              ots_doctools_is_clean="yes";                                    \
            else                                                              \
              ots_doctools_is_clean="no";                                     \
            fi;                                                               \
            cd ..;                                                            \
            if [ "$${ots_doctools_is_clean}" = "yes" ]; then                  \
              rm -rf ots-doctools;                                            \
            elif [ "$${ots_doctools_is_clean}" = "no" ]; then                 \
              echo "WARNING: 'ots-doctools' modified, so leaving it" >&2;     \
            elif [ "$${ots_doctools_is_clean}" = "maybe" ]; then              \
              echo "ERROR: 'ots_doctools_is_clean' still undetermined" >&2;   \
              exit 1;                                                         \
            else                                                              \
              echo "ERROR: Weird value for 'ots_doctools_is_clean'" >&2;      \
              exit 1;                                                         \
            fi;                                                               \
          fi;                                                                 \
        )

