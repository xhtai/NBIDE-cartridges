####################### get files organized #######################
load("/home/xtai/Desktop/NBIDEcartridges/data/imageData.Rdata")
setwd("/home/xtai/Desktop/research/code/2_February/")

resultsList <- system("ls ./comparisonResults/", intern = TRUE)

# rbind all
load(paste0("./comparisonResults/", resultsList[1]))
matches <- which(imageData$gun == imageData$gun[imageData$image == substr(resultsList[1], 1, 8)] & imageData$image != substr(resultsList[1], 1, 8))
compare$match <- 0

compare$match[compare$compare %in% imageData$image[matches]] <- 1
compare$newImage <- substr(resultsList[1], 1, 8)

allResults <- compare
for (i in 2:(length(resultsList))) {
    load(paste0("./comparisonResults/", resultsList[i]))
    matches <- which(imageData$gun == imageData$gun[imageData$image == substr(resultsList[i], 1, 8)] & imageData$image != substr(resultsList[i], 1, 8))
    compare$match <- 0
    
    compare$match[compare$compare %in% imageData$image[matches]] <- 1
    compare$newImage <- substr(resultsList[i], 1, 8)

    allResults <- rbind(allResults, compare)
}
save(allResults, file = "./comparisonResults/allResults.Rdata")

########## Step 6: compute p-value
load("./comparisonResults/allResults.Rdata")
library(cartridges)

newImages <- unique(allResults$newImage)

for (i in 1:length(newImages)) {
    empNull <- allResults$corr[allResults$compare != newImages[i] & allResults$newImage != newImages[i] & allResults$match == 0]
    
    allResults$pValue[allResults$newImage == newImages[i]] <- unlist(lapply(allResults[allResults$newImage == newImages[i], "corr"], FUN = function(x) computeProb(x, empNull)))
}

save(allResults, file = "./comparisonResults/allResults.Rdata")


#### repeat for WO step 1
load("/home/xtai/Desktop/NBIDEcartridges/data/imageData.Rdata")
setwd("/home/xtai/Desktop/research/code/2_February/")

resultsList <- system("ls ./comparisonResultsWO1/", intern = TRUE)

# rbind all
load(paste0("./comparisonResultsWO1/", resultsList[1]))
matches <- which(imageData$gun == imageData$gun[imageData$image == substr(resultsList[1], 1, 8)] & imageData$image != substr(resultsList[1], 1, 8))
compare$match <- 0

compare$match[compare$compare %in% imageData$image[matches]] <- 1
compare$newImage <- substr(resultsList[1], 1, 8)

allResults <- compare
for (i in 2:(length(resultsList))) {
    load(paste0("./comparisonResultsWO1/", resultsList[i]))
    matches <- which(imageData$gun == imageData$gun[imageData$image == substr(resultsList[i], 1, 8)] & imageData$image != substr(resultsList[i], 1, 8))
    compare$match <- 0
    
    compare$match[compare$compare %in% imageData$image[matches]] <- 1
    compare$newImage <- substr(resultsList[i], 1, 8)
    
    allResults <- rbind(allResults, compare)
}
save(allResults, file = "./comparisonResultsWO1/allResults.Rdata")


#### repeat for WO step 3
load("/home/xtai/Desktop/NBIDEcartridges/data/imageData.Rdata")
setwd("/home/xtai/Desktop/research/code/2_February/")

resultsList <- system("ls ./comparisonResultsWO3/", intern = TRUE)

# rbind all
load(paste0("./comparisonResultsWO3/", resultsList[1]))
matches <- which(imageData$gun == imageData$gun[imageData$image == substr(resultsList[1], 1, 8)] & imageData$image != substr(resultsList[1], 1, 8))
compare$match <- 0

compare$match[compare$compare %in% imageData$image[matches]] <- 1
compare$newImage <- substr(resultsList[1], 1, 8)

