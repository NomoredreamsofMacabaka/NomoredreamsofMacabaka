library(ggplot2)
library(reshape2)
library(ggpubr)

rm(list = ls())
data<- read.table("/public/igenebook/fusarium_graminearum_gca_AJRS2210617023_rna/RNA/04.Expr/All_sample_FPKM.xls",
           header = T,
           row.names = 1)
data <- data.frame(data,data[,1:2])
data <- data[,-1:-2]
colnames(data)[3:4] <- c("Elo2_1","Elo2_2")

#加两列为两组生物学重复的平均值，为后续的p值计算做准备
#head(as.vector(data[,1]))
#head(as.vector(data[,2]))
#head(data.frame(data,mean=((as.vector(data[,1])+as.vector(data[,2]))/2)))
#data_final <- data.frame(data,ZJU1_mean=((as.vector(data[,1])+as.vector(data[,2]))/2),
#                         Elo2_mean=((as.vector(data[,3])+as.vector(data[,4]))/2))

     
#转置为后续的长宽数据框转换做准备
data_do <- t(data)
#melt可以转换长宽数据框
my_data <- melt(data_do,id.vars="Sample",variable.names="Gene",value.name = "FPKM")
head(my_data)

my_comparisons <- list(c("ZJU1_mean","Elo2_mean"))

ggplot(data=my_data, aes(x=Var1,y=log2(FPKM+1)))+geom_boxplot(aes(fill=Var1))+labs(y="log2(FPKM+1)",x="Sample")+
  theme_bw()+theme(text=element_text(size=25),legend.position='right',legend.title=element_blank(),axis.text.x = element_text(vjust = 1, hjust = 1, angle = 80))
#  + stat_compare_means(comparisons = my_comparisons, #增加自定义的检验变量之间独立性的p-value
#                     label.y=15)
  