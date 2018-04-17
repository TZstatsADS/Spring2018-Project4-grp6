

m_train_full<-read.csv(choose.files())
m_test<-read.csv(choose.files())
m_train<-m_train_full[, -1]
m_test<-m_test[, -1]
m_train<-m_train[1:100, 1:200]
################ EM Algorithm#################

clusterEM<- function (m_train, tau, C){
  J <- ncol(m_train)
  # C<-5 # choice of Groups 
  I<-nrow(m_train)
  ## initialize the mu and and gamma 
  mu_int<-numeric(C)
  gamma<-array(0, dim = c(7, J, C)) #7 vote, J movie, C cluster
  for (c in 1:(C-1)) {
    mu_int[c]<-runif(1, 0, 1-sum(mu_int))
  }
  
  mu_int[C]<-1-sum(mu_int)
  
  
  ## Problem's here
  for( c in 1:C){
    for(j in 1:J){
    gamma[1, j, c]<-runif(1, 0, 1)
    gamma[2, j, c]<-runif(1, 0, 1-gamma[1, j, c])
    gamma[3, j, c]<-runif(1, 0, 1-gamma[1, j, c]-gamma[2, j, c])
    gamma[4, j, c]<-runif(1, 0, 1-gamma[1, j, c]-gamma[2, j, c]-gamma[3, j, c])
    gamma[5, j, c]<-runif(1, 0, 1-gamma[1, j, c]-gamma[2, j, c]-gamma[3, j, c]-gamma[4, j, c])
    gamma[6, j, c]<-runif(1, 0, 1-gamma[1, j, c]-gamma[2, j, c]-gamma[3, j, c]-gamma[4, j, c]-gamma[5, j, c])
    gamma[7, j, c]<-1-gamma[1, j, c]-gamma[2, j, c]-gamma[3, j, c]-gamma[4, j, c]-gamma[5, j, c]-gamma[6, j, c]
    }
  }
  
  
  pi<-matrix(NA, ncol = C, nrow= nrow(m_train)) # r = user, C = Group
  
  phi<-matrix(NA, ncol = C, nrow =I)
  pi_pre <- matrix(0, nrow = I, ncol = C)
  

  
  iter <- 1 #iteration
  ITER<-200
  check_conv <- Inf

  while(check_conv > tau & iter < ITER){
    for(i in 1:I){ #get phi
      sub_mu_phi <- array(0,C) 
      for(j in 1:20) {
        #i<-1; j <- 3
        sub_mu_phi <- sub_mu_phi + log(gamma[m_train[i,j]+1, j,])
        #print(sub_mu_phi)
      }
      phi[i, ] <- exp(sub_mu_phi)
    }
    tmp_1 <- mu_int * phi
    pi <- tmp_1/apply(tmp_1, 1, sum)
    

    mu_int <- apply(pi, 2, sum)/I
    
    for(c in 1:C){ 
      for(j in 1:J){

        gamma[1, j, c]<-sum(pi[, c]*(m_train[, j] == 0))/sum(pi[, c])
        gamma[2, j, c]<-sum(pi[, c]*(m_train[, j] == 1))/sum(pi[, c])
        gamma[3, j, c]<-sum(pi[, c]*(m_train[, j] == 2))/sum(pi[, c])
        gamma[4, j, c]<-sum(pi[, c]*(m_train[, j] == 3))/sum(pi[, c])
        gamma[5, j, c]<-sum(pi[, c]*(m_train[, j] == 4))/sum(pi[, c])
        gamma[6, j, c]<-sum(pi[, c]*(m_train[, j] == 5))/sum(pi[, c])
        gamma[7, j, c]<-sum(pi[, c]*(m_train[, j] == 6))/sum(pi[, c])
      }
    }
    
    check_conv <- norm(pi - pi_pre)
    print(check_conv)
    print(iter)
    
    pi_pre <- pi
    iter = iter + 1
  }
  
  return(list(mu = mu_int, gamma= gamma, pi = pi))
}
 
cl<-clusterEM(m_train, 5, 3)

#Generating prediction
mu <- cl$mu
gamma<-cl$gamma
pi<-cl$pi


pred_func <- function(m_train, gamma, mu, pi){
  item_test <- colnames(m_train)
  # order <- match(item_test, items)
  I <- nrow(m_train)
  J <- ncol(m_train)
  predictions <- matrix(numeric(I*J), nrow = I, ncol = J)
  #colnames(predictions) <- item_test
  
  user_cluster <- apply(pi, 1, which.max)
  error <- 0
  
  for(i in 1:I){
    for(j in 1:J){
      cluster <- user_cluster[i]
      predictions[i,j] <- sum(c(gamma[1, j, cluster], gamma[2, j, cluster], gamma[3, j, cluster], gamma[4, j, cluster],
                            gamma[5, j, cluster], gamma[6, j, cluster], gamma[7, j, cluster])*c(0, 1, 2, 3, 4, 5, 6))
    }
  }       
  predictions<-as.data.frame(predictions)
  return(predictions)
}
NN<-apply(predictions, 1, is.na)
MM<-apply(m_test, 1, is.na)
pre<-pred_func(m_train, gamma, mu, pi)

clusterMAE<-function(m_test, prediction){
  J <- ncol(m_test)
  # C<-5 # choice of Groups 
  I<-nrow(m_test)
  MAE<-abs(m_test-pre)
  return(sum(MAE)/(I*J))
}

evaluation_mae <- function(pred_mat, Movie_test){
  ## function to calculate mean absolute error of predicted value
  ## Input: pred_mat - predicted value
  ##        Movie_test - test data matrix
  ## Output: MAE
  pred_mat<-pre
  Movie_test<-m_test
  for (i in 1:nrow(pred_mat)){
    Movie_test[i,]<-ifelse(Movie_test[i,]==0,NA,Movie_test)
  }
  mae <- as.matrix(abs(pred_mat - Movie_test))
  mae<-mean(mae, na.rm = TRUE)
  return(mae)
}

evaluation_mae2 <- function(pred_mat, Movie_test, Movie_train){
  ## function to calculate mean absolute error of predicted value
  ## Input: pred_mat - predicted value
  ##        Movie_test - test data matrix
  ## Output: MAE
  for (i in 1:nrow(pred_mat)){
    Movie_test[i,]<-ifelse(Movie_train[i,]!=0,NA,Movie_test)
  }
  mae <- as.matrix(abs(pred_mat - Movie_test))
  return(mae)
}


pre<-clusterEM(m_train, 5, 5)
pre<-pred_func(m_train, pre$gamma, pre$mu, pre$pi)
A<-evaluation_mae2(pre, m_test, m_train)

### CV

C_CV<-seq(20,30, 2)
MAE<-numeric(10)
for (i in 1:10){
  pre<-clusterEM(m_train, 5, C_CV[i])
  pre<-pred_func(m_train, pre$gamma, pre$mu, pre$pi)
  MAE[i]<-evaluation_mae(pre, m_test)
}

pre<-clusterEM(m_train, 5, 60)
pre<-pred_func(m_train, pre$gamma, pre$mu, pre$pi)
MAEEEE<-evaluation_mae(pre, m_test)