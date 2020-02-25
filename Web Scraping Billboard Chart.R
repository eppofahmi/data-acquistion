library(tidyverse)
library(rvest)
library(xml2)


#Get URL
url <- "https://www.billboard.com/charts/billboard-200"
chart <- read_html(url)

body_nodes <- chart %>% 
  html_node("body") %>% 
  html_children()
body_nodes

body_nodes %>% 
  html_children()

#Get Rank
rank <- chart %>% 
  rvest::html_nodes('body') %>% 
  xml2::xml_find_all("//span[contains(@class, 'chart-element__rank__number')]") %>% 
  rvest::html_text()

#Get Artist Name
artist <- chart %>% 
  rvest::html_nodes('body') %>% 
  xml2::xml_find_all("//span[contains(@class, 'chart-element__information__artist')]") %>% 
  rvest::html_text()

#Get Song Tittle
title <- chart %>% 
  rvest::html_nodes('body') %>% 
  xml2::xml_find_all("//span[contains(@class, 'chart-element__information__song')]") %>% 
  rvest::html_text()

#Create Dataframe
chart_df <- data.frame(rank, artist, title)

