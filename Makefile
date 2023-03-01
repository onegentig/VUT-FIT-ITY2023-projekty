###############################################################################
#
# ITY-Projekt Makefile
# @author Onegen Something <xonege99@vutbr.cz>
#
# Usage:
#   - `make` or `make all` to compile the PDF
#   - `make clean` to remove built PDF
#   - `make zip` to create a zip archive of the project
#   - `make help` to show Makefile usage
#
###############################################################################

TARGET                 = proj1
ZIPNAME                = xonege99.zip

LATEX                  = latex
DVIPS                  = dvips -t a4
PS2PDF                 = ps2pdf -sPAPERSIZE=a4

###############################################################################

.PHONY: all help clean zip lint format

all: ${TARGET}.pdf

${TARGET}.pdf: ${TARGET}.tex
	${LATEX} ${TARGET}.tex
	${LATEX} ${TARGET}.tex
	${DVIPS} ${TARGET}.dvi
	${PS2PDF} ${TARGET}.ps

help:
	@echo "ITY-Project 1"
	@echo "@author Onegen Something <xonege99@vutbr.cz>"
	@echo ""
	@echo "Usage: make [TARGET]"
	@echo "TARGETs:"
	@echo "  all     compile LaTeX to PDF (default)"
	@echo "  clean   clean compiled files"
	@echo "  zip     create a .zip archive with all sources"
	@echo "  help    print this message"

format:
	latexindent -w ${TARGET}.tex

lint:
	chktex ${TARGET}.tex

clean:
	${RM} ${TARGET}.{aux,dvi,log,ps,pdf} ${ZIPNAME}

zip: ${ZIPNAME}
	zip -q -r ${ZIPNAME} *.tex Makefile
