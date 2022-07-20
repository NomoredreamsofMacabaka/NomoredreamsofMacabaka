library(Seurat)
library(SingleR)
library(stringr)
library(ggplot2)
library(dplyr)
library(celldex)  ###为singleR单独提供数据库支撑。


args <- commandArgs(T)


Seurat_rds_path <- args[1]
Seurat_rds <- readRDS(Seurat_rds_path)
species <- args[2]    ###只包含了常规的人和小鼠
output <- args[3]
system2(command = 'mkdir',args = c('-p',paste(output,'SingleR',sep = '/')))



#标准数据库加载
if(species=='human'){
  ref_database <- celldex::HumanPrimaryCellAtlasData()
}else if(species=='mouse'){
  ref_database <- celldex::MouseRNAseqData()
}




if(length(Seurat_rds)==1){
  #RDS对象的细胞表达矩阵提取
  counts <- Seurat_rds@assays$RNA@counts
  #RDS对象的群体提取
  cluster <- Seurat_rds@meta.data$seurat_clusters
  
  #开始SingleR注释
  #clusters参数是指对指定的标志上进行注释，如果不设置默认对每个单元进行注释
  #genes参数'de'识别标签之间的差异表达基因;
  #         'sd'标识跨标签高度可变基因;
  #         'all'不会执行任何特征选择
  
  #1.针对群体注释，clusters如果添加，就很根据所给标识进行聚合注释，不设置就是对所有细胞进行单独注释。
  #SingleR注释对象标签在微调之前（first.labels），微调之后（labels）和修剪后（pruned.labels）以及相关得分
  Seurat_SingleR_anno <- SingleR(test = counts, ref = ref_database,labels = ref_database$label.main,
                                 clusters = cluster,genes = "de")
  cluster_label <- data.frame('cluster_label' = Seurat_SingleR_anno$pruned.labels)
  #相当于给一列群体的编号，将分群编号和注释的群体类型对应起来
  cluster_label$seurat_clusters <- as.character(as.numeric(rownames(cluster_label))-1)
  project_rownames <- rownames(Seurat_rds@meta.data)
  ###dplyr包中left_join作用为includes all rows in x.
  #这里就是为metadata添加注释列
  Seurat_rds@meta.data <-dplyr::left_join(x = Seurat_rds@meta.data, y = cluster_label, by='seurat_clusters')
  #添加行名(细胞ID),由于left_join操作后，行名变成了1,2,3这种行号，所以需要重新赋值。
  rownames(Seurat_rds@meta.data) <- project_rownames
  
  #2.对所有细胞进行单独注释：
  SingleR_allcell_anno <- SingleR(test = counts , ref = ref_database , genes = 'de', labels = ref_database$label.main)
  plotScoreHeatmap(SingleR_allcell_anno)
  ggsave(paste(output,'SingleR/All_cell_anno_heatmap.png',sep = '/'),dpi = 300)
  ggsave(paste(output,'SingleR/All_cell_anno_heatmap.pdf',sep = '/'),dpi = 300)
  write.table(SingleR_allcell_anno,paste(output,'SingleR/All_cell_anno.xls',sep = '/'),quote = F,sep = '\t')
  write.table(Seurat_SingleR_anno,paste(output,'SingleR/All_cluster_anno.xls',sep = '/'),quote = F,sep = '\t')
  
  #保存对象
  saveRDS(Seurat_rds,paste(output,'SingleR.rds',sep='/'))
  
}else{
  library(foreach)
  library(doParallel)
  threads_num <- makeCluster(length(Seurat_rds))
  registerDoParallel(threads_num)
  foreach(i = 1:length(Seurat_rds) , .inorder = F , .packages = c('Seurat','SingleR')) %dopar% {
    count[i] <- Seurat_rds[[i]]@assays$RNA@counts
    cluster[i] <- Seurat_rds[[i]]@mete.data$seurat_clusters
    Seurat_SingleR_anno[i] <- SingleR(test = count[i] , ref = ref_database , labels = ref_database$label.main,
                                      clusters = cluster[i],genes = "de")
    }
}


#给定markergene分析举例
if(F){
  #查看特定基因在降维聚类中的分布：
  mm10_RDS <- readRDS("/biodata/06.personalized_analysis/mm10_AJSCRS2211009007_scRNA_20220117/01.analysis/standard/sce.integrated.Rds")
  FeaturePlot(Seurat_rds,features = c('Dclk1','Kit'),reduction = 'umap')
  #群体鉴定完毕后修改cluster名称方法：
  # #1.直接改掉active.ident的名称
  # new_name <- as.character(c(2:20))
  # names(new_name) <- levels(mm10_RDS)  #这里是对new_name起标识名，为对应RDS对象中的标识
  # mm10_RDS <- RenameIdents(mm10_RDS,new_name)
  # UMAPPlot(mm10_RDS)
  # mm10_RDS@active.ident   ###active.ident指代当前对象的标识，RenameIdents改的就是这个
  #2.不改变当前对象标识，通过加一列来进行重新命名
  library(plyr)
  SPP1 <- c(6,10)
  DCLK1 <- c(16)
  KIT <- c(9,11,17,18)
  other <- c(1,2,3,4,5,7,8,10,12,13,14,15)
  idents <- c(SPP1,DCLK1,KIT)
  new_cluster.idents <- c(rep('Spp1',length(SPP1)),rep('DCLK1',length(DCLK1)),rep('KIT',length(KIT)),rep('other',length(other)))
  mm10_RDS@meta.data$new_cluster.idents <- plyr::mapvalues(x=as.integer(as.character(mm10_RDS@meta.data$seurat_clusters)),
                  from = idents,
                  to = new_cluster.idents
                  )
}













