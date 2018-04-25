all: proposal.pdf

proposal.pdf: proposal.tex $(wildcard *.sty) $(wildcard *.tex) $(wildcard *.bib)
	pdflatex -shell-escape proposal
	bibtex proposal -min-crossrefs=1000
	pdflatex -shell-escape proposal
	pdflatex -shell-escape proposal

clean:
	rm -f proposal.pdf proposal.bbl proposal.blg proposal.log proposal.out proposal.aux
.PHONY: clean

SPELLTEX := $(shell ./bin/get-tex-files.sh proposal.tex) proposal.bbl
spell:
	@ for i in $(SPELLTEX); do aspell -l en_us --mode=tex \
					  --add-tex-command="autoref p" \
					  -p ./aspell.words -c $$i; done
	@ for i in $(SPELLTEX); do perl bin/double.pl $$i; done
	@ for i in $(SPELLTEX); do perl bin/abbrv.pl  $$i; done
	@ bash bin/hyphens.sh $(SPELLTEX)
	@ ( head -1 aspell.words ; tail -n +2 aspell.words | LC_ALL=C sort ) > aspell.words~
	@ mv aspell.words~ aspell.words
.PHONY: spell
