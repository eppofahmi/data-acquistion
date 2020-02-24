# Mendapatkan data dari twitter

# Langkah 1: Loading package ----
library(twitteR)

# Langkah 2: Setup twitter token ----
# Jika belum punya bisa buat di: https://developer.twitter.com/en/apps/create
consumer_key <- "_isi_"
consumer_secret <- "_isi_"
access_token <- "_isi_"
access_secret <- "_isi_"

# Langkah 3: Menyimpan token ----
# Ketik 1 atau tes di console setelah menjalankan skrip di bawah ini
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

# Langkah 4: Ambil data tagar ----
# Ambil data dari twitter bisa menggunakan fungsi searchTwitter(), yang berisi parameter keywords, since until, dan lain-lain
# API Twitter basic hanya bisa mengembalikan data paling jauh 10 hari terakhir. 
# Skrip dibawah ini mengembalikan data dalam bentuk list
tw = twitteR::searchTwitter(searchString = '#chelsea + #arsenal', 
                            n = 100, 
                            since = '2020-02-21', 
                            until = '2020-02-24', 
                            resultType="recent", 
                            retryOnRateLimit = 1e3)

# Mengubah list data twitter dengan fungsi twListToDF untuk menjadikannya data frame
d = twitteR::twListToDF(tw)

# Langkah 5: Cek hasil ambil data ----
# objek d berisi 100 baris dan 16 kolom/variabel 
library(tidyverse)
glimpse(d)

# Langkah 6: Eskplorasi ----
# 1. Distribusi
d %>% 
  select(created) %>% 
  count(created) %>% 
  ggplot(aes(x = created, y = n, group = 1)) + 
  geom_line()

# 2. Jumlah respons 
response <- d %>% 
  select(retweetCount, favoriteCount, screenName)

# 3. Mengubah data menjadi model long data
library(reshape2)
response <- melt(response, id.vars = "screenName")
response %>% 
  group_by(variable) %>% 
  summarise(total = sum(value)) %>% 
  ggplot(aes(x = variable, y = total)) + 
  geom_col()

# Timeline user ----
userT <- userTimeline(c("@canggihpw"), n=100, maxID=NULL, 
                      sinceID=NULL, includeRts=FALSE, 
             excludeReplies=FALSE)
userT <- twitteR::twListToDF(userT)

# Lookup user user ----
tuser <- lookupUsers(d$screenName)
tuser <- twitteR::twListToDF(tuser)

# Penutup ----
# Menggunakan api memiliki beberapa keuntungan dan keterbatasan
# 1. Mudah digunakan dan cenderung lebih cepat
# 2. Memiliki banyak fungsi untuk memenuhi kebutuhan user
# 3. Dalam konteks twitter dan api yang disediakan oleh provider lainnya selalu memiliki batasan/limit. 