library(tmap)
library(raster)

p1 = stack(dir(path = "data", pattern = "p1_*", full.names = TRUE))
p1_years = gsub("p1_", "", names(p1))
p1_sum_pop = cellStats(p1, "sum")

tm1 = tm_shape(p1) +
  tm_raster(col = names(p1), style = "fixed", breaks = seq(0, 60, by = 5), 
            palette = tmaptools::get_brewer_pal("Spectral", n = 13),
            title = paste0("Year ", p1_years, "\n",
                           "Global population (mln): ", round(p1_sum_pop, 2), "\n",
                           "Population (mln):")) + 
  tm_facets(nrow = 1, ncol = 1)

animation_tmap(tm1)

tm2 = tm_shape(p1) +
  tm_raster(col = names(p1), style = "fixed", breaks = c(0:12, 60), 
            palette = tmaptools::get_brewer_pal("Spectral", n = 13),
            title = paste0("Year ", p1_years, "\n",
                           "Global population (mln): ", round(p1_sum_pop, 2), "\n",
                           "Population (mln):")) + 
  tm_facets(nrow = 1, ncol = 1)

animation_tmap(tm2, "animation2.gif")


hist(p1)
