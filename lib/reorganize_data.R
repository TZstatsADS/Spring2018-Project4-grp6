setwd("C:/Users/Kevin Zhang/Documents/GitHub/Spring2018-Project4-grp6/data/data_sample/MS_sample")
MS.Data.Transform.Function <- function(data){
  usernum <- which(data$V1 == 'C')
  userid <- data$V2[usernum]
  vrootid <- unique(data$V2[which(data$V1 == 'V')])
  table <- matrix(0, nrow=length(userid), ncol=length(vrootid))
  rownames(table) <- as.character(userid)
  colnames(table) <- as.character(vrootid)
  for (i in 1:length(usernum)){
    start.indx <- usernum[i]
    if (i != length(usernum)){
      end.indx <- usernum[i+1]
    }
    else {
      end.indx <- nrow(data)+1
    }
    
    userid_mat <- as.character(userid[i])
    
    for (j in (start.indx+1):(end.indx-1)){
      vrootid_mat <- as.character(data$V2[j])
      table[userid_mat, vrootid_mat] <- 1
    }
  }
  return(table)
}
ms.train.data <- read.csv("data_train.csv",header = TRUE,as.is = FALSE)
ms.test.data <- read.csv("data_test.csv",header = TRUE,as.is = FALSE)
transformed.traindata <- MS.Data.Transform.Function(ms.train.data)
transformed.testdata <- MS.Data.Transform.Function(ms.test.data)
write.csv(transformed.traindata,file = "MS_data_train.csv")
write.csv(transformed.testdata,file = "MS_data_test.csv")
