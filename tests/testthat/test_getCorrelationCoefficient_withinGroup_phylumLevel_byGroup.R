context("Check for correct output from getCorrelationCoefficient_withinGroup_phylumLevel_byGroup function")

metadataFile_path=test_path("UseCase_MetadataSample_moreSamples.txt")
asvFile_path=test_path("UseCase_sampleByTaxaFormat.txt")
asv_phylum_map = test_path("UseCase_asv_phylum_map.txt")

usecase_metadataFile = read.table(metadataFile_path, header = T, sep = "\t")
usecase_asvFile = read.table(asvFile_path, header = T, sep = "\t", check.names = F)
usecase_asvPhylumMap = read.table(asv_phylum_map, header = T, sep = "\t")

countsOnly_log10norm = lognorm_function(usecase_asvFile[2:ncol(usecase_asvFile)])
##need to set rownames as sampleID
rownames(countsOnly_log10norm)=usecase_asvFile$SampleID

countsWithMetadata = countsOnly_log10norm
countsWithMetadata$SampleID = usecase_asvFile$SampleID
countsWithMetadata = full_join(countsWithMetadata, usecase_metadataFile, by="SampleID")
                                                                                                                                                                                                                    
phenotypeList = unique(countsWithMetadata$FMTGroupFMTsourcegtRecipientbackground)
phylumList = unique(countsWithMetadata$Phylum)

testoutput_withingroups = getCorrelationCoefficient_withinGroup_phylumLevel_byGroup(
  groupList=phylumList, tableWithMeta=countsWithMetadata, 
  tableCountsOnly=countsOnly_log10norm, 
  corrTestMethod="pearson", sampleGroup = phenotypeList[1], 
  mappingMetaFile = usecase_asvPhylumMap,mappingMetaFile_taxaColName = "ASV", 
  mappingMetaFile_phylumColName = "Phylum", 
  tableWithMeta_sampleColName = "SampleID" ,tableWithMeta_groupColName = "FMTGroupFMTsourcegtRecipientbackground"
)

  # check for correct correlation calculation
asvID_byGroup = usecase_asvPhylumMap$ASV[usecase_asvPhylumMap$Phylum == "Firmicutes"]
samples_byInputRecipientGroup = countsWithMetadata$SampleID[countsWithMetadata$FMTGroupFMTsourcegtRecipientbackground =="1gKOinput"]
check_df_group = countsOnly_log10norm[samples_byInputRecipientGroup,colnames(countsOnly_log10norm) %in% asvID_byGroup]

functionCalculated_correlationResult = testoutput_withingroups[[2]][[1]][1]
expectedCorrelationResult = as.numeric(cor.test(as.numeric(check_df_group[1,]), 
                                                as.numeric(check_df_group[2,]),
                                                method="pearson")$estimate)

#########################################

test_that("Check that the taxa names in dataframes are the same as the taxa names in the metamapping file",
          expect_that(colnames(countsOnly_log10norm), equals(usecase_asvPhylumMap$ASV))
          )

test_that("Check for correct correlation coefficient values",
          expect_that(functionCalculated_correlationResult, equals(expectedCorrelationResult))
          
          )
test_that("Check for correct total number of correlations, within group  ",
          expect_that(length(testoutput_withingroups[[2]][[1]]), equals(choose(nrow(check_df_group),2)))
          )

