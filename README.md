# parseHRV
R scripts to parse and plot heart rate variability (HRV) data.

It was tested on exported data from Elite HRV.

[RHRV](https://rhrv.r-forge.r-project.org/) is utilized to calculate time-domain and frequency-domain statistics on the filtered RR data.

The generated heatmap calendar is based on Ryan Plant's implementation: https://ryanplant.netlify.app/post/calendar-heatmaps-in-ggplot/

# Installation
Ubuntu requires the r-cran-rgl package. (sudo apt-get install r-cran-rgl)
Move the R scripts to the folder containing the exported txt files. (e.g. export/x@email.com/)

# Running the scripts
cd to the folder containing the exported txt files.

In order to parse the exported HRV files in a csv file run:
'Rscript HRV_parse.R'

To create a heatmap calendar run:
'Rscript HRV_cal.R file2.csv rMSSD 10 80'

HRV_cal takes 4 arguements:
1. file name
1. name of one variable (e.g. eHRV, HR, SDNN, pNN50, SDSD, rMSSD, IRRR, MADRR, TINN, HRVi, LF, HF, LFHF)
1. min of range
1. max of range

