#!/bin/bash

python scrapeAllData.py
Rscript.exe movingPlots.R
Rscript.exe -e "rmarkdown::render('MovingDecision.Rmd')"