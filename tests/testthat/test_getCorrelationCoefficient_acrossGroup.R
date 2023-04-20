context("Check output for getCorrelationCoefficient_acrossGroup function")

metadataFile_path=test_path("useCaseFiles/UseCase_MetadataSample_moreSamples.txt")
asvFile_path=test_path("useCaseFiles/UseCase_sampleByTaxaFormat.txt")

usecase_metadataFile = read.table(metadataFile_path, header = T, sep = "\t")
usecase_asvFile = read.table(asvFile_path, header = T, sep = "\t")


countsOnly_log10norm = lognorm_function(usecase_asvFile[2:ncol(usecase_asvFile)])
##need to set rownames as sampleID
rownames(countsOnly_log10norm)=usecase_asvFile$SampleID

countsWithMetadata = countsOnly_log10norm
countsWithMetadata$SampleID = usecase_asvFile$SampleID
countsWithMetadata = full_join(countsWithMetadata, usecase_metadataFile, by="SampleID")

phenotypeList = unique(countsWithMetadata$FMTGroupFMTsourcegtRecipientbackground)

testoutput_acrossgroups =getCorrelationCoefficient_acrossGroup(groupList=phenotypeList, tableWithMeta=countsWithMetadata, 
                                                               tableCountsOnly=countsOnly_log10norm, 
                                                               corrTestMethod="pearson",
                                                               variableName = "FMTGroupFMTsourcegtRecipientbackground",
                                                               sampleColumnName = "SampleID")
# subset for correlation check
subset_group1=countsOnly_log10norm[countsWithMetadata$FMTGroupFMTsourcegtRecipientbackground==phenotypeList[1],]
subset_group2=countsOnly_log10norm[countsWithMetadata$FMTGroupFMTsourcegtRecipientbackground==phenotypeList[2],]

# check for correct correlation calculation
functionCalculated_correlationResult_across = testoutput_acrossgroups[[2]][[1]][1]
expectedCorrelationResult_across = as.numeric(cor.test(as.numeric(subset_group1[1,]), 
                                                as.numeric(subset_group2[1,]),
                                                method="pearson")$estimate)

# check number of sample pairs
a = usecase_metadataFile$SampleID[usecase_metadataFile$FMTGroupFMTsourcegtRecipientbackground==phenotypeList[1]]
b = usecase_metadataFile$SampleID[usecase_metadataFile$FMTGroupFMTsourcegtRecipientbackground==phenotypeList[2]]

totalSamplePairs_across = length(a) * length(b)

#########################################

test_that("Check for correct correlation values",
          expect_that(functionCalculated_correlationResult_across, equals(expectedCorrelationResult_across))
          
)
test_that("Check for correct total number of correlations across group",
          expect_that(length(testoutput_acrossgroups[[2]][[1]]), equals(totalSamplePairs_across))
)




