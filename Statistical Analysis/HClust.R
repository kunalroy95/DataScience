
# Load a dataset of U.S. States and Arrests.  Let's see 
# what kinds of patterns they contain
ds = USArrests
head(ds)

# Remove any missing values just to be safe
ds = na.omit(ds)

# Since some of these variables are much larger than others
# and the units are different, we will scale these to 
# make the data more uniform
ds = scale(ds)
head(ds)

# Now, let's take a look with MDS
d = dist(ds)

library(MASS)
fit = isoMDS(d)
fit$stress     # 7.9% ... not bad

plot(fit$points)  # Hmm ... some close points and some groupings
                  # but no clear set of clusters

# Hierarchical clustering 
cluster1 = hclust(d)

# Interesting, some of the first to merge into a two
# element cluster are
# 
#    Iowa & New Hampshire ... what do these have in common?
#    Illinois & New York
#    Indiana & Kansas
# 
# Is there anything we can draw from this?
plot(cluster1, cex = 0.6, hang = -1)

# How about going the other way?  For divisive, we have 
# to use another function
install.packages("cluster")
library(cluster)

# The diana function takes the data directly NOT the distance
# matrix
cluster2 = diana(ds)

plot(cluster2)  # This will give several plots ... watch the console!
                # Again we get Illinois & NewYork first

# The cutree method can cut at a given level and produce
# the actual clusters for plotting
plot(cluster1, cex = 0.6, hang = -1)
clusters = cutree(cluster1, k = 4)
head(clusters)

# Use these clusters to color the MDS
plot(fit$points, col=clusters) 

# To add this to our data we need to first convert "ds" 
# to a data.frame and then use the mutate function to add 
# the column
library(dplyr)
ds = mutate(as.data.frame(ds), cluster = clusters)
head(ds)
class(ds)
