context("Testing function: getCorrelationCoefficient_withinGroup_perCage")

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
mymetalist = c("SampleID","FMTGroupFMTsourcegtRecipientbackground","Phylum", "Cage")

test_withinGroups_perCage = getCorrelationCoefficient_withinGroup_perCage(tableWithMeta=countsWithMetadata, 
                                                                     corrTestMethod="pearson", 
                                                                     phenotypeGroup=phenotypeList, 
                                                                     tableWithMeta_sampleColName="SampleID",
                                                                     tableWithMeta_groupColName="FMTGroupFMTsourcegtRecipientbackground",
                                                                     tableWithMeta_cageColName="Cage",
                                                                     metadataNames = mymetalist)

#setting variables for tests
mycage_index = as.integer(6) #integer input here selects the cage group index to test
mycage_check = unique(countsWithMetadata$Cage)[mycage_index]
mycage_check_functionResult = test_withinGroups_perCage[[2]][[mycage_index]]
numberOfSamplesIn_mycagecheck = sum(countsWithMetadata$Cage==mycage_check)

#########################################

test_that("Check for correct number of cages",
          expect_that(length(test_withinGroups_perCage[[1]]), equals(length(unique(countsWithMetadata$Cage))))
          
)
test_that("Check for correct total number of results",
          expect_that(length(test_withinGroups_perCage[[1]]), equals(length(test_withinGroups_perCage[[2]])))
)
test_that("Check for correct total number of correlations for a given cage",
          expect_that(choose(numberOfSamplesIn_mycagecheck,2), equals(length(mycage_check_functionResult)))
)
