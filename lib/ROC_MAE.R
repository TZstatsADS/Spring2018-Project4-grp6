###### Using ROC and MAE on data set 2 (Movie data) ##############

## ROC
evaluation_roc <- function(roc_value, pred_mat, Movie_test){ 
  ## function to calculate ROC of predicted value
  ## Input: roc_value= 4 (according to the paper 2)
  ##        pred_mat - predicted value
  ##        test_mat - test data matrix
  ## Output: roc 
  
  dataframe_movie_prediction <- data.frame(pred_mat)
  
  for (i in 1:nrow(dataframe_movie_prediction)){
    dataframe_movie_prediction[i,]<-ifelse(dataframe_movie_prediction[i,]==0,NA,dataframe_movie_prediction[i,])
  }
  
  pred_mat <- as.matrix(dataframe_movie_prediction)
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
  mae <- mean(abs(pred_mat - Movie_test), na.rm = T)
  return(mae)
}
