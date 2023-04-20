#calculates levenes test between two groups of histology scores 
#input: table with histology score data and group names, column name for region of tissue scores, column name for group of interest, list of phenotype/group names 
#output: bartlett pvalues for each possible pairwise comparison 

calculateLevenesTestPvalue_histologyScoreData = function(scoreTable, regionColName, groupColName,
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
      
      testResults_pval = leveneTest(values~ind, stacked.df)[['Pr(>F)']][1]
      pairName = paste0(phenotypeNames[m],"_vs_", phenotypeNames[n])
      
      pvalResults[length(pvalResults)+1] = testResults_pval
      groupPairNames[length(groupPairNames) + 1] = pairName
    }}
  return(list("LevenesTestPvals"= pvalResults, "GroupPair"=groupPairNames))
}