# Moving Decision

We were considering moving to several places around the country. This program scrapes data from http://www.bestplaces.net/ for all the locations we were considering.

# Description

* `runAll.sh` is the shell script to run everything

* `scrapeAllData.py` collects all data from http://www.bestplaces.net/ and stores it as .csv files in the /data directory.

* `movingPlots.R` cleans all the data and produces plots in the \figures directory.

* `MovingDecision.Rmd` is an rMarkdown file that produces an .html page with some of the charts highlighted. To run this file from the command line: `Rscript.exe -e "rmarkdown::render('MovingDecision.Rmd')"`