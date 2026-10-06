############################################################################################
##########################  Population structure analysis
############################################################################################
### Scripts to run genetic population structure using DAPC

library('adegenet')

load('Data/fSNPS.rda')
load('Data/env.rda')
load('Data/reef.rda')
load('Data/outlierloci.rda')

### Remove outlier loci
fSNPS=fSNPS[,(colnames(fSNPS)%in%outlierloci)==F]
length(outlierloci) # nb outlier loci
dim(fSNPS) # size of matrix of neutral GTs 

### Format table for Adegenet
# compute allele count table
A.0 = fSNPS
colnames(A.0) = paste0(colnames(fSNPS),'.0')
A.1 = -(fSNPS-2)
colnames(A.1) = paste0(colnames(fSNPS), '.1')

AC= cbind(A.0, A.1)[, rep(1:ncol(fSNPS), each=2)+rep(c(0, ncol(fSNPS)), times=ncol(fSNPS))]

# Create geneInd object
GI=genind(AC, type='codom')

#### DAPC: version 1, without a priori
#check number of cluster (without a priori)
find.clusters(GI, n.pca = 200)


#### DAPC: version 2, with a priori
GI@pop = droplevels(reef) # load a priori information on sampling locations

# compute alpha-score (optimal number of PCs to retain for DAPC with a priori)
dapc_a_score <- dapc(GI,n.pca=nInd(GI),n.da=10) 
temp_score <- optim.a.score(dapc_a_score)

# Run DAPC with a priori
daPC = dapc(GI, pop = reef, n.pca = temp_score$best, n.da = 2)

daPC$eig[1:2]/sum(daPC$eig) # % of variance explained by first two discriminant axes

### Plot scatterplot dapc
# Create scale of color and symbols 
colorscale = rainbow(20)
names(colorscale) = c('15', '20', '14', '9', '4', '19', '17', '16b', '16a', '11', '7', '1', '2', '6', '18', '13', '3', '8', '10', '5')

symbolscale = c(15:18, 0:2, 15:18, 0:2, 15:18, 0:1)
names(symbolscale) = c('15', '20', '14', '9', '4', '19', '17', '16b', '16a', '11', '7', '1', '2', '6', '18', '13', '3', '8', '10', '5')

scatter(daPC, col = colorscale[levels(daPC$grp)], pch=symbolscale[levels(daPC$grp)], cex=2,  label = '', scree.pca = F, scree.da = F, posi.da = 'topleft', )

