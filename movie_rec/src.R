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