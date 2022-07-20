library(monocle)
args <- commandArgs(T)

RDS_path <- args[1]
output <- args[2]
monocle_rds<- readRDS(RDS_path)
system2(command = 'mkdir',args = c('-p',paste(output,'monocle',sep = '/')))

# Seurat_rds <- readRDS("/nfs2/worktmp/chenzh_test/scRNA/mm10_AJSCRS2211009007_test/SingleR.rds")

###这里要注意的是，monocle默认的输入是count数，如果你输入的数据是FPKM或者TPM呢，需要进行一定的转换
data <- as(as.matrix(Seurat_rds@assays$RNA@counts),'sparseMatrix')  ###将UMI的稀疏矩阵存储到data中
pd <- new('AnnotatedDataFrame',data=Seurat_rds@meta.data)
###row.names(data)为genename
fData <- data.frame(gene_short_name = row.names(data),row.names = row.names(data))
fd <- new("AnnotatedDataFrame",data=fData)

#创建monocle需要使用的celldata对象：
#celldata创建需要pd，fd数据
monocle_cds <- newCellDataSet(data,
                              phenoData = pd,
                              featureData = fd,
                              lowerDetectionLimit = 0.1,   #过滤值，构成真实表达的最低表达水平
                              expressionFamily = negbinomial.size())

##使用差异基因进行细胞排序
#对细胞进行排序之前，需要降维，降维形成的细胞cluster，通过细胞cluster形成的细胞集，对细胞轨迹进行训练。
#https://www.jianshu.com/p/aaa0c768c861
#这里是对数据做标准化，即使Seurat对象已经做了标准化，这里还是要做下。
monocle_cds <- estimateSizeFactors(monocle_cds)   #计算SizeFactor,在phenodata中加入sizefactor这列,同时SizeFactor的结果用于后续的DDRTree降维聚类
monocle_cds <- estimateDispersions(monocle_cds)   #计算Dispersion离散，有利于后续进行高变基因的评估。


#fData()提取CDS对象中的基因注释表格，得到的结果为数据框
#pData()提取CDS对象中细胞表型的表格
head(fData(monocle_cds))
head(pData(monocle_cds))
head(dispersionTable(monocle_cds))

#step1:(差异gene筛选)选择不同方式得到的轨迹结果不同
###方式一.     选择离散程度较高的gene作为后续降维分析的标识。
#之前使用monocle的estimateDispersions()函数对数据进行了评估。
#dispersionTable()可以提取estimateDispersions()评估的数据结果
dispersion_gene_tab <- dispersionTable(monocle_cds)
#挑选出离散程度较大的gene
unsup_cluster_gene <- subset(dispersion_gene_tab,mean_expression>=0.1)
monocle_cds_new <- setOrderingFilter(monocle_cds,unsup_cluster_gene$gene_id)
#同时要对数据进行排序，这是由于后续的DDRTree的算法
plot_ordering_genes(monocle_cds_new)

# ###方式二.     选择Seurat的高变基因
# varb_genes <- VariableFeatures(Seurat_rds) 
# monocle_varb_cds <- setOrderingFilter(monocle_cds,varb_genes)
# plot_ordering_genes(monocle_varb_cds)



#step2:降维，默认为DDRTree：
monocle_cds_new <- reduceDimension(monocle_cds_new , max_components = 2 , method = 'DDRTree')

#step3:排序,通过计算来学习细胞的生物学轨迹，并且返回两列State和Pseudotime
monocle_cds_new <- orderCells(monocle_cds_new)

#保存对象
saveRDS(monocle_cds_new,paste(output,"monocle.rds",sep='/'))

#step4:绘制轨迹图
###State轨迹图
plot_cell_trajectory(monocle_cds_new,color_by = "State")
ggsave(paste(output,'monocle/State_trajectory.png',sep='/'),dpi=300)
###Cluster轨迹图
plot_cell_trajectory(monocle_cds_new,color_by = "seurat_clusters")
ggsave(paste(output,'monocle/Cluster_trajectory.png',sep='/'),dpi=300)
###Pseudotime轨迹图
plot_cell_trajectory(monocle_cds_new,color_by = "Pseudotime")
ggsave(paste(output,'monocle/Pseudotime_trajectory.png',sep='/'),dpi=300)

