find_neighbours<-function(sim_mat,method='combined',threshold=NA,n=NA){
  
  #####Input: similarity matrix
  #####       method: weighthres, bestn, combined
  #####       threshold
  #####Output: index of neighbours
  
  stopifnot(method=='weighthres'|method=='combined'|method=='bestn')
  
  neighbours<-list()
  
  if (method=='weighthres'){
    for (i in 1:nrow(sim_mat)){
      sel<-ifelse(abs(sim_mat[i,])>threshold,1,0)[-i]
      neighbours[[i]]<-which(sel==1)
    }
  }else{
    if(method=='bestn'){
      for (i in 1:nrow(sim_mat)){
        neighbours[[i]]<-order(sim_mat[i,],decreasing = T)[-i][1:n]
      }
    }else{
      for(i in 1:nrow(sim_mat)){
        sel.w<-which(ifelse(abs(sim_mat[i,])>threshold,1,0)[-i]==1)
        sel.b<-order(sim_mat[i,],decreasing = T)[-i][1:n]
        neighbours[[i]]<-intersect(sel.w,sel.b)
      }
    }
  }
  return(neighbours)
}
