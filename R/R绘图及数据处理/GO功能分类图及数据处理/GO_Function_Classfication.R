library(ggplot2)
go  <- read.table('wego_count.txt',head=T,sep='\t')  #head让第一行变成表头
go_sort <- go[order(go$GO_term,-go$gene_num),]
bb <- head(go_sort[go_sort$GO_term=="biological_process",],n=20L) #超过20取20，没有20就取完
cc <- head(go_sort[go_sort$GO_term=="cellular_component",],n=20L)
mm <- head(go_sort[go_sort$GO_term=="molecular_function",],n=20L)
go_file <- rbind(bb,cc,mm)

#需要将GO_description列转换为因子。为什么要转化成因子呢？
#转化成因子在画图调用时可以让图形的坐轴排序按我们的表格顺序来?但是操作了好像没啥用
#go_file$GO_description=factor(go_file$GO_description)

#画图，条形图有两种类型：geom_bar() 和 geom_col()。 geom_bar() 使条的高度与每组中的
#案例数成正比（或者如果提供了重量美学，则是权重的总和）。 如果您希望条形的高度代表
#数据中的值，请改用 geom_col()。 geom_bar() 默认使用 stat_count()：它计算每个 x 位
#置的案例数。 geom_col() 使用 stat_identity()：它保持数据不变。
#bar图x一般是离散变量，histogram图x一般是连续变量


#a <- unique(go_file$GO_term)
#go_file$GO_term=factor(go_file$GO_term,levels=go_file$a)  ####不指定level的话会默认为x中的去重标识。

png('GO_funcation.png',width=4000,height=2000,res=300,type="cairo")  #res为分辨率
#reorder函数把x轴的顺序按y轴的值来排
p <- ggplot(go_file, aes(x=reorder(GO_description,-log2(gene_num+1)),y=log2(gene_num+1)))+
 # geom_col(aes(fill=GO_term))+
  geom_bar(stat='identity',width=0.75,aes(fill=GO_term))+
  guides(fill=FALSE)+   #去除图例
  facet_grid(.~GO_term,scales ="free",space="free")+ #space=free控制每个分类图的柱形大小相同
                                                     #scales是做什么的，标准化自由吗？
  #facets:图形/数据的分面。这是ggplot2作图比较特殊的一个概念，它把数据按某种规则
  #进行分类，每一类数据做一个图形，最终效果就是一页多图。
  labs(y="log2(Gene number)",x="GO Term")+
  theme(legend.background = element_rect(color="gray"))+
  theme(panel.background = element_rect(color="gray",fill="white"))+ #控制图例的边框颜色和填充颜色
  theme(strip.text=element_text(size =10),  #设置分页的文本
        axis.text.x=element_text(size=8,vjust=1,hjust=1,angle=75),  #设置x轴文本
        axis.ticks.x=element_blank())
p
dev.off()
