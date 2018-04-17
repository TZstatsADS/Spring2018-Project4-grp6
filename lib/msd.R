mean_sq_diff <- function(df){
  sim<-matrix(NA,ncol=nrow(df),nrow=nrow(df))
  for (a in 1:nrow(df)){
    for(i in 1:nrow(df)){
      if (a<=i){
        sim[a,i]<-mean((df[a,]-df[i,])^2)
      }else{
        sim[a,i]<-sim[i,a]
      }
    }
  }
  return(sim)
}