allResults <- compare
for (i in 2:(length(resultsList))) {
    load(paste0("./comparisonResultsWO3/", resultsList[i]))
    matches <- which(imageData$gun == imageData$gun[imageData$image == substr(resultsList[i], 1, 8)] & imageData$image != substr(resultsList[i], 1, 8))
    compare$match <- 0
    
    compare$match[compare$compare %in% imageData$image[matches]] <- 1
    compare$newImage <- substr(resultsList[i], 1, 8)
    
    allResults <- rbind(allResults, compare)
}
save(allResults, file = "./comparisonResultsWO3/allResults.Rdata")

############ combine all of the results
load("./comparisonResultsWO3/allResults.Rdata")
combinedResults <- allResults[, c("compare", "newImage", "match", "corr")]
names(combinedResults)[4] <- "step1"

load("./comparisonResultsWO1/allResults.Rdata")
combinedResults <- cbind(combinedResults, allResults[, "corr"])
names(combinedResults)[5] <- "step3"

load("./comparisonResults/allResults.Rdata")
combinedResults <- cbind(combinedResults, allResults[, "corr"])
names(combinedResults)[6] <- "step1and3"

# add published results
resultsList <- system("ls /home/xtai/Desktop/NBIDEcartridges/data/3_MSUinR/results/", intern = TRUE) # these are results from published method

# rbind all
load(paste0("/home/xtai/Desktop/NBIDEcartridges/data/3_MSUinR/results/", resultsList[1]))
MSUresults <- compare
for (i in 2:108) {
    load(paste0("/home/xtai/Desktop/NBIDEcartridges/data/3_MSUinR/results/", resultsList[i]))
    MSUresults <- rbind(MSUresults, compare)
}
combinedResults <- cbind(combinedResults, MSUresults[, "corr"])
names(combinedResults)[7] <- "published"

save(combinedResults, file = "/home/xtai/Desktop/research/code/2_February/combinedResults.Rdata")

############################ plots #########################
load("./comparisonResults/allResults.Rdata")

# histogram
png(file = "./comparisonResults/distributionCCFmax.png", width = 500, height = 400)
hist(allResults$corr[allResults$match == 0], freq = FALSE, main = "Distribution of CCFmax", xlab = "CCFmax", xlim = c(0, .5), col = adjustcolor("red", alpha.f = .75))
hist(allResults$corr[allResults$match == 1], freq = FALSE, add = TRUE, col = adjustcolor("forestgreen", alpha.f = .75), breaks = 60)

legend("topright", legend = c(paste0("True Non-match (N=10692), mean=", sprintf("%.3f", mean(allResults$corr[allResults$match == 0]))), paste0("True Match (N=864), mean=", sprintf("%.3f", mean(allResults$corr[allResults$match == 1])))), fill = c("red", "forestgreen"))
dev.off()


png(file = "./comparisonResults/distributionProbs.png", width = 800, height = 400)
par(mfrow = c(1, 2))
par(mar = c(5.1, 5.1, 4.1, 2.1))
hist(allResults$pValue[allResults$match == 0], main = "Histogram of probabilities for non-matches", xlab = "Random match probability", breaks = 50, col = adjustcolor("red", alpha.f = .75))
mtext(paste0("N=10692, mean=", sprintf("%.3f", mean(allResults$pValue[allResults$match == 0]))), side = 3)
hist(allResults$pValue[allResults$match == 1], main = "Histogram of probabilities for matches", xlab = "Random match probability", breaks = 50, col = adjustcolor("forestgreen", alpha.f = .85))
mtext(paste0("N=864, mean=", sprintf("%.3f", mean(allResults$pValue[allResults$match == 1]))), side = 3)
dev.off()

