## Reduce Environmental Dataset: checks correlation between environmental variables and selects only one variable per group of similar indicators.

redENV = function(ienv, corcutoff=0.7) {
  
  listvar = colnames(ienv)
  
  co=1
  
  olist=list()
  
  while(length(listvar)>0) {
    
    C = abs(cor(ienv)[listvar[co],listvar[-co]]) 
    group=names(C[C>corcutoff]) 
    
    olist[listvar[co]]=paste(group, collapse = ', ')
    
    listvar=listvar[-c(1,which(listvar%in%group))]
    
  }
  
  return(olist)
  
}


### Process LFMM output

processLFMM = function(outlist, groupvar, qlevels=0.01) {
  
  
  # Retrieve output from LFMM
  KA=data.frame(outlist[[1]])
  KB=data.frame(outlist[[2]])
  KC=data.frame(outlist[[3]])
  
  # Correct qvalues
  qKA = apply(KA, 2, function(x) {qvalue(x)$qvalue})
  qKB = apply(KB, 2, function(x) {qvalue(x)$qvalue})
  qKC = apply(KC, 2, function(x) {qvalue(x)$qvalue})
  
  
  # retrieve output info for every group of environemental vars
  
  # Create out tables
  outtab = c()
  lsSNPS = list()
  for (var in names(groupvar)) {
    
    # Find minimal q-value across runs
    QS=apply(cbind(qKA[,var], qKB[,var], qKC[,var]), 1, min)
    
    # Store QS aside if CRW.BA or CRW.BA_1
    if (var == 'CRW.BA') {QS.CRW.BA=QS}
    if (var == 'CRW.BA_1') {QS.CRW.BA_1=QS}
    
    # Find all vars in group
    allvars = c(var, groupvar[[var]])
    allvars = allvars[allvars!='']
    allvars = paste(allvars, collapse = ', ')
    
    # Find # of significant snps, for different levels of q
    qc = sum(QS<qlevels)
    lsSNPS[[var]] = names(which(QS<qlevels))
    
    # Add to outtab
    outtab = rbind(outtab, c(allvars, qc))
    
    # Compute correlation between groups of variables
    for (var2 in names(groupvar)) {
      
      g1 = c(var, unlist(strsplit(groupvar[[var]], ', ')))
      g2 = c(var2, unlist(strsplit(groupvar[[var2]], ', ')))
    }
  }
  
  return(list(outtab, QS.CRW.BA, QS.CRW.BA_1, lsSNPS))
  
}

### Retrieve annotations next to a SNP

