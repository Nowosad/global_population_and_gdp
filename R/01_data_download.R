# file download -----------------------------------------------------------
# http://www.cger.nies.go.jp/gcp/population-and-gdp.html
# http://db.cger.nies.go.jp/dataset/gcp/population-and-gdp/Data_description.pdf
# gridded populations (unit: million)
# gridded GDPs (unit: PPP, Billion US$2005/yr)
dir.create("raw_data")

# download grid -----------------------------------------------------------
download.file("http://db.cger.nies.go.jp/dataset/gcp/population-and-gdp/grid.zip",
              destfile = "raw_data/grid.zip")

# download ssp1 -----------------------------------------------------------
download.file("http://db.cger.nies.go.jp/dataset/gcp/population-and-gdp/pop_ssp1.csv",
              destfile = "raw_data/pop_ssp1.csv")

download.file("http://db.cger.nies.go.jp/dataset/gcp/population-and-gdp/gdp_ssp1.csv",
              destfile = "raw_data/gdp_ssp1.csv")

# download ssp2 -----------------------------------------------------------
download.file("http://db.cger.nies.go.jp/dataset/gcp/population-and-gdp/pop_ssp2.csv",
              destfile = "raw_data/pop_ssp2.csv")

download.file("http://db.cger.nies.go.jp/dataset/gcp/population-and-gdp/gdp_ssp2.csv",
              destfile = "raw_data/gdp_ssp2.csv")

# download ssp3 -----------------------------------------------------------
download.file("http://db.cger.nies.go.jp/dataset/gcp/population-and-gdp/pop_ssp3.csv",
              destfile = "raw_data/pop_ssp3.csv")

download.file("http://db.cger.nies.go.jp/dataset/gcp/population-and-gdp/gdp_ssp3.csv",
              destfile = "raw_data/gdp_ssp3.csv")

# unzip grid --------------------------------------------------------------
unzip("raw_data/grid.zip", exdir = "raw_data")
