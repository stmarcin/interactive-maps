library(tmap)
library(dplyr)
library(readr)
library(rgdal)

# set the tmap "view" mode
tmap_mode("view")

# read spatial data & combine with csv file. This will be invisible layer only for Popup
Free.Flow <- merge(
      readOGR("Data/Madrid_TAZ.shp",
            layer = "Madrid_TAZ", GDAL1_integer64_policy = TRUE),
       read_csv("Data/Ai_tmap.csv"),
      by.x = "TAZ_Madr_1", by.y = "Or")

tm_shape(Free.Flow) +
      tm_polygons("FreeFlow", # column used for cartogram
            title = "Number of accessible jobs", # title of the legend
            alpha = 0.6, # transparency of thematic layer
            n = 16, # number of classes of cartogram
            border.col = "#990099", # color of border of transport zones
            border.alpha = 0.02, # transparency level of the border
            id = "TAZ_Madrid", # id which is diplayed in popup window
            legend.show = TRUE,
            palette = hcl.colors(18, palette = "Inferno", # color palette
                  alpha = NULL, rev = FALSE, fixup = TRUE)[3:18], # excluded the darkest colors
            popup.vars=c(
            "Accessible_jobs: "="FreeFlow",
                  "Population: " = "POP2017")
            ) +
      tm_layout(title = "Accessibility to jobs<br>Model: Car free flow speeds")

tmap_last() %>% 
      tmap_save("test2.html")
