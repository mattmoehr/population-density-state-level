## import data and run a quick model

install.packages("rjson")
## sudo apt-get install libgdal-dev
install.packages(c("maptools", "rgeos"))

library("rjson")
library("maptools")
gpclibPermit()

state_pop <- fromJSON(file = "data/raw/state_population.json")

state_pop_df <- data.frame( t( sapply(state_pop[2:53], c) ), stringsAsFactors = FALSE )
colnames(state_pop_df) <- c(state_pop[[1]])

state_pop_df$pop_n   = as.numeric(state_pop_df$POP)
state_pop_df$name    = do.call( rbind, strsplit(as.vector(state_pop_df$GEONAME), split = ",") )[,1]


median(state_pop_df$pop_n)


state_shp = readShapePoly("data/raw/natural-earth-110m-states-provinces/ne_110m_admin_1_states_provinces.shp")

plot(state_shp)

head(state_shp@data)

lower49_shp <- state_shp[!(state_shp@data$postal %in% c('AK', 'HI')), ]

plot(lower49_shp)

View(lower49_shp@data)


## TODO join the population to the shapefile

