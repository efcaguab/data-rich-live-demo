# Prepare cards
library(vegan)
library(MASS)
library(ggplot2)
library(dplyr)

data("BCI")
data("Animals")

BCI <- BCI[1:25, 1:nrow(Animals)]
names(BCI) <- rownames(Animals)
BCI <- BCI %>% dplyr::mutate(site = 1:nrow(BCI))
BCI <- tidyr::gather(BCI, "animal", "present", -site) %>%
  dplyr::filter(present > 0) %>%
  dplyr::mutate(present = 1, 
                animal = if_else(grepl("elephant", animal), 
                                 true = "Elephant",
                                 false = animal), 
                animal = if_else(grepl("hamster", animal), 
                                 true = "Hamster",
                                 false = animal), 
                animal = if_else(grepl("beaver", animal), 
                                 true = "Beaver",
                                 false = animal), 
                animal = if_else(grepl("Rhesus", animal), 
                                 true = "Kiwi",
                                 false = animal),
                animal = if_else(grepl("Potar", animal), 
                                 true = "Jaguar",
                                 false = animal)) %>%
  dplyr::rowwise() %>%
  dplyr::mutate(order = runif(1)) %>%
  dplyr::arrange(site)

for(i in 1:4){
  ggplot(BCI[(64*(i-1)+1):(64*i), ]) +
    geom_text(aes(label = animal), x = 0.5, y = 0.65, size = 5) +
    geom_text(aes(label = paste("site:", site)), x = 0.5, y = 0.35, size = 4) +
    facet_wrap(~order, ncol = 8, nrow = 8) +
    theme_minimal()  + 
    theme(strip.background = element_blank(),
          strip.text.x = element_blank())
  
  ggsave(paste0("names_", i, ".pdf"), device = "pdf", width = 16.53, height = 11.69, units = "in")
}


  
  

