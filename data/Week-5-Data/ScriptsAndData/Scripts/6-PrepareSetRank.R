############################################################################################
##########################  Prepare SetRank
############################################################################################
source('CommonScriptsAndData/functions.R')


## Prepare geneset collection and a list of ranked genes for setRank analysis

# load data

load('Data/GOmf.rda') # table of genes- to GO terms annotation
load('Data/GENpos.rda') # position of genes
load('Data/snpINFO.rda') # position of snps
load('Data/exons.rda') # position of exons
load('Data/QS.CRWBA.rda')  # q-value SNPs vs. BAF (5 km)
load('Data/QS.CRWBA_1.rda') # q-value SNPs vs. BAF (1 km)

## Create collections of GO
collection = createGScollection(GOmf)

# Create ranked list of genes
ranked_CRWBA = rankGenes(QS.CRWBA, GENpos, snpINFO, exons)
ranked_CRWBA_1 = rankGenes(QS.CRWBA_1, GENpos, snpINFO, exons)

# Export output
# save(collection, file='Data/SRcollection.rda')
# save(ranked_CRWBA, file='Data/ranked_CRWBA.rda')
# save(ranked_CRWBA_1, file='Data/ranked_CRWBA_1.rda')

