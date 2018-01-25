library(sf)
library(tidyverse)
library(raster)

bulk_rasterization = function(var, vector, raster_template){
  new_filename = paste0("data/", var, ".tif")
  rasterize(vector, raster_template, field = var, filename = new_filename)
}

# vector data read --------------------------------------------------------
regular_grid_data = st_read("data/global_population_and_gdp.gpkg")

# raster template create --------------------------------------------------
raster_template = raster(extent(regular_grid_data), resolution = 0.5, crs = "+init=epsg:4326")

# rasterization -----------------------------------------------------------
colnames(regular_grid_data)[-c(1, 80)] %>% 
  bulk_rasterization(regular_grid_data, raster_template)

