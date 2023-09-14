library("dplyr") #for data manipulation
library("igraph") # for social network analysis
library("ggraph") # 
library(googlesheets4)
library(googledrive)
library(readxl)


library(tidyverse)
library(ggraph)
library(tidygraph)
library(academictwitteR)
library(googlesheets4)
library(googledrive)
library(dplyr)
library(graphlayouts)
library(ggplot2)
library(snahelper)

library(miniCRAN)
library(magrittr)
library(remotes)
library(intergraph)

library(Cairo)
library(ggrepel)
###############################################################################################################

# Limpeza do Enviroment
rm(list = ls())



# ImportaÇão das Tabelas

#Caminho

c <- '/Users/mauriciofernandes/Dropbox/Projeto Mestrado/NodeXL/4- EducaçãoFinanceira/NodeXLGraph - EducFin.xlsx'

c <- 'C:/Users/Mauricio/Dropbox/Projeto Mestrado/NodeXL/4- #EducaçãoFinanceira/NodeXLGraph - EducFin.xlsx'
  
edges <- read_excel(c,sheet = "Edges", skip = 1)
vertices <- read_excel(c, sheet = "Vertices", skip = 1)




###############################################################################################################
# Excluir da tabela os tweets NodeXL

tweets <- edges
tweets <- filter(tweets,tweets$Relationship!="Tweet")

###############################################################################################################
# Criação da matriz com as arestas


tweets$label <- tolower(tweets$`Vertex 1`)

### Creating a data frame from the sender-receiver objects
rts.df <- tweets %>% select(`Vertex 1`,`Vertex 2`)

colnames(rts.df) <- c("rt.sender","rt.receiver")

###############################################################################################################

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

###############################################################################################################
# Criação do Grafo


net.tidy <- tbl_graph(
  nodes = nodes, edges = edges, directed = TRUE
)

###############################################################################################################

# Criação da Tabela com as centralidades


net.tidy <- net.tidy %>%
  activate(nodes) %>%
  mutate(PageRank = centrality_pagerank())
# %>%
#  mutate(Betweenness = centrality_betweenness()) %>%
#  mutate(Authority = centrality_authority()) %>%
#  mutate(In_Degree = centrality_degree(mode = "in"))


# Criação da Tabela com os Nós, métricas e informações das contas
net.tidy2 <- as.data.frame(net.tidy)


users0 <- select(vertices,Vertex,Name,Description,Followers)


colnames(users0) <- c("label","user_name","descrição","N.seguidores")

net.tidy2$label <- tolower(net.tidy2$label)

w <- unique(left_join(net.tidy2,users0,by="label"))

w <- w %>%
  select(label, user_name, descrição, PageRank, N.seguidores) %>%
  arrange(desc(PageRank))   %>%
#  mutate(N.seguidores = as.numeric(N.seguidores)) %>%
#  filter(N.seguidores > 1000)    %>%
  mutate(N.seguidores = format(N.seguidores, big.mark = ".")) 


colnames(w) <- c("User_Name","Usuário","Descrição","PageRank","N. Seguidores")



###############################################################################################################
# Exportação da tabela dos influenciadores

ss <- "https://docs.google.com/spreadsheets/d/1QdUc9dMyGZYqakLvS4JoKMG4USslhPwJUNfH0mhITig/edit?usp=sharing"

write_sheet(w,ss= ss,sheet = "Metricas")


###############################################################################################################
# Plot com Clusters


# Escolha layout
#l="nicely"
#l="sphere" #um dos melhores
#l="circlepack"
#l= "layout fruchterman reingold"
#l= layout.fruchterman.reingold(net.tidy)
l= "fr" #melhor opção
#l="kk"
#l="circle"
#l=layout_randomly(net.tidy)
#l="lgl"



set.seed(123)

g <- net.tidy %>%
  activate(nodes) %>%
  mutate(PageRank = centrality_pagerank()) %>%
  mutate(community = as.factor(group_infomap())) %>%
  ggraph(layout = l) +
  
  labs(title = "(educaçãofinanceira OR finançaspessoais OR #educaçãofinanceira OR #educacaofinanceira)
") +
  geom_edge_arc(alpha=.6,edge_width = 0.015,edge_colour = "#A8A8A8", arrow = arrow(angle = 0, length = unit(0.1, "inches"), ends = "last", type = "closed")) +
  
  geom_edge_link(width = 1, colour = "lightgray") +
  geom_node_point(aes(colour = community,size=3*PageRank)) +
  
  geom_node_text(aes(label = label,size=2*PageRank), colour = "#000000",repel=TRUE,
                 family = "serif",fontface = "bold") +
  scale_size(range = c(0, 15)) + 
  
  theme_graph(foreground = 'steelblue', fg_text_colour = 'white') + 
  theme(legend.position = "none") 

g


###############################################################################################################
# Exportar Gráfico 

# Defina o nome do arquivo de saída
#nome_do_arquivo <- "C:\\Users\\Mauricio\\Downloads\\Redes Sociais\\Gráficos\\teste.png"


#ggsave(plot = g, nome_do_arquivo,
#       width = 14, height = 8.5, dpi = 600, units = "in",type="cairo")









