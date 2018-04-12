

######## Cluster Modeling ########

if (!require("pacman")) install.packages("pacman")
pacman::p_load(text2vec, dplyr, qlcMatrix, kernlab, knitr)

# Step 0 : Load data
train<-read.csv(file="/Users/anshuma/Documents/GitHub/Spring2018-Project4-group6/data/Movie_data_train.csv",header = T)
test<-read.csv(file="/Users/anshuma/Documents/GitHub/Spring2018-Project4-group6/data/Movie_data_test.csv",header = T)

train[is.na(train)] <- 0
test[is.na(test)] <- 0
# Step 1 : Write functions for training the data in order to get the parameters of the model.
# Two parameters are needed : probability of class (mu) and conditional probability of votes given class (gamma).
# Estimate parameters by maximum ikelihood estimation. Get Log likelihood and maximise by EM Algo. 

#-------------------------------- Expectation  -----------------------------
expectation <- function(mu,gamma,matrixk,c){
  theta<-NULL
  N<-nrow(matrixk)
  for (i in 1:c){
    gamma_c<-gamma[((i-1)*6+1):(6*i),]
    gamma_c<-as.vector(t(gamma_c))
    gamma_c<-matrix(rep(gamma_c,each=N),nrow=N)
    Di<-matrixk*gamma_c
    theta_i<-apply(Di,1,function(x){return(prod(x[x>0]))})
    names(theta_i)<-NULL
    theta<-rbind(theta,theta_i)
  }
  mu_repeat<-matrix(rep(mu,each=N),nrow=N)
  upper<-t(mu_repeat)*theta
  sum<-colSums(upper, na.rm=TRUE)
  lower<-matrix(rep(sum,each=c),nrow=c)
  p<-upper/lower
  p[is.na(p)]<-10^(-100)
  return(p)
}

###end of expectation

#-------------------------------- Maximization   --------------------------------
maximization <- function(p,matrixk,c){
  N<-ncol(matrixk)
  # estimate mu
  mu <- rowSums(p,na.rm = TRUE)/ncol(p)
  
  # estimate gamma
  summation<-rowSums(p,na.rm = TRUE)
  lower<-matrix(rep(summation,each=N),nrow=N)
  gamma_temp<-NULL
  for (k in 1:6){
    data<-as.matrix(matrixk)
    data[data != k]<-0
    data[data == k]<-1 
    upper<-p%*%data
    gamma_k<-upper/t(lower)
    gamma_k<-as.vector(t(gamma_k))
    gamma_temp<-rbind(gamma_temp,gamma_k)
  }### end of gamma calculation for each k 
  gamma<-NULL
  for (i in 1:c){
    temp<-gamma_temp[,((i-1)*N+1):(i*N)]
    gamma<-rbind(gamma,temp)
  }
  mu[is.na(mu)]<-10^(-100)
  gamma[is.na(gamma)]<-10^(-100)
  re<-list(mu,gamma)
  return(re)
}


#---------------------------- Expectation Maximization Algorithm  -------------------------

EM <- function(data,matrixk,mu_inits,gamma_inits,c,maxit=100,tol=1e-5) #maxit= maximum iterations; TA said you can set maxit=50
{
  # Estimation of parameter(Initial)
  flag <- 0
  mu_cur <- mu_inits; gamma_cur <- gamma_inits
  
  # Iterate between expectation and maximization parts
  
  for(i in 1:maxit){
    cur <- c(mu_cur,gamma_cur)
    new <- maximization(expectation(mu_cur,gamma_cur,data,c),matrixk,c)
    mu_new <- new[[1]]; gamma_new <- new[[2]]
    new_step <- c(mu_new,gamma_new)
    
    # Stop iteration if the difference between the current and new estimates is less than a tolerance level
    if( all(abs(cur - new_step) < tol) ){ flag <- 1; break}
    
    # Otherwise continue iteration
    mu_cur <- mu_new; gamma_cur <- gamma_new
  }
  if(!flag) warning("Didn't converge\n")
  
  em<-list(mu_cur, gamma_cur)
  return(em)
}



data_train <- read.csv("/Users/anshuma/Documents/GitHub/Spring2018-Project4-group6/data/Movie_data_train.csv")
data_train[is.na(data_train)] <- 0
rownames(data_train)<-data_train[,1]
data_train<-as.data.frame(data_train[,-1])
movie.index<-substring(names(data_train), 7)
colnames(data_train)<-1:ncol(data_train)

# Construct a binary matrix for users & moives 
data<-rep(NA,nrow(data_train))
for (i in 1:6){
  dat<-data_train
  dat[dat==i]<-1
  dat[dat!=i]<-0
  data<-cbind(data,dat)
}
data<-data[,-1]

# Set parameter estimates
c<-9

#mu
rand_mu<-runif(c, min=0,max=1)
mu_inits<-rand_mu/sum(rand_mu)

#gamma
rand<-runif(c*6*ncol(data_train),min=0,max=1)
ar <- array(rand, dim=c(c,  ncol(data_train),6))
arr<-matrix(rep(NA,ncol(data_train)),ncol=ncol(data_train),nrow=1)
for (i in 1:c){
  arr_i<-t(ar[i,,]/rowSums(ar[i,,]))
  arr<-rbind(arr,arr_i)
}
gamma_inits<-arr[-1,]

#--------------------Return EM Algorithm function -----------------------------
output <- EM(data,data_train,mu_inits,gamma_inits,c)
