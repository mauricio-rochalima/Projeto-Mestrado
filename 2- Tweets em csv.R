#Step 2 - Converter arquivos Jstor para csv

# Versão MAC

tweets <- bind_tweets("/Users/mauriciofernandes/Downloads/Redes Sociais", user = FALSE, verbose = TRUE, output_format = NA) 

# Versão Windows 

tweets <- bind_tweets("C:\\Users\\Mauricio\\Downloads\\Redes Sociais", user = FALSE, verbose = TRUE, output_format = NA) 



# Versão  MAC

users <- bind_tweets(data_path = "data/", user = TRUE)


# Versão  Window

users <- bind_tweets(data_path = "C:\\Users\\Mauricio\\Downloads\\Redes Sociais", user = TRUE)



# Versão  MAC
convert_json("/Users/mauriciofernandes/Downloads/Redes Sociais", output_format = "tidy")

# Versão  Window

convert_json("C:\\Users\\Mauricio\\Downloads\\Redes Sociais", output_format = "tidy")


# Versão  MAC

# bind json files in the directory "data" into a "tidy" data frame / tibble 
tweets <- bind_tweets(data_path = "data/", user = TRUE, output_format = "tidy")

# Versão  Window

tweets <- bind_tweets(data_path = "C:\\Users\\Mauricio\\Downloads\\Redes Sociais", user = TRUE, output_format = "tidy")

# Versão  MAC

write.csv(tweets,"/Users/mauriciofernandes/Downloads/Redes Sociais\\T2.csv", row.names = FALSE)


# Versão  Window

write.csv(tweets,"C:\\Users\\Mauricio\\Downloads\\Redes Sociais\\T2.csv", row.names = FALSE)

