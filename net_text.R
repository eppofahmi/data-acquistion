# net_text

net_dat<- tes %>% 
  select(value.full_text) %>% 
  unnest_tokens(output = "kata", value.full_text, 
                token ="ngrams", n = 2, 
                collapse = FALSE, 
                to_lower = TRUE) %>% 
  count(kata, sort = TRUE)

net_data <- net_dat %>% 
  separate(col = kata, into = c("sumber", "target"), sep = " ")
class(net_data)

library(igraph)
# mengubah df menjadi objek igraph/graph
graph_from_data_frame()

graph1 <- net_data %>% 
  head(n = 10) %>% 
  graph_from_data_frame(directed = FALSE)

plot(graph1)
