library(sf)
library(tidyverse)
library(raster)
# devtools::install_github("ecohealthalliance/fasterize")
library(fasterize)

bulk_rasterization = function(var, vector, raster_template){
  new_filename = paste0("data/", var, ".tif")
  new_raster = fasterize(vector, raster_template, field = var, fun = "last")
  writeRaster(new_raster, filename = new_filename)
}

# vector data read --------------------------------------------------------
regular_grid_data = st_read("data/global_population_and_gdp.gpkg")

# raster template create --------------------------------------------------
my_raster_template = raster(extent(regular_grid_data), resolution = 0.5, crs = "+init=epsg:4326")

# rasterization -----------------------------------------------------------
colnames(regular_grid_data)[-c(1, 80)] %>% 
  map(bulk_rasterization, regular_grid_data, my_raster_template)
