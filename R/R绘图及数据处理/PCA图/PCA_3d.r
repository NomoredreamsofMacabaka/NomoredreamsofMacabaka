library(showtext)
font_add("times",regular="/opt/software/root/fonts/times.ttf")
par(family="times")
pca_data <- read.table("/public/igenebook/soybean_AJRS2210715027_20210806/personal/All_sample_FPKM.xls",header=T,sep="\t")
#pca_data <- read.table(args[1],header=T,row.names=1,sep="\t")
pca_group <- factor(unlist(strsplit("Bragg_L2,Bragg_L2,Bragg_L2,Bragg_L4,Bragg_L4,Bragg_L6,Bragg_L6,Bragg_L6,Bragg_M,Bragg_M,Bragg_M,Bragg_S,Bragg_S,Bragg_S,n1007_L2,n1007_L2,n1007_L2,n1007_L4,n1007_L4,n1007_L4,n1007_L6,n1007_L6,n1007_M,n1007_M,n1007_S,n1007_S,n1007_S,n49_L2,n49_L2,n49_L2,n49_L4,n49_L4,n49_L4,n49_L6,n49_L6,n49_L6,n49_M,n49_M,n49_M,n49_S,n49_S,n49_S",split = ",")))
unique(pca_group)
length(pca_group)
#pca_group
pca1 <- prcomp(t(pca_data[,-1]))
#pca1 <- princomp(pca_data)
ss=summary(pca1)
#ss
PCA1 <- ss$importance[2,1]*100
PCA2 <- ss$importance[2,2]*100
PCA3 <- ss$importance[2,3]*100


library(ggplot2)
library(RColorBrewer)
library(scatterplot3d)
#colour <- rainbow(length(unique(pca_group)))
colour <- brewer.pal(8,"Dark2")
colour2 <-brewer.pal(8,"Accent")
colour <- c(colour,colour2)
col_map <- colour[1:length(unique(pca_group))]
names(col_map)<-unique(pca_group)
group2<-data.frame(pca_group)
pca_reuslt<-as.data.frame(pca1$x)
pca_reuslt<-cbind(pca_reuslt,group2)
head(pca_reuslt)
sample_names <- colnames(pca_data)
sample_names <- sample_names[-1]
par(mai=c(1,1,1,2))


write("/home/chenzh/pca_group",pca_group)
head(pca_reuslt[,1:3])


attach(pca_reuslt)
s3d <- scatterplot3d(PC1,PC2,PC3,
                     color = col_map[pca_group],pch=16)
legend("topright",s3d$xyz.convert(1.0,0.8,-0.2),pch=16,yjust=0,
       legend=levels(pca_reuslt$pca_group),cex = 0.62,inset = -0.01,xjust = 0.5,
       bty = 'n',horiz = F,col=unique(col_map[pca_group]),ncol=1)




