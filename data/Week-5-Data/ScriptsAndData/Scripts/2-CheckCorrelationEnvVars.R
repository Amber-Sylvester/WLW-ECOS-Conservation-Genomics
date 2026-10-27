############################################################################################
##########################  Check correlation between environmental
############################################################################################

load('Data/env.rda') # load environmental table 
load('Data//groupvar.rda') # load list of highly correlated descriptors (0.9, obtained using the RedEnv function), employed for LFMM calcualtions

# compute correlation between env vars, exclude coords

COR.ENV = as.matrix(cor(env[,-c(1:2)]))

# check correlation between groups of correlated descriptors

COR.GR.ENV = matrix(NA, ncol=length(groupvar), nrow=length(groupvar))
dimnames(COR.GR.ENV) = list(names(groupvar),names(groupvar))

# For every pair of group of environmental variables...
for (i in 1:length(groupvar)) {
  for (l in 1:length(groupvar)) {
    
    varsi =   c(names(groupvar)[i], unlist(strsplit(groupvar[[i]], ', '))) # envars in group i
    varsl =   c(names(groupvar)[l], unlist(strsplit(groupvar[[l]], ', '))) # envars in group l
    
    cor = c()
    # retrieve correlation between variables in the two groups of interest
    for (j in varsi) {
      for (k in varsl) {
        cor=c(cor, COR.ENV[j,k])
    }
}
      
    COR.GR.ENV[i,l] = abs(mean((cor)))
    
}
}

COR.GR.ENV # table storing average correlation between groups of environmental variables

