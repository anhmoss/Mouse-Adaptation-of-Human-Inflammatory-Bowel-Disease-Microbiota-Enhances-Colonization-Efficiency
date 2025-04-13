# counts and metadata files are under one folder ("Lundberg")
# libraries and functions are listed in the RunAllTasks Notebook



library(here)

my.asv.counts.lundberg = read.table(here("Lundberg", "lundberg_countsTable_asv.txt"), header = T, sep = "\t")
my.metadata.lundberg = read.table(here("Lundberg", "lundberg_metadata_combined.txt"), header = T, sep = "\t")

my.asv.counts.only = my.asv.counts.lundberg[,-which(colnames(my.asv.counts.lundberg) %in% c("taxonomy","OTU_ID"))]

rownames(my.asv.counts.only) = my.asv.counts.lundberg$OTU_ID 

my.asv.counts.only.transposed = t(my.asv.counts.only)


lundberg_countsOnly_asv_normalized=my.asv.counts.only.transposed[which(rowSums(my.asv.counts.only.transposed)!=0),]
lundberg_countsOnly_asv_normalized=lundberg_countsOnly_asv_normalized/rowSums(lundberg_countsOnly_asv_normalized)*mean(rowSums(lundberg_countsOnly_asv_normalized))

my.asv.counts.only.transposed.log10norm = data.frame(lognorm_function(my.asv.counts.only.transposed))
my.asv.counts.only.transposed.log10norm$Run = rownames(my.asv.counts.only.transposed)

#merge counts and metadata dataframes
asv.and.metadata = full_join(my.asv.counts.only.transposed.log10norm, 
                             my.metadata.lundberg, 
                             by="Run")

#parse groups

sampleBiologicalReplicate.index = grep("fecal sample from human microbiota-associated", asv.and.metadata$sample_biological_replicate)

fecal.humanMicrobiomAssociated.df = asv.and.metadata[sampleBiologicalReplicate.index,]

fecal.humanMicrobiomAssociated.myStrain.df = fecal.humanMicrobiomAssociated.df[fecal.humanMicrobiomAssociated.df$Strain=="C57BL6/NTac",]


fecal.humanMicrobiomAssociated.myStrain.age_17_18.df=fecal.humanMicrobiomAssociated.myStrain.df[fecal.humanMicrobiomAssociated.myStrain.df$AgeWeeks=="17-18",]


fecal.humanMicrobiomAssociated.myStrain.age_17_18.groupA.df = fecal.humanMicrobiomAssociated.myStrain.age_17_18.df[fecal.humanMicrobiomAssociated.myStrain.age_17_18.df$Group=="A"]

# parsing counts table for only human samples 
counts.for.humanInoculum = asv.and.metadata[asv.and.metadata$sample_biological_replicate=="Human fecal inoculum",]

# combining human counts samples to selected mice samples
fecal.humanMicrobiomAssociated.myStrain.age_17_18.groupA.plusHumanInoculum.df = rbind(fecal.humanMicrobiomAssociated.myStrain.age_17_18.groupA.df,counts.for.humanInoculum)


#define group labels
generation.labels.PtoF1 = c("P", "F1")
generation.labels.humanToP = c("HumanInoculum", "P")


# transfer efficiency (pearson): human to P ; p to f1

transferEfficiencyResults.humantoP.age_17_18 = getCorrelationCoefficient_acrossGroup(groupList=generation.labels.humanToP, tableWithMeta=fecal.humanMicrobiomAssociated.myStrain.age_17_18.groupA.plusHumanInoculum.df, 
                                                                                     tableCountsOnly=my.asv.counts.only.transposed.log10norm, corrTestMethod="pearson",
                                                                                     variableName = "Generation",
                                                                                     sampleColumnName = "Run")


transferEfficiencyResults.PtoF1.age_17_18 = getCorrelationCoefficient_acrossGroup(groupList=generation.labels.PtoF1, tableWithMeta=fecal.humanMicrobiomAssociated.myStrain.age_17_18.groupA.df, 
                                                                                  tableCountsOnly=my.asv.counts.only.transposed.log10norm, corrTestMethod="pearson",
                                                                                  variableName = "Generation",
                                                                                  sampleColumnName = "Run")

## boxplot with both human-to-mouse and mouse-to-mouse transfer efficiencies
boxplot(c(transferEfficiencyResults.humantoP.age_17_18[[2]],transferEfficiencyResults.PtoF1.age_17_18[[2]]),
        names = c("Human vs P","P vs F1"),
        cex.axis=1.2,
        main="Transfer Efficiency Across Groups, \nAge 17-18 (Weeks)", cex.main=0.8,
        ylim=c(0,1), xlab="Pearson Correlation Coefficients")

stripchart(c(transferEfficiencyResults.humantoP.age_17_18[[2]],transferEfficiencyResults.PtoF1.age_17_18[[2]]), add=T, vertical=T, pch=16)

