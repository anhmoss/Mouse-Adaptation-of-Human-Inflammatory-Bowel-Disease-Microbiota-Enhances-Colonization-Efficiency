# Generates a tab-delimited file of a dataframe with ASV names, taxonomy labels, and counts of non-transferred ASVs of a pair of samples across different groups
#input: directory path for results, list of interest groups/labels, dataframe with counts and metadata, 
# taxonomyMap (table that maps taxonomy names to ASV names), taxaColName(column name with taxonomy),asvColName (column name with asv names)
#output: a list of lists, of corr results within each interest group

generateTableWithTaxonomy_NontransferringASVS_samplePairsAcrossGroup = function(groupList,taxonomyMap,
                                                                                taxaColName,asvColName,
                                                                           tableWithMeta,
                                                                           tableCountsOnly,
                                                                           resultsDirectory){
  all_ntASVNames = list()
  
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
      
      names_NTasvs = list()
      
      for(i in 1:nrow(df_firstGroup)){
        for(k in 1: nrow(df_secondGroup)){
          
          myfirstGroup = as.numeric(df_firstGroup[i,])
          mysecondGroup = as.numeric(df_secondGroup[k,])
          
          myfirstGroup_df = df_firstGroup[i,]
          mysecondGroup_df = df_secondGroup[k,]
          
          mytwosamples_df=rbind(myfirstGroup_df,mysecondGroup_df)
          
          # extract names of non-transferred asvs for each sample
          firstGroup_ASVsThatDidNotTransferToSecondGroup.index = which(myfirstGroup != 0 & mysecondGroup ==0)
          secondGroups_ASVsThatDidNotTransferToFirstGroup.index = which(mysecondGroup != 0 & myfirstGroup==0)
          
          firstGroup_nonTransferredAsvNames = colnames(myfirstGroup_df)[firstGroup_ASVsThatDidNotTransferToSecondGroup.index]
          secondGroup_nonTransferredAsvNames = colnames(mysecondGroup_df)[secondGroups_ASVsThatDidNotTransferToFirstGroup.index]
          
          firstGroup_nonTransferredTaxonomy = taxonomyMap[,taxaColName][taxonomyMap[,asvColName] %in% firstGroup_nonTransferredAsvNames]
          secondGroup_nonTransferredTaxonomy = taxonomyMap[,taxaColName][taxonomyMap[,asvColName] %in% secondGroup_nonTransferredAsvNames]
          
          # extract counts of non-transferred asvs for each sample
          firstGroup_ASVsThatDidNotTransferToSecondGroup = myfirstGroup[which(myfirstGroup != 0 & mysecondGroup ==0)]
          secondGroups_ASVsThatDidNotTransferToFirstGroup = mysecondGroup[which(mysecondGroup != 0 & myfirstGroup==0)]          
          
          #make dataframe of names and counts of non-transferred asvs for each sample
          firstgroup_nonTransferredASVs_df = data.frame("ntASVNames_firstGroup"=firstGroup_nonTransferredAsvNames, 
                                                        "ntTaxonomy_firstGroup" = firstGroup_nonTransferredTaxonomy,
                                                        "ntASVCounts_firstGroup"=firstGroup_ASVsThatDidNotTransferToSecondGroup)
          secondgroup_nonTransferredASVs_df = data.frame("ntASVNames_secondGroup" = secondGroup_nonTransferredAsvNames, 
                                                         "ntTaxonomy_secondGroup" = secondGroup_nonTransferredTaxonomy,
                                                         "ntASVCounts_secondGroup" = secondGroups_ASVsThatDidNotTransferToFirstGroup)
          
          ntASVs_df = full_join(firstgroup_nonTransferredASVs_df, secondgroup_nonTransferredASVs_df,by=c("ntASVNames_firstGroup"="ntASVNames_secondGroup") ,keep=TRUE)
          
          write.table(ntASVs_df, file=paste0(resultsDirectory, "nonTransferredASVS_", outfileLlabels_firstGroup, "_vs_",outfileLlabels_secondGroup,
                                             rownames(df_secondGroup[k,]), "_vs_", rownames(df_firstGroup[i,]), ".txt"),
                      quote = F, row.names = F, sep = "\t")

        }
      }
      
    } 

  } 

}
