## complements the function samplePairsAcrossGroup_NontransferringASVS_returnVectorsOnly, returns labels (sample names) of each pairwise comparison within groups
# input: grouplist (list of phyla names), dataframe with counts and metadata, dataframe with counts only 
# output: list of sample names for all pairwise comparisons across groups for the non-transferred asvs

ntasvs_histogramLabels= function(groupList, tableWithMeta, tableCountsOnly){
  outlabels = list()
  for( m in 1:(length(groupList)-1)){
    
    for(n in (m+1):length(groupList)){
      
      samples_firstGroup = tableWithMeta$SampleID[tableWithMeta$FMTGroupFMTsourcegtRecipientbackground==groupList[m]]
      samples_secondGroup = tableWithMeta$SampleID[tableWithMeta$FMTGroupFMTsourcegtRecipientbackground==groupList[n]]
      
      df_firstGroup = tableCountsOnly[rownames(tableCountsOnly)%in%samples_firstGroup,]
      df_secondGroup = tableCountsOnly[rownames(tableCountsOnly)%in%samples_secondGroup,]
      
      labels_firstGroup = groupList[m]
      labels_secondGroup = groupList[n]
      
      outfileLlabels_firstGroup = gsub("->", "_to_", labels_firstGroup) 
      outfileLlabels_secondGroup = gsub("->", "_to_", labels_secondGroup) 
      
      for(i in 1:nrow(df_firstGroup)){
        for(k in 1: nrow(df_secondGroup)){    
      a=rownames(df_firstGroup[i,])
      b=rownames(df_secondGroup[k,])
      eachplotlabel = paste0(a, "_vs_", b)

      outlabels[[length(outlabels)+1]]=eachplotlabel
        }}
    } 
  }
  return(outlabels)
}
