library(recommenderlab)
library(ggplot2)
library(data.table)
library(reshape2)

movie_data <- read.csv("IMDB-Dataset/movies.csv", stringsAsFactors = FALSE)
rating_data <- read.csv("IMDB-Dataset/ratings.csv")

#summary(movie_data)
#head(movie_data)

#summary(ratings.csv)
#head(ratings.csv)

#preprocess data
movie_genre <- as.data.frame(movie_data$genres, stringsAsFactors = FALSE)
movie_genre2 <- as.data.frame(tstrsplit(movie_genre[,1], '[|]', type.convert = TRUE),
                              stringsAsFactors = FALSE)

colnames(movie_genre2) <- c(1:10)

genre_list <- c("Action", "Adventure", "Animation", "Children", 
                "Comedy", "Crime","Documentary", "Drama", "Fantasy",
                "Film-Noir", "Horror", "Musical", "Mystery","Romance",
                "Sci-Fi", "Thriller", "War", "Western")

genre_matrix <- matrix(0, 10330, 18)
genre_matrix[1,] <- genre_list
colnames(genre_matrix) <- genre_list

for(i in 1:nrow(movie_genre2)) {
  for(col in 1:ncol(movie_genre2)){
    genre_col = which(genre_matrix[1,] == movie_genre2[i, col])
    genre_matrix[i+1, genre_col] <- 1
  }
}

genre_matrix2 <- as.data.frame(genre_matrix[-1,], stringsAsFactors = FALSE)
for(col in 1:ncol(genre_matrix2)){
  genre_matrix2[,col] <- as.integer(genre_matrix2[,col])
}
#str(genre_matrix2)

SearchMatrix <- cbind(movie_data[,1:2], genre_matrix2[])
#head(SearchMatrix)

RatingMatrix <- dcast(rating_data,userId~movieId, value.var = "rating", na.rm = FALSE)
RatingMatrix <- as.matrix(RatingMatrix[,-1])
str(RatingMatrix)
summary(RatingMatrix)
any(is.na(RatingMatrix))
RatingMatrix <- as(RatingMatrix, "RealRatingMatrix")
class(RatingMatrix)

RecommendationModel <- recommenderRegistry$get_entries(dataType = "RealRatingMatrix")
names(RecommendationModel)
 
lapply(RecommendationModel, "[[", "description")
 
RecommendationModel$IBCF_RealRatingMatrix$parameters

#Exploring Similar Data
similarity_matrix <- similarity(RatingMatrix[1:4, ],
                                method = "cosine",
                                which = "users")

as.matrix(similarity_matrix)
image(as.matrix(similarity_matrix), main = "User's Similarities")

movie_similarity <- similarity(RatingMatrix[, 1:4],
                               method = "cosine",
                               which = "items")

as.matrix(movie_similarity)
image(as.matrix(movie_similarity), main = "Movies Similarity")

rating_values <- as.vector(RatingMatrix@data)
unique(rating_values)

TableOfRating <- table(rating_values)
#TableOfRating