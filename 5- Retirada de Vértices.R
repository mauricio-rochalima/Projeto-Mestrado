# importing handle names from the official list release in congress

# Captura de perfis a serem excluídos

#drive_auth()

ss <- "https://docs.google.com/spreadsheets/d/1QdUc9dMyGZYqakLvS4JoKMG4USslhPwJUNfH0mhITig/edit?usp=sharing"

# Leitura da Planilha ExcluirPerfis
trolls_official <- read_sheet(ss,sheet = "ExcluirPerfis")
#tweets <- tweets %>% rename(handle = user_username) #renaming handle name variable
handles <- select(tweets,user_username)
#names(handles) <- "user_username"
#handles <- rbind(trolls_official, handles)
#handles.u <- unique(handles) #removing duplicates

handles.u <- trolls_official
handles.u$troll <- "troll" #assigning all of these users a trolls

### matching trolls with the complete set of handle names in the retweet network

sender <- as.character(rts.df$rt.sender)
receiver <- as.character(rts.df$rt.receiver)
handle.all <-  unique(as.data.frame(c(sender,receiver))) 
names(handle.all) <- "user_username"
nodes <- right_join(handles.u, handle.all)
#nodes <- merge(handles.u, handle.all, all.y = TRUE)
nodes <- replace(nodes, is.na(nodes), "non-troll") 


rts.df <- data.frame(sender, receiver)

rts.g <- graph.data.frame(rts.df, directed=T, vertices = nodes)
rts.g <-simplify(rts.g)


### subsetting the graph by removing non-trolls
#selecting nodes to exclude
exclude <- V(rts.g)[troll == "troll"]
#excluding the nodes
rts.g <- delete_vertices(rts.g, exclude)


# Planilha Influencers


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







