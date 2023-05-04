###############################################################################
#
# ITY-Projekt Makefile
# @author Filip J. Kramec <xkrame00@vutbr.cz>
#
###############################################################################

TARGET                 = proj4
ZIPNAME                = xkrame00.zip

LATEX                  = latex
BIB                    = bibtex
DVIPS                  = dvips -t a4
PS2PDF                 = ps2pdf -sPAPERSIZE=a4

RM                     = rm -f

###############################################################################

.PHONY: format lint clean

all: ${TARGET}.pdf

${TARGET}.pdf: ${TARGET}.tex
	${LATEX} ${TARGET}.tex
	${BIB} $(TARGET).aux
	${LATEX} ${TARGET}.tex
	${LATEX} ${TARGET}.tex
	${DVIPS} ${TARGET}.dvi
	${PS2PDF} ${TARGET}.ps

lint:
	chktex ${TARGET}.tex

format:
	vlna -l ${TARGET}.tex
	latexindent -w ${TARGET}.tex > /dev/null
	diff -sy --left-column ${TARGET}.tex ${TARGET}.te~ || true
	${RM} ${TARGET}.te~ ${TARGET}.bak0 indent.log

clean:
	${RM} ${TARGET}.{aux,dvi,log,out,pdf,ps,bbl,blg,run.xml} ${TARGET}-blx.bib compare.pdf

zip: ${ZIPNAME}
	zip -q -r ${ZIPNAME} ${TARGET}.tex ${TARGET}.bib Makefile
