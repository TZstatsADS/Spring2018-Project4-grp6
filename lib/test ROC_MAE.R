source("prediction.R")
source("find_neighbours.R")

MS_weights <- read.csv("C:/StudyLife/Columbia/STAT 5243/Local Project 4/Each Movie Case/MS_Spearman_weights.csv")

Movie_weights <- read.csv("C:/StudyLife/Columbia/STAT 5243/Local Project 4/Each Movie Case/Movie_Spearman_weights.csv")

MS_neighbors <- find_neighbours(Movie_weights, method = "combined" ,threshold = 0.01, n = 20)
MS_neighbors