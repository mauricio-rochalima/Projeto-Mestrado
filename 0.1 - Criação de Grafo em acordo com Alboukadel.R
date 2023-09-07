

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

# Versão Windowns
write.graph(net.igraph, file="C:\\Users\\Mauricio\\Downloads\\Redes Sociais\\rts.graphml", format="graphml")




# Cálculo das centralidades

set.seed(123)

nodes$PageRank <-
  net.tidy %>%
  activate(nodes) %>%
  mutate(PageRank = centrality_degree())


################################################################################


  
  net.tidy %>%
  activate(nodes) %>%
  mutate(PageRank = centrality_pagerank()) %>%
  ggraph(layout = "graphopt") +
  geom_edge_link(width = 1, colour = "lightgray") +
  geom_node_point(aes(size = PageRank, colour = PageRank)) +
  geom_node_text(aes(label = label,size = PageRank), repel = TRUE) +
  scale_color_gradient(low = "yellow", high = "red") +
  
  
  
  scale_fill_gradient(low = "white", high = "steelblue") +
  scale_size(range = c(0, 20)) + 
  theme_graph(foreground = 'steelblue', fg_text_colour = 'white') + 

  
  theme_graph()


##################################################################

net.tidy %>%
  activate(nodes) %>%
  mutate(PageRank = centrality_pagerank()) %>%


 ggraph(layout = l) + 
  labs(title = "#educaçãofinanceira") +
  geom_edge_arc(alpha=.6,edge_width = 0.01,edge_colour = "#A8A8A8", arrow = arrow(angle = 0, length = unit(0.1, "inches"), ends = "last", type = "closed")) +
  #geom_edge_parallel0(edge_colour = "#A8A8A8",
                  #    edge_width = 0.01, edge_alpha = 1, arrow = arrow(angle = 0, length = unit(0.1, "inches"), ends = "last", type = "closed")) + 
  
  
  geom_node_point(aes(fill = PageRank, size = PageRank),
                  colour = "#8b0000", shape = 21, stroke = 0.7) + 
  
 
  
  scale_fill_gradient(low = "white", high = "steelblue") +
  scale_size(range = c(0, 40)) + 
  
  geom_node_text(aes(label = label,size = PageRank), colour = "#000000",repel=TRUE,
                 family = "serif",fontface = "bold") +
  
  theme_graph(foreground = 'steelblue', fg_text_colour = 'white') + 
  theme(legend.position = "none")






# Escolha layout
#l="nicely"
#l="sphere" #um dos melhores
#l="circlepack"
#l= "layout fruchterman reingold"
#l= layout.fruchterman.reingold(rts.g)
#l= "fr" #melhor opção
#l="kk"
#l="circle"
#l=layout_randomly(rts.g)
#l="lgl"






net.tidy <- net.tidy %>%
  activate(nodes) %>%
  mutate(PageRank = centrality_pagerank()) %>%
  mutate(Betweenness = centrality_betweenness()) %>%
  mutate(Authority = centrality_authority()) %>%
  mutate(In_Degree = centrality_degree(mode = "in"))


net.tidy2 <- as.data.frame(net.tidy)

#########################################################################################


# Clusters

set.seed(123)

net.tidy %>%
  activate(nodes) %>%
  mutate(PageRank = centrality_pagerank()) %>%
    mutate(community = as.factor(group_infomap())) %>%
  ggraph(layout = l) +
  
  labs(title = "#educaçãofinanceira") +
  geom_edge_arc(alpha=.6,edge_width = 0.01,edge_colour = "#A8A8A8", arrow = arrow(angle = 0, length = unit(0.1, "inches"), ends = "last", type = "closed")) +
  
  geom_edge_link(width = 1, colour = "lightgray") +
  geom_node_point(aes(colour = community,size=PageRank)) +
  
  geom_node_text(aes(label = label,size=.3*PageRank), colour = "#000000",repel=FALSE,
                 family = "serif",fontface = "bold") +
  scale_size(range = c(0, 40)) + 
  
  theme_graph(foreground = 'steelblue', fg_text_colour = 'white') + 
  theme(legend.position = "none")
 















