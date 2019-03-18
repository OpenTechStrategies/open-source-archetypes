#!/bin/sh

### The upstream master version of this Makefile lives here:
### 
### https://github.com/OpenTechStrategies/ots-doctools/blob/master/ext-Makefile
### 
### A copy of this Makefile will often be included in a document
### source tree, because for people who build documents, it's very
### convenient to just run 'make' or 'make some_document_name.pdf' and
### have the desired thing happen.  This Makefile then just forwards
### all the action to the much more sophisticated Makefile found at
### ${OTS_DOCTOOLS_DIR}/Makefile.  Therefore, please try not to make
### changes here; instead, put any improvements in the other Makefile.

.PHONY: default check

# The order of the rules below is important; change only with care.

default: check
	@make -s -f ${OTS_DOCTOOLS_DIR}/Makefile

%: check
	@make -s -f ${OTS_DOCTOOLS_DIR}/Makefile $@

check:
	@if [ "${OTS_DOCTOOLS_DIR}X" = "X" ]; then                            \
           echo "";                                                           \
           echo "ERROR: Your OTS_DOCTOOLS_DIR env var is not set up yet.";    \
           echo "       Please see this repository for instructions:";        \
           echo "       https://github.com/OpenTechStrategies/ots-doctools."; \
           echo "";                                                           \
           exit 1;                                                            \
        fi
