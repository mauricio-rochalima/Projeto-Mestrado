

sources <- rts.df %>% distinct(rt.sender) %>% rename(label=rt.sender)
destination <- rts.df %>% distinct(rt.receiver) %>% rename(label=rt.receiver)



nodes <- full_join(sources, destination,by="label") %>% mutate(id = 1:nrow(nodes)) %>% select(id,everything())

nodes <- full_join(sources, destination,by="label") %>% mutate(id = 1:nrow(nodes)) %>% select(id,everything())


edges <- rts.df %>% left_join(nodes, by=c("rt.sender" = "label")) %>% rename(from="id")
edges <- edges %>% left_join(nodes,by=c("rt.receiver" = "label")) %>% rename(to=id)


edges <- select(edges,from,to)


# Criação do Grafo

library(igraph)

net.igraph <- graph_from_data_frame(
  
  d = edges, vertices = nodes, directed = TRUE
  
)


set.seed(123)

plot(net.igraph,edge.arrow.size=.2,layout = layout_with_graphopt)

library(tidygraph)

net.tidy <- tbl_graph(
  nodes = nodes, edges = edges, directed = TRUE
)

plot(net.tidy)


library(ggraph)

# Versão MAC
write.graph(net.igraph, file="/Users/mauriciofernandes/Downloads/Redes Sociais/rts.graphml", format="graphml")




# Cálculo das centralidades






