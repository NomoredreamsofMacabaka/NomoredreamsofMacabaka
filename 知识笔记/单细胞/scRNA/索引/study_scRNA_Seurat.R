library(Seurat)
library(patchwork)
library(tidyverse)
library(ggplot2)
library(stringr)
library(clustree)

args <- commandArgs(TRUE)



matrix_sum = args[1] #样本名对应的表达矩阵路劲,这里样本名就是表达路径的末尾文件夹名字,处理组在前,对照组在后
species = args[2]  #物种，由于老鼠和人有区别，所以要注明
output = args[3]  #输出目录
system2(command = 'mkdir',args = c('-p',paste(output,'QC/single_sample',sep='/')))
system2(command = 'mkdir',args = c('-p',paste(output,'QC/combine_sample',sep='/')))
system2(command = 'mkdir',args = c('-p',paste(output,'DEG/single_sample',sep='/')))
system2(command = 'mkdir',args = c('-p',paste(output,'DEG/combine_sample',sep='/')))

# matrix_sum='/biodata/05.standard_analysis/mm10_AJSCRS2211009007_scRNA_20211229/ApCon,/biodata/05.standard_analysis/mm10_AJSCRS2211009007_scRNA_20211229/ApEp1'

###可以为多个样本，所以设置成','分割。
matrix_path <- unlist(str_split(matrix_sum,',')) ###由于str_split分割产生了list对象不好计数，unlist将list转化成向量对象
sample_num <- length(matrix_path) ##统计所输入的样本个数，为后续的分配线程数和循环运行做准备。

matrix_path
sample_num

##进程和线程调用，每个样本单独进行Seurat包的质控和找差异gene时，可以考虑使用并行进程
#合并后的数据可以考虑多线程运行
#常用函数:
# detectCores()   检查当前的可用核数
# clusterExport() 配置当前环境
# makeCluster() 分配核数
# stopCluster() 关闭集群
# parLapply()   lapply()函数的并行版本

###第一种方法，多线程运行任务，并行线程运行
# library(parallel)
# threads_num <- makeCluster(sample_num)
#QC_step1是读取10X数据，创建Seurat对象
# QC_step1 <- function(folder){
#   # library(Seurat)    #多线程运行有自己的环境，所以要么给函数对应的包，要么调用多线程的ClusterExort函数配置环境
#   expression_matrix <- Read10X(data.dir = folder)
#   #下面这个if为了判断是否为多组学建库，多组学建库length为2，对象中有gene_expression和peak两种对应scRNA和scATAC
#   if(length(expression_matrix)==2){
#     expression_matrix = expression_matrix$`Gene Expression`
#   }
#   #为细胞ID加上前缀，防止数据合并出现重名
#   colnames(expression_matrix) <- paste(basename(folder),colnames(expression_matrix),sep='_')
#   CreateSeuratObject(counts = expression_matrix,min.cells=3 ,min.features=200,project = basename(folder))
# }
# sceList <- lapply(c('/biodata/05.standard_analysis/mm10_AJSCRS2211009007_scRNA_20211229/ApCon','/biodata/05.standard_analysis/mm10_AJSCRS2211009007_scRNA_20211229/ApEp1'),QC_step1)
# sceList <- parLapply(threads_num,matrix_path,QC_step1)
# saveRDS(sceList,paste(output,'test.rds',sep='/'))


###第二种方法并行方法:   这种方法不需要额外设置环境变量什么的。
library(future)
library(future.apply)
options(future.globals.maxSize = 6000*1024^2)  ###设置最大导出值，设置为6G
plan("multiprocess",workers = 6)  #并行运算数设置

sceList = future_lapply(matrix_path,function(folder){
  expression_matrix <- Read10X(data.dir = folder)
  #下面这个if为了判断是否为多组学建库，多组学建库length为2，对象中有gene_expression和peak两种对应scRNA和scATAC
  if(length(expression_matrix)==2){
    expression_matrix = expression_matrix$`Gene Expression`
  }
  #为细胞ID加上前缀，防止数据合并出现重名
  colnames(expression_matrix) <- paste(basename(folder),colnames(expression_matrix),sep='_')
  CreateSeuratObject(counts = expression_matrix,min.cells=3 ,min.features=200,project = basename(folder))
})





