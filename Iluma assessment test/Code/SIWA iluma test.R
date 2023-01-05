library(vegan)

# metadata_ws_2_
# otu_taxa_ws_2_
# Features_Table5


## Raw data and plotting
data(Features_Table5)
data(metadata_ws_2_)
# m <- betadiver(Features_Table)
# plot(m)
## The indices
#betadiver(help=TRUE)
## The basic Whittaker index
z <- betadiver(Features_Table5, "z")
SampleLocation <- with(metadata_ws_2_, betadisper(z, SampleLocation))
SampleLocation

plot(SampleLocation)

