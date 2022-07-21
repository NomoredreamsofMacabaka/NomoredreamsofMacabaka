library(Seurat)
library(dplyr)
library(ggplot2)
library(plotly)
library(plot3D)


load("obj.Rda")

seurat_object[["celltype"]] <- Idents(seurat_object)
stat <- table(seurat_object$orig.ident,seurat_object$celltype)
stat <- as.data.frame(stat)

colnames(stat) <- c('sample','celltype','Freq')

ggplot(stat, aes(x = celltype, y = Freq,fill=sample))+
  geom_bar(stat = 'identity',position = "fill")

ggplot(stat , aes(x=sample,y=Freq,fill=celltype))+
  geom_bar(stat='identity',position = 'dodge')
ggplot(stat , aes(x=sample,y=Freq,fill=celltype))+
  geom_bar(stat='identity',position = 'fill')





seurat_object <- RunUMAP(seurat_object,reduction = 'harmony',dims=1:20)
UMAP_coor <- seurat_object@reductions$umap@cell.embeddings
UMAP_coor <- as.data.frame(UMAP_coor)
celltype <- Idents(seurat_object)
UMAP_coor <- cbind(UMAP_coor,celltype)



IL4I1 <- FetchData(seurat_object,vars='IL4I1')
UMAP_coor <- cbind(UMAP_coor,IL4I1)


Tcell_marker <- c('CD3D','CD3E','CD3G')
Tcell_data <- seurat_object@assays$RNA@data[Tcell_marker,]
Tcell_data <- expm1(Tcell_data)
T_cell <- log1p(colMeans(Tcell_data))
UMAP_coor <- cbind(UMAP_coor,T_cell)



ggplot(UMAP_coor,aes(x=UMAP_1,y=UMAP_2,label=celltype))+2
  geom_point(aes(color=celltype))+
  geom_text(color='black',size=3)


label_coor <- UMAP_coor %>% group_by(celltype) %>% summarise(UMAP_1=median(UMAP_1),UMAP_2=median(UMAP_2))
ggplot(UMAP_coor,aes(x=UMAP_1,y=UMAP_2,label=celltype))+
   geom_point(aes(color=celltype))+
   geom_text(data = label_coor,color="black",size=3)








































