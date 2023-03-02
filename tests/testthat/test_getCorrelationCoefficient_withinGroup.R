context("Check output for getCorrelationCoefficient_withinGroup function")

usecase_metadataFile = read.table("./tests/UseCase_MetadataSample_moreSamples.txt", header = T, sep = "\t")
usecase_asvFile = read.table("./tests/UseCase_sampleByTaxaFormat.txt", header = T, sep = "\t")

countsOnly_log10norm = lognorm_function(usecase_asvFile[2:ncol(usecase_asvFile)])

## set rownames as sampleID
rownames(countsOnly_log10norm)=usecase_asvFile$SampleID

countsWithMetadata = countsOnly_log10norm
countsWithMetadata$SampleID = usecase_asvFile$SampleID
countsWithMetadata = full_join(countsWithMetadata, usecase_metadataFile, by="SampleID")

phenotypeList = unique(countsWithMetadata$FMTGroupFMTsourcegtRecipientbackground)

testoutput_withingroups = getCorrelationCoefficient_withinGroup(groupList=phenotypeList, tableWithMeta=countsWithMetadata, 
                                                                tableCountsOnly=countsOnly_log10norm, 
                                                                corrTestMethod="pearson")


# check for correct correlation calculation
functionCalculated_correlationResult = testoutput_withingroups[[1]][1]
expectedCorrelationResult = as.numeric(cor.test(as.numeric(countsOnly_log10norm[1,]), 
                                     as.numeric(countsOnly_log10norm[2,]),
                                method="pearson")$estimate)

#check number of sample pairs
a = usecase_metadataFile$SampleID[usecase_metadataFile$FMTGroupFMTsourcegtRecipientbackground==phenotypeList[1]]
b = usecase_metadataFile$SampleID[usecase_metadataFile$FMTGroupFMTsourcegtRecipientbackground==phenotypeList[2]]

totalSamplePairs_within_a = choose(length(a),2)
totalSamplePairs_within_b = choose(length(b),2)

#########################################

test_that("Check for correct correlation values",
          expect_that(functionCalculated_correlationResult, equals(expectedCorrelationResult))

)
test_that("Check for correct total number of correlations, within group  ",
          expect_that(length(testoutput_withingroups[[1]]), equals(totalSamplePairs_within_a))
)
test_that("Check for correct total number of correlations, within group  ",
          expect_that(length(testoutput_withingroups[[2]]), equals(totalSamplePairs_within_b))
)
