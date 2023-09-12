set.seed(123)

# Suponha que você deseja mostrar apenas os nós da comunidade 1
#comunidade_desejada <- 1

set.seed(123)

# Suponha que você deseja mostrar apenas os nós da comunidade 1
comunidade_desejada <- 1

# Filtrar o conjunto de dados para incluir apenas os nós da comunidade desejada
g <- net.tidy %>%
  activate(nodes) %>%
  mutate(PageRank = centrality_pagerank()) %>%
  mutate(community = as.factor(group_infomap())) %>%
  filter(community != comunidade_desejada) %>%
  ggraph(l="fr")  +
  geom_edge_arc(alpha = 0.6, edge_width = 0.015, edge_colour = "#A8A8A8", arrow = arrow(angle = 0, length = unit(0.1, "inches"), ends = "last", type = "closed")) +
  ggraph::geom_edge_link(width = 1, colour = "lightgray") +
  ggraph::geom_node_point(aes(colour = community, size = .6*PageRank)) +
  geom_node_text(aes(label = label, size = 6), colour = "#000000", repel = TRUE,
                         family = "serif", fontface = "bold") +
  scale_size(range = c(0, 40)) + 
  
theme_graph(foreground = 'steelblue', fg_text_colour = 'white') + 
theme(legend.position = "none")

# Visualize o gráfico
g
