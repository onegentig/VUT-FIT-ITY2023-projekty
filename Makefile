###############################################################################
#
# ITY-Projekt Makefile
# @author Onegen Something <xonege99@vutbr.cz>
#
###############################################################################

TARGET                 = proj2
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

format:
	vlna -l ${TARGET}.tex
	latexindent -w ${TARGET}.tex > /dev/null
	diff -sy --left-column ${TARGET}.tex ${TARGET}.te~ || true
	${RM} ${TARGET}.te~ ${TARGET}.bak0 indent.log

lint:
	chktex ${TARGET}.tex

clean:
	${RM} ${TARGET}.{aux,dvi,log,out,pdf,ps} compare.pdf ${ZIPNAME}

comp: all
	pdftk vzor.pdf multibackground ${TARGET}.pdf output compare.pdf

zip: ${ZIPNAME}
	zip -q -r ${ZIPNAME} *.tex Makefile