write.table(pData(monocle_cds_new),paste(output,'monocle/monocle_pData.xls',sep = '/'),sep = '\t',quote = F,row.names = F)
write.table(fData(monocle_cds_new),paste(output,'monocle/monocle_fData.xls',sep = '/'),sep = '\t',quote = F,row.names = F)



# monocle_cds_new <- readRDS("/nfs2/worktmp/chenzh_test/scRNA/mm10_AJSCRS2211009007_test/monocle.rds")
if(F){
  #1.自定义根节点
  GM_state <- function(cds){
    if(length(unique(pData(cds)$State))>1){
      #[,"0"] 这里指代seurat_clusters为0时的State情况。这里没有什么生物学意义，仅举例应用。一般可以根据时间样本进行记录。
      T0_counts <- table(pData(cds)$State , pData(cds)$seurat_clusters)[,"0"] 
      return(as.numeric(names(T0_counts)[which(T0_counts == max(T0_counts))]))
    }else{
      return(1)
    }
  }
  GM_state(monocle_cds_new)
  #指定起点后重新排序细胞：
  monocle_cds_new <- orderCells(monocle_cds_new , root_state = GM_state(monocle_cds_new))
  #facet_wrap分页函数
  plot_cell_trajectory(monocle_cds_new , color_by = 'State') + facet_wrap(~State, nrow=2)
  
  
  #2.比较细胞分化轨迹过程中的功能差异基因的表达
  test <- row.names(subset(fData(monocle_cds_new),gene_short_name %in% c('Cd58','Lyz1','Cd38')))
  test_subset <- monocle_cds_new[test,]   #CDS对象类似于Seurat的assay横坐标gene，纵坐标细胞
  #plot_genes_in_pseudotime等函数可以查看gene的表达在不同状态或者时间等等因素下的变化。
  plot_genes_in_pseudotime(test_subset, color_by = 'State')
  plot_genes_jitter(test_subset , color_by = 'State')
  plot_genes_violin(test_subset , color_by = 'State')
  
  

  # 4.monocle中找差异基因的方法
  # Monocle中differentialGeneTest()函数可以按条件进行差异分析，将相关参数设为fullModelFormulaStr = "~sm.ns(Pseudotime)"时，
  # 可以找到与拟时相关的差异基因。我们可以按一定的条件筛选基因后进行差异分析，全部基因都输入会耗费比较长的时间
  # 建议使用cluster差异基因或高变基因输入函数计算。
  #主要用到sm.ns()函数根据表达量拟合曲线,该函数会进行模型计算，算法比monocle自带的聚类分群算法更加复杂一些。
  if(F){
    
      #1. 测试选择前6的高变基因
      test_genes <- head(VariableFeatures(SingleR_rds))
      test_subset <- monocle_cds_new[test_genes,]
      # diff_test_res <- differentialGeneTest(test_subset,fullModelFormulaStr = "~sm.ns(State)")
      diff_test_res <- differentialGeneTest(test_subset,fullModelFormulaStr = "~sm.ns(Pseudotime)")
      
      sig_gene_names <- row.names(subset(diff_test_res, qval < 0.01))
      #num_clusters为热图聚类的数目
      plot_pseudotime_heatmap(monocle_cds_new[sig_gene_names,] , num_clusters = 3 , show_rownames = T)
      
      
      #2. 也可以使用monocle的函数来找高变基因
      disp_table <- dispersionTable(monocle_cds_new)
      disp.genes <- subset(disp_table, mean_expression >= 0.5 & dispersion_empirical >= 1*dispersion_fit)
      disp_genes <- disp.genes$gene_id
      plot_pseudotime_heatmap(monocle_cds_new[disp_genes,] , num_clusters = 4 , show_rownames = T)
      
      #3. 也可以使用群体间差异基因,这里测试前6个，这里应该每个群体都挑选几个差异基因，这里偷懒了。
      diff_in_cluster <- read.table("/nfs2/worktmp/chenzh_test/scRNA/mm10_AJSCRS2211009007_test/DEG/combine_sample/All_markers_between_cluster.xls")
      test1 <- head(rownames(diff_in_cluster[diff_in_cluster$cluster==0,]),n=3)
      test2 <- head(rownames(diff_in_cluster[diff_in_cluster$cluster==2,]),n=3)
      diff_in_cluster_genes <- as.character(rbind(test1,test2))
      plot_pseudotime_heatmap(monocle_cds_new[diff_in_cluster_genes,] , num_clusters = 2 , show_rownames = T)
      
      #4. 也可以找单个群体内部的差异基因
  }
  
  
  
  
  #5. BEAM分析，研究和寻找关于分支调控的关键基因
  plot_cell_trajectory(monocle_cds_new[disp_genes,] , color_by = "State")
  #由于太慢了，这里测试50个gene
  disp_genes <- head(disp_genes,n = 50)
  beam_res <- BEAM(monocle_cds_new[disp_genes,], branch_point = 1, cores = 8)
  beam_res <- beam_res[order(beam_res$qval),]
  monocle_cds_new_beam <- monocle_cds_new[row.names(subset(beam_res, qval < 1e-4)),]
  #plot_genes_branched_heatmap分支热图，拟时序从中间开始，向右是一个分支，向左是另一个。这个函数要指定分支节点branch_point
  plot_genes_branched_heatmap(monocle_cds_new_beam,  branch_point = 1 , show_rownames = T)
  #根据beam的结果挑选几个基因可视化
  test <- head(rownames(beam_res),n=3)
  plot_genes_branched_pseudotime(monocle_cds_new[test,],
                                 branch_point = 1,
                                 color_by = 'orig.ident')
}