snps_to_genes = function(snps, evar, GENpos, exons, snpINFO, outlist,  d=100000, qt=0.01) {
  
  # load results LFMM
  Qalt = array(NA,  dim=c(nrow(outlist[[1]]),ncol(outlist[[1]]), 3) )
  Qalt[,,1] = apply(outlist[[1]], 2, function(x) {qvalue(x)$qvalue})
  Qalt[,,2] = apply(outlist[[2]], 2, function(x) {qvalue(x)$qvalue})
  Qalt[,,3] = apply(outlist[[3]], 2, function(x) {qvalue(x)$qvalue})
  
  qalt = apply(Qalt, 1:2, min)
  rownames(qalt) = rownames(outlist[[1]])
  colnames(qalt) = colnames(outlist[[1]])
  # q alt stores q-values for LFMM models of every SNP against all the environmental variables
  
  outtab= c()
  
  for (snp in snps) {
    
    # retrieve snps position
    snppos = snpINFO[snp,]
    po = as.numeric(snppos$pos)
    
    # retrieve neighboring genes
    gs = GENpos[which(GENpos$chr==as.character(snppos$chr)),]
    gs=gs[as.numeric(gs$start)>(po-d)&as.numeric(gs$start)<(po+d),]
    
    
    # compute shortest distance 
    shortd = apply(cbind((po-as.numeric(gs$start)),(po-as.numeric(gs$end)) ), 1, function(x) {
      return(x[which.min(abs(x))])
    }) # shortest distance between SNP and genes
    
    # 
    
    # retrieve strand orientation of every gene
    genestrand = gs$strand
    
    # prepare output information
    out = rep(NA, length(shortd))
    out[genestrand=='+'&sign(shortd)==-1] = ' bps from start'
    out[genestrand=='-'&sign(shortd)==-1] = ' bps from end'  
    out[genestrand=='+'&sign(shortd)==+1] = ' bps from end'
    out[genestrand=='-'&sign(shortd)==+1] = ' bps from start'
    out=paste0(abs(shortd), out)
    
    # Check if SNP is in a gene
    inGene = snppos$pos>gs$start&snppos$pos<gs$end 
    shortd[inGene] = 0
    
    # Is the closest gene unknown? 
    CU = is.na(gs[which.min(abs(shortd)),'blast'])
    
    # remove genes with unknown function
    gs = gs[is.na(gs$blast)==F,,drop=F]
    
    # repeat computation og closest gene
    
    # compute shortest distance 
    shortd = apply(cbind((po-as.numeric(gs$start)),(po-as.numeric(gs$end)) ), 1, function(x) {
      return(x[which.min(abs(x))])
    }) # shortest distance between SNP and genes
    
    # 
    
    # retrieve strand orientation of every gene
    genestrand = gs$strand
    
    # prepare output information
    out = rep(NA, length(shortd))
    out[genestrand=='+'&sign(shortd)==-1] = ' bps from start'
    out[genestrand=='-'&sign(shortd)==-1] = ' bps from end'  
    out[genestrand=='+'&sign(shortd)==+1] = ' bps from end'
    out[genestrand=='-'&sign(shortd)==+1] = ' bps from start'
    out=paste0(abs(shortd), out)
    
    # Check if SNP is in a gene
    inGene = snppos$pos>gs$start&snppos$pos<gs$end 
    shortd[inGene] = 0
    
    
    # If there are more genes overlapping on the same SNP, keep the longest
    if (sum(inGene)>1) {
      tk = which.min(as.numeric(gs$end)[inGene]-as.numeric(gs$start)[inGene]) # to keep
      gs = gs[-which(inGene)[-tk],]
      out = out[-which(inGene)[-tk]]
      shortd = shortd[-which(inGene)[-tk]] 
      inGene = inGene[-which(inGene)[-tk]] 
    }
    
    if (sum(inGene)>0) {
      
      # find exons of the gene
      ex = exons[exons$genename==gs$geneid[inGene],]
      
      inExons = ex[ex$start<=po&ex$end>=po,]
      
      if (nrow(inExons)==0) {     # step 3a: if it is in intron
        
        out[inGene] = 'Intronic'
        
      } else {     # step 3b: if it is in exon
        
        if (inExons$strand=='+') {
          
          posCDS=inExons$start:inExons$end
          codon = ceiling(which(posCDS==po)/3)
          tripl = which(posCDS==po)%%3
          # find triplet sequence, depending on position of SNP on codon
          if (tripl==0) {
            tri.seq = substr(snppos$sequence, 1, 3)
            tri.seq.alt = substr(snppos$sequenceAlt, 1, 3)
          }
          if (tripl==1) {
            tri.seq = substr(snppos$sequence, 3, 5)
            tri.seq.alt = substr(snppos$sequenceAlt, 3, 5)
          }
          if (tripl==2) {
            tri.seq = substr(snppos$sequence, 2, 4)
            tri.seq.alt = substr(snppos$sequenceAlt, 2, 4)
          }
          
          AA = CODON.AA[tri.seq]
          AA_alt = CODON.AA[tri.seq.alt]
          
          if (AA!=AA_alt) { out[inGene] = paste0('In CDS (Non Syn. on codon ', codon  ,')' )     }
          if (AA==AA_alt) { out[inGene] = paste0('In CDS (Syn. on codon ', codon  ,')' )     }
          
        } else if (inExons$strand=='-')  {
          
          posCDS=inExons$end:inExons$start
          codon = ceiling(which(posCDS==po)/3)
          tripl = which(posCDS==po)%%3
          
          # find reverse complement of SNP sequence  
          revseq = paste(comp(strsplit(snppos$sequence, '')[[1]], forceToLower = F)[5:1], collapse = '')
          revseqAlt = paste(comp(strsplit(snppos$sequenceAlt, '')[[1]], forceToLower = F)[5:1], collapse = '')
          
          
          # find triplet sequence, depending on position of SNP on codon
          if (tripl==0) {
            tri.seq = substr(revseq, 1, 3)
            tri.seq.alt = substr(revseqAlt, 1, 3)
          }
          if (tripl==1) {
            tri.seq = substr(revseq, 3, 5)
            tri.seq.alt = substr(revseqAlt, 3, 5)
          }
          if (tripl==2) {
            tri.seq = substr(revseq, 2, 4)
            tri.seq.alt = substr(revseqAlt, 2, 4)
          }
          
          AA = CODON.AA[tri.seq]
          AA_alt = CODON.AA[tri.seq.alt]
          
          if (AA!=AA_alt) { out[inGene] = paste0('In CDS (Non Syn. on codon ', codon  ,')' )     }
          if (AA==AA_alt) { out[inGene] = paste0('In CDS (Syn. on codon ', codon  ,')' )     }
          
          
        }
        
      }
    }
    
    
    
    # find qvalues
    qI = qalt[snp,evar] # snp of interest
    qO = qalt[snp,colnames(qalt)!=evar] # q-value with other env vars
    wqO = names(which(qO<qt))
    if (length(wqO)>0) {  wqO = paste(paste0(wqO), collapse=',') # other variables significantly associated with SNP
    }     else {wqO = ''}
    # check if SNP is an outlier loci
    outlier = qI%in%outlierloci
    
    closest.gene.id = gs$geneid[which.min(abs(shortd))]
    closest.gene.name = gs$blast[which.min(abs(shortd))]
    closest.gene.distance = out[which.min(abs(shortd))]
    closest.gene.functions = GENpos[closest.gene.id,'GOmf']
    
    if (length(which.min(abs(shortd)))==0) {
      closest.gene.id = closest.gene.name = closest.gene.distance = closest.gene.functions = ''
    }
    
    outtab = rbind(outtab, c(snp, snppos$chr, po, outlier, evar ,qI, wqO, CU, closest.gene.id, closest.gene.distance, closest.gene.name, closest.gene.functions))
  }
  outdf = data.frame(outtab, stringsAsFactors = F)
  colnames(outdf) = c('SNPid', 'Chromosome/Contig', 'Position', 'Outlier?', 'ENV', 'q', 'Other env?', 'Closest.Gene.Unknown?','Closest.Gene.ID','Closest.Gene.Position', 'Closest.Gene.Name', 'Closest.Gene.GOs')
  
  
  return(outdf)
}


### Create GeneSet collection for SetRank out of GO annotations

createGScollection = function(GOmf) {
  library(SetRank)
  # create an annotation table for every geneID-GOterm combination
  annotab=c()
  GO=GOmf
  
  for (genes in names(GO)) {
    x = GO[[genes]]
    if (is.na(x)==F) {
      for (i in 1:length(x)) {
        annotab=rbind(annotab, c(genes, names(x[i]), x[i], 'GOmf', '-' ))
      }
    }
  }
  
  colnames(annotab) = c('geneID', 'termID', 'termName', 'dbName', 'description')
  GSC = data.frame(annotab)
  
  dim(GSC)
  # Create the geneset collection
  
  options(mc.cores=3)
  collection = buildSetCollection(GSC)
  
  return(collection)
}

### Function to rank genes found in proximity of SNPs based on q-value

rankGenes = function(QS, GENpos, snpINFO, exons) {
  
  cSNPs = names(sort(QS))
  
  ## Find all genes located around significant SNPs and rank them by distance
  rank.tab= c()
  
  # restrict genpos only to +- 200kb surrounding candidates SNPs
  genpos = GENpos
  d1=50000
  d2=5000
  
  for (snp in cSNPs) {
    
    snppos = snpINFO[snp,]
    po = as.numeric(snppos$pos)
    
    gs = genpos[genpos$chr==as.character(snppos$chr),]
    gs=gs[as.numeric(gs$start)>(po-d1)&as.numeric(gs$start)<(po+d1),]
    
    if (nrow(gs)>0) {
      
      n_exons = exons[exons$genename%in%gs$geneid,] # exons of neighboring genes
      
      shortd = apply(cbind(abs(po-as.numeric(n_exons$start)),abs(po-as.numeric(n_exons$end)) ), 1, min) # shortest distance between SNP and exons
      
      inCDS = po>n_exons$start&po<n_exons$end # SNP in cds of an exon?
      
      shortd[inCDS] = 0 # if SNP inside a CDS: shorter dist = 0!
      
      shortd_by_gene = by(shortd, n_exons$genename, min) # retrieve shortest distance, for every gene
      
      cgene = which.min(shortd_by_gene)
      d.cgene = min(shortd_by_gene)
      
      if (d.cgene<d2) {rank.tab = rbind(rank.tab, cbind(names(shortd_by_gene[cgene]), shortd_by_gene[cgene], snp))}
      
    }
  }
  
  rank.tab = as.data.frame(rank.tab, stringsAsFactors = F)
  
  
  # If one gene was close to multiple cSNPs, select closest one!
  rank.tab.filtered = by(rank.tab, rank.tab[,1], function(x) {
    return(x[which.min(as.numeric(x[,2])),] )
  })
  
  rank.tab.filtered = as.data.frame(matrix(unlist(rank.tab.filtered), ncol=3, byrow=T), stringsAsFactors = F)
  
  # order by q value significance
  rank.tab.filtered$psnp = QS[rank.tab.filtered$V3]
  
  rank.tab.odered = rank.tab.filtered[order(rank.tab.filtered$psnp),]
  
  # create ranked list of candidates
  return(rank.tab.odered)
}
