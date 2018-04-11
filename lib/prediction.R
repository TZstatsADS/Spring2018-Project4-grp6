prediction<-function(df,sim_mat,nbor_list){
  
  library(matrixStats)
  
  df.mean<-matrix(rep(rowMeans(df,na.rm=T),each=ncol(df)),nrow=nrow(df),byrow = T)
  df.sd<-matrix(rep(rowSds(df,na.rm=T),each=ncol(df)),nrow=nrow(df),byrow = T)
  
  df<-ifelse(is.na(df),0,df)
  
  pred<-matrix(NA,ncol=ncol(df),nrow=nrow(df))
  
  for (i in 1:nrow(df)){
    ind<-nbor_list[[i]]
    nbors_mat<-df[ind,]
    w<-as.matrix.data.frame(sim_mat[i,ind]/sum(sim_mat[i,ind]))
    pred.a<- df.mean[i,1] + (w %*% ((nbors_mat-df.mean[ind,])/df.sd[ind,])) * df.sd[i,1]  
    rm.ind<-which(df[i,]==1)
    pred.a[rm.ind]<-NA
    pred[i,]<-pred.a
  }
  
  pred<-ifelse(pred<0,0,pred)
  pred<-ifelse(pred>1,1,pred)
  rownames(pred)<-rownames(df)
  colnames(pred)<-colnames(df)
  
  return(pred)
}

