## generates correlation coefficient for sample pairs ACROSS Groups
#input: directory path for results, list of interest groups/labels, dataframe with counts and metadata, 
## dataframe with counts only (lognormalized), correlation test, variableName is the column name of metadata, sampleColumnName is the column name of sample names
#output: a list of group pair labels for each correlation,a list of lists of correlation coefficient for sample pairs across groups 

getCorrelationCoefficient_acrossGroup = function(groupList, tableWithMeta, tableCountsOnly, 
                                                 corrTestMethod, variableName, sampleColumnName){
  
  corr_acrossGroups_list = list()
  labels_groupPairs = list()
  
  
  for( m in 1:(length(groupList)-1)){
    
    for(n in (m+1):length(groupList)){
      
      samples.index = which(colnames(tableWithMeta)==sampleColumnName)
      variable.index = which(colnames(tableWithMeta)==variableName)
      
      samples_firstGroup = tableWithMeta[,samples.index][tableWithMeta[,variable.index]==groupList[m]]
      samples_secondGroup = tableWithMeta[,samples.index][tableWithMeta[,variable.index]==groupList[n]]
      
      df_firstGroup = tableCountsOnly[rownames(tableCountsOnly)%in%samples_firstGroup,]
      df_secondGroup = tableCountsOnly[rownames(tableCountsOnly)%in%samples_secondGroup,]
      
      labels_firstGroup = groupList[m]
      labels_secondGroup = groupList[n]
      
      corr_rho_perGroup = vector()
      
      outfileLabels_firstGroup = gsub("->", "_to_", labels_firstGroup)
      outfileLabels_secondGroup = gsub("->", "_to_", labels_secondGroup)
      
      for(i in 1:nrow(df_firstGroup)){
        for(k in 1: nrow(df_secondGroup)){
          
          corr_rho = cor.test(as.numeric(df_firstGroup[i,]), as.numeric(df_secondGroup[k,]), method = corrTestMethod)$estimate
          corr_pval = cor.test(as.numeric(df_firstGroup[i,]), as.numeric(df_secondGroup[k,]), method = corrTestMethod)$p.value
          
          corr_rho_perGroup[length(corr_rho_perGroup)+1] = corr_rho
          
        }
      }
      
      corr_acrossGroups_list[[length(corr_acrossGroups_list)+1]] = corr_rho_perGroup
      labels_groupPairs[length(labels_groupPairs)+1] = paste0(outfileLabels_firstGroup,"vs",outfileLabels_secondGroup)
      
    } }
  return(list(labels_groupPairs,corr_acrossGroups_list))
}