###由于所给对象已经经过Seurat处理，所以通常monocle就不处理了。
# #1.数据质控：
# #detectGenes运行结果是在featureData表格中添加num_cells_expressed列；
# #同时在phenoData表格中添加num_genes_expressed列；
# monocle_cds <- detectGenes(monocle_cds , min_expr = 0.1)
# #1.1 过滤基因，保留至少在十个细胞内表达的基因：
# expression_genes <- row.names(subset(fData(monocle_cds),num_cells_expressed>10))
# length(expression_genes)
# monocle_cds <- monocle_cds[expression_genes,]
# 
# #1.2 过滤细胞：由于之前Seurat质控了所以一般不用在过滤
# valid_cells <- row.names(subset(pData(monocle_cds),num_genes_expressed>200 & num_genes_expressed<5000))
# monocle_cds <- monocle_cds[,valid_cells]
# #使用exprs()提取表达量稀疏矩阵：
# exp_datatable <- exprs(monocle_cds)
# dim(exp_datatable)
# pData(monocle_cds)$Total_mRNA <- Matrix::colSums(exp_datatable)
# #根据细胞总mRNA数的核密度分布曲线进一步过滤总mRNA异常的细胞：
# #异常值范围边界确定为：mean ± 2sd(sd为标准差)
# upper_bound <- 10^(mean(log10(pData(monocle_cds)$Total_mRNA))+
#                       2*sd(log10(pData(monocle_cds)$Total_mRNA)))
# down_bound  <- 10^(mean(log10(pData(monocle_cds)$Total_mRNA))-
#                       2*sd(log10(pData(monocle_cds)$Total_mRNA)))
# qplot(Total_mRNA, data=pData(monocle_cds) , color=pData(monocle_cds)$orig.ident , geom = 'density') +
#   geom_vline(xintercept = upper_bound)+ #添加辅助线
#   geom_vline(xintercept = down_bound)
# #保留中间区域数据：
# valid_cells_2 <- pData(monocle_cds)$Total_mRNA<upper_bound & pData(monocle_cds)$Total_mRNA>down_bound
# monocle_filter_cds <- monocle_cds[,valid_cells_2]
# dim(monocle_filter_cds)








####1. 重新进行聚类分析来对细胞轨迹进行无监督学习分析：
#先绘制主成分对应的解释方差的值可视化图形
plot_pc_variance_explained(monocle_cds,return_all=F,max_components=25)



















