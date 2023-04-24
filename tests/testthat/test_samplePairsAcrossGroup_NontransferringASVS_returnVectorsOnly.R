context("Check output for samplePairsAcrossGroup_NontransferringASVS_returnVectorsOnly function")

metadataFile_path=test_path("useCaseFiles/UseCase_MetadataSample_moreSamples.txt")
asvFile_path=test_path("useCaseFiles/UseCase_nontransferredASVsCountsTable.txt")

usecase_metadataFile = read.table(metadataFile_path, header = T, sep = "\t")
usecase_asvFile = read.table(asvFile_path, header = T, sep = "\t")

# 
countsOnly= usecase_asvFile[2:ncol(usecase_asvFile)]
rownames(countsOnly)=usecase_asvFile$SampleID

countsWithMetadata = countsOnly
countsWithMetadata$SampleID = usecase_asvFile$SampleID
countsWithMetadata = full_join(countsWithMetadata, usecase_metadataFile, by="SampleID")

phenotypeList = unique(usecase_metadataFile$FMTGroupFMTsourcegtRecipientbackground)

testoutput_acrossgroups_ntASVs =samplePairsAcrossGroup_NontransferringASVS_returnVectorsOnly(groupList=phenotypeList, 
                                                               tableWithMeta=countsWithMetadata, 
                                                               tableCountsOnly=countsOnly, 
                                                               variableName = "FMTGroupFMTsourcegtRecipientbackground",
                                                               sampleColumnName = "SampleID")
# check number of sample pairs
a = usecase_metadataFile$SampleID[usecase_metadataFile$FMTGroupFMTsourcegtRecipientbackground==phenotypeList[1]]
b = usecase_metadataFile$SampleID[usecase_metadataFile$FMTGroupFMTsourcegtRecipientbackground==phenotypeList[2]]

totalSamplePairs_across = length(a) * length(b)

known_nontransferredASV_firstone = 13615

#########################################

test_that("Check for correct count values",
          expect_that(testoutput_acrossgroups_ntASVs[[1]][[1]][1], equals(known_nontransferredASV_firstone))
          
)
test_that("Check for correct number of results",
          expect_that(length(testoutput_acrossgroups_ntASVs), equals(totalSamplePairs_across))
)




