load("/home/xtai/Desktop/data/imageData.Rdata")
setwd("/home/xtai/Desktop/updatePackage")

resultsList <- system("ls ./comparisonResults/", intern = TRUE)
for (i in 1:(length(resultsList))) {
    load(paste0("./comparisonResults/", resultsList[i]))
    matches <- which(imageData$gun == imageData$gun[imageData$image == substr(resultsList[i], 1, 8)] & imageData$image != substr(resultsList[i], 1, 8))
    compare$match <- 0
    
    compare$match[compare$compare %in% imageData$image[matches]] <- 1
    compare$newImage <- substr(resultsList[i], 1, 8)
    
    save(compare, file = paste0("./comparisonResults/", resultsList[i]))
}

# rbind all
load(paste0("./comparisonResults/", resultsList[1]))
allResults <- compare
for (i in 2:(length(resultsList))) {
    load(paste0("./comparisonResults/", resultsList[i]))
    allResults <- rbind(allResults, compare)
}
save(allResults, file = "./comparisonResults/allResults.Rdata")

# histogram
png(file = "./comparisonResults/distributionCCFmax.png", width = 500, height = 400)
hist(allResults$corr[allResults$match == 0], freq = FALSE, main = "Distribution of CCFmax", xlab = "CCFmax", xlim = c(0, .5), col = adjustcolor("red", alpha.f = .75))
hist(allResults$corr[allResults$match == 1], freq = FALSE, add = TRUE, col = adjustcolor("forestgreen", alpha.f = .75), breaks = 60)

legend("topright", legend = c(paste0("True Non-match (N=10692), mean=", sprintf("%.3f", mean(allResults$corr[allResults$match == 0]))), paste0("True Match (N=864), mean=", sprintf("%.3f", mean(allResults$corr[allResults$match == 1])))), fill = c("red", "forestgreen"))
dev.off()


########## Step 6: compute p-value
load("./comparisonResults/allResults.Rdata")
library(cartridges)

newImages <- unique(allResults$newImage)

for (i in 1:length(newImages)) {
    empNull <- allResults$corr[allResults$compare != newImages[i] & allResults$newImage != newImages[i] & allResults$match == 0]
    
    allResults$pValue[allResults$newImage == newImages[i]] <- unlist(lapply(allResults[allResults$newImage == newImages[i], "corr"], FUN = function(x) computeProb(x, empNull)))
}

save(allResults, file = "./comparisonResults/allResults.Rdata")

png(file = "./comparisonResults/distributionProbs.png", width = 800, height = 400)
par(mfrow = c(1, 2))
par(mar = c(5.1, 5.1, 4.1, 2.1))
hist(allResults$pValue[allResults$match == 0], main = "Histogram of p-values for non-matches", xlab = "p-value", breaks = 50, col = adjustcolor("red", alpha.f = .75))
mtext(paste0("N=10692, mean=", sprintf("%.3f", mean(allResults$pValue[allResults$match == 0]))), side = 3)
hist(allResults$pValue[allResults$match == 1], main = "Histogram of p-values for matches", xlab = "p-value", breaks = 50, col = adjustcolor("forestgreen", alpha.f = .85))
mtext(paste0("N=864, mean=", sprintf("%.3f", mean(allResults$pValue[allResults$match == 1]))), side = 3)
dev.off()
