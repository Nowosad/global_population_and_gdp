library(tmap)
library(tmaptools)
library(raster)

p1 = raster("data/p_2010.tif")
p1_sum_pop = cellStats(p1, "sum")

my_plot = tm_shape(p1) +
  tm_raster(col = names(p1), style = "kmeans", 
            palette = "PuRd", n = 10, contrast = c(0, 0.95) ,
            title = paste0("Year 2010\n",
                           "Global population (mln): ", round(p1_sum_pop, 2), "\n",
                           "Population (mln):")) + 
  tm_format_World()

save_tmap(my_plot, "figs/pop2010.png", width = 800, asp = 0, scale = 0.2)
