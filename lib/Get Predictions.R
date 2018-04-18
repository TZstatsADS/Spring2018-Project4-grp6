source("prediction.R")
source("find_neighbours.R")

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

TimeStart1 <- Sys.time()

Movie_neighbors <- find_neighbours(Movie_weights[,-1], method = "bestn" , n = 60)

movie_prediction <- prediction(data1[, -1], Movie_weights[, -1], Movie_neighbors)

TimeEnd1 <- Sys.time()

dataframe_movie_prediction <- data.frame(movie_prediction)

#eval_roc_Spearman <- evaluation_roc(4, as.matrix(dataframe_movie_prediction), as.matrix(movietest))
#eval_roc_Spearman

eval_mae_Spearman <- evaluation_mae(as.matrix(dataframe_movie_prediction), as.matrix(numeric_movietest))
eval_mae_Spearman

RunningTime1 <- TimeEnd1 - TimeStart1
RunningTime1

# neighbors of method weighthres
TimeStart2 <- Sys.time()

movie_neighbors_weighthres <- find_neighbours(Movie_weights[,-1], method = "weighthres" , threshold = 0.3)
  
movie_prediction_weighthres <- prediction(data1[, -1], Movie_weights[, -1], movie_neighbors_weighthres)

TimeEnd2 <- Sys.time()

dataframe_movie_prediction_weighthres <- data.frame(movie_prediction_weighthres)

#eval_roc_Spearman_weighthres <- evaluation_roc(4, as.matrix(movie_prediction_weighthres), as.matrix(movietest))
#eval_roc_Spearman_weighthres

eval_mae_Spearman_weighthres <- evaluation_mae(as.matrix(dataframe_movie_prediction_weighthres), as.matrix(numeric_movietest))
eval_mae_Spearman_weighthres

RunningTime2 <- TimeEnd2 - TimeStart2
RunningTime2

# neighbors of method combined

TimeStart3 <- Sys.time()

movie_neighbors_combined <- find_neighbours(Movie_weights[,-1], method = "combined" , threshold = 0.3, n = 60)

movie_prediction_combined <- prediction(data1[, -1], Movie_weights[, -1], movie_neighbors_combined)

TimeEnd3 <- Sys.time()

dataframe_movie_prediction_combined <- data.frame(movie_prediction_combined)

#eval_roc_Spearman_combined <- evaluation_roc(4, as.matrix(movie_prediction_combined), as.matrix(movietest))
#eval_roc_Spearman_combined

eval_mae_Spearman_combined <- evaluation_mae(as.matrix(dataframe_movie_prediction_combined), as.matrix(numeric_movietest))
eval_mae_Spearman_combined

RunningTime3 <- TimeEnd3 - TimeStart3
RunningTime3

######### MSD
Movie_MSD_weights <- read.csv("C:/StudyLife/Columbia/STAT 5243/Local Project 4/Each Movie Case/Movie_msd_weight.csv")

# neighbors of method bestn
TimeStart4 <- Sys.time()

Movie_MSD_neighbors <- find_neighbours(Movie_MSD_weights[,-1], method = "bestn" , n = 60)

movie_prediction_MSD <- prediction(data1[, -1], Movie_MSD_weights[, -1], Movie_MSD_neighbors)

TimeEnd4 <- Sys.time()

dataframe_movie_MSD_prediction <- data.frame(movie_prediction_MSD)

#eval_roc_MSD <- evaluation_roc(4, as.matrix(movie_prediction_MSD), as.matrix(movietest))
#eval_roc_MSD

eval_mae_MSD <- evaluation_mae(as.matrix(dataframe_movie_MSD_prediction), as.matrix(numeric_movietest))
eval_mae_MSD

RunningTime4 <- TimeEnd4 - TimeStart4
RunningTime4


# neighbors of method weighthres

TimeStart5 <- Sys.time()

movie_MSD_neighbors_weighthres <- find_neighbours(Movie_MSD_weights[,-1], method = "weighthres" , threshold = 0.3)

movie_prediction_MSD_weighthres <- prediction(data1[, -1], Movie_MSD_weights[, -1], movie_MSD_neighbors_weighthres)

TimeEnd5 <- Sys.time()

dataframe_movie_prediction_MSD_weighthres <- data.frame(movie_prediction_MSD_weighthres)

#eval_roc_MSD_weighthres <- evaluation_roc(4, as.matrix(movie_prediction_MSD_weighthres), as.matrix(movietest))
#eval_roc_MSD_weighthres

eval_mae_MSD_weighthres <- evaluation_mae(as.matrix(dataframe_movie_prediction_MSD_weighthres), as.matrix(numeric_movietest))
eval_mae_MSD_weighthres

RunningTime5 <- TimeEnd5 - TimeStart5
RunningTime5

# neighbors of method combined

TimeStart6 <- Sys.time()

movie_MSD_neighbors_combined <- find_neighbours(Movie_MSD_weights[,-1], method = "combined" , threshold = 0.3, n = 60)

movie_prediction_MSD_combined <- prediction(data1[, -1], Movie_MSD_weights[, -1], movie_MSD_neighbors_combined)

TimeEnd6 <- Sys.time()

dataframe_movie_prediction_MSD_combined <- data.frame(movie_prediction_MSD_combined)

#eval_roc_MSD_combined <- evaluation_roc(4, as.matrix(movie_prediction_MSD_combined), as.matrix(movietest))
#eval_roc_MSD_combined

eval_mae_MSD_combined <- evaluation_mae(as.matrix(dataframe_movie_prediction_MSD_combined), as.matrix(numeric_movietest))
eval_mae_MSD_combined

RunningTime6 <- TimeEnd6 - TimeStart6
RunningTime6

