# libraries
library(tidyverse)
library(ggridges)

# open csv and select columns
Acc <- read_csv("Data/Ai_tmap.csv", 
      col_types = list(
            "Or" = col_skip(),
            "POP2017" = col_skip() ) ) %>% 
      gather()

# rename and round values
Acc <- Acc %>% 
      
      # rename scenarios
      mutate(key = str_replace(key, "FreeFlow", "Car free flow speeds")) %>% 
      mutate(key = str_replace(key, "Car_Avg", "Car congested speeds")) %>% 
      mutate(key = str_replace(key, "FullFreq", "PT no waiting times")) %>% 
      mutate(key = str_replace(key, "PT_Avg", "PT average times")) %>% 
      
      # reorder factor levels
      mutate(key = fct_reorder(key, value)) %>% 
      
      # round number of jobs (thousands)
      mutate(value = round((value/10000), 0)*10)

# prepare a plot
 Acc %>% 
      ggplot( aes(y=key, x=value,  fill=key)) +
      geom_density_ridges(alpha=0.6, bandwidth=10) +
      see::scale_fill_metro(discrete=TRUE, reverse = TRUE) +
      see::scale_color_metro(discrete=TRUE, reverse = TRUE) +
      see::theme_modern() +
      theme(
            legend.position="none",
            panel.spacing = unit(0.1, "lines"),
            strip.text.x = element_text(size = 8)
            ) +
      xlab("Accessible jobs (thousands)") +
      ylab("distribution of accessibility values")

 # save a plot
ggsave("img/distribution_acc.png", dpi = "retina", 
      scale = 0.8)
