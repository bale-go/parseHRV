# parseHRV
R scripts for parsing and plotting the change in heart rate variability (HRV) statistics over multiple days.

They were tested with exported data from [EliteHRV](https://elitehrv.com/) and [Heart Rate Monitor](https://play.google.com/store/apps/details?id=com.bmi.hr_monitor) (BM innovations GmbH). 

[Heart Rate Monitor](https://play.google.com/store/apps/details?id=com.bmi.hr_monitor) is a simple application that can record heart rate and RR. It is a great choice if you do not want to expose your heart rate data to third parties. It works without Google Play Services and it does not require you to create an account.

[RHRV](https://rhrv.r-forge.r-project.org/) is utilized to calculate time-domain and frequency-domain statistics on the filtered RR data.

The generated heatmap calendar is based on Ryan Plant's implementation: https://ryanplant.netlify.app/post/calendar-heatmaps-in-ggplot/

# Installation
Ubuntu requires the installation of r-cran-rgl package. (`sudo apt-get install r-cran-rgl`)

Move R scripts (HRV_parse.R, HRV_cal.R) to the folder containing the exported txt or csv files. (e.g. export/x@email.com/)

R scripts will install the required R libraries ("RHRV", "lubridate", "tidyverse", "zoo", "viridis") on the first run. It might take a few minutes.

If Rscript complains about /R/site-library not being writable, run `R` from command line and in R run: `install.packages("RHRV", dependencies = TRUE)`

# Running the scripts
cd to the folder containing the exported txt or csv files and the R scripts (HRV_parse.R, HRV_cal.R).

Run the following command to parse the exported HRV files to csv file: 

`Rscript HRV_parse.R`

Or if you exported data from [Heart Rate Monitor](https://play.google.com/store/apps/details?id=com.bmi.hr_monitor): 

`Rscript HRV_parse.R HRmonitor`

The output (HRV_parsed.csv) will contain the HRV statistics (e.g. [eHRV](https://help.elitehrv.com/article/54-how-do-you-calculate-the-hrv-score), [HR](https://en.wikipedia.org/wiki/Heart_rate), [SDNN, pNN50, SDSD, rMSSD, IRRR, MADRR, TINN, HRVi, LF, HF, LFHF](https://rhrv.r-forge.r-project.org/tutorial/tutorial.pdf)) for each date. If multiple measurements were done on a given date, only the first one - the "Morning HRV reading" - is used.

Run the following command to create the heatmap calendar of rMSSD:

`Rscript HRV_cal.R HRV_parsed.csv rMSSD 10 80`

HRV_cal.R takes 4 arguements:
1. file name (e.g. HRV_parsed.csv)
1. name of one variable (e.g. eHRV, HR, SDNN, pNN50, SDSD, rMSSD, IRRR, MADRR, TINN, HRVi, LF, HF, LFHF)
1. min of range
1. max of range

# Heatmap calendar
![alt text](https://raw.githubusercontent.com/bale-go/parseHRV/main/rMSSD_plot.png "Heatmap calendar")
