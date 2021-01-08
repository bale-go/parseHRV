#parse arguments
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=4) {
  stop("At least four arguments must be supplied: file name, name of one variable (e.g. eHRV, HR, SDNN, pNN50, SDSD, rMSSD, IRRR, MADRR, TINN, HRVi, LF, HF, LFHF), min of range, max of range", call.=FALSE)
} 

#install required packages
list.of.packages <- c("lubridate","tidyverse","zoo","viridis")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


library(tidyverse)
library(lubridate)
library(scales)
library(zoo)
library(viridis)

#load file into data frame
hrvcal = read.table(args[1],header = T, sep =",")
hrv1 <- as.data.frame(hrvcal)
hrv1_df <- fortify.zoo(hrv1)

#calculate pdf dimensions
datepre <- gsub('.{6}$', '',hrv1_df$date)
datepre <- as.numeric(datepre)
years <- max(datepre) - min(datepre) + 1
pdf(paste(args[2],"_plot.pdf",sep=""),width=18, height=3*years)

#create calendar heatmap, based on Ryan Plant's implementation https://ryanplant.netlify.app/post/calendar-heatmaps-in-ggplot/
hrv1_df %>%
  mutate(dateas = as.Date(date,"%Y-%m-%d"),
         year = year(dateas),
         month = month(dateas, label = TRUE),
         wkday = fct_relevel(wday(dateas, label=TRUE),
                             c("Mon", "Tue","Wed","Thu","Fri","Sat","Sun")
                             ),
         day = day(dateas),
         wk = format(dateas, "%W"),
         value = (eval(as.symbol(args[2])))) %>%
  select(year, month, wkday, day, wk, value) %>% 
    ggplot(aes(wk, wkday, fill=value)) +
      geom_tile(color='black') +
      geom_text(aes(label=day), size=3) + 
      labs(x='', 
           y='',
           title=args[2]) +
      scale_fill_viridis(limits=c(strtoi(args[3]), strtoi(args[4])),
                         na.value = 'white',
                         direction = 1) +
      theme(panel.background = element_blank(),
            axis.ticks = element_blank(),
            axis.text.x = element_blank(),
            strip.background = element_rect("grey92"),
            aspect.ratio = 1
            ) +
      facet_grid(year~month, scales="free", space="free")
dev.off()


