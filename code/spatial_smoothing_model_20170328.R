## run some smoothing models
load("data/intermediate/lower49.RData")

install.packages("gstat")

library(gstat)

m1 <- variogram()
