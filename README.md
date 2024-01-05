# FMTModelForHumanizedMice

Overview

In our manuscript, we present a transfer efficiency analysis of a fecal microbiome transplant (FMT) model.  Our FMT analysis includes serial transfers of input fecal microbiome to germ-free adult mice with two different host phenotypes (inflamed Il10-/-, non-inflamed WT) where serial passage number is denoted by generation 1, 2, or 3, (-g1, -g2, -g3).  Consistent with published literature, we observed a bottleneck in the engraftment of human microbiome into mice.  Compared to the low transfer efficiency of human microbiome into mice, we observed consistently higher transfer efficiency of mouse-adapted microbiome into mice.  Our results show that mouse-adapted microbiomes are more stable and reproducible compared to the initial transfer from human to mouse microbiome.  
Here, we provide all the data files and code that we used for our analysis.  With these files, one can easily replicate our figures and results. 


Data Files

For this analysis, the 16S rRNA sequence data was processed through the QIIME2 (ver. 2021.2) pipeline and taxonomically classified with DADA2 (ver. 2021.2), resulting in tab-delimited counts data.  
We provided both the original files from the QIIME2 classification (tab-delimited counts data files with no edits or transformations), as well as the version of the counts table that was used for our analysis.  This version was formatted to make it more R-friendly, while keeping the data unchanged.  More detailed notes in data transformations and formatting are available in the R notebook. 
The original counts files are labeled as “feature_table”, while the counts files that were used for our analysis are labeled as “countsTable”.  We used counts tables at the phylum, genus, and strain (amplicon sequence variant, ASV) level.  
Early in our analysis, we updated the labeling nomenclature system of our different FMT groups and samples for easier readability.  As such, we have posted metadata with both the original and current nomenclature, the latter which we used in our analysis pipeline.   


QIIME2 Scripts

These are bash scripts that were submitted and ran on the high-performance computing (HPC) cluster at the University of North Carolina at Charlotte, with the function of running raw sequence files (fastq format) with the DADA2 classification through the QIIME2 pipeline.  The resulting output are the tab-delimited counts tables at the phylum, genus, and ASV level.  


R Scripts

Our goal is to provide scripts that easily replicate and reproduce our analysis.  Here, we have individual R scripts and an R Notebook.  The R Notebook is available in both the R markdown file (RunAllTasks.Rmd) and an HTML file (RunAllTasks.html) for viewing on a browser. 
Each individual R script contains code that performs a specific task (a function), and all of these R functions are invoked throughout the main analysis pipeline, which is provided in the R Notebook.  The R Notebook presents detailed information of each step of our pipeline, as well as all the code to generate figures and tables that are published in our paper.  
To reproduce the figures from this analysis, one would run the code chunks sequentially listed in the R Notebook.  All files are read into the R scripts with relative paths.  Therefore, before running scripts from the R Notebook, please ensure that all R scripts are in the same directory as the R Notebook.  In our analysis, we organized our files within an R project directory, so we recommend organizing all data, metadata and R script files into the same directory, with the data and metadata in a subdirectory (“files”).  


Testing

In an independent testing and validation of our code, Jacqueline B. Young used the original, unedited counts tables and metadata with the original nomenclature to replicate five main figures of our analysis.  These key figures, originally generated in R by Anh D. Moss, were independently successfully replicated using Python by Jacqueline B. Young.  The Jupyter Notebook with the Python scripts and replicated figures are provided in the Supplementary section of our manuscript. 
