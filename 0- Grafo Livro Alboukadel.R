if(!require(devtools)) install.packages("devtools")
devtools::install_github("kassambara/navdata")

library(navdata)
data("phone.call")

#Crianção das tabelas de nós e de arestas

sources <- phone.call %>% distinct(source) %>% rename(label=source)

destination <- phone.call %>% distinct(destination) %>% rename(label=destination)

nodes <- full_join(sources, destination,by="label") %>% mutate(id = 1:nrow(nodes)) %>% select(id,everything())

phone.call <- phone.call %>% rename(weight = n.call)

edges <- phone.call %>% left_join(nodes, by=c("source" = "label")) %>% rename(from="id")

edges <- edges %>% left_join(nodes,by=c("destination" = "label")) %>% rename(to=id)

edges <- select(edges,from,to,weight)


# Criação do Grafo

library(igraph)

net.igraph <- graph_from_data_frame(
  
  d = edges, vertices = nodes, directed = TRUE
  
)


set.seed(123)

plot(net.igraph,edge.arrow.size=.2,layout = layout_with_graphopt)




