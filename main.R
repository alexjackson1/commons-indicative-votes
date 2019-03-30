# Libraries ========================================================================================
library(jsonlite, dplyr, ggplot2, "factoextra")

# Parameters =======================================================================================
motions = c('B', 'D', 'H', 'J', 'K', 'L', 'M', 'O')
file_ids = c(
  '1105521',
  '1105524',
  '1105526',
  '1105527',
  '1105529',
  '1105530',
  '1105532',
  '1105533'
)
schema = c(
  'http://data.parliament.uk/schema/parl#AyeVote',
  'http://data.parliament.uk/schema/parl#NoVote'
)
set.seed(1580444)
# Read Data ========================================================================================
data_list = list()

## Loop through motions and data files to create a data frame of how mps voted
for (i in 1:length(file_ids)) {
  # Read in data from file
  data <-
    jsonlite::read_json(paste0(file_ids[i], '.json'), flatten = TRUE)
  
  # Extract the votes into a dataframe
  votes <- data$result$primaryTopic$vote
  votes.df <-
    data.frame(matrix(unlist(votes), nrow = length(votes), byrow = TRUE),
               stringsAsFactors = FALSE)
  
  # Filter only useful information and rename
  votes.df <- votes.df[, c('X4', 'X5', 'X6')]
  names(votes.df) <- c('party', 'mp', motions[i])
  
  # Convert votes into binary variable
  votes.df[, motions[i]][votes.df[motions[i]] == schema[1]] <- 1
  votes.df[, motions[i]][votes.df[motions[i]] == schema[2]] <- 0
  
  # Add to list
  data_list[[i]] <- votes.df
}

# Merge data from amendments into single data frame
vote_data <-
  Reduce(function(d1, d2)
    merge(
      d1,
      d2,
      by = c("party", "mp"),
      all.x = TRUE,
      all.y = TRUE
    ),
    data_list)

# Clean workspace
rm('data',
   'data_list',
   'votes',
   'votes.df',
   'i',
   'schema',
   'file_ids')

# Set NA values as 0, and the noes as -1 for clustering
vote_data_cluster <- vote_data[, motions]
for (motion in motions) {
  vote_data_cluster[!is.na(vote_data_cluster[, motion]) &
                      vote_data_cluster[, motion] == 0, motion] <- -1
  vote_data_cluster[is.na(vote_data_cluster[, motion]), motion] <- 0
}
vote_data_cluster <- data.matrix(vote_data_cluster)

cluster_analysis <-
  kmeans(vote_data_cluster, centers = 2, nstart = 25)
fviz_cluster(cluster_analysis, data = vote_data_cluster)
