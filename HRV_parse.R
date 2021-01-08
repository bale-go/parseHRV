#install required packages
list.of.packages <- c("RHRV")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, dependencies = TRUE)

library(RHRV)

#load file into data frame
fli <- list.files(path = ".", pattern = "txt")
lenfli <- length(fli)


#use only the first measurement of the day
odate <- c(0)
vector <- c()
fdate <- gsub('.{9}$', '',gsub('.{4}$', '',fli)) #get date
for (i in 1:lenfli) {
    if (fdate[i]>odate) {
        vector <- c(vector,i)
        odate <- fdate[i]
        }
    }
lenvector <- length(vector)

mat <- matrix(0, lenvector, 15)
colnames(mat) <- c("date","time","eHRV","HR","SDNN","pNN50","SDSD","rMSSD","IRRR","MADRR","TINN","HRVi","LF","HF","LFHF")

# calculate time-domain and frequency-domain statistics on the filtered RR data
for (i in 1:lenvector) {
    hrv.data = CreateHRVData()
    hrv.data = SetVerbose(hrv.data,FALSE)
    hrv.data = LoadBeatRR(hrv.data, fli[vector[i]],".",scale=0.001)
    hrv.data = BuildNIHR(hrv.data)
    hrv.data = FilterNIHR(hrv.data)
    hrv.data = SetVerbose(hrv.data,TRUE)
    hrv.data = CreateTimeAnalysis(hrv.data)
    hrv.data = InterpolateNIHR (hrv.data, freqhr = 1)
    hrv.data = CreateFreqAnalysis(hrv.data)
    hrv.data = SetVerbose(hrv.data,TRUE)
    hrv.data = CalculatePowerBand(hrv.data, indexFreqAnalysis= 1, size = 120, shift = 10, ULFmin = 0, ULFmax = 0.0033, VLFmin = 0.0033, VLFmax = 0.04, LFmin = 0.04, LFmax = 0.15, HFmin = 0.15, HFmax = 0.4 ) #modified RHRV default according to doi: 10.3389/fpubh.2017.00258
    datetime <- gsub('.{4}$', '',fli[vector[i]])
    mat[i,1] <- gsub('.{9}$', '',datetime)
    mat[i,2] <- gsub('-',':',gsub('.{11}', '',datetime))
    mat[i,3] <- log(hrv.data$TimeAnalysis[[1]]$rMSSD)/6.5*100
    mat[i,4] <- mean(hrv.data$Beat$niHR)
    mat[i,5] <- hrv.data$TimeAnalysis[[1]]$SDNN
    mat[i,6] <- hrv.data$TimeAnalysis[[1]]$pNN50
    mat[i,7] <- hrv.data$TimeAnalysis[[1]]$SDSD
    mat[i,8] <- hrv.data$TimeAnalysis[[1]]$rMSSD
    mat[i,9] <- hrv.data$TimeAnalysis[[1]]$IRRR
    mat[i,10] <- hrv.data$TimeAnalysis[[1]]$MADRR
    mat[i,11] <- hrv.data$TimeAnalysis[[1]]$TINN
    mat[i,12] <- hrv.data$TimeAnalysis[[1]]$HRVi
    mat[i,13] <- mean(hrv.data$FreqAnalysis[[1]]$LF)
    mat[i,14] <- mean(hrv.data$FreqAnalysis[[1]]$HF)
    mat[i,15] <- mean(hrv.data$FreqAnalysis[[1]]$LFHF)
}

write.csv(mat, file="HRV_parsed.csv")

