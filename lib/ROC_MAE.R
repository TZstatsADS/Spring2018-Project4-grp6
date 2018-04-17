###### Using ROC and MAE on data set 2 (Movie data) ##############


## ROC
evaluation_roc <- function(roc_value, pred_mat, Movie_test){ 
  ## function to calculate ROC of predicted value
  ## Input: roc_value= 4 (according to the paper 2)
  ##        pred_mat - predicted value
  ##        test_mat - test data matrix
  ## Output: roc 
  roc_mat <- matrix(roc_value, nrow = nrow(pred_mat), ncol = ncol(pred_mat))
  same <- sum((pred_mat >= roc_mat) == (Movie_test >= roc_mat), na.rm=TRUE)
  n <- sum(!is.na(pred_mat))
  return(same/n)
}

## MAE
evaluation_mae <- function(pred_mat, Movie_test){
  ## function to calculate mean absolute error of predicted value
  ## Input: pred_mat - predicted value
  ##        Movie_test - test data matrix
  ## Output: MAE
  for (i in 1:nrow(pred_mat)){
    pred_mat[i,]<-ifelse(pred_mat[i,]==0,NA,pred_mat[i,])
  }
  mae <- mean(abs(pred_mat - Movie_test), na.rm = T)
  return(mae)
}