###第三种并行方法
library(foreach)
library(doParallel)

threads_num <- makeCluster(sample_num)
registerDoParallel(threads_num)  ##这种方法需要对核数进行注册
#.inorder是表示.combine函数是否需要按照顺序执行，顺序不重要的话，F可以提高性能。
#%dopar%是进行并行计算
#foreach中的变量是局部变量，所以要用返回值把对象给到全局中
sceList <- foreach(i=1:length(sceList),.inorder = F,.packages = c('Seurat','patchwork',
                                                       'tidyverse','ggplot2','stringr')) %dopar%{
  ###计算rRNA，线粒体，红血细胞比例
  if(species=='human'){
    sceList[[i]][['percent.mt']]=PercentageFeatureSet( sceList[[i]],pattern = '^MT-')
    sceList[[i]][['percent.rrna']]=PercentageFeatureSet( sceList[[i]],pattern = '^RP[SL]') #[]显示或者的意思
    sceList[[i]][['percent.hb']]=PercentageFeatureSet( sceList[[i]],pattern = '^HB[^(P)]')
  }else if(species=='mouse'){
    sceList[[i]][['percent.mt']]=PercentageFeatureSet( sceList[[i]],pattern = '^mt-')
    sceList[[i]][['percent.rrna']]=PercentageFeatureSet( sceList[[i]],pattern = '^Rp[sl]') #[]显示或者的意思
    sceList[[i]]=PercentageFeatureSet( sceList[[i]],pattern = '^Hb[^(p)]',col.name = 'percent.hb') #[^]匹配不符合括号的字符
  }
  VlnPlot(sceList[[i]],features = c('nFeature_RNA','nCount_RNA','percent.mt'),ncol = 3)
  ggsave(paste(output,'/QC/single_sample/',sceList[[i]]@project.name,'_Vlnplot.png',sep=''),dpi=300)
  ggsave(paste(output,'/QC/single_sample/',sceList[[i]]@project.name,'_Vlnplot.pdf',sep=''),dpi=300)

  ###对细胞进行过滤，检查过滤的情况，做小提琴图。
  ###过滤的参数视情况而定，一般细胞最小基因数在200到500，最大基因数一般4000左右
  sceList[[i]]<- subset(sceList[[i]],subset=(nFeature_RNA>200 & nFeature_RNA<5000 & percent.mt<10))
  VlnPlot(sceList[[i]],features = c('nFeature_RNA','nCount_RNA','percent.mt'),ncol = 3)
  ggsave(paste(output,'/QC/single_sample/',sceList[[i]]@project.name,'_Vlnplot_filter.png',sep=''),dpi=300)

  #看下基因和线粒体和UMI对应转录本的相关性系数图
  plot1 <- FeatureScatter(sceList[[i]], feature1 = "nCount_RNA", feature2 = "percent.mt")
  plot2 <- FeatureScatter(sceList[[i]], feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
  p_merge = plot1 + plot2
  ggsave(paste(output,'/QC/single_sample/',sceList[[i]]@project.name,'_Cor.png',sep=''),p_merge,dpi=300)

  #寻找高变基因，标准化数据，降维聚类
  sceList[[i]] <- NormalizeData(sceList[[i]],verbose=F)  #verbose运行进度条不显示
  sceList[[i]] <- FindVariableFeatures(sceList[[i]],selection.method='vst',nfeatures=2000,verbose=F) #选择2000个高变基因
  top10 <- head(VariableFeatures(sceList[[i]]),10)
  plot1 <- VariableFeaturePlot(sceList[[i]])
  plot2 <- LabelPoints(plot=plot1,points = top10,repel=T)
  plot_high_change <- plot1+plot2
  ggsave(paste(output,'/QC/single_sample/',sceList[[i]]@project.name,'_VariableFeaturePlot.png',sep=''),plot_high_change,dpi=300)
  
  
  ###细胞周期分析，视情况考虑分析否，主要是为了消除细胞周期markergene对分群影响
  #如下操作了后，可以让处于不同周期的细胞也可以混在同一类型中。如果不研究细胞周期可以考虑做一下。
  if(F){
      if(species=='human'){
        #cc.genes为Seurat包中自带的细胞周期数据集
        s.genes <- cc.genes$s.genes
        g2m.genes <- cc.genes$g2m.genes
        
        #计算细胞周期分数
        #CellCycleScoring()函数会多出三列值，S.Score和G2M.Score是根据给的两个数据集计算的分数
        #Phase是细胞周期判断，前两列分数都小于0被判断为G1(细胞间期初期),其余列哪个值大，判断为哪个
        #G2M为细胞间期后期到细胞分裂期，S为细胞间期的第三个阶段S期。
        #old.ident对应cluster的名称
        sceList[[i]] <- CellCycleScoring(sceList[[i]] , s.features = s.genes , g2m.features = g2m.genes , set.ident = T)
        
        #周期markergene的可视化,str_to_upper()处理字符串全部大写
        cellcycle_markergene <- RidgePlot(sceList[[i]],features = str_to_upper(c('Pcna','Top2a','Mcm6','Mki67')),ncol = 2)
      }else if(species=='mouse'){
        s.genes <- str_to_title(cc.genes$s.genes)
        g2m.genes <- str_to_title(cc.genes$g2m.genes)
        sceList[[i]] <- CellCycleScoring(sceList[[i]] , s.features = s.genes , g2m.features = g2m.genes , set.ident = T)
        cellcycle_markergene <- RidgePlot(sceList[[i]],features = c('Pcna','Top2a','Mcm6','Mki67'),ncol = 2)
      }
      ggsave(paste(output,'/QC/single_sample/',sceList[[i]]@project.name,'_cellcycle_markergene.png',sep=''),cellcycle_markergene,dpi=300)
      
      #以周期markergene进行PCA降维：
      sceList[[i]] <- RunPCA( sceList[[i]], features = c(s.genes,g2m.genes))
      DimPlot(sceList[[i]],reduction = 'pca')
      ggsave(paste(output,'/QC/single_sample/',sceList[[i]]@project.name,'_cellcycle_PCA.png',sep=''),dpi=300)
      
      ###去除细胞周期对分群差异的影响。
      ###vars.to.regress是根据给定的列进行回归
      sceList[[i]] <- ScaleData(sceList[[i]], vars.to.regress = c("S.Score","G2M.Score"),features = rownames(sceList[[i]]))
      sceList[[i]] <- RunPCA(sceList[[i]] , features = VariableFeatures(sceList[[i]]))
      DimPlot(sceList[[i]] , reduction = 'pca')
      ggsave(paste(output,'/QC/single_sample/',sceList[[i]]@project.name,'_cellcycle_scale_PCA.png',sep=''),dpi=300)
  }else{
    sceList[[i]] <- ScaleData(sceList[[i]],verbose =F, features = rownames(sceList[[i]]))  #对所有基因进行数据中心化
    # #原始表达矩阵
    # GetAssayData(scRNA,slot="counts",assay="RNA")
    # #标准化之后的表达矩阵
    # GetAssayData(scRNA,slot="data",assay="RNA")
    # #中心化之后的表达矩阵
    # GetAssayData(scRNA,slot="scale.data",assay="RNA")
    sceList[[i]] <- RunPCA(sceList[[i]], features=VariableFeatures(sceList[[i]]))
  }
  elbowplot <- ElbowPlot(sceList[[i]], ndims=20, reduction="pca")
  dimplot <- DimPlot(sceList[[i]], reduction = "pca", group.by="orig.ident")
  plot_merge <- dimplot+elbowplot
  ggsave(paste(output,'/QC/single_sample/',sceList[[i]]@project.name,'_Elbow.png',sep=''),plot_merge,dpi=300)
  #tsne和umap降维聚类
  sceList[[i]] <- RunTSNE(sceList[[i]],dims=1:20)
  sceList[[i]] <- RunUMAP(sceList[[i]],dims=1:20)      #dims数值一般根据肘部图来判断选取多少个PCA主成分
  sceList[[i]] <- FindNeighbors(sceList[[i]],dims=1:20)   #基于欧氏几何计算，找临近点
  resolutions = c(0.1,0.3,0.8,0.6)
  for (j in resolutions){
  sceList[[i]] <- FindClusters (sceList[[i]],resolution = j)  #找聚类群体，resolution相当于分辨率，越大分辨率越大。
  umap_plot <- DimPlot(sceList[[i]],reduction='umap',label = T)
  tsne_plot <- DimPlot(sceList[[i]],reduction='tsne',label = T)
  ggsave(paste(output,'/QC/single_sample/',sceList[[i]]@project.name,'_',j,'_TSNE.png',sep=''),tsne_plot,dpi=300)
  ggsave(paste(output,'/QC/single_sample/',sceList[[i]]@project.name,'_',j,'_UMAP.png',sep=''),umap_plot,dpi=300)
  }

  #群体之间差异基因寻找:
  markers_between_cluster <- FindAllMarkers(sceList[[i]], only.pos = T,min.pct = 0.1,logfc.threshold = 0.25)
  write.table(markers_between_cluster,paste(output,'/DEG/single_sample/',sceList[[i]]@project.name,'_markers_between_cluster.xls',sep = ''),quote = F,sep = '\t',row.names=F)

  #返回对象
  return(sceList[[i]])
}
saveRDS(sceList,paste(output,'sceList.rds',sep='/'))
stopCluster(threads_num)




###多样本的CCA校验,CCA讲解可见markdown记录
if(sample_num>=2){
     #1.以高变基因为基础来寻找锚点
     #SelectIntegrationFeatures()筛选出共同的高变基因
     high_change_features <- SelectIntegrationFeatures(object.list = sceList,nfeatures = 2000,verbose = F)
     sceList.anchors <- FindIntegrationAnchors(object.list = sceList, anchor.features=high_change_features)

     #2.利用锚点来整合数据
     scRNA_merge <- IntegrateData(anchorset = sceList.anchors,dims = 1:20)
     dim(scRNA_merge)
     
     #切换数据集,其实不用切换,默认就是integrated(合并后的数据集)里面存在高边基因等标签。
     DefaultAssay(scRNA_merge) <- "integrated"   #integrated为整合的高变基因数据集
     scRNA_merge@project.name <- "scRNA_merge"   ###重新命名project

     #3.直接对校正后的合并数据进行Scale，因为合并后总的数据集变了，重新计算下，默认模式为DefaultAssay
     scRNA_merge <- ScaleData(scRNA_merge,verbose =F,features = VariableFeatures(scRNA_merge))
     # #原始表达矩阵
     # GetAssayData(scRNA,slot="counts",assay="RNA")
     # #标准化之后的表达矩阵
     # GetAssayData(scRNA,slot="data",assay="RNA")
     # #中心化之后的表达矩阵
     # GetAssayData(scRNA,slot="scale.data",assay="RNA")
     scRNA_merge <- RunPCA(scRNA_merge,features = VariableFeatures(scRNA_merge))
     elbowplot <- ElbowPlot(scRNA_merge, ndims=20, reduction="pca")
     dimplot <- DimPlot(scRNA_merge, reduction = "pca", group.by="orig.ident")
     plot_merge <- dimplot+elbowplot
     ggsave(paste(output,'/QC/combine_sample/',scRNA_merge@project.name,'_Elbow.png',sep=''),plot_merge,dpi=300)
     #tsne和umap降维聚类
     scRNA_merge <- RunTSNE(scRNA_merge,dims=1:20)
     scRNA_merge <- RunUMAP(scRNA_merge,dims=1:20)
     scRNA_merge <- FindNeighbors(scRNA_merge,dims=1:20)   #基于欧氏几何计算，找临近点
     resolutions = c(0.1,0.3,0.8,0.6)
     for (j in resolutions){
       scRNA_merge <- FindClusters (scRNA_merge,resolution = j)  #找聚类群体，resolution相当于分辨率，越大分辨率越大。
       umap_plot <- DimPlot(scRNA_merge,reduction='umap',label = T)
       tsne_plot <- DimPlot(scRNA_merge,reduction='tsne',label = T)
       umap_plot2 <- DimPlot(scRNA_merge,reduction='umap',group.by = 'orig.ident',label = T)
       tsne_plot2 <- DimPlot(scRNA_merge,reduction='tsne',group.by = 'orig.ident',label = T)
       ggsave(paste(output,'/QC/combine_sample/',scRNA_merge@project.name,'_',j,'_TSNE.png',sep=''),tsne_plot,dpi=300)
       ggsave(paste(output,'/QC/combine_sample/',scRNA_merge@project.name,'_',j,'_UMAP.png',sep=''),umap_plot,dpi=300)
       ggsave(paste(output,'/QC/combine_sample/',scRNA_merge@project.name,'_',j,'_TSNE_orig.ident.png',sep=''),tsne_plot2,dpi=300)
       ggsave(paste(output,'/QC/combine_sample/',scRNA_merge@project.name,'_',j,'_UMAP_orig.ident.png',sep=''),umap_plot2,dpi=300)
     }

     #tree分类树
     Treeplot <- clustree(scRNA_merge@meta.data,prefix = 'RNA_snn_res.')   #prefix为包含聚类信息列的字符串
     ggsave(paste(output,'/QC/combine_sample/',scRNA_merge@project.name,'_Treeplot.png',sep=''),Treeplot,dpi=300)


     #群体之间差异基因寻找:
     markers_between_cluster <- FindAllMarkers(scRNA_merge, only.pos = T,min.pct = 0.1,logfc.threshold = 0.25)
     write.table(markers_between_cluster,paste(output,'DEG/combine_sample','All_markers_between_cluster.xls',sep = '/'),quote = F,sep = '\t',row.names=F)

     #群体内部样本差异基因寻找(并行运算):
     cluster_num <- length(unique(scRNA_merge$seurat_clusters))
     sample_id <- basename(matrix_path)
     threads_num <- makeCluster(5)
     registerDoParallel(threads_num)  ##这种方法需要对核数进行注册
     foreach(i = 0:(cluster_num-1), .inorder = F ,.packages=c('Seurat')) %dopar% {
       #subset.ident只在group.by存在时候启用,将group.by根据subset.ident的值在进行子集化
       #min.cells.group表是群体内部最小细胞数,还有控制细胞内最少基因数的参数min.cells.feature
       #i-1是由于分群的时候是0开头
       #由于可能存在有样本没在群体细胞中，所以利用try函数规避erro报错
        try({DEG_markers_in_cluster <-  FindMarkers(scRNA_merge,ident.1 = sample_id[1],ident.2 = sample_id[2],group.by = 'orig.ident',subset.ident = i,min.cells.group = 1)},silent = T)
        if(exists('DEG_markers_in_cluster')){
            write.table(DEG_markers_in_cluster,paste(output,'/DEG/combine_sample/markers_DEG_',i,'.xls',sep = ''),quote = F,sep = '\t')
            }
     }
     stopCluster(threads_num)
}
saveRDS(scRNA_merge,paste(output,"scRNA_merge.rds",sep = '/'))



if(F){
  #1. 查看特定基因分布
  #这个函数可以清晰看出基因位于哪些群体之中
  FeaturePlot(scRNA_merge,features = 'Lyz1')  #Lyz1为小鼠基因
  #NoLegend()为Seurat包中去除图例函数
  DimPlot(scRNA_merge,reduction = 'umap',label = T) + NoLegend() +FeaturePlot(scRNA_merge,features = 'Lyz1')
  #查看基因气泡图，这个更加直观的可以判断基因在群体的分布
  DotPlot(scRNA_merge,features = c('Lyz1'))
}










