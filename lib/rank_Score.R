#### Rank Scoring for Data 1 (MS_data) #######
# Input: predicted matrix & test set matrix.
#        These matrices need to have user names in rownames (could do this in order to get row names)
rownames(train) <- train[,1]
train <- train[,-1]
rownames(test) <- test[,1]
test <- test[,-1]


#######################################

# Auxiliary function

rank_matrix <- function(pred_mat, MS_test){
  nrow <- nrow(MS_test)
  ncol <- ncol(MS_test)
  ranked_mat <- matrix(NA, nrow, ncol)
  
  for (r in 1:nrow){
    # get username of the row
    user_id = rownames(MS_test)[r] 
    
    # sort pred values
    sorted_pred <- sort(pred_mat[user_id,], decreasing=TRUE) 
    
    # sort test data values based on pred values.
    sorted_obs <- unlist( MS_test[user_id,][names(sorted_pred)] )
    
    # save the ranked row in the new matrix.
    ranked_mat[r,] <- unname(sorted_obs)
  }
  rownames(ranked_mat) <- rownames(MS_test)
  return(ranked_mat)
}


# Main function for ranking
ranked_scoring <- function(pred_mat, MS_test, alpha){
  
  ## Ranked scroing function
  ## Input: predicted matrix & test matrix.Also alpha value (alpha is taken as 5 as suggested in the paper).
  ##        These matrices need to have user id in rownames.
  ## Output: return the ranked score for the test set matrix
 
  
  # Rank the test matrix
  ranked_mat <- rank_matrix(pred_mat, MS_test)
  
  nrow <- nrow(ranked_mat)
  ncol <- ncol(ranked_mat)
  alpha_one <- alpha-1
  
  # We assume the neutral vote to be 0, i.e. d= 0  
  
  ranked_mat[ranked_mat<0] <- 0
  
  # denominator of r_a & r_a_max (ease of calculation!)
  denom_vec <- 2^(0:(ncol-1)/alpha_one)
  denom_mat <- matrix(rep(denom_vec, nrow), nrow, ncol, byrow=T)
  
  # vector of R_a
  utility_matrix <- ranked_mat/denom_mat
  R_a <- rowSums(utility_matrix)
  
  # Rank the test data for R_a max to get the maximum achievable utility.
  max_numerator_matrix <- t(apply(MS_test, 1, sort,decreasing=T))
  
 
  max_utility_matrix <- max_numerator_matrix/denom_mat
  max_R_a <- rowSums(max_utility_matrix)
  
  # R_a / R_a_max score
  R <- 100 * sum(R_a)/sum(max_R_a)
  
  return(R)
}



########### 2nd Option ########## Cleaner #########


ranked_scoring <- function(pred_test,MS_test){
  ## function to calculate rank score of predicted value
  ## input: pred_test - predicted value test data
  ##        test - test data 
  ## output: rank score

  d <- 0  #neutral vote
  r<-function(x){
    return(rank(x,ties.method="first"))
  }
  rank_pred <- ncol(pred_test)+1-t(apply(pred_test,1,r))
  rank_test <- ncol(MS_test)+1-t(apply(MS_test,1,r))
  vec = ifelse(test - d > 0, test - d, 0)
  R_a <- apply(1/(2^((rank_pred-1)/4)) * vec,1,sum)    #alpha is taken as 5 as in the paper. Can use 10 as well.
  R_a_max <- apply(1/(2^((rank_test-1)/4)) * vec,1,sum)
  
  R <- 100*sum(R_a)/sum(R_a_max)
  return(R)
}