#calculates bartlett test between two groups of histology scores 
#in order to do this, we read a table into the function, subset the samples by group and region,
#create a stacked df for each possible pair of groups, then run test with the stacked df for each group
#input: table with histology score data and group names, column name for region of tissue scores, 
# column name for group of interest, list of phenotype/group names 
#output: bartlett pvalues for each possible pairwise comparison 

calculateBartlettPvalue_histologyScoreData = function(scoreTable, regionColName, groupColName,
                                                      phenotypeNames){
pvalResults = NULL
groupPairNames = NULL
  
for( m in 1:(length(phenotypeNames)-1)){
  for(n in (m+1):length(phenotypeNames)){
    
    region.index = which(colnames(scoreTable)==regionColName)
    group.index = which(colnames(scoreTable)==groupColName) 
    
    samples_group1 = scoreTable[,region.index][scoreTable[,group.index]==phenotypeNames[m]]
    samples_group2 = scoreTable[,region.index][scoreTable[,group.index]==phenotypeNames[n]]
    
    stacked.df = stack(list(samples_group1=samples_group1,
                            samples_group2=samples_group2))
    
    bartlettResults_pval = bartlett.test(values~ind, stacked.df)$p.value
    pairName = paste0(phenotypeNames[m],"_vs_", phenotypeNames[n])
    
    pvalResults[length(pvalResults)+1] = bartlettResults_pval
    groupPairNames[length(groupPairNames) + 1] = pairName
  }}
return(list("BartlettPvals"= pvalResults, "GroupPair"=groupPairNames))
}


