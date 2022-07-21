setwd("/public/igenebook/AJWGR2210803009_WGR/personal/test")
library(ggplot2)
argv <- commandArgs() 
input <- argv[6]  #因为集群上打印参数可以看到，我们命令开始是在第六个参数，前面五个都有默认参数
outfile <- argv[7]




#给的目标序列
ref <- 'gcagtcaggaagacagcctactcccatctctccacctctaagagacagtcatcctcaggccatgcagtggaactccacaacattccaccaagctctgctagaccccagagtgaggggcctatactttcctgctggtggctccagttccggaacagtaaaccctgttccgactactgcctcacccatatcgtcaatcttctcgaggactggggaccctgcaccgaacatggagaacac'
ref <- toupper(ref) #大小写转化
len <- nchar(ref)  #计数字符串长度
ref2 <- unlist(strsplit(ref, split="")) #给定一个列表结构 x，unlist 简化它以生成一个向量，其中包含出现在 x 中的所有原子组件。
dat <- read.table(input)
colnames(dat) <- c('POS','ALT','fre') #把读进来的数据框改列名


p <-  ggplot(dat, aes(POS,fre)) +
  scale_x_continuous(limits=c(1,len),breaks = c(1:len),labels = ref2, expand = c(0.01,0.01)) +
  # scale_y_continuous(expand = c(0,0.002))  +
  geom_segment(aes(x = POS, y = 0, xend = POS, yend = fre), alpha = 0.5) + #segment这里是画点对应的x轴的竖线
  geom_point() +
  geom_label(aes(label=ALT)) +
  geom_text(aes(label=fre),nudge_x=5) + #nudge_x是lable对于点的偏移
  theme(
    # axis.text  = element_blank(),
        # axis.ticks = element_blank(),
        axis.line = element_line(),
        # axis.text.y  = element_blank(),
        # legend.position = 'none',
        # title = element_blank(),
        # strip.background = element_blank(),
        panel.background = element_blank(),
        # plot.margin=unit(rep(1,4),'lines')
  )

png(paste(outfile,".png",sep=""),width=1500,height=500,type = "cairo")
p
dev.off()
pdf(paste(outfile,".pdf",sep=""),width=25,height = 10)
p
dev.off()



