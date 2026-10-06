##### Script to run a genome scan and identify outlier loci

library(pcadapt)
library(qvalue)
library(AssocTests)
source('CommonScriptsAndData/functions.R')

load('Data/fSNPS.rda')

dim(fSNPS)

filename = read.pcadapt(t(fSNPS)) # load data

### check how many PCs to keep

x = pcadapt(filename, K=50) 

plot(x, option='screeplot')

var = x$singular.values^2

tw = tw(var, length(var))

tw$SigntEigenL # #PCs to retain for neutral structure in pcadapt

### Keep Significant PCs, rerun DAPC

x = pcadapt(filename, K=tw$SigntEigenL) 

### Correct for multiple testing 

qval = qvalue(x$pvalues)$qvalues 

names(qval) = colnames(fSNPS)

qval # indicates which are the outliers 

length(qval[which(qval<0.01)]) # how many outliers with q<0.01?

### Save outlier loci

outlierloci = names(qval[which(qval<0.01)])

save(outlierloci, file='Data/outlierloci.rda')

