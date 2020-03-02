library(rvest)
library(tidyverse)

### Scraping Renanstore Rohmat

# url dasar
url_dasar <- "https://renanstore.co.id/category/sale/page/"
no_url <- paste0(seq(from = 2, to = 3), "/")
# Membuat data berisi links per halaman 
data_halaman <- data_frame(URLs = paste0(url_dasar, no_url))


# data halaman pertama
page1 <- read_html("https://renanstore.co.id/category/sale/")

# fungsi scrap
scrap_renan <- function(hal) {
  main <- data_frame(
    title = html_nodes(x = hal, css = ".smart_pdtitle a") %>%
      html_text(trim = TRUE),
    link = html_nodes(x = hal, css = ".smart_pdtitle a") %>%
      html_attr("href"),
    harga = html_nodes(x = hal, css = ".smart_dtprice") %>%
      html_text(trim = TRUE)
  )
}

hasil_pg1 <- scrap_renan(hal = page1)
#hasil_pg2 <- scrap_renan(hal = page2)
#hasil_pg3 <- scrap_renan(hal = page3)


# list kosong
datalist = list()


# looping halaman
for (i in seq_along(data_halaman$URLs)) {
  print(i)
  hal <- read_html(paste0(data_halaman$URLs[i])) 
  data_hasil1 <- scrap_renan(hal = hal)
  datalist[[i]] <- data_hasil1
}


# mengubah list menjadi data frame
hasil_pg23 <- data.table::rbindlist(datalist)

# binding dengan hasil_pg1
hasil_gabung <- rbind(hasil_pg1, hasil_pg23)
view(hasil_gabung)
