# Cluster Analysis of Indicative Votes on Brexit in the UK House of Commons
This repository contains:
 - Data collected from [The Houses of Parliament API](http://explore.data.parliament.uk)
 - A script for cleaning and merging the data on the 8 motions which were voted on, and performing a k-means cluster analysis on the resulting data frame
 - The results of the cluster analysis (where k=2)
 
The results of the analysis partition the MPs into two groups depending on how they voted in the indicative voting process on 27th March 2019.
Eight motions representing different brexit options were selected by speaker John Bercow and MPs were asked to record their preferences as either for or against, or they could abstain.  

The data contained in `vote_data.csv` contains the results of the indicative votes where a value of 1 indicates an 'aye' response, 0 a 'no' response, and `NA` an abstention.

The cluster analysis was performed with a variety of k-values and 2 clusters produced the clearest split with no overlap. The noes were given a value of -1, the ayes 1, and abstention 0 (to represent their distance from a particular motion) and the euclidean distance was used to position the centroids.