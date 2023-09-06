# The UserNetR package contains the example network "DHHS"
# UserNetR, which must be installed from Github rather than CRAN, as follow:
#library(remotes)
#remotes::install_github("DougLuke/UserNetR")
# Setup and example network
# Close R and reinstall Intergraph to start clean
#install.packages("intergraph")
#library(intergraph)
#library(UserNetR)

#install.packages("ggrepel")
#library(ggrepel)



# From network object to vertex and edge list
DHHS_list <- intergraph::asDF(rts.g)


edges <- as.data.frame(DHHS_list$edges)
vertexes <- as.data.frame(DHHS_list$vertexes)

DHHS2 <- intergraph::asNetwork(edges, vertices=vertexes, undirected=FALSE) 



# Set graphical parameters for plotting wider margins for a larger, better spaced layout
#op <- par(mar=rep(0,4))


# Include next line to divert output from the RStudio Viewer
# to a high-resolution pdf displayed in the default browser (not done here).
# Run the “g” graph object at the end as described in the network-on-a-map example.
# grDevices::pdf(g1 <- tempfile(fileext = ".pdf"), width = 40, height = 20)

#Cálculo do tamanho dos nós

# Create a scaling factor for node size based on degree centrality
# The multiplier may require adjustment for different data
# ignore.eval=TRUE means degree is not weighted by values in a column
# gmode="graph" means the network is undirected; if directed, use “digraph”
# cmode="freeman" means degree is based on total, not “indegree” or “outdegree” 
# degscale <- .4*sna::degree(DHHS2, ignore.eval=TRUE, gmode="digraph", cmode="freeman")
degscale <- page.rank(rts.g)$vector

# Cálculo do tamanho dos textos -> valores degree abaixo da média tem texto valor 0
last <- length(degscale)
corte <- mean(degscale)# + .3*sd(degscale)

degscale.label <- degscale

for (i in 1:last){
  if(degscale[i]>corte){degscale.label[i] <- 5}else{degscale.label[i]<-2}
}


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

# Execução do Gráfico

set.seed(123)

g<- ggraph(DHHS2, layout = l) + 
  labs(title = "#educaçãofinanceira") +
  geom_edge_parallel0(edge_colour = "#A8A8A8",
                      edge_width = 0.01, edge_alpha = 1, arrow = arrow(angle = 0, length = unit(0.1, "inches"), ends = "last", type = "closed")) + 
  
  geom_node_point(aes(fill = degscale, size = degscale),
                  colour = "#8b0000", shape = 21, stroke = 0.7) + 
  
  scale_fill_gradient(low = "white", high = "steelblue") +
  scale_size(range = c(0, 40)) + 
  
  geom_node_text(aes(label = name), colour = "#000000", size = degscale.label,#repel=TRUE,
                 family = "serif",fontface = "bold") +
  
  theme_graph(foreground = 'steelblue', fg_text_colour = 'white') + 
  theme(legend.position = "none")





# Reset margins for future plots
#par(op)
g



#####################################
# Gráfico 2

Page_Rank <- degscale

g <- ggraph(DHHS2,  layout = 'lgl') +
  geom_edge_arc(color="gray", curvature=0.3) +            
  geom_node_point(color="orange", aes(size = Page_Rank)) +     
  geom_node_text(aes(label = name), size=3, color="gray50", repel=T) +
  theme_void()


g


