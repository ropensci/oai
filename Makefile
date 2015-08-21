all: move rmd2md

move:
		cp inst/vign/oai_vignette.md vignettes

rmd2md:
		cd vignettes;\
		mv oai_vignette.md oai_vignette.Rmd
