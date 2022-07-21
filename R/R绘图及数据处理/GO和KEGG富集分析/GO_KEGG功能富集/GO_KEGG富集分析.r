#GO的富集分析
rm(list = ls())
library(clusterProfiler)
library(DOSE)
library(stringi)
library(stringr)

gene_id_list <- read.table('gene_id.list',head=T)
gene <- gene_id_list[,1]

#读KEGG和基因的对应关系总表
disease2gene <-  read.table('/public/database/annotation/Yarrowia_lipolytica/Yarrowia_lipolytica.kegg.transform2',header=F,sep='\t',quote="",colClasses = "character")
#读KEGG功能注释总表
disease2name <-  read.table('/data/project/hejie/my_script/datebase/KEGG/map_title.tab',header=F,sep="\t",quote="",colClasses = "character")
##读取GO和基因的对应关系总表
#disease2gene <- read.table('/public/database/annotation/Yarrowia_lipolytica/Yarrowia_lipolytica.wego3',header=F,sep='\t',quote="",colClasses = "character")
##读取GO功能表,该功能表格有的GO号对应的功能是一样的,这个在我们绘制的图中是怎么处理的?
##解答在下面的for循环判断中.
#disease2name <- read.table('/data/project/hejie/my_script/datebase/GO/GO_function.xls',header=F,sep="\t",quote="",colClasses = "character")
#富集使用clusterProfiler::enricher函数,计算pAdjustMethod的方式是BH算法,没有深入了解
#TERM2GENE给的是gene注释库,是GO与基因组基因的对应关系,TERM2NAME给的是GO对应的功能信息
#p.q值可用来筛选最终显示结果
#minGSSize和maxGSSize规定注释到GO的gene数目的最大最小数值
x_all = enricher(gene, TERM2GENE=disease2gene, TERM2NAME=disease2name,pvalueCutoff = 1,qvalueCutoff = 1,minGSSize = 1, maxGSSize = 2000,)
x = enricher(gene, TERM2GENE=disease2gene, TERM2NAME=disease2name,pvalueCutoff = 1,qvalueCutoff = 0.05,minGSSize = 1, maxGSSize = 2000,)
#把结果中第二列功能为NA的去除,疑问是有GO号在GO数据库中会没有注释功能吗?
#难道有gene注释到GO号,但是该GO号没有功能的情况吗?
x_all@result <- x_all@result[which(x_all@result[,2] != 'NA'),]
###x_all是什么结构?
rows <- nrow(x_all@result)



###处理结果第二列功能名字过长问题,若大于60就截取40字段,后面用'...'代替,
###若有功能截取字段后显示重复,那么就在截取后重复的功能字段添加'.'
set <- ""
for (i in 1:rows){
  s <- x_all@result[i,2]
  if(nchar(s)>60){           
    sub1 <- substring(s,1,40)
    sub2 <- '...'
    #stringi::stri_detect_regex函数匹配函数,在set中寻找是否存在sub1这一字符串,
    #若存在返回T,不存在返回F
    #opts_regex设置函数的匹配参数等情况,stri_opts_regex来传参,
    #literal=T将整个模式视为文字字符串:输入序列中的元字符或转义序列将没有特殊含义
    judgment <- stri_detect_regex(set,sub1,opts_regex = stri_opts_regex(literal = T))
    #any()判断所给的至少含有一个TRUE即返回TRUE,sub1和set里面若有NA(上面去除了NA的为啥这儿还要搞一遍?)
    #就先去除NA在进行any()判断,这个na.omit()是逻辑值去NA,上面的是字符串去NA.所以会不会是这个原因.
    if (any(na.omit(judgment))){
      #judgment记录了T和F的值,set[na.omit(judgment)]表示set['T','F','T'],T就返回了其对应索引下的值
      #str_match()模式匹配函数
      #这个判断的功能:如果有前40个字符串相同的功能字符,那么在追加的'...'后面一直追加'.'
      #通俗讲就是遇到相同的,第二个后面加四个点,第三个后面加五个点...以此类推
      #\\.+$含义:第一个'\'转义后面的'\',第二个'\'转义'.','+'代表后续一个以上的所有字符一直到'$'(末尾标识)
      #疑问:为啥要接'()'?
      #'()'表示提取匹配的字符串
      #但这里需要这样操作吗?
      #加了括号后面得到的匹配结果变成了两列
      #第一列是匹配到的字符串,第二列显示匹配到()内的字符串
      #但是这里写'+'匹配了'.'所有,我认为这里不需要加'()',也就不需要[,2]了.
      pit <- str_match(set[na.omit(judgment)],"(\\.+)$")[,2]
      if(length(na.omit(pit))>0){
        sub2 <- paste0(pit[which.max(nchar(pit))],'.')
      }
    }
    subs <- paste0(sub1,sub2)
    set  <- c(set,subs)
    x_all@result[i,2] <- subs
  }
  #当功能字符串小于60个字符遇到相同功能的名字,进行上面类似处理
  #如相同,第二个后面加'.',第三个后面加'..',以此类推
  else{
    judgment <- stri_detect_regex(set,s,opts_regex = stri_opts_regex(literal = T))
    suffix <- ""
    if (any(na.omit(judgment))){
      pit <- str_match(suffix[na.omit(judgment)],"(\\.*$)")[,2]
      #这里有个疑问:第一个相同功能名出现时,是匹配不到'.'的,那这个if判断就不成立啊
      #pit去除了NA过后长度就为0了
      #我写的话逻辑是这样的:
      if(length(na.omit(pit))>0){
        suffix <- paste0(pit[which.max(nchar(pit))],".")
      }
      else{
        suffix <- '.'
      }
      #if(length(na.omit(pit))>0){
      #  if(allnchr(pit)==0){
      #    suffix <- '.'
      #  }
      #  else{
      #    suffix <- paste0(pit[which.max(nchar(pit))],".")
      #  }
      }
      subs <- paste0(s,suffix)
      set <- c(set,subs)
      x_all@result[i,2] <- subs
    }
}
#}

