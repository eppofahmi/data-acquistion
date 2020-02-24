# Scrapping dengan R dan rvest

# Langkah 1: Loading package ----
library(tidyverse)
library(rvest)

# Langkah 2: Menentukan web tagert  ----
url_target <- "https://www.kdnuggets.com/"

# Langkah 3: Mengunduh halaman yang akan diambil datanya  ----
# Menggunakan fungsi read_html() dari xml2 yang juga udh dibawa oleh rvest
page <- xml2::read_html(url_target)

# Menentukan nodes/letak data yang akan dimabil dari web
# Contoh: ambil link dan judul most recent
# nodes <- html_nodes(x = page, css = "ul > li > a")

nodes <- html_nodes(x = page, css = "#content .latn ul a")

# Langkah 4: Mengekstark isi nodes  ----
# contoh 1: mengesktrak link/url
# fungsi yang digunakan html_attr("href")
nodes %>% 
  html_attr("href")

# Content 2: extract text
# fungsi yang digunakan html_text()
nodes %>% 
  html_text(trim = TRUE)

# Langkah 5: Menyatukan data yg bisa diambil ----
h1 <- data.frame(
  link = html_nodes(x = page, css = "#content .latn ul a") %>% 
    html_attr("href"),
  judul = html_nodes(x = page, css = "#content .latn ul a") %>% 
    html_text(), 
  stringsAsFactors = FALSE
  )

# Langkah 6: Membuatnya dalam sebuah fungsi ----
# Keuntungan: lebih fleksibel dan bisa menambahkan skenario jika nodes yang ingin diambil tidak ada datanya
# Contoh: Mengambil konten dari judul yang dan link yang sudah diambil 
# Skenario: mengunduh semua page html dari link yang terdapat dalam objek h1 
# menggunakan looping
# nodes konten: #post- li , p
# Langkah 1: Persiapan, tes konten
page2 <- read_html(h1$link[2])

judul <- html_nodes(page2, "#title") %>% 
  html_text(trim = TRUE) %>% 
  paste0(collapse = "")

konten <- html_nodes(page2, "#post- li , p") %>% 
  html_text(trim = TRUE) %>% 
  paste0(collapse = "")

# Dari persiapan diatas, sepertinya sudah sesuai semua, di mana judul dan konten sudah bisa terambil
# dan bisa dilihat pada objek judul dan konten di bagian environment
# saatnya untuk mengambil semua konten dan judul dari semua link pada objek h1

# Membuat fungsi untuk mengambil data 
get_hasil <- function(url) {
  pages <- read_html(url) 
  judul <- html_nodes(pages, "#title") %>% 
    html_text(trim = TRUE)
  konten <- html_nodes(pages, "#post- li , p") %>% 
    html_text(trim = TRUE) %>% 
    paste0(collapse = "")
  
  return(data.frame(judul, konten, stringsAsFactors = FALSE))
}

# tes fungsi
tes <- get_hasil(url = h1$link[10])

# Melakukan iterasi untuk masing-masing link di h1
hasil <- list()

# melakukan iterasi dari link ke 1 hingga link terakhir
for(i in seq_along(1:nrow(h1))) {
  print(i)
  url1 <- h1$link[i]
  tes <- get_hasil(url1)
  hasil[[i]] <- tes
}

# mengubah list menjadi data farme
tes2 <- data.table::rbindlist(hasil)
colnames(tes2) <- c("judul", "konten")

# menggabungkan hasil h1 dengan tes2 
tes3 <- left_join(tes2, h1, by = "judul")
