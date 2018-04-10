### This is the R file to calculate the similarity of weights using Mean-squared error


#######################################
# Mean Squared Difference
#######################################

# Reduced the computational time significantly by assigning arguments outside 
# the loops, initiating the output matrix r with NA first, and using apply 
# to mean() outside the loops.

m_train<-as.matrix(m_train)

mean_sq_diff <- function(matrix){
  
  matrix[is.na(matrix)] = 0
  usermean = apply(matrix,1,mean)
  
  ncolrow = nrow(matrix)
  w <- matrix(rep(NA), ncolrow, ncolrow)
  rownames(w) = rownames(matrix)
  colnames(w) = rownames(matrix)
  
  for (r in 1:ncolrow){
    for (c in 1:ncolrow){
      if (r<c){
        w[r,c] <- (usermean[r]-usermean[c])^2
      }
      else if(r==c){
        w[r,c] <- 0
      }
      else {
        w[c,r]<-w[r,c]
      }
    }
  }
}

