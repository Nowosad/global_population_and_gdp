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
  select(-(p2_1980:p2_2010), -(p3_1980:p3_2010)) %>% 
  select(-(g2_1980:g2_2010), -(g3_1980:g3_2010)) %>% 
  mutate(grid_id = st_intersects(., regular_grid) %>% flatten_int()) %>% 
  st_set_geometry(NULL)

# update names ------------------------------------------------------------
p1_estimation_names = c("p1_1980", "p1_1990", "p1_2000", "p1_2010")
colnames(raw_data_pos)[colnames(raw_data_pos) %in% p1_estimation_names] = c("p_1980", "p_1990", "p_2000", "p_2010")

g1_estimation_names = c("g1_1980", "g1_1990", "g1_2000", "g1_2010")
colnames(raw_data_pos)[colnames(raw_data_pos) %in% g1_estimation_names] = c("g_1980", "g_1990", "g_2000", "g_2010")

# calculate grouped vars --------------------------------------------------
raw_data_pos_vars = raw_data_pos %>% 
  group_by(grid_id) %>% 
  summarize_all(sum)

# add data to grid---------------------------------------------------------
regular_grid_data = regular_grid %>% 
  left_join(raw_data_pos_vars, by = "grid_id") %>% 
  na.omit()

# clean the data ----------------------------------------------------------
regular_grid_data = regular_grid_data %>% 
  select(starts_with("p_"), starts_with("g_"), 
         starts_with("p1_"), starts_with("g1_"),
         starts_with("p2_"), starts_with("g2_"),
         starts_with("p3_"), starts_with("g3_"))

# save new data -----------------------------------------------------------
dir.create("data")
st_write(regular_grid_data, "data/global_population_and_gdp.gpkg")
