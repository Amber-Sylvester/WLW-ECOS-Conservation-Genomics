############################################################################################
##########################  Run SetRank Analysis
############################################################################################
library(SetRank)
# set p-value and q-value threshold for enrichment analysis
PT = 0.01 
QT = 0.05

# load data

load('Data/SRcollection.rda') # Gene set collection
load('Data/ranked_CRWBA.rda') # ranks of genes (BAF - 5 km)
load('Data/ranked_CRWBA_1.rda') # ranks of genes (BAF - 5 km)


# run setrank (BAF- 5 km)
enrichmentSR = setRankAnalysis(ranked_CRWBA$V1, collection, use.ranks = T, setPCutoff = PT, fdrCutoff = QT)
exportSingleResult(network = enrichmentSR, selectedGenes = ranked_CRWBA$V1, collection = collection, networkName = 'setrank5',IDConverter = NULL, outputPath = "Data/")

# run setrank (BAF- 1 km)
enrichmentSR = setRankAnalysis(ranked_CRWBA_1$V1, collection, use.ranks = T, setPCutoff = PT, fdrCutoff = QT)
exportSingleResult(network = enrichmentSR, selectedGenes = ranked_CRWBA_1$V1, collection = collection, networkName = 'setrank1',IDConverter = NULL, outputPath = "Data/")

