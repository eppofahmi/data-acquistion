# Di dalam melakukan sceaping, kita juga harus waspada jika dalam suatu waktu ada nodes yang berbeda. 
# Misalnya, untuk sebuah halaman nodesnya a, tapi di halaman lain menjadi a1. Maka hal tersebut akan 
# memberikan error karena nodes yang dituju tidak ada. 

# Untuk mengatasi hal tersebut, maka kita bisa membuat langkah yg lebih panjang. Yaitu dengan 
# membuat fungsi di mana jika nodes yang di tuju tidak ada, maka akan mengembalikan nila NA.
# Dengan demikian, kita akan bisa melanjutkan pada nodes lain dan link/page yang lain tanpa terputus

## Membuat fungsi per nodes untuk judul
## Contoh fungsi berikut harusnya mengembalikan nilai NA, karena nodes "#title p" tidak ada dalam laman yang 
## yang akan diambil datanya

fun_judul <- function(pages) {
  judul = tryCatch(html_text(html_nodes(pages, "#title p"), trim = TRUE) %>%
                       paste(collapse = '---'), error=function(err) NA)
  
  if (judul >= 1) {
    judul
  } else {
    judul = NA
  }
}

## Membuat fungsi per nodes untuk konten
fun_konten <- function(pages) {
  konten = tryCatch(html_text(html_nodes(pages, "#post- li , p"), trim = TRUE) %>%
                     paste(collapse = ''), error=function(err) NA)
  
  if (konten >= 1) {
    konten
  } else {
    konten = NA
  }
}

## dua fungsi di atas bertujuan untuk mengambil judul dan konten. Dua fungsi diatas, selanjutnya dapat
## dimasukkan kedalam fungsi untuk mengambil dua data sekaligus (judul dan konten)

get_hasil <- function(url) {
  halaman <- read_html(url) 
  judul <- fun_judul(pages = halaman)
  konten <- fun_konten(pages = halaman)
  
  return(data.frame(judul, konten, stringsAsFactors = FALSE))
}

## Iterasi fungsi
hasil <- list()
for(i in seq_along(1:nrow(h1))) {
  print(i)
  url1 <- h1$link[i]
  tes <- get_hasil(url1)
  hasil[[i]] <- tes
}

## Hasil
hasil1 <- data.table::rbindlist(hasil)
colnames(tes2) <- c("judul", "konten")
