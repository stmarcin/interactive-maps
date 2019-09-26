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
       (read_csv("Data/Ai_tmap.csv") %>% 
      mutate(K.FreeFlow = FreeFlow*1000) ),
      by.x = "TAZ_Madr_1", by.y = "Or") 

tm_shape(Free.Flow) +
   tm_polygons("FreeFlow",
               
               # popup definition
               popup.vars=c(
                  "Accessible_jobs: "="K.FreeFlow",
                  "Population: " = "POP2017"),
               id = "TAZ_Madrid",
               
               # transparency, number of classes and palette
               alpha = 0.6,
               n = 16,
               palette = hcl.colors(18, palette = "Inferno")[3:18],
               
               # border definition: color and transparency
               border.col = "#990099",
               border.alpha = 0.05, 
               
               # title of the legend
               title = "Accessible jobs<br>(thous.)"
   ) +
   
   # map title 
   tm_layout(title = "Accessibility to jobs<br>Model: Car free flow speeds")



tmap_last() %>% 
      tmap_save("Madrid_accessibility_map.html")
