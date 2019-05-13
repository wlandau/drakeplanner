all: inst/README.md

inst/README.md: README.md
	cp README.md inst/README.md

README.md: README.Rmd
	Rscript -e 'rmarkdown::render("README.Rmd", output_format = "github_document")'
	rm -rf README.html

clean:
	rm -rf README.html README.md inst/README.md
