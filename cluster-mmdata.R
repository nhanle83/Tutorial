MMdata <- read.csv("C:/Users/LeN/Google Drive/202/MMdata.csv")

row.names(MMdata) <- MMdata$X
MMdata$X <- NULL
plot(hclust(dist(data.matrix(MMdata))))
