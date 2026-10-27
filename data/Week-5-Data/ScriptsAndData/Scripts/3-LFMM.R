############################################################################################
##########################  Run LFMM
############################################################################################
load('Data/fSNPS.rda')
load('Data/env.rda')
load('Data/groupvar.rda')

library(LEA)
library(qvalue)


## Create input files for LFMM

inLEA = fSNPS
inLEA[is.na(inLEA)] = 9

write.lfmm(inLEA, 'LFMM/genotypes.lfmm')
write.geno(inLEA, 'LFMM/genotypes.geno')
write.env(env[,names(groupvar)],'LFMM/gradients.env' )


### SNMF - infer admixture

project= NULL
project = snmf("LFMM/genotypes.geno", K=1:30, entropy = TRUE, repetitions = 5, project = 'new', CPU=1)

plot(project)


# Impute missing obs
K = 2 # Important: adapt to results of snmf, or use K from paper

project.missing = snmf("LFMM/genotypes.lfmm", K = K,entropy = TRUE, repetitions = 5,project = "new")

best = which.min(cross.entropy(project.missing, K = K))

impute(project.missing, "LFMM/genotypes.lfmm",method = 'mode', K = K, run = best)

### Run LFMM
Ks = 2:4 # Important: adapt to results of snmf, or use K from paper


project = NULL
project = lfmm("LFMM/genotypes.lfmm_imputed.lfmm", "LFMM/gradients.env", K=Ks, repetitions=5, CPU=1, project = 'new')


## Create Output for postprocessing

outlist = list()
for (k in Ks) {
  out=c()
for (e in 1:length(groupvar)) {
  p = lfmm.pvalues(project, K=k, d=e)
  
  out=cbind(out, (p$pvalues))

}
  rownames(out) = colnames(fSNPS)
  colnames(out) = names(groupvar)
  outlist[[paste0('k',k)]] = out
}


#save(outlist, file='outlist.rda')

