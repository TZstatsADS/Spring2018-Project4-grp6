find_neighbours<-function(sim_mat,method='combined',threshold=NA,n=NA){
  
  #####Input: similarity matrix
  #####       method: weighthres, bestn, combined
  #####       threshold
  #####Output: index of neighbours
  
  stopifnot(method=='weighthres'|method=='combined'|method=='bestn')
  
  neighbours<-list()
  
  if (method=='weighthres'){
    for (i in 1:nrow(sim_mat)){
      sel<-ifelse(abs(sim_mat[i,])>threshold,1,0)
      ind<-which(sel==1)
      neighbours[[i]]<-ind[which(ind!=i)]
    }
  }else{
    if(method=='bestn'){
      for (i in 1:nrow(sim_mat)){
        ord<-order(abs(sim_mat[i,]),decreasing = T)
        neighbours[[i]]<-ord[which(ord!=i)][1:n]
      }
    }else{
      for(i in 1:nrow(sim_mat)){
        ind.w<-which(ifelse(abs(sim_mat[i,])>threshold,1,0)==1)
        sel.w<-ind.w[which(ind.w!=i)]
        ord.b<-order(abs(sim_mat[i,]),decreasing = T) 
        sel.b<-ord.b[which(ord.b!=i)][1:n]
        neighbours[[i]]<-intersect(sel.w,sel.b)
      }
    }
  }
  
  null <- (1:length(neighbours))[lapply(neighbours,length) == 0]
  if(length(null)!=0){
    for (i in 1:length(null)){
      index <- null[i]
      neighbours[[index]] <- null[i]
    }
  }
  
  return(neighbours)
}
