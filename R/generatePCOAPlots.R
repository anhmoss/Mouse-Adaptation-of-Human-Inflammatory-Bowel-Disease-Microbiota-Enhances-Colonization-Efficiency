## function to generate pcoa plots
## input: counts table, metadata, colors for metadata groups, legendlocation, and plottitle
## output: pcoa plot

generatePCOAPlots = function(mycountsTable, mymetagroup,mycolors, 
                             legendlocation,plotTitle) {

myPcoa = capscale(mycountsTable ~ 1, distance ="bray")
percentVariance = eigenvals(myPcoa)/sum(eigenvals(myPcoa))
permanova_allSamples_genus = adonis2(mycountsTable ~ mymetagroup)

pcoa_12 = ordiplot(myPcoa, choices = c(1,2), 
                   main= paste0(plotTitle, " \n", 
    "R2=", format(permanova_allSamples_genus$R2[1],digits=3),
                                ", P-value=", permanova_allSamples_genus$`Pr(>F)`[1]),
                   type = "none", display="sites", cex.lab=1.5, 
                   xlab=paste("MDS1 (",format(percentVariance[1]*100,digits=4),"%)", sep=""), 
                   ylab=paste("MDS 2 (",format(percentVariance[2]*100,digits=4),"%)", sep=""))

points(pcoa_12, "sites",
       col=adjustcolor(mycolors[mymetagroup], alpha.f = 0.7),pch=20, cex=2)

ordiellipse(pcoa_12, mymetagroup, kind = "se", conf=0.95,lwd = 3, draw = "lines",
            col= mycolors)

legend(legendlocation,
       levels(mymetagroup),
       col=mycolors,
       pch=15, cex=0.6)

}