## import data and run a quick model

## on ubuntu 16.04 install packages:
## sudo apt-get install r-cran-rgl r-cran-tkrplot
## sudo apt-get install bwidget libgdal-dev libgdal1-dev libgeos-dev libgeos++-dev libgsl0-dev libproj-dev libspatialite-dev netcdf-bin

## in case there are any packages from R < 3.0.0
## update.packages(checkBuilt=TRUE, ask=FALSE)


# install.packages("broom")
# install.packages("dplyr")
# install.packages("rjson")
# install.packages("rgdal")
# install.packages("rgeos")
# install.packages("ggmap")

library("broom")
library("dplyr")
library("rjson")
library("rgdal")
library("rgeos")
#library("maptools")
library("ggmap")

## state population data
state_pop <- fromJSON(file = "data/raw/state_population.json")
state_pop_df <- data.frame( t( sapply(state_pop[2:53], c) ), stringsAsFactors = FALSE )
colnames(state_pop_df) <- c(state_pop[[1]])
state_pop_df$pop_n   = as.numeric(state_pop_df$POP)
state_pop_df$name    = do.call( rbind, strsplit(as.vector(state_pop_df$GEONAME), split = ",") )[,1]
state_pop_df$name
median(state_pop_df$pop_n)


## shape file for states
state_shp = readOGR("data/raw/natural-earth-110m-states-provinces/ne_110m_admin_1_states_provinces.shp")
plot(state_shp)
head(state_shp@data)
lower49_shp <- state_shp[!(state_shp@data$postal %in% c('AK', 'HI')), ]
lower49_shp@data$name_c = as.character(lower49_shp@data$name)
plot(lower49_shp)
colnames(lower49_shp@data)
lower49_shp@data$name_c


## make centroid point shapefile
lower49_cent <- gCentroid(lower49_shp, byid = TRUE)
plot(lower49_cent)
lower49_cent_sdf <- SpatialPointsDataFrame(lower49_cent, lower49_shp@data)
class(lower49_cent_sdf)
plot(lower49_cent_sdf)


## merge the population on to the spatial points
lower49_pop = merge(lower49_cent_sdf, state_pop_df, by.X = "name_c", by.Y = "name")
lower49_pop@data$id <- row.names(lower49_pop)

## use broom::tidy to make it a ggplot dataframe
lower49_tidy <- tidy(lower49_pop)
head(lower49_tidy)
colnames(lower49_pop@data)
cols_to_keep <- c("id", "pop_n", "postal", "region", "region_big", "x", "y")
head(lower49_tidy[, cols_to_keep])

lower49_tidy <- lower49_tidy[, cols_to_keep]

dev.off()

ggplot(data = lower49_tidy) +
  geom_point(
    aes(x = x, y = y, size = pop_n),
    color = "black"
    )

save(list =  c("lower49_tidy",
               "lower49_pop",
               "state_pop",
               "lower49_shp"
               ),
      file = "data/intermediate/lower49.RData"
      )
