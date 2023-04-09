###############################################################################
#
# ITY-Projekt Makefile
# @author Onegen Something <xonege99@vutbr.cz>
#
###############################################################################

TARGET                 = proj4

LATEX                  = latex
BIB                    = bibtex
DVIPS                  = dvips -t a4
PS2PDF                 = ps2pdf -sPAPERSIZE=a4

RM                     = rm -f
CP 			        = cp -vr

###############################################################################

.PHONY: format lint clean assets unasset

# Vzdialený build (idk why ale LaTeX mi doma tvorí o niečo iný output)
REMOTE_HOST            = ${VUT_XLOGIN}@merlin.fit.vutbr.cz
REMOTE_CONN            = sshpass -f ${VUT_PTPASS}
# Príkazy ssh na vzdialený build nejako niekedy nenačítajú PATH, takže tu
# je workaround (použiť absolutnu cestu, ale len keď je treba).
HOST                   = ${shell hostname}
ifeq (${HOST},merlin.fit.vutbr.cz)
	ifneq (${PROFILE_DONE},yes)
		LATEX        := /usr/local/share/texlive/bin/${LATEX} \
			-interaction=batchmode 
		DVIPS        := /usr/local/share/texlive/bin/${DVIPS} -q
	endif
else ifeq (${HOST},ongn-zetaxi270)
# Menší clutter
# @see https://gitlab.com/jirislav/pdftex-quiet
	LATEX             := pdflatex-quiet -output-format=dvi
endif

# Assets
ASSETS                 = ${shell ls assets/${TARGET}}
ifeq (${ASSETS},)
	CP 			   = true
endif

###############################################################################

${TARGET}.pdf: ${TARGET}.tex
	${LATEX} ${TARGET}.tex
	${BIB} $(TARGET).aux
	${LATEX} ${TARGET}.tex
	${LATEX} ${TARGET}.tex
	${DVIPS} ${TARGET}.dvi
	${PS2PDF} ${TARGET}.ps

remote: ${TARGET}.tex
	${REMOTE_CONN} rsync -qrauz assets/${TARGET} \
		${REMOTE_HOST}:~/dev/ity/assets
	@${REMOTE_CONN} rsync -azvhP ${TARGET}.tex Makefile \
		${REMOTE_HOST}:~/dev/ity
	${REMOTE_CONN} ssh ${REMOTE_HOST} "make -C dev/ity clean -s && \
		make -C dev/ity assets -s && \
		make -C dev/ity -s"
	@${REMOTE_CONN} rsync -auvzhP ${REMOTE_HOST}:~/dev/ity/${TARGET}.** .

# Jednodušší (priamy) compare:
# (krajší výstup, ale je nutné manuálne zmeniť farbu v LaTeXe)
#
# compare: ${TARGET}.pdf
# 	pdftk ${TARGET}.pdf multistamp vzor.pdf output compare.pdf
#
# Zložitejší (PopplerUtils & ImageMagick) compare:
compare: ${TARGET}.pdf
	pdftoppm ${TARGET}.pdf cpage -png
	for file in cpage-*.png; do \
		convert "$$file" -fuzz 85% -fill blue -opaque black "$$file"; \
	done
	convert $$(ls cpage-*.png | sort -V) ${TARGET}-blue.pdf
	${RM} cpage-*.png
	pdftk ${TARGET}-blue.pdf multistamp vzor.pdf output compare.pdf
	${RM} ${TARGET}-blue.pdf

lint:
	chktex ${TARGET}.tex

format:
	vlna -l ${TARGET}.tex
	latexindent -w ${TARGET}.tex > /dev/null
	diff -sy --left-column ${TARGET}.tex ${TARGET}.te~ || true
	${RM} ${TARGET}.te~ ${TARGET}.bak0 indent.log

clean: unasset
	${RM} ${TARGET}.{aux,dvi,log,out,pdf,ps,bbl,blg,run.xml} ${TARGET}-blx.bib compare.pdf

# Assets - pretože som moc tvrdohlavý na to robiť podadresáre
# pre každý projekt. :>

assets:
	${CP} assets/${TARGET}/** .

unasset:
	${RM} -r ${ASSETS}
