## get asv abundances of those that did not transfer
#input: list of interest groups/labels, tableWithMeta (dataframe with counts and metadata), tableCountsOnly (dataframe with counts only), sampleColumnName (column name sampleIDs), variableName (column name for variable of interest)
#output: list of vectors with counts of the non-transferred ASVs

samplePairsAcrossGroup_NontransferringASVS_returnVectors = function(groupList, tableWithMeta, 
                                                                    tableCountsOnly, sampleColumnName,
                                                                    variableName){
  
  resultsToPrint = list()
  
  
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

      outfileLlabels_firstGroup = gsub("->", "_to_", labels_firstGroup)
      outfileLlabels_secondGroup = gsub("->", "_to_", labels_secondGroup)
      
      results_bothvectors = list()
      
      for(i in 1:nrow(df_firstGroup)){
        for(k in 1: nrow(df_secondGroup)){
          
          myfirstGroup = as.numeric(df_firstGroup[i,])
          mysecondGroup = as.numeric(df_secondGroup[k,])
          
          firstGroup_ASVsThatDidNotTransferToSecondGroup = myfirstGroup[myfirstGroup != 0 & mysecondGroup ==0]
          secondGroups_ASVsThatDidNotTransferToFirstGroup = mysecondGroup[mysecondGroup != 0 & myfirstGroup==0]
          
          results_list = list(firstGroup_ASVsThatDidNotTransferToSecondGroup,
                              secondGroups_ASVsThatDidNotTransferToFirstGroup)
          
          resultsToPrint[[length(resultsToPrint)+1]] = results_list

        }
      }

    } 
  }
  return(resultsToPrint)
}
