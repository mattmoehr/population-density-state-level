## run some smoothing models
load("data/intermediate/lower49.RData")

#install.packages("automap")

library(sp)
library(gstat)
library(automap)
library(rgdal)

class(lower49_pop)
bubble(lower49_pop, "pop_n")

## make a grid for the kriging

lower49_grid <- makegrid(lower49_pop,
                         cellsize = 1
                         )

lower49_grid_pts <- SpatialPoints(coords = lower49_grid,
                                  proj4string = CRS(proj4string(lower49_pop))
                                  )
lower49_grid_pxs <- SpatialPixels(points = lower49_grid_pts,
                                  proj4string = CRS(proj4string(lower49_grid_pts))
                                  )

## TODO trim the grid to the outline of the US

plot(lower49_grid_pxs)
points(lower49_pop)



# project both the points and the grid

proj4string(lower49_pop)
proj4string(lower49_grid_pxs)

## use the EPSG:102005 USA_Contiguous_Equidistant_Conic projection
## http://gis.stackexchange.com/questions/141580/which-projection-is-best-for-mapping-the-contiguous-united-states
equidistant_conic <- CRS("+proj=eqdc +lat_0=39 +lon_0=-96 +lat_1=33 +lat_2=45 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs")

lower49_pop.proj <- spTransform(lower49_pop,
                                equidistant_conic
                                )

lower49_grid_pxs.proj <- spTransform(lower49_grid_pxs,
                                     equidistant_conic
                                     )

## KRIGE!

pop_auto_krige <- autoKrige(pop_n ~ 1,
                            lower49_pop.proj,
                            lower49_grid_pxs.proj,
                            verbose = TRUE
                            )

plot(pop_auto_krige)

