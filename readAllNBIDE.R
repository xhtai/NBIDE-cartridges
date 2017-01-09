############ pre-processing for all NBIDE
library(cartridges)

dataDir <- "/home/xtai/Desktop/research/Data/NBIDE/cc/"
processedDir <- "/home/xtai/Desktop/updatePackage/processed/"

fileNames <- system(paste0("ls ", dataDir, "*.png"), intern = TRUE)
shortened <- paste("NBIDE", substr(fileNames, start = 54, stop = 56), sep = "")

for (i in 1:length(fileNames)) {
    cat(i, ", ")
    
    preprocessed <- allPreprocess(fileNames[i])
    save(preprocessed, file = paste0(processedDir, shortened[i], ".Rdata"))
}

