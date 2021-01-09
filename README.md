# parseHRV
R scripts to parse and plot the change in heart rate variability (HRV) statistics over long time frames.

It was tested with exported data from Elite HRV. ([EliteHRV](https://elitehrv.com/))

[RHRV](https://rhrv.r-forge.r-project.org/) is utilized to calculate time-domain and frequency-domain statistics on the filtered RR data.

The generated heatmap calendar is based on Ryan Plant's implementation: https://ryanplant.netlify.app/post/calendar-heatmaps-in-ggplot/

# Installation
Ubuntu requires the installation of r-cran-rgl package. (`sudo apt-get install r-cran-rgl`)

Move R scripts (HRV_parse.R, HRV_cal.R) to the folder containing the exported txt files. (e.g. export/x@email.com/)

R scripts will install the required R libraries ("RHRV", "lubridate", "tidyverse", "zoo", "viridis") on the first run. It might take a few minutes.

If Rscript complains about /R/site-library not being writable, run `R` from command line and in R run: `install.packages("RHRV", dependencies = TRUE)`

# Running the scripts
cd to the folder containing the exported txt files and the R scripts (HRV_parse.R, HRV_cal.R).

Run the following command to parse the exported HRV files to csv file: 

`Rscript HRV_parse.R`

The output (HRV_parsed.csv) will contain the HRV statistics for each date. If multiple measurements were done on a given date, only the first one - the "Morning HRV reading" - is used.

Run the following command to create the heatmap calendar:

`Rscript HRV_cal.R HRV_parsed.csv rMSSD 10 80`

HRV_cal.R takes 4 arguements:
1. file name (e.g. HRV_parsed.csv)
1. name of one variable (e.g. eHRV, HR, SDNN, pNN50, SDSD, rMSSD, IRRR, MADRR, TINN, HRVi, LF, HF, LFHF)
1. min of range
1. max of range

# Heatmap calendar
![alt text](https://raw.githubusercontent.com/bale-go/parseHRV/main/rMSSD_plot.png "Heatmap calendar")