###### split by type of comparison (for checking assumption)
load("/home/xtai/Desktop/NBIDEcartridges/data/imageData.Rdata")
# null distribution
nullDist <- allResults[allResults$match == 0, c("corr", "compare", "newImage")]
nullDist$compareGun <- imageData[match(nullDist$compare, imageData$image), "gunMake"]
nullDist$compareCartridge <- imageData[match(nullDist$compare, imageData$image), "cartridge"]
nullDist$newImageGun <- imageData[match(nullDist$newImage, imageData$image), "gunMake"]
nullDist$newImageCartridge <- imageData[match(nullDist$newImage, imageData$image), "cartridge"]
nullDist$nullType <- 2*(nullDist$compareGun == nullDist$newImageGun) + (nullDist$compareCartridge == nullDist$newImageCartridge)



png(file = "/home/xtai/Desktop/research/code/2_February/comparisonResults/empiricalNullByType_pres_v2.png", width = 600, height = 600)
#png(file = "/home/xtai/Desktop/research/code/10_October/oct21/results/empiricalNullByType_v2.png", width = 600, height = 600)
par(mfrow = c(4, 1))
par(mar = c(2.1, 5.1, 4.1, 2.1))
hist(nullDist$corr[nullDist$nullType == 3], breaks = 50, xlim = c(.04, .12), main = "Same gun/cartridge brand (972 obs)", col = "salmon", freq = FALSE, ylim = c(0, 70), cex.lab = 1.5, cex.main = 2, cex.axis = 1.5)
hist(nullDist$corr[nullDist$nullType == 2], breaks = 50, xlim = c(.04, .12), main = "Same gun brand, different cartridge brand (1944 obs)", col = "cadetblue", freq = FALSE, ylim = c(0, 70), cex.lab = 1.5, cex.main = 2, cex.axis = 1.5)
hist(nullDist$corr[nullDist$nullType == 1], breaks = 50, xlim = c(.04, .12), main = "Different gun brand, same cartridge brand (2592 obs)", col = "darkorchid", freq = FALSE, ylim = c(0, 70), cex.lab = 1.5, cex.main = 2, cex.axis = 1.5)
hist(nullDist$corr[nullDist$nullType == 0], breaks = 50, xlim = c(.04, .12), main = "Different gun/cartridge brand (5184 obs)", col = "deeppink", freq = FALSE, ylim = c(0, 70), cex.lab = 1.5, cex.main = 2, cex.axis = 1.5)
dev.off()


############ comparison plots
load("/home/xtai/Desktop/research/code/2_February/combinedResults.Rdata")

png(file = "/home/xtai/Desktop/research/code/2_February/resultsVsPublished.png", width = 1200, height = 400)
par(mfrow = c(1, 3))
par(mar = c(5.1, 5.1, 4.1, 2.1))
MASS::eqscplot(combinedResults$published, combinedResults$step1, col = ifelse(combinedResults$match == 0, "red", "white"), xlab = "Published Methods", ylab = "Step 1", main = "Automatic breechface selection", cex.main = 2, cex.axis = 2, cex.lab = 2, cex = .3)
points(combinedResults$published[combinedResults$match == 1], combinedResults$step1[combinedResults$match == 1], col = "forestgreen", cex = .3)
abline(a = 0, b = 1)
abline(lm(combinedResults$step1[combinedResults$match == 1] ~ combinedResults$published[combinedResults$match == 1]), lty = 2)
abline(lm(combinedResults$step1 ~ combinedResults$published), lty = 5)
legend("topleft", legend = c("True Non-match", "True Match", "45-degree line", "Best fit line", "Best fit line (true matches)"), col = c("red", "forestgreen", "black", "black", "black"), lty = c(0, 0, 1, 5, 2), pt.bg = c("red", "forestgreen", NA, NA, NA), pch = c(22, 22, NA, NA, NA), cex = 1.5)


