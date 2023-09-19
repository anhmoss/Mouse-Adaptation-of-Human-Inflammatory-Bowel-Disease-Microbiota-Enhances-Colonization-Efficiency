## get asv abundances of those that did not transfer

## generate scatterplots for sample pairs ACROSS Groups
#input: directory path for results, list of interest groups/labels, dataframe with counts and metadata, 
# input: dataframe with counts only (lognormalized), correlation test/method, pick corr estimate or pval
#output: a list of lists, of corr results within each interest group

generateScatterPlots_samplePairsAcrossGroup_histogramOfNontransferringASVS = function(groupList, tableWithMeta, 
                                                                                      tableCountsOnly,
                                                                                      resultsDirectory){
  
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
          
          myfirstGroup = as.numeric(df_firstGroup[i,])
          mysecondGroup = as.numeric(df_secondGroup[k,])
                           
          firstGroup_ASVsThatDidNotTransferToSecondGroup = myfirstGroup[myfirstGroup != 0 & mysecondGroup ==0]
          secondGroups_ASVsThatDidNotTransferToFirstGroup = mysecondGroup[mysecondGroup != 0 & myfirstGroup==0]
          
          h1 = hist(firstGroup_ASVsThatDidNotTransferToSecondGroup, breaks=seq(0,5,length.out=10))
          h2 = hist(secondGroups_ASVsThatDidNotTransferToFirstGroup, breaks=seq(0,5,length.out=10))
          
          pdf(paste0(resultsDirectory, "nonTransferredASVS_acrossGroups_", outfileLlabels_firstGroup, "_vs_",outfileLlabels_secondGroup,
                      rownames(df_firstGroup[i,]), "_vs_", rownames(df_secondGroup[k,]), ".pdf"))
          
          plot(h1, col="red", main=paste0("Abundance Comparison of Non-transferred ASVs, \nAcross Groups: ", 
                                          labels_firstGroup, "_vs_",labels_secondGroup),
               xlab="Abundance of Non-transferred ASVs(Log10 Normalized)",xlim=c(0,5),ylim=c(0,120), cex.lab=1.5)
          plot(h2, col=scales::alpha("blue",.5), main=paste0("Abundance Comparison of Non-transferred ASVs, \nAcross Groups: ", 
                    labels_firstGroup, "_vs_",labels_secondGroup),cex.lab=1.5,
               add = T, xlim=c(0,5), ylim=c(0,120))
          op <- par(cex = 1.3)
          legend("topright", c(paste0(labels_firstGroup, " Sample: ", rownames(df_firstGroup[i,])),
                               paste0(labels_secondGroup, " Sample: ",rownames(df_secondGroup[k,]))),
          fill=c("red", "blue"), border = NA)
         dev.off() 
          
        }
      }
    } 
  }
}
