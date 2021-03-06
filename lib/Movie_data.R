movie_train<-read.csv(choose.files())
movie_test<-read.csv(choose.files())

Transformer <- function(data.set){
  columns.data <- sort(unique(data.set$Movie))
  rows.data <- sort(unique(data.set$User))
  Table_ <- matrix(NA,nrow = length(rows.data), ncol = length(columns.data))
  for(i in 1:length(columns.data)){
    col.name <- columns.data[i]
    index <- which(data.set$Movie == col.name)
    scores <- data.set[index,4] #Scores
    users <- data.set[index,3] #Users
    index2 <- which(rows.data %in% users)
    Table_[index2,i] = scores
    Table_[!index2,i] = NA
  }
  colnames(Table_) <- columns.data
  rownames(Table_) <- rows.data
  return(Table_)
}

m_train<-Transformer(movie_train)
m_test<-Transformer(movie_test)

## add the missing columns to test data
miss_index<-numeric(length(train.index))
for(i in 1:length(train.index)){
  miss_index[i]<-train.index[i]%in%test.index
}
m_index<-which(miss_index == 0)
train.index[m_index]
m_matrix<-matrix(NA, ncol = 22, nrow = 5055)
colnames(m_matrix)<-m_index
m_test<-cbind(m_matrix, m_test)
m_test<-m_test[, order(as.numeric(colnames(m_test)))]


write.csv(m_train, "Movie_data_train.csv")
write.csv(m_test, "Movie_data_test.csv")
