## function to generate pcoa plots, flips Y axis
## input: counts table, metadata, colors for metadata groups, legendlocation, and plottitle
## output: pcoa plot

generatePCOAPlots_flipYaxis = function(mycountsTable, mymetagroup,mycolors, 
                                       legendlocation,plotTitle) {
  
  myPcoa = capscale(mycountsTable ~ 1, distance ="bray")
  percentVariance = eigenvals(myPcoa)/sum(eigenvals(myPcoa))
  permanova_allSamples_genus = adonis2(mycountsTable ~ mymetagroup)
  
  a = matrix(c(summary(myPcoa)$site[,1],
               (summary(myPcoa)$site[,2]*(-1))), ncol=2)
  b=plot(summary(myPcoa)$site[,1],(summary(myPcoa)$site[,2]*(-1)),
         col=adjustcolor(mycolors[mymetagroup], alpha.f = 0.7),pch=20, cex=2,
         xlim = c(min(summary(myPcoa)$site[,1])-0.3, 
                  max(summary(myPcoa)$site[,1])+0.3),
         ylim= c(min((summary(myPcoa)$site[,2]*(-1)))-0.3, 
                 max((summary(myPcoa)$site[,2]*(-1))+0.3)),
         main= paste0(plotTitle, " \n", 
                      "R2=", format(permanova_allSamples_genus$R2[1],digits=3),
                      ", P-value=", permanova_allSamples_genus$`Pr(>F)`[1]),
         cex.lab=1.5, 
         xlab=paste("MDS1 (",format(percentVariance[1]*100,digits=4),"%)", sep=""), 
         ylab=paste("MDS 2 (",format(percentVariance[2]*100,digits=4),"%)", sep=""))
  
  ordiellipse(a, mymetagroup, kind = "se", conf=0.95,lwd = 3, draw = "lines",
              col= mycolors)
  
  legend(legendlocation,
         levels(mymetagroup),
         col=mycolors,
         pch=15, cex=0.6)
  
}
