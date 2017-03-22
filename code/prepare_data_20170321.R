## import data and run a quick model

install.packages("rjson")
library("rjson")

state_pop <- fromJSON(file = "data/raw/state_population.json")

state_pop_df <- data.frame( t( sapply(state_pop[2:53], c) ), stringsAsFactors = FALSE )
colnames(state_pop_df) <- c(state_pop[[1]])

state_pop_df$pop_n = as.numeric(state_pop_df$POP)

median(state_pop_df$pop_n)
