source("prediction.R")
source("find_neighbours.R")

library(Metrics)

library(pROC)

######## Spearman
#MS_weights <- read.csv("C:/StudyLife/Columbia/STAT 5243/Local Project 4/Each Movie Case/MS_Spearman_weights.csv")

Movie_weights <- read.csv("C:/StudyLife/Columbia/STAT 5243/Local Project 4/Each Movie Case/Movie_Spearman_weights.csv")

data1 <- read.csv("C:/StudyLife/Columbia/STAT 5243/Local Project 4/Each Movie Case/Movie_data_train.csv")

movietest <- read.csv("C:/StudyLife/Columbia/STAT 5243/Local Project 4/Each Movie Case/Movie_data_test.csv")
movietest <- movietest[,-1]

numeric_movietest <- NULL
for(i in 1:ncol(movietest)) {
  numeric_movietest <- cbind(numeric_movietest, as.numeric(movietest[,i]))
}

# neighbors of method bestn
Movie_neighbors <- find_neighbours(Movie_weights[,-1], method = "bestn" , n = 20)

movie_prediction <- prediction(data1[, -1], Movie_weights[, -1], Movie_neighbors)

dataframe_movie_prediction <- data.frame(movie_prediction)

eval_roc_Spearman <- evaluation_roc(4, as.matrix(dataframe_movie_prediction), as.matrix(movietest))
eval_roc_Spearman

eval_mae_Spearman <- evaluation_mae(as.matrix(dataframe_movie_prediction), as.matrix(numeric_movietest))
eval_mae_Spearman

# neighbors of method weighthres
movie_neighbors_weighthres <- find_neighbours(Movie_weights[,-1], method = "weighthres" , threshold = 0.05)
  
movie_prediction_weighthres <- prediction(data1[, -1], Movie_weights[, -1], movie_neighbors_weighthres)

dataframe_movie_prediction_weighthres <- data.frame(movie_prediction_weighthres)

eval_roc_Spearman_weighthres <- evaluation_roc(4, as.matrix(movie_prediction_weighthres), as.matrix(movietest))
eval_roc_Spearman_weighthres

eval_mae_Spearman_weighthres <- evaluation_mae(as.matrix(dataframe_movie_prediction_weighthres), as.matrix(numeric_movietest))
eval_mae_Spearman_weighthres

# neighbors of method combined



######### MSD
Movie_MSD_weights <- read.csv("C:/StudyLife/Columbia/STAT 5243/Local Project 4/Each Movie Case/MSD_train_movie.csv")

# neighbors of method bestn
Movie_MSD_neighbors <- find_neighbours(Movie_MSD_weights[,-1], method = "bestn" , n = 10)

movie_prediction_MSD <- prediction(data1[, -1], Movie_MSD_weights[, -1], Movie_MSD_neighbors)

dataframe_movie_MSD_prediction <- data.frame(movie_prediction_MSD)

eval_roc_MSD <- evaluation_roc(4, as.matrix(movie_prediction_MSD), as.matrix(movietest))
eval_roc_MSD

eval_mae_MSD <- evaluation_mae(as.matrix(dataframe_movie_MSD_prediction), as.matrix(numeric_movietest))
eval_mae_MSD
