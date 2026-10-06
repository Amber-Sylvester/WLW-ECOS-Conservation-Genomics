############################################################################################
##########################  Filtering Genotype Matrix
############################################################################################
## Load Packages

library('raster')
source('../CommonScriptsAndData/functions.R')
library(vcfR)
library(SNPRelate)
library(readxl)

### Load SNP metadata
load('Data/snpINFO.rda')

### Import Imputed DATA

GT=read.vcfR('Data/sorted_imputed.vcf')
SNPS=extract.gt(GT)

head(GT)

fSNPS=apply(SNPS,1, function(x) { 
  y=rep(NA, length(x))
  y[x=='0/0'] = 0
  y[x=='0/1'] = 1
  y[x=='1/1'] = 2
  return(y)
})

rownames(fSNPS) = colnames(SNPS)

### Missingness by Individual

## For each individual, it computes the % of missing observation across the SNPs. 

MNind <- apply(fSNPS, 1, function(x) { sum(is.na(x))/length(x) })
hist(MNind, breaks=100) # Check the distribution and set a cutoff value
fSNPS <- fSNPS[MNind<0.05,] # Modify here the cutoff value for this paramter (default 0.05)

### Minor Allele Frequency

## For each SNP, it computes the frequncy of the most rare allele across all individuals. 

MAF <- apply(fSNPS, 2, function(x) {
  a=(sum(x=='1', na.rm=T)+sum(x=='0', na.rm=T)*2)/(sum(is.na(x)==F)*2)
  A=(sum(x=='1', na.rm=T)+sum(x=='2', na.rm=T)*2)/(sum(is.na(x)==F)*2)
  return(min(a,A))
})
hist(MAF, breaks=100) # Check the distribution and set a cutoff value
fSNPS <- fSNPS[,MAF>0.05] # Modify here the cutoff value for this paramter (default 0.05)

### Major Genotype Frequency

## For each SNP, it computes the frequency of the most frequent genotype across all individuals. 

MGF <- apply(fSNPS, 2, function(x) {
  aa=(sum(x=='0', na.rm=T))/(sum(is.na(x)==F))
  aA=(sum(x=='1', na.rm=T))/(sum(is.na(x)==F))
  AA=(sum(x=='2', na.rm=T))/(sum(is.na(x)==F))
  return(max(aa,aA,AA))
})
hist(MGF, breaks=100) # Check the distribution and set a cutoff value
fSNPS <- fSNPS[,MGF<0.95] # Modify here the cutoff value for this paramter (default 0.95)


dim(fSNPS) # Check the number of individuals and genes kept after filering.
 

# Linkage Disequilibrium

snpgdsClose(genofile)

snpgdsCreateGeno('Data/LD.gds', genmat = fSNPS, 
                 sample.id = rownames(fSNPS),
                 snp.id = colnames(fSNPS), snp.chromosome = as.character(unlist(snpINFO[colnames(fSNPS),2])) , snp.position = as.numeric(snpINFO[colnames(fSNPS),3]), 
                 snpfirstdim=F)

genofile = snpgdsOpen('Data/LD.gds')
LDmark = snpgdsLDpruning(genofile, ld.threshold = 0.3, autosome.only=F)

fSNPS=fSNPS[,unlist(LDmark)]

snpgdsClose(genofile)


## Filter for clones

C.g = cor(t(fSNPS), use='pairwise.complete.obs') # compute correlation between indivudals GT
diag(C.g)=NA

while (max(C.g, na.rm=T)>0.9) {
  
  for (i in 1:nrow(C.g)) {
    
    if (max(C.g[i,], na.rm=T)>0.9) { # if there is a clone
      clone = which.max(C.g[i,]) 
      fSNPS = fSNPS[-clone,] # remove it
      break # and exit for loop
    }
  }
  
  print(paste0('removed ', names(clone)))
  C.g = cor(t(fSNPS), use='pairwise.complete.obs')
  diag(C.g)=NA
  
  
}

### backup fSNPs and env as objects

# save(fSNPS, file='Data/fSNPS.rda')