barplot(x_all,showCategory = 20)  
cnetplot(x_all,showCategory = 10)  ##只显示了10个功能点为了好看
upsetplot(x_all)



#x_all@result中gene_ratio指:(该GO号注释到关联基因的数目/关联基因注释到所有GO号上的总数)
#x_all@result中bg_ratio指:(该GO号在基因组上能注释到的gene数/基因组上所有能注释到所有GO号的基因总数)
#富集因子:gene_ratio/bg_ratio(bg_ratio即为背景值,考虑到每个GO号在基因组上所对应的gene数的不同,
#所以要除去背景)
#dotplot(x_all, showCategory=10) 
result <- x_all@result
gene_ratio <- strsplit(result$GeneRatio,split="/")
bg_ratio <- strsplit(result$BgRatio,split="/")
rich_factor <- c()
for (i in 1:length(gene_ratio)){
  gene_ratio[[i]] <- as.numeric(gene_ratio[[i]])
  bg_ratio[[i]] <- as.numeric(bg_ratio[[i]])
  rich_factor[i] <- (gene_ratio[[i]][1]/gene_ratio[[i]][2])/(bg_ratio[[i]][1]/bg_ratio[[i]][2])
}

#流程中rich_factor的计算是根据:
#rich_factor=(每个GO号注释到的关联gene数目/每个GO号在基因组上能注释到的gene数目)

#直接取值不排序是因为我们画富集散点图主要看的是p值,富集因子其次.
#enricher()函数得到的结果会自动按照p值升序排列,所以可以直接取前20行
pythway <- head(result,n=20L)
rich_factor <- rich_factor[1:20]
rich_factor <- data_frame(rich_factor)
pythway <- tibble(cbind(pythway,rich_factor))
p <- ggplot(pythway,aes(x=rich_factor,y=Description))+    #布局画布坐标轴信息等
      scale_y_discrete(limits=rev(pythway$Description))+  #rev,反转函数reverse()
      geom_point(aes(size=Count,color=p.adjust))          #画图,散点图,点的大小是count,颜色是p.adjust

#scale_colour_gradient()创建渐变色函数,breaks是分割图标刻度值
p+scale_colour_gradient(breaks = seq(0,1,0.2),limits=c(0,1),low="red",high="green")+
  labs(color=expression(p.adjust),size="Gene number",
       title="Enrichment plot",x="",y="")+
  theme(plot.title = element_text(hjust = 0.5))+  #标题文字调整到中央
  theme_bw()  #给背景模板
#这里x=""和y=""就是x和y轴标题赋值为空



