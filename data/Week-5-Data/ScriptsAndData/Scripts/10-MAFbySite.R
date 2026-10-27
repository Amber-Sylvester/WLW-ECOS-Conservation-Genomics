############################################################################################
##########################  MAF analysis by site
############################################################################################
### Load data

load('Data/fSNPS.rda')
load('Data/env.rda')
load('Data/reef.rda')

### Plot MAF by site (minimum 5 samples per site)

# Create scale of color and symbols 
colorscale = rainbow(20)
names(colorscale) = c('15', '20', '14', '9', '4', '19', '17', '16b', '16a', '11', '7', '1', '2', '6', '18', '13', '3', '8', '10', '5')

symbolscale = c(15:18, 0:2, 15:18, 0:2, 15:18, 0:1)
names(symbolscale) = c('15', '20', '14', '9', '4', '19', '17', '16b', '16a', '11', '7', '1', '2', '6', '18', '13', '3', '8', '10', '5')


order = c('15', '20', '14', '9', '4', '19', '17', '16b', '16a', '11', '7', '1', '2', '6', '18', '13', '3', '8', '10', '5')


MAF= function(fSNPS) { maf=apply(fSNPS, 2, function(x) {
  a=(sum(x=='1', na.rm=T)+sum(x=='0', na.rm=T)*2)/(sum(is.na(x)==F)*2)
  A=(sum(x=='1', na.rm=T)+sum(x=='2', na.rm=T)*2)/(sum(is.na(x)==F)*2)
  return(min(a,A))
})
return(maf)
}


# Subset only to locations with at least 5 samples
tk=reef%in%names(which(table(reef)>=5))

fSNPS=fSNPS[tk,]
env=env[tk,]
reef=reef[tk]

reef=droplevels(reef)

levels(reef) = order[order%in%levels(reef)]  

# compute MAF
maf = by(fSNPS, reef, MAF)

# plot MAF
par(mar=c(2,2,0.5,0.5), xpd=TRUE)
boxplot(maf, xaxt='n')
points(1:length(levels(reef)), rep(-0.05, times=length(levels(reef))), pch=symbolscale[levels(reef)], col=colorscale[levels(reef)], cex=1.5) 

