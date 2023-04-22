## correlations for samples within Groups, per cage
#input: tableWithMeta(dataframe with counts and metadata),corrTestMethod(correlation test), 
#phenotypeGroup: (phenotype to subset the samples by (ie input/recipient), only one input), and column names for sample, group, and cage metadata
#output: a list with two list elements: a list of all cages, and a list of lists of correlation coefficient between sample pairs within each cage

getCorrelationCoefficient_withinGroup_perCage = function(tableWithMeta, 
                                                         corrTestMethod, phenotypeGroup, 
                                                         tableWithMeta_sampleColName,
                                                         tableWithMeta_groupColName,
                                                         tableWithMeta_cageColName){
  
  corr_rho_withinGroups_list = list()
  group_labels=list()
  
  
  for(m in 1:length(phenotypeGroup)){
    
    rownames(tableWithMeta) = tableWithMeta[,tableWithMeta_sampleColName]
    
    samples_byInputRecipientGroup = tableWithMeta[,tableWithMeta_sampleColName][tableWithMeta[,tableWithMeta_groupColName] %in% phenotypeGroup[m]]
    df_groupAndCage = tableWithMeta[samples_byInputRecipientGroup,]
    uniqueCages = unique(df_groupAndCage[,tableWithMeta_cageColName])

    for(n in 1:length(uniqueCages)){
      df_group_perCage_alldf = df_groupAndCage[df_groupAndCage[,tableWithMeta_cageColName] %in% uniqueCages[n],]
      df_group_perCage = df_group_perCage_alldf[,1:4075]
          
      corr_rho_perGroup = vector()
      label_perCageWithinGroup = list()
      
      if(nrow(df_group_perCage)<=1){
        print(paste0("Only one sample in cage: ", uniqueCages[n]))
        cagelabel = paste0("Only one sample in cage:: ", uniqueCages[n])
        label_perCageWithinGroup[length(label_perCageWithinGroup)+1]=cagelabel
      } else {cagelabel = paste0("Cage: ", uniqueCages[n])
      label_perCageWithinGroup[length(label_perCageWithinGroup)+1]=cagelabel
        
        for(i in 1:(nrow(df_group_perCage)-1)){
              for(k in (i+1): nrow(df_group_perCage)){
              corr_rho = cor.test(as.numeric(df_group_perCage[i,]), as.numeric(df_group_perCage[k,]), method = corrTestMethod)$estimate
              corr_rho_perGroup[length(corr_rho_perGroup)+1] = corr_rho
        
              } } }
    
    corr_rho_withinGroups_list[[length(corr_rho_withinGroups_list)+1]] = corr_rho_perGroup
    group_labels[[length(group_labels)+1]] = uniqueCages[n]
    
    } 

    } 
  
  outfileLabels_grouplabels = gsub("->", "_to_", group_labels) 
  
  return(list(outfileLabels_grouplabels,corr_rho_withinGroups_list)) 
}

