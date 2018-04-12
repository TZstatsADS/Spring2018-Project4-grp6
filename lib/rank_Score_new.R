ranked_scoring <- function(pred, MS_test, alpha){
  
  visited_ind <- apply(MS_test, 1, function(x){return(which(x==1))})
  ord <- t(apply(pred, 1, function(x){return(order(x,decreasing = T))})) #rank list of predicted
  # R_a: Expected utility of a ranked list for user a 
  R_a <- rep(NA, nrow(MS_test))
  R_a_max <- rep(NA, nrow(MS_test))
  
  for(a in 1:nrow(MS_test)){
    d<-mean(pred[a,])
    j<-ord[a,] # rank of test according to predicted
    m<-ifelse((pred[a,])>0,(pred[a,]),0) #assuming d to be 0
    
    R_a[a] <- sum( m / 2^((j-1)/(alpha-1)) )
    R_a_max[a] <- length(visited_ind[[a]])
  }
  
  # Final rank score 
  R <- 100 * (sum(R_a) / sum(R_a_max))
  return(R)
}