MASS::eqscplot(combinedResults$published, combinedResults$step3, col = ifelse(combinedResults$match == 0, "red", "white"), xlab = "Published Methods", ylab = "Step 3", main = "Removing circular symmetry", cex.main = 2, cex.axis = 2, cex.lab = 2, cex = .3)
points(combinedResults$published[combinedResults$match == 1], combinedResults$step3[combinedResults$match == 1], cex = .3, col = "forestgreen")
abline(a = 0, b = 1)
abline(lm(combinedResults$step3[combinedResults$match == 1] ~ combinedResults$published[combinedResults$match == 1]), lty = 2)
abline(lm(combinedResults$step3 ~ combinedResults$published), lty = 5)
legend("topleft", legend = c("True Non-match", "True Match", "45-degree line", "Best fit line", "Best fit line (true matches)"), col = c("red", "forestgreen", "black", "black", "black"), lty = c(0, 0, 1, 5, 2), pt.bg = c("red", "forestgreen", NA, NA, NA), pch = c(22, 22, NA, NA, NA), cex = 1.5)

MASS::eqscplot(combinedResults$published, combinedResults$step1and3, col = ifelse(combinedResults$match == 0, "red", "white"), xlab = "Published Methods", ylab = "Step 1 and 3", main = "Both", cex.main = 2, cex.axis = 2, cex.lab = 2, cex = .3)
points(combinedResults$published[combinedResults$match == 1], combinedResults$step1and3[combinedResults$match == 1], cex = .3, col = "forestgreen")
abline(a = 0, b = 1)
abline(lm(combinedResults$step1and3[combinedResults$match == 1] ~ combinedResults$published[combinedResults$match == 1]), lty = 2)
abline(lm(combinedResults$step1and3 ~ combinedResults$published), lty = 5)
legend("topleft", legend = c("True Non-match", "True Match", "45-degree line", "Best fit line", "Best fit line (true matches)"), col = c("red", "forestgreen", "black", "black", "black"), lty = c(0, 0, 1, 5, 2), pt.bg = c("red", "forestgreen", NA, NA, NA), pch = c(22, 22, NA, NA, NA), cex = 1.5)

dev.off()

######### top 10 lists
splitByNew <- split(combinedResults, f = combinedResults$newImage)
splitByNew <- lapply(splitByNew, FUN = function(x) x[order(x$step1and3, decreasing = TRUE), ])
matchesTop10 <- unlist(lapply(splitByNew, FUN = function(x) sum(x$match[1:10])))
table(matchesTop10)
# 1  2  3  4  5  6  7  8 
# 2  2  3  4  1  7 21 68 

# just step 1
splitByNewStep1 <- split(combinedResults, f = combinedResults$newImage)
splitByNewStep1 <- lapply(splitByNewStep1, FUN = function(x) x[order(x$step1, decreasing = TRUE), ])
matchesTop10step1 <- unlist(lapply(splitByNewStep1, FUN = function(x) sum(x$match[1:10])))
table(matchesTop10step1)
# matchesTop10step1
# 0  1  2  3  4  5  6  7  8 
# 1  1  2  3  4  4  7 19 67 

# just step 3
splitByNewStep3 <- split(combinedResults, f = combinedResults$newImage)
splitByNewStep3 <- lapply(splitByNewStep3, FUN = function(x) x[order(x$step3, decreasing = TRUE), ])
matchesTop10step3 <- unlist(lapply(splitByNewStep3, FUN = function(x) sum(x$match[1:10])))
table(matchesTop10step3)
# matchesTop10step3
# 1  2  3  4  5  6  7  8 
# 1  2  2  4  6 12 21 60 



# published
splitByNewPublished <- split(combinedResults, f = combinedResults$newImage)
splitByNewPublished <- lapply(splitByNewPublished, FUN = function(x) x[order(x$published, decreasing = TRUE), ])
matchesTop10published <- unlist(lapply(splitByNewPublished, FUN = function(x) sum(x$match[1:10])))
table(matchesTop10published)
# matchesTop10published
# 1  2  3  4  5  6  7  8 
# 2  1  2  2 10 14 19 58 




