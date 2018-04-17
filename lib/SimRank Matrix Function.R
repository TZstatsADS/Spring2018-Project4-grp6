setwd("C:/Users/Kevin Zhang/Documents/GitHub/Spring2018-Project4-grp6/data")
getwd()
MS.train.data <- read.csv("MS_data_train.csv",header=T)
MS.test.data <- read.csv("MS_data_test.csv",header=T)

# Substring the column name
substr.colname <- function(dataset){
  names <- colnames(dataset)
  for(i in 1:ncol(dataset)){
    names[i] <- substr(names[i], start = 2, stop = nchar(names[i]))
  }
  return(names)
}

# SimRank Function
generate.simrank.mat <- function(c = 0.8, k = 5, traindata = MS.train.data, 
                                 testdata = MS.test.data){
  MS.train.data = traindata
  MS.test.data = testdata
  
  # Pre process the train and test data
  rownames(MS.train.data) <- MS.train.data[,1]
  MS.train.data <- MS.train.data[,-1]  # variable name are exclude from the data area
  rownames(MS.test.data) <- MS.test.data[,1]
  MS.test.data <- MS.test.data[,-1]
  colnames(MS.train.data) <- substr.colname(MS.train.data)
  colnames(MS.test.data) <- substr.colname(MS.test.data)
  
  # Generate the bipartite graph
  bipartite.graph <- list()
  for(i in 1:nrow(MS.train.data)){
    bipartite.graph[[i]] <- colnames(MS.train.data)[which(MS.train.data[i,]==1)]
  }
  n <- length(bipartite.graph)
  t_MS.train.data <- as.data.frame(t(MS.train.data))
  for(i in 1:nrow(t_MS.train.data)){
    bipartite.graph[[n+i]] <- colnames(t_MS.train.data)[which(t_MS.train.data[i,]==1)]
  }
  tail(bipartite.graph)
  # Nodes name = user ID + vroots
  nodes.name <- as.numeric(c(rownames(MS.train.data),colnames(MS.train.data)))
  
  # Construction of Graph Matrix
  graph.matrix <- matrix(0,nrow = length(nodes.name),ncol = length(nodes.name))
  matrix1 <- matrix(0,nrow = nrow(MS.train.data),ncol = nrow(MS.train.data))
  matrix3 <- t(MS.train.data)
  matrix4 <- matrix(0,nrow = ncol(MS.train.data),ncol = ncol(MS.train.data))
  matrix5 <- cbind(matrix3,matrix4)
  graph.matrix <- cbind(matrix1,MS.train.data)
  colnames(graph.matrix) <- nodes.name
  colnames(matrix5) <- nodes.name
  graph.matrix <- rbind(graph.matrix,matrix5)
  dim(graph.matrix)
  
  # Column-normalized matrix
  colnum <- colSums(graph.matrix)
  for (i in 1:ncol(graph.matrix)){
    graph.matrix[,i] <- graph.matrix[,i]/colnum[i]
  }
  
  # Iteration Mtd of SimRank
  W <- as.matrix(graph.matrix)
  simrank.matrix.pre <- matrix(0, nrow = length(nodes.name), ncol = length(nodes.name))
  diag(simrank.matrix.pre) <- 1 
  simrank.matrix <- simrank.matrix.pre

  for(i in 1:k){
    simrank.matrix.pre <- simrank.matrix
    simrank.matrix <- c * (t(W) %*% simrank.matrix.pre %*% W)
    diag(simrank.matrix) <- 1
    print(i)
  }
  dim(simrank.matrix)
  
  # Extraction of User Part
  simrank.fin.matrix <- simrank.matrix[1:nrow(MS.train.data),1:nrow(MS.train.data)]
  dim(simrank.fin.matrix)
  
  return(simrank.fin.matrix)
}


simrank.fin.matrix <- generate.simrank.mat(c = 0.8, k = 5, traindata = MS.train.data, 
                                       testdata = MS.test.data)
write.csv(simrank.fin.matrix, file = "simrank.fin.matrix.csv")







