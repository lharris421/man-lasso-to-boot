R_SCRIPTS := $(wildcard ./fig/*.R)
FIG_FILES := $(shell for script in $(R_SCRIPTS); do fig/target $$script || exit 1; done)
TAB_SCRIPTS := $(wildcard ./tab/*.R)
TAB_FILES := $(patsubst %.R,%.tex,$(TAB_SCRIPTS))

# Make tables
%.tex: %.R
	@Rscript $< > /dev/null 2>&1

# Make figures
%.pdf: %.R
	@Rscript $< > /dev/null 2>&1
%.png: %.R
	@Rscript $< > /dev/null 2>&1

# Make document
lasso-to-boot.pdf: lasso-to-boot.tex main.tex $(FIG_FILES) $(TAB_FILES)
	cleantex -btq lasso-to-boot.tex
