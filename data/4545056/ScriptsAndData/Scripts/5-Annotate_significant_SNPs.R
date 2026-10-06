############################################################################################
##########################  Find function of genes next to significant SNPs
############################################################################################# 
source('CommonScriptsAndData/functions.R')
# Load Codon to AA table
library(seqinr)
library(qvalue)
data(SEQINR.UTIL)
CODON.AA= as.character(SEQINR.UTIL$CODON.AA$AA)
names(CODON.AA) = toupper(SEQINR.UTIL$CODON.AA$CODON)


## Load data 

load('Data/QS.CRWBA.rda') # q-value SNPs vs. BAF (5 km)
load('Data/QS.CRWBA_1.rda') # q-value SNPs vs. BAF (1 km)
load('Data/GENpos.rda') # position of genes
load('Data/exons.rda') # position of exons
load('Data/snpINFO.rda') # position of SNPs
load('Data/outlist.rda') # lfmm results
load('Data/outlierloci.rda') # outlier loci

ANN=c()# table storing annotations

snps = names(which(sort(QS.CRWBA)<0.01))
ANN=rbind(ANN, snps_to_genes(snps, evar = 'CRW.BA', GENpos, exons, snpINFO, outlist))

snps = names(which(sort(QS.CRWBA_1)<0.01))
ANN=rbind(ANN, snps_to_genes(snps, evar = 'CRW.BA_1', GENpos, exons, snpINFO, outlist))

ANN # visualize gene annotations


