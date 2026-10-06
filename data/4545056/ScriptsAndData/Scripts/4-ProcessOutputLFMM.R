############################################################################################
##########################  Process output LFMM
############################################################################################
source('CommonScriptsAndData/functions.R')
library(qvalue)
### Process LFMM output

load('Data/fSNPS.rda')
load('Data/groupvar.rda')
load('Data/outlist.rda')


outLFMM = processLFMM(outlist, groupvar)

nSNPs = outLFMM[[1]] # nb. of significant SNPs per group of collinear environmental variables 
QS.CRWBA = outLFMM[[2]]  # q-values for SNPs vs CRW.BAF (5 km)
QS.CRWBA_1 = outLFMM[[3]]  # q-values for SNPs vs CRW.BAF (1 km)
lsSNPs = outLFMM[[4]] # overall list of significant SNPs (all vars)

length(unique(c(lsSNPs$CRW.BA, lsSNPs$CRW.BA_1))) # shared annotations between CRW.BA-CRW.BA_1
length(unique(unlist(lsSNPs[substr(names(lsSNPs),1,3)%in%c('SST','sst')]))) # shared annotations between SST vars
length(unique(unlist(lsSNPs[substr(names(lsSNPs),1,3)%in%c('SSS')]))) # shared annotations between SSS vars
length(unique(unlist(lsSNPs[substr(names(lsSNPs),1,3)%in%c('CHL')]))) # shared annotations between CHL vars
length(unique(unlist(lsSNPs[substr(names(lsSNPs),1,3)%in%c('SCV')]))) # shared annotations between SCV vars
length(unique(unlist(lsSNPs[substr(names(lsSNPs),1,3)%in%c('SPM')]))) # shared annotations between SPM vars

# export Q-values

#save(QS.CRWBA, file='Data/QS.CRWBA.rda')  
#save(QS.CRWBA_1, file='Data/QS.CRWBA_1.rda')  

