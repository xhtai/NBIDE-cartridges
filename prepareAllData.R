################## save MSU processed data: 1_MSU
# without steps 1 and 3, MSU MATLAB code

library(R.matlab)

fileList <- system("ls /home/xtai/Desktop/research/MSU/NBIDE/Proc/*_reg.mat", intern = TRUE)

for (i in 1:length(fileList)) {
    MSUprocessed <- readMat(fileList[i])$T
    save(MSUprocessed, file = paste0("/home/xtai/Desktop/data/1_MSU/NBIDE", substr(fileList[i], start = 59, stop = 61) , ".Rdata"))
}

#################### 2_mineMatlab
fileList <- system("ls /home/xtai/Desktop/research/code/10_October/oct21/matfiles/3_processed/*.mat", intern = TRUE)

for (i in 1:length(fileList)) {
    mineMatlab <- readMat(fileList[i])$T
    save(mineMatlab, file = paste0("/home/xtai/Desktop/data/2_mineMatlab/NBIDE", substr(fileList[i], start = 87, stop = 89) , ".Rdata"))
}

################### without steps 1 and 3: 3_MSUinR
library(cartridges)
library(R.matlab)

fileList <- system("ls /home/xtai/Desktop/research/MSU/NBIDE/Proc/*_reg.mat", intern = TRUE)
fileList2 <- system("ls /home/xtai/Desktop/research/MSU/NBIDE/Proc/*.mat", intern = TRUE)
fileList2 <- setdiff(fileList2, fileList)

for (i in 1:length(fileList2)) {
    cat(i, ", ")
    tmp <- readMat(fileList2[i])
    BF <- tmp$T.[13:1931, 337:2255]
    manualCenteri <- round(tmp$bf.y) - 12
    manualCenterj <- round(tmp$bf.x) - 336
    
    # instead of centerBFprimer, do this
    centeredBF <- matrix(0, nrow = 1769, ncol = 1769)
    centeredBF[51:1719, 51:1719] <- BF[(manualCenteri - 834):(manualCenteri + 834), (manualCenterj - 834):(manualCenterj + 834)]
    
    # for crop later:
    primerRows <- which(Matrix::rowSums(centeredBF != 0) > 0)
    primerCols <- which(Matrix::colSums(centeredBF != 0) > 0)
    
    centeredBF[centeredBF == 0] <- NA
    
    leveled <- levelBF(centeredBF)
    cropped <- leveled[primerRows, primerCols]
    
    outlierNA <- outlierRejection(cropped)
    inpainted <- inpaint_nans(outlierNA)
    
    nonBF <- is.na(cropped)
    processed <- gaussianFilter(inpainted, nonBF)
    
    save(processed, file =  paste0("/home/xtai/Desktop/data/3_MSUinR/NBIDE", substr(fileList2[i], start = 59, stop = 61) , ".Rdata"))

    gc()
}

#################### 4_mineR
# in /home/xtai/Desktop/updatePackage/processed
# see readAllNBIDE.R


##### image data
load("/home/xtai/Desktop/research/code/7_July/4_myResults/MSUImageData.Rdata")
imageData <- MSUImageData
imageData$image <- paste0("NBIDE", imageData$image)
imageData <- imageData[, 1:4]
imageData <- imageData[order(imageData$image), ]
rownames(imageData) <- NULL
save(imageData, file = "/home/xtai/Desktop/data/imageData.Rdata")
