# multipage 

# PERSIAPAN -----
# 1. install selector gedget di chrome
# 2. Install package rvest
# 3. Install package tidyverse

library(rvest)
library(tidyverse)

# eksplorasi perubahan link
url_1 <- "https://setkab.go.id/category/transkrip-pidato/page/1/"
url_2 <- "https://setkab.go.id/category/transkrip-pidato/page/2/"
url_3 <- "https://setkab.go.id/category/transkrip-pidato/page/3/"

# membuat link per halaman dengan cara url dasar + nomor 
url_dasar <- "https://setkab.go.id/category/transkrip-pidato/page/"
no_url <- paste0(seq_along(1:115), "/")

# Membuat data berisi links per halaman 
data_halaman <- data_frame(URLs = paste0(url_dasar, no_url))
data_halaman <- data_halaman[1:5, ]

# Pengambilan data awal
# data yang diambil adalah: Tanggal, Judul, Url, dan Headline
page <- read_html("https://setkab.go.id/category/transkrip-pidato/")

scrap_pidato <- function(page) {
  hasil_scrap <- data_frame(
    Tanggal = html_nodes(page, css = ".date") %>% 
      html_text(trim = TRUE),
    # Urls
    Urls = html_nodes(page, css = ".text a") %>% 
      html_attr("href"),
    # Judul
    Judul = html_nodes(page, css = ".text a") %>% 
      html_text(trim = TRUE),
    # Headline
    Headline = html_nodes(page, css = ".desc p") %>% 
      html_text(trim = TRUE)
  )
}

data_hasil <- scrap_pidato(page = page)

# Melakukan iterasi untuk taip halaman page/1/ dan seterusnya
# skrip berikut berfungsi untuk membuat lis. 
# seharusnya mendapatkan 5 list yang didalamnya terdapat data frame dengan isi seperti 
# objek data_hasil1
datalist = list()

for (i in seq_along(data_halaman$URLs)) {
  print(i)
  page <- read_html(paste0(data_halaman$URLs[i])) 
  data_hasil1 <- scrap_pidato(page = page)
  datalist[[i]] <- data_hasil1
}

# mengubah list menjadi data frame
hasil_pidato <- data.table::rbindlist(datalist)


#################################### TUGAS ##########################################
# LAKUKAN PENGABILAN KONTEN ISI PIDATO DENGAN CARA YANG SUDAH DIPELAJARI SEBELUMNYA #
#################################### TUGAS ##########################################
