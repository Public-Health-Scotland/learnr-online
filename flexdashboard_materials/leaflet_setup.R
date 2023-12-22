## Information -----------------------------------

#' Name of file:    leaflet_setup.R
#' Author:          Ross Burns
#' Date:            September 2023
#' Written/run on:  Posit Workbench
#' R Version:       4.1.2

#' Credits:
#' -  Adam Rennie - Leaflet Training Scripts (https://phs-git.nhsnss.scot.nhs.uk/ATI/Mapping_with_leaflet.git)

## Description -----------------------------------

#' Setup code to create data visualisation maps of Council Authorities using the leaflet package.
#' Maps will be included in the components section of the flexdashboard tutorial.


## 1 - Setup -----------------------------------

#### Set environment variables to point to installations of geospatial libraries ----

## Amend 'LD_LIBRARY_PATH'

# Get the existing value of 'LD_LIBRARY_PATH'
old_ld_path <- Sys.getenv("LD_LIBRARY_PATH") 

# Append paths to GDAL and PROJ to 'LD_LIBRARY_PATH'
Sys.setenv(LD_LIBRARY_PATH = paste(old_ld_path,
                                   "/usr/gdal34/lib",
                                   "/usr/proj81/lib",
                                   sep = ":"))

rm(old_ld_path)

## Specify additional proj path in which pkg-config should look for .pc files

Sys.setenv("PKG_CONFIG_PATH" = "/usr/proj81/lib/pkgconfig")

## Specify the path to GDAL data

Sys.setenv("GDAL_DATA" = "/usr/gdal34/share/gdal")

## Ensure geospatial packages have been loaded

dyn.load("/usr/gdal34/lib/libgdal.so")
dyn.load("/usr/geos310/lib64/libgeos_c.so", local = FALSE)

#### Load Packages ----

library(leaflet)    # Create a map widget
library(sf)         # Read in geospatial data
library(htmltools)  # Edit HTML formatting for map features



## 2 - Population Lookup ---------------------

# Read in the population estimate lookup file to be used to calculate rates per 1,000 population for the map
pop_lookup <- readRDS('/conf/linkage/output/lookups/Unicode/Populations/Estimates/CA2019_pop_est_1981_2021.rds') %>%
  clean_names() %>%
  # filter for most recent years data
  filter(year == max(year)) %>% 
  # population is split by age and gender so it needs to be grouped by council area
  group_by(year, ca2019) %>%
  summarise(pop = sum(pop)) %>%
  ungroup() %>%
  select(-year) %>%
  # Rename column to match the shp file
  rename(code = "ca2019") 



## 3 - Import Data --------------------------

# Join CA codes and Population estimates to last week's Covid-19 cases,
# to calculate crude rate per 1,000 population to be shown on the map.
last_week_rates_ca <- last_week_totals_ca %>%
  left_join(ca_lookup, by = "ca_name") %>%
  left_join(pop_lookup, by = "code") %>%
  mutate(rate = 1000 * weekly_positive / pop) %>%
  select(-week)

## Load Council Area shapefile for map boundaries using sf::st_read()
# This shapefile has been simplified to improve performance within flexdashboard,
# but the original shapefile (and many others) can be found in the lookup folder area:
# "/conf/linkage/output/lookups/Unicode/Geography/Shapefiles/"
ca <- st_read(dsn = "flexdashboard_materials/data/council_area_2019_shapefile")

# Remove the unnecessary fields of data in the shp file
ca <- ca %>% select(code, geometry)

# Convert the shapefile to use latitude and longitude
ca <- st_transform(x = ca, crs = 4326)

# Attach data to the shape files
ca <- merge(ca, last_week_rates_ca, "code", duplicateGeoms = TRUE)



## 4 - Formatting ----------------------------

# Create colour palette for number of cases
pal <- colorNumeric(
  palette = colorRampPalette(c("yellow","red"))(length(ca$code)), 
  # set the minimum value to just above zero so that nil values or NA values stay grey
  domain = c(0.1:max(ca$weekly_positive+1)))

# 2nd palette for the 2nd indicator included in the map (rate per 1,000 population)
pal2 <- colorNumeric(
  palette = colorRampPalette(c("yellow","red"))(length(ca$code)), 
  domain = seq(min(ca$rate)-0.01, max(ca$rate)+0.01, 0.01))

# Create title to be displayed on Map
tag.map.title <- tags$style(HTML("
                                 .leaflet-control.map-title { 
                                 transform: translate(-50%,20%);
                                 position: fixed !important;
                                 left: 50%;
                                 text-align: center;
                                 padding-left: 10px; 
                                 padding-right: 10px; 
                                 background: rgba(255,255,255,0.75);
                                 font-size: 22px;
                                 }
                                 "))
title <- tags$div(
  tag.map.title, HTML(paste0("<b>Total COVID-19 Cases</b><br>", 
                             "<i>(Week Beginning ", format(last_week_start, "%d %b %Y"), ")</i>")))



## 5 - Create Map --------------------------------------

map <- leaflet() %>%
  
  # Specify map layer
  addMapPane("polygons", zIndex = 420) %>% 
  
  # Add background map 
  addProviderTiles(provider = providers$CartoDB.PositronNoLabels) %>%
  
  ## Add the shapes which will be filled according to the selected measure
  # Total Positive Cases:
  addPolygons(data = ca, stroke = T, weight = 2, color = "grey",
              fillOpacity = .9, fillColor = pal(ca$weekly_positive),
              popup = paste0("Local Authority: <b>", ca$ca_name,"<br/>",
                             "Positive Cases: ", format(ca$weekly_positive, big.mark = ","), "<br/>",
                             "Population: ", format(ca$pop, big.mark = ",")),
              options = leafletOptions(pane = "polygons"), group = "Total Cases") %>%
  
  # Rate per 1,000 Population:
  addPolygons(data = ca, stroke = T, weight = 2, color = "grey",
              fillOpacity = .9, fillColor = pal2(ca$rate),
              popup = paste0("Local Authority: <b>", ca$ca_name,"<br/>",
                             "Rate per 1,000 Population: ", format(ca$rate, big.mark = ","),"<br/>",
                             "Population: ", format(ca$pop, big.mark = ",")),
              options = leafletOptions(pane = "polygons"), group = "Rate per 1,000 Population") %>%
  
  # Add legends to show the range of the fill colour gradients
  addLegend("bottomright", pal = pal, values = ca$weekly_positive,
            title = "Total Cases",
            opacity = 1, bins = 5, group = "Total Cases") %>%
  
  addLegend("bottomright", pal = pal2, values = ca$rate,
            title = "Rate per 1,000<br>Population",
            opacity = 1, bins = 5, group = "Rate per 1,000 Population") %>%
  
  # Add toggle buttons switch between map layers
  addLayersControl(baseGroups = c("Total Cases", "Rate per 1,000 Population"),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  
  # Add HTML title to the map
  addControl(title, position = "topleft", className = "map-title")


