## correlations for samples WITHIN Groups for each phylum groups
#input: grouplist(list of phylum groups, can be a list of multiple phyla), tableWithMeta(dataframe with counts and metadata), 
# tableCountsOnly(dataframe with counts only (lognormalized)), corrTestMethod(correlation test), 
#sampleGroup (phenotype to subset the samples by (ie input/recipient), only one input), mappingMetaFile(metadata that maps asv/taxa to phyla)
#output: a list of group pair labels for each correlation, a list of lists of correlation coefficient for sample pairs within groups

getCorrelationCoefficient_withinGroup_phylumLevel_byGroup = function(groupList, tableWithMeta, tableCountsOnly, 
                                                                    corrTestMethod, sampleGroup, mappingMetaFile,
                                                                    mappingMetaFile_taxaColName, 
                                                                    mappingMetaFile_phylumColName,
                                                                    tableWithMeta_sampleColName,
                                                                    tableWithMeta_groupColName){
  
  corr_rho_withinGroups_list = list()
  group_labels=list()

  
  for(m in 1:length(groupList)){
      
      asvID_byGroup = mappingMetaFile[,mappingMetaFile_taxaColName][mappingMetaFile[,mappingMetaFile_phylumColName] %in% groupList[m]]
      
      samples_byInputRecipientGroup = tableWithMeta[,tableWithMeta_sampleColName][tableWithMeta[,tableWithMeta_groupColName] %in% sampleGroup]
      
      df_group = tableCountsOnly[samples_byInputRecipientGroup,colnames(tableCountsOnly) %in% asvID_byGroup]
      
      corr_rho_perGroup = vector()
      
      for(i in 1:(nrow(df_group)-1)){
        for(k in (i+1): nrow(df_group)){
          corr_rho = cor.test(as.numeric(df_group[i,]), as.numeric(df_group[k,]), method = corrTestMethod)$estimate
          corr_rho_perGroup[length(corr_rho_perGroup)+1] = corr_rho
          
        } }
      
      corr_rho_withinGroups_list[[length(corr_rho_withinGroups_list)+1]] = corr_rho_perGroup
      group_labels[length(group_labels)+1] = paste0("Phylum:", groupList[m], ", SampleGroup:",sampleGroup)
      
    } 
 
  outfileLabels_grouplabels = gsub("->", "_to_", group_labels) 

return(list(outfileLabels_grouplabels,corr_rho_withinGroups_list)) 
}

