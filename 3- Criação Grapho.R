#library("dplyr") #for data manipulation
#library("igraph") # for social network analysis



###############################################################################################################

# Filtrar tweets com determinadas palavras-chave

tweets <- Ttweets

dados_filtrados <- tweets %>%
  filter(grepl("financeiro", text, ignore.case = TRUE))

#Ttweets <- tweets

tweets <- dados_filtrados

#tweets <- Ttweets

###############################################################################################################

# Exclusão de Perfis

tweets <- tweets %>% 
  filter((label != "zehdeabreu"))





###################################################
# Separação das contas com menos de 1k seguidores (Em teste)

Contas_excluidas <- users0 %>%
  filter(N.seguidores < 1000) %>%
  select(label, N.seguidores)

colnames(users0)


tweets <- tweets %>%
  anti_join(Contas_excluidas, by = "label")

#######################################################













tweets0 <- tweets


# Classifica os tweets
classified_tweets <- tweets %>%
  mutate(tweet_category = case_when(
    grepl("^@\\w+", tweets$text) ~ "mention",        # Menção
    grepl("^RT @\\w+", tweets$text) ~ "retweet",     # Retweet
    grepl("^@\\w+", tweets$text) ~ "reply",          # Resposta
    TRUE ~ "tweet"                                  # Tweet
  ))

# Excluir da tabela os tweets

tweets <- filter(classified_tweets,tweet_category!="tweet")

tweets$label <- tolower(tweets$user_username)

##################################################

#selecting only the retweets
rts <- grep("^rt @[a-z0-9_]{1,15}", tolower(tweets$text), perl=T, value=T)


# extracting handle names for the senders (those who retweet)
rt.sender <- tolower(as.character(tweets$user_username[grep("^rt @[a-z0-9_]{1,15}", tolower(tweets$text), perl=T)]))

# extracting handle names for the recievers (those who are being retweeted)
rt.receiver<- tolower(regmatches(rts, regexpr("@(?U).*:", rts)))
rt.receiver <- (gsub(":", "", rt.receiver)) #removing ":"
rt.receiver <- (gsub("@", "", rt.receiver)) #removing "@"

### Registering empty entries as missing
rt.sender[rt.sender==""] <- "<NA>"
rt.receiver[rt.receiver==""] <- "<NA>"



### Creating a data frame from the sender-receiver objects
rts.df <- data.frame(rt.sender, rt.receiver)

#############################################################################################
# Ajustes nas tabelas para a criação do Grafo

# Separar as contas que enviaram mensagem
sources <- rts.df %>% distinct(rt.sender) %>% rename(label=rt.sender)

# Separar as contas que receberam mensagem
destination <- rts.df %>% distinct(rt.receiver) %>% rename(label=rt.receiver)


# Criação da Tabela de Nós (Atores), incluindo chave primária para identificação dos nós
nodes <- full_join(sources, destination,by="label")
nodes <- full_join(sources, destination,by="label") %>% mutate(id = 1:nrow(nodes)) %>% select(id,everything())


# Criação da Tabela de Arestas
edges <- rts.df %>% left_join(nodes, by=c("rt.sender" = "label")) %>% rename(from="id")
edges <- edges %>% left_join(nodes,by=c("rt.receiver" = "label")) %>% rename(to=id)


edges <- select(edges,from,to)


#############################################################################################


# Criação do Grafo

library(igraph)

net.igraph <- graph_from_data_frame(
  
  d = edges, vertices = nodes, directed = TRUE
  
)



library(tidygraph)

net.tidy <- tbl_graph(
  nodes = nodes, edges = edges, directed = TRUE
)


# Exportação do Arquivo Graph


# Versão MAC
write.graph(net.igraph, file="/Users/mauriciofernandes/Downloads/Redes Sociais/rts.graphml", format="graphml")

# Versão Windowns
write.graph(net.igraph, file="C:\\Users\\Mauricio\\Downloads\\Redes Sociais\\rts.graphml", format="graphml")


#############################################################################################
# Plot 1

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

#############################################################################################

# Plot 2

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



#############################################################################################

# Criação da Tabela com as centralidades


net.tidy <- net.tidy %>%
  activate(nodes) %>%
  mutate(PageRank = centrality_pagerank()) %>%
  mutate(Betweenness = centrality_betweenness()) %>%
  mutate(Authority = centrality_authority()) %>%
  mutate(In_Degree = centrality_degree(mode = "in"))


# Criação da Tabela com os Nós, métricas e informações das contas
net.tidy2 <- as.data.frame(net.tidy)


# Separação das colunas de interesse da tabela users

users0 <- NULL
users0 <- users

users0$N.Seguidores <- users0$public_metrics$followers_count

users0 <- select(users0,username,name,description,N.Seguidores)
users0$username <- tolower(users0$username)


colnames(users0) <- c("label","user_name","descrição","N.seguidores")

# Unificação das Tabelas

net.tidy2$label <- tolower(net.tidy2$label)

w <- unique(left_join(net.tidy2,users0,by="label"))



#############################################################################################
# Plot 3

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



# Clusters

set.seed(123)

g <- net.tidy %>%
  activate(nodes) %>%
  mutate(PageRank = centrality_pagerank()) %>%
  mutate(community = as.factor(group_infomap())) %>%
  ggraph(layout = l) +
  
  labs(title = "financeiro") +
  geom_edge_arc(alpha=.6,edge_width = 0.01,edge_colour = "#A8A8A8", arrow = arrow(angle = 0, length = unit(0.1, "inches"), ends = "last", type = "closed")) +
  
  geom_edge_link(width = 1, colour = "lightgray") +
  geom_node_point(aes(colour = community,size=PageRank)) +
  
  geom_node_text(aes(label = label,size=.04), colour = "#000000",repel=TRUE,
                 family = "serif",fontface = "bold") +
  scale_size(range = c(0, 20)) + 
  
  theme_graph(foreground = 'steelblue', fg_text_colour = 'white') + 
  theme(legend.position = "none") 

g


#############################################################################################

# Exportar Gráfico 

# Defina o nome do arquivo de saída
nome_do_arquivo <- "C:\\Users\\Mauricio\\Downloads\\Redes Sociais\\financeiro.png"


ggsave(plot = g, nome_do_arquivo,
       width = 14, height = 8.5, dpi = 600, units = "in",type="cairo")






