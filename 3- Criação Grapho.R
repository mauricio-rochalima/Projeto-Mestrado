#library("dplyr") #for data manipulation
#library("igraph") # for social network analysis




# Classifica os tweets
classified_tweets <- tweets %>%
  mutate(tweet_category = case_when(
    grepl("^@\\w+", tweets$text) ~ "mention",        # Menção
    grepl("^RT @\\w+", tweets$text) ~ "retweet",     # Retweet
    grepl("^@\\w+", tweets$text) ~ "reply",          # Resposta
    TRUE ~ "tweet"                                  # Tweet
  ))


tweets <- filter(classified_tweets,tweet_category!="tweet")


##################################################

#selecting only the retweets
# rts <- grep("^rt @[a-z0-9_]{1,15}", tolower(tweets$text), perl=T, value=T)


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


sources <- rts.df %>% distinct(rt.sender) %>% rename(label=rt.sender)
destination <- rts.df %>% distinct(rt.receiver) %>% rename(label=rt.receiver)



nodes <- full_join(sources, destination,by="label") %>% mutate(id = 1:nrow(nodes)) %>% select(id,everything())

nodes <- full_join(sources, destination,by="label") %>% mutate(id = 1:nrow(nodes)) %>% select(id,everything())


edges <- rts.df %>% left_join(nodes, by=c("rt.sender" = "label")) %>% rename(from="id")
edges <- edges %>% left_join(nodes,by=c("rt.receiver" = "label")) %>% rename(to=id)


edges <- select(edges,from,to)


#############################################################################################

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

g<-data.frame(user_username=V(rts.g)$name,page_rank=rts.g$pr)
t2 <- select(tweets,user_username,user_name,user_description,user_followers_count)


w<-right_join(g,t2,by="user_username")

w <- distinct(w)



#exporting the rts.g graph object as a graphml file 
write.graph(rts.g, file="rts.graphml", format="graphml")
write.csv(rts.df,"rts_df.csv", row.names = FALSE)


#exporting Windowns
write.graph(rts.f, file="C:\\Users\\Mauricio\\Downloads\\Redes Sociais\\rts.graphml", format="graphml")
write.csv(rts.df,"C:\\Users\\Mauricio\\Downloads\\Redes Sociais\\rts_df.csv", row.names = FALSE)





