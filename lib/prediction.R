prediction<-function(df,sim_mat,nbor_list){
  
  df.new<-df   #copy for calculating the mean by control NA.
  for (i in 1:nrow(df.new)){
    df.new[i,]<-ifelse(df.new[i,]==0,NA,df.new[i,])
  }
  df.mean<-matrix(rep(rowMeans(df.new,na.rm=T),each=ncol(df)),nrow=nrow(df),byrow = T)
  
  pred<-matrix(NA,ncol=ncol(df),nrow=nrow(df))
  
  for (i in 1:nrow(df)){
    ind<-nbor_list[[i]]
    nbors_mat<-df[ind,]
    w<-as.matrix(sim_mat[i,ind]/sum(sim_mat[i,ind]))
    nei.demean <- as.matrix(nbors_mat-df.mean[ind,])
    pred.a<- df.mean[i,1] + (w %*% (nei.demean))
    rm.ind<-which(df[i,]==1)
    pred.a[rm.ind]<-0
    pred[i,]<-pred.a
  }
  
  for (i in 1:nrow(df)){
    pred[i,]<-ifelse(pred[i,]<0,0,pred[i,])
  }  
  
  rownames(pred)<-rownames(df)
  colnames(pred)<-colnames(df)
  
  return(pred)
}
