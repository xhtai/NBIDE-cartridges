#!/usr/bin/Rscript
args = commandArgs(trailingOnly = TRUE)
args <- as.numeric(args)

library(cartridges)

fileList <- system("ls ./processed/*.Rdata", intern = TRUE)

allPairwise <- function(newImageIndex) {
    load(paste0("./processed/NBIDE", sprintf("%03d", newImageIndex), ".Rdata"))
    newImage <- preprocessed
    out <- data.frame(compare = substr(fileList, start = 13, stop = 20), corr = NA, dx = NA, dy = NA, theta = NA, stringsAsFactors = FALSE)
    index <- which(substr(out$compare, 6, 8) == sprintf("%03d", newImageIndex))
    out <- out[-index, ]
    for (i in 1:nrow(out)) {
        #cat(i, ", ")
        load(paste0("./processed/", out$compare[i], ".Rdata"))
        out[i, 2:5] <- calculateCCFmax(preprocessed, newImage) # new image gets rotated
    }
    return(out)
}

for (i in 1:length(args)) {
    #cat(args[[i]], ", ")
    compare <- allPairwise(args[[i]])
    save(compare, file = paste0("./results/NBIDE", sprintf("%03d", args[[i]]), ".Rdata"))
}

############### to get commands to run in shell
# fileList <- as.numeric(substr(fileList, start = 18,  stop = 20))
# out <- paste("nohup ./compareAllNBIDE.R", fileList, "& ", collapse="\n")
# cat(out)

# nohup ./compareAllNBIDE.R 1 &
# nohup ./compareAllNBIDE.R 2 &
# nohup ./compareAllNBIDE.R 3 &
# nohup ./compareAllNBIDE.R 4 &
# nohup ./compareAllNBIDE.R 5 &
# nohup ./compareAllNBIDE.R 6 &
# nohup ./compareAllNBIDE.R 7 &
# nohup ./compareAllNBIDE.R 8 &
# nohup ./compareAllNBIDE.R 9 &
# nohup ./compareAllNBIDE.R 10 &
# nohup ./compareAllNBIDE.R 12 &
# nohup ./compareAllNBIDE.R 13 &
# nohup ./compareAllNBIDE.R 15 &
# nohup ./compareAllNBIDE.R 16 &
# nohup ./compareAllNBIDE.R 17 &
# nohup ./compareAllNBIDE.R 19 &
# nohup ./compareAllNBIDE.R 20 &
# nohup ./compareAllNBIDE.R 21 &
# nohup ./compareAllNBIDE.R 22 &
# nohup ./compareAllNBIDE.R 23 &
# nohup ./compareAllNBIDE.R 24 &
# nohup ./compareAllNBIDE.R 25 &
# nohup ./compareAllNBIDE.R 26 &
# nohup ./compareAllNBIDE.R 27 &
# nohup ./compareAllNBIDE.R 28 &
# nohup ./compareAllNBIDE.R 29 &
#     
# nohup ./compareAllNBIDE.R 30 &
# nohup ./compareAllNBIDE.R 31 &
# nohup ./compareAllNBIDE.R 32 &
# nohup ./compareAllNBIDE.R 34 &
# nohup ./compareAllNBIDE.R 35 &
# nohup ./compareAllNBIDE.R 36 &
# nohup ./compareAllNBIDE.R 39 &
# nohup ./compareAllNBIDE.R 40 &
# nohup ./compareAllNBIDE.R 41 &
# nohup ./compareAllNBIDE.R 42 &
# nohup ./compareAllNBIDE.R 43 &
# nohup ./compareAllNBIDE.R 44 &
# nohup ./compareAllNBIDE.R 45 &
# nohup ./compareAllNBIDE.R 46 &
# nohup ./compareAllNBIDE.R 48 &
# nohup ./compareAllNBIDE.R 49 &
# nohup ./compareAllNBIDE.R 50 &
# nohup ./compareAllNBIDE.R 51 &
# nohup ./compareAllNBIDE.R 53 &
# nohup ./compareAllNBIDE.R 54 &
# nohup ./compareAllNBIDE.R 55 &
# nohup ./compareAllNBIDE.R 56 &
# nohup ./compareAllNBIDE.R 57 &
# nohup ./compareAllNBIDE.R 59 &
# nohup ./compareAllNBIDE.R 60 &
# nohup ./compareAllNBIDE.R 61 &
# nohup ./compareAllNBIDE.R 62 &
# nohup ./compareAllNBIDE.R 63 &
#     
# nohup ./compareAllNBIDE.R 64 &
# nohup ./compareAllNBIDE.R 65 &
# nohup ./compareAllNBIDE.R 66 &
# nohup ./compareAllNBIDE.R 67 &
# nohup ./compareAllNBIDE.R 71 &
# nohup ./compareAllNBIDE.R 72 &
# nohup ./compareAllNBIDE.R 75 &
# nohup ./compareAllNBIDE.R 76 &
# nohup ./compareAllNBIDE.R 78 &
# nohup ./compareAllNBIDE.R 79 &
# nohup ./compareAllNBIDE.R 80 &
# nohup ./compareAllNBIDE.R 82 &
# nohup ./compareAllNBIDE.R 84 &
# nohup ./compareAllNBIDE.R 85 &
# nohup ./compareAllNBIDE.R 87 &
# nohup ./compareAllNBIDE.R 89 &
# nohup ./compareAllNBIDE.R 90 &
# nohup ./compareAllNBIDE.R 91 &
# nohup ./compareAllNBIDE.R 92 &
# nohup ./compareAllNBIDE.R 94 &
# nohup ./compareAllNBIDE.R 95 &
# nohup ./compareAllNBIDE.R 96 &
# nohup ./compareAllNBIDE.R 97 &
# nohup ./compareAllNBIDE.R 99 &
# nohup ./compareAllNBIDE.R 100 &
# nohup ./compareAllNBIDE.R 102 &
# nohup ./compareAllNBIDE.R 103 &
# nohup ./compareAllNBIDE.R 106 &
#     
# nohup ./compareAllNBIDE.R 110 &
# nohup ./compareAllNBIDE.R 111 &
# nohup ./compareAllNBIDE.R 112 &
# nohup ./compareAllNBIDE.R 114 &
# nohup ./compareAllNBIDE.R 115 &
# nohup ./compareAllNBIDE.R 116 &
# nohup ./compareAllNBIDE.R 117 &
# nohup ./compareAllNBIDE.R 118 &
# nohup ./compareAllNBIDE.R 119 &
# nohup ./compareAllNBIDE.R 120 &
# nohup ./compareAllNBIDE.R 121 &
# nohup ./compareAllNBIDE.R 125 &
# nohup ./compareAllNBIDE.R 127 &
# nohup ./compareAllNBIDE.R 128 &
# nohup ./compareAllNBIDE.R 129 &
# nohup ./compareAllNBIDE.R 130 &
# nohup ./compareAllNBIDE.R 131 &
# nohup ./compareAllNBIDE.R 134 &
# nohup ./compareAllNBIDE.R 135 &
# nohup ./compareAllNBIDE.R 136 &
# nohup ./compareAllNBIDE.R 137 &
# nohup ./compareAllNBIDE.R 138 &
# nohup ./compareAllNBIDE.R 139 &
# nohup ./compareAllNBIDE.R 141 &
# nohup ./compareAllNBIDE.R 142 &
# nohup ./compareAllNBIDE.R 143 &