setwd('C:/Users/rolco/Desktop')
ms<-read.csv('ms_summary.csv',header=T,sep=',')
movie<-read.csv('movie_summary.csv',header=T,sep=',')
rownames(ms)<-ms[,1]
ms<-ms[,-1]
rownames(movie)<-movie[,1]
movie<-movie[,-1]

library(heatmaply)
library(RColorBrewer)
b<-brewer.pal(n = 8, name = "Blues")
heatmaply(ms,draw_cellnote = TRUE,colors =b,dendrogram='none',
          fontsize_row = 14, fontsize_col = 14,cellnote_size = 20)

heatmaply(movie,draw_cellnote = TRUE,colors =b,dendrogram='none',
          fontsize_row = 14, fontsize_col = 14,cellnote_size = 20)



