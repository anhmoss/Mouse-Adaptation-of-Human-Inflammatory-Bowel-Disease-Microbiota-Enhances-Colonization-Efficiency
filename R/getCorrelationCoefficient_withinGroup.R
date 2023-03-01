## correlations for all possible sample pairs WITHIN Groups
#input: list of group names, dataframe with counts and metadata, dataframe with counts only (lognormalized), correlation method
#output: a list of lists of correlation coefficient for sample pairs across groups 


getCorrelationCoefficient_withinGroup = function(groupList, tableWithMeta, tableCountsOnly, 
                                             corrTestMethod){
  
  corr_rho_withinGroups_list = list()
  
  for(m in 1:length(groupList)){
    
    samples_firstGroup = tableWithMeta$SampleID[tableWithMeta$FMTGroupFMTsourcegtRecipientbackground==groupList[m]]
    df_firstGroup = tableCountsOnly[rownames(tableCountsOnly)%in%samples_firstGroup,]
    labels_firstGroup = groupList[m]
    corr_rho_perGroup = vector()
    
    for(i in 1:(nrow(df_firstGroup)-1)){
      for(k in (i+1): nrow(df_firstGroup)){
        corr_rho = cor.test(as.numeric(df_firstGroup[i,]), as.numeric(df_firstGroup[k,]), method = corrTestMethod)$estimate
        corr_rho_perGroup[length(corr_rho_perGroup)+1] = corr_rho
        
      }
    }
    corr_rho_withinGroups_list[[m]] = corr_rho_perGroup
  }
  return(corr_rho_withinGroups_list)
}
