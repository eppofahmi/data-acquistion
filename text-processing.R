library(tidyverse)

# Load data
df1 <- read_csv("https://raw.githubusercontent.com/eppofahmi/data-acquistion/master/u-nurul%20q-%23situbondokab%20from%202019-01-01%20to%202019-12-31.csv")

# cek isi
glimpse(df1)

# menghilangkan kolom dengan isi == "None
library(reshape2)
df2 <- melt(df1, id.vars = "created_at")
df2 <- df2 %>% 
  filter(value != "None")
glimpse(df2)

# df3 <- melt(data = df1)
tes <- reshape(df2, idvar = "created_at", 
               timevar = "variable", 
               direction = "wide")

library(tidytext)
hasil_token<- tes %>% 
  select(value.full_text) %>% 
  unnest_tokens(output = "kata", value.full_text, 
                token ="ngrams", n = 1, 
                collapse = FALSE, 
                to_lower = TRUE) %>% 
  count(kata, sort = TRUE)

kamus <- c("di", "dan", "yang", "dalam")

hasil_token <- hasil_token %>% 
  filter(!kata %in% kamus)

hasil_token %>% 
  head(n = 10) %>% 
  ggplot(aes(x = kata, y = n)) + 
  geom_col() + 
  coord_flip()

# vis in wordcloud 
library(wordcloud)

hasil_token <- hasil_token %>% 
  head(n = 100)

set.seed(123)
wordcloud(words = hasil_token$kata, freq = hasil_token$n, min.freq = 15)
