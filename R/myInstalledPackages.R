# Installing and loading packages for this study

packagesToInstall = c("ggplot2", "vegan", "dplyr", "testthat")
install.packages(packagesToInstall) 
lapply(packagesToInstall, library, character.only=TRUE)