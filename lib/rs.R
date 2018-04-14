rank_score<-function(pred,test,d,alpha){
  R_a<-rep(NA,nrow(test))
  R_a_max<-rep(NA,nrow(test))
  
  for(i in 1:nrow(test)){
    j<-order(pred[i,],decreasing = T)
    pred.s<-sort(pred[i,])
    numer<-ifelse(pred.s-d>0,pred.s-d,0) 
    R_a[i] <- sum( numer / 2^((j-1)/(alpha-1)))
    pred.s<-ifelse(test[i,]==1,1,pred.s)
    j<-order(pred.s,decreasing = T)
    pred.s<-sort(pred.s)
    denom<-ifelse(pred.s-d>0,pred.s-d,0) 
    R_a_max[i] <- sum( denom / 2^((j-1)/(alpha-1)))
  }
  R <- 100 * (sum(R_a) / sum(R_a_max))
  return(R)
}
