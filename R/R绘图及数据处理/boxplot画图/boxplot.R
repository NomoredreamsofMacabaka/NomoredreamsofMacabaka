##### boxplot for trait & ck ########
# setwd('/nfs2/igenebook/AJFX221072952_NRK52E_mouse/heatmap')

library(ggplot2)
library(ggsignif)

dat = read.table('EnrichmentFold.xls')
dat$group = as.factor(str_split(dat$V1,'_',simplify = T)[,2]) # 否则无法分组求p值
dat$group2 = as.factor(str_split(dat$V1,'_',simplify = T)[,1])
dat = dat[dat$V2<75,]
dat$V1 = factor(dat$V1,levels = c('DMSO_Menin','APH_Menin','DMSO_H3K4me3','APH_H3K4me3','DMSO_Mll1','APH_Mll1'))

### version1
pdemo = ggplot(dat) + stat_boxplot(aes(group,V2,fill=V1),geom = 'errorbar',width=0.2,position = position_dodge(width = 0.75)) + 
  geom_boxplot(aes(group,V2,fill=V1,alpha=V1)) + scale_fill_manual(values = rep(c('#ee0000','#008b45','#631879'),each=2)) + scale_alpha_manual(values = rep(c(0.7,1),3)) + 
  theme_bw() + theme(panel.grid = element_blank(),legend.position = 'none') + xlab('') + ylab('Enrichment fold')


mycompares = list(c('DMSO_Menin','APH_Menin'),c('DMSO_H3K4me3','APH_H3K4me3'),c('DMSO_Mll1','APH_Mll1'))
### version2
p = ggplot(dat) + stat_boxplot(aes(group,V2,fill=V1),geom = 'errorbar',width=0.2,position = position_dodge(width = 0.75)) + 
  geom_boxplot(aes(group,V2,fill=V1)) + scale_fill_manual(values = c('#4dae7d','#008b45','#f34d4d','#ee0000','#925da1','#631879')) +
  # geom_signif(data = dat,aes(group,V2,group=group2),map_signif_level=function(p)sprintf("p = %.2g", p)) + 
  stat_compare_means(aes(group,V2,group = group2),label = "p.format",method = "t.test",vjust = -1,bracket.size=50,tip.length=34) + 
  theme_bw() + theme(panel.grid = element_blank(),legend.title = element_blank(),axis.text = element_text(size=18),
                     axis.title = element_text(size=20)) + xlab('') + ylab('Enrichment fold')
ggsave('group_Enrichment_fold.pdf',width = 8,height = 8.5)
ggsave('group_Enrichment_fold.png',dpi = 300,width = 8,height = 8.5)

### version3
p2 = ggplot(dat) + stat_boxplot(aes(V1,V2,fill=V1),geom = 'errorbar',width=0.2,position = position_dodge(width = 0.75)) + 
  geom_boxplot(aes(V1,V2,fill=V1)) + scale_fill_manual(values = c('#4dae7d','#008b45','#f34d4d','#ee0000','#925da1','#631879')) +
  geom_signif(data = dat,aes(V1,V2),comparisons = mycompares,map_signif_level=function(p)sprintf("p = %.2g", p),
              textsize = 6,size=1,tip_length = 0.01,test = 't.test') +
  theme_bw() + theme(panel.grid = element_blank(),legend.title = element_blank(),axis.text.y = element_text(size=18),
    axis.text.x = element_text(size=14,hjust=1,vjust = 1,angle=70),axis.title = element_text(size=20)) + xlab('') + ylab('Enrichment fold')

