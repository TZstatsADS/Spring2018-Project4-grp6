score_estimation <- function(train, test, p){    #p is a list of parameters- mu and gamma
  ####Following the steps mentioned in the handout####### 
  ###Input: training set, test set, parameter list
  ###Output: estimated score
  
  mu <- p$mu
  gamma <- p$gamma
  C <- length(mu)   #clusters
  
  w <- array(0, c(M,N,7))  #M: movies , N: Users ; 7 categories of votes
  for(k in 1:6){
    w[,,k] <- ifelse(t(train)==k, 1, 0)  #give vote 1 if there is a match, 0 otherwise 
    w[,,k] <- ifelse(is.na(w[,,k]),0,w[,,k])
  }
  w[,,7] <- ifelse(!is.na(t(test_df)), 1, 0)
  
  ##probability by Naive Bayes formula ()
  prob <- array(0,c(N,M,7))
  prob_mu <- matrix(mu, N, C, byrow = TRUE) 
  phi <- matrix(0, C, N)
  for(k in 1:6){
    phi <- phi + t(log(gamma[,,k]))%*%w[,,k]
  }
  
  phi <- exp(phi)
  
  denominator <- matrix(diag(prob_mu%*%phi), N, M, byrow=FALSE)   #equation (2) denominator (check cluster model handout)
  
  
  for(k in 1:6){
    
    
    numerator <- (t(phi)*prob_mu)%*%t(gamma[,,k]) #numerator in equation (2) of cluster model handout
    prob[,,k] <- ifelse(numerator==denominator & numerator == 0, runif(1)/6, numerator/denominator)
    prob[,,7] <- prob[,,7] + k*prob[,,k]
  }
  return(prob[,,7]*t(w[,,7]))
}