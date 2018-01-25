library(sf)
library(tidyverse)

# create regular grid -----------------------------------------------------
regular_grid = st_make_grid(cellsize = c(0.5),
                       offset = c(-180, -59.5),
                       n = c(720, 287),
                       crs = st_crs(4326)) %>% 
  st_sf() %>% 
  mutate(grid_id = row_number())

# data merge --------------------------------------------------------------
raw_data = st_read("raw_data/grid.shp", stringsAsFactors = FALSE) %>% 
  left_join(read_csv("raw_data/pop_ssp1.csv"), by = c("gID", "px", "py", "ISO3")) %>% 
  left_join(read_csv("raw_data/gdp_ssp1.csv"), by = c("gID", "px", "py", "ISO3")) %>% 
  left_join(read_csv("raw_data/pop_ssp2.csv"), by = c("gID", "px", "py", "ISO3")) %>% 
  left_join(read_csv("raw_data/gdp_ssp2.csv"), by = c("gID", "px", "py", "ISO3")) %>% 
  left_join(read_csv("raw_data/pop_ssp3.csv"), by = c("gID", "px", "py", "ISO3")) %>% 
  left_join(read_csv("raw_data/gdp_ssp3.csv"), by = c("gID", "px", "py", "ISO3"))

# create points on surface ------------------------------------------------
raw_data_pos = st_point_on_surface(raw_data) %>% 
  select(-gID, -ISO3, -px, -py) %>% 
  mutate(grid_id = st_intersects(., regular_grid) %>% flatten_int())

# calculate grouped vars --------------------------------------------------
raw_data_pos_vars = raw_data_pos %>% 
  st_set_geometry(NULL) %>% 
  group_by(grid_id) %>% 
  summarize_all(sum)

# add data to grid---------------------------------------------------------
regular_grid_data = regular_grid %>% 
  left_join(raw_data_pos_vars, by = "grid_id") %>% 
  na.omit()

# save new data -----------------------------------------------------------
dir.create("data")
st_write(regular_grid_data, "data/global_population_and_gdp.gpkg")
