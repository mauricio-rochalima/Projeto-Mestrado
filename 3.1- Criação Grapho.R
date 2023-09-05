#library("dplyr") #for data manipulation
#library("igraph") # for social network analysis


#filtrar apenas retweets e mencions

tweets <- filter(tweets,!is.na(sourcetweet_type))


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


### creating the retweetnetwork based on the sender-receiver df and the node attributes (troll/non-troll)
rts.g <- graph.data.frame(rts.df, directed=T);



### removing self-ties
rts.g <-simplify(rts.g, remove.loops = T, remove.multiple = F)

rts.g <-simplify(rts.g)



# Cálculo Page Rank

rts.g$pr <- rts.g %>%
  page.rank(directed = TRUE) %>%
  use_series("vector") %>%
  #  sort(decreasing = TRUE) %>%
  as.matrix




# Calcula o in-degree de cada nó
in_degree_vector <- degree(rts.g, mode = "in", v = V(rts.g)) 

# Adiciona o vetor de in-degree ao grafo como atributo
rts.g$in_d <- in_degree_vector

# Calcula a centralidade de intermediação (betweenness centrality)
betweenness_vector <- betweenness(rts.g, directed = TRUE)

# Adiciona o vetor de centralidade de intermediação ao grafo como atributo
rts.g$betweenness <- betweenness_vector




g<-data.frame(user_username=V(rts.g)$name,page_rank=rts.g$pr,in_deg=rts.g$in_d,betweenness=rts.g$betweenness)
t2 <- select(tweets,user_username,user_name,user_description,user_followers_count)


w<-right_join(g,t2,by="user_username")

w <- distinct(w)



#exporting the rts.g graph object as a graphml file 
write.graph(rts.g, file="rts.graphml", format="graphml")
write.csv(rts.df,"rts_df.csv", row.names = FALSE)

