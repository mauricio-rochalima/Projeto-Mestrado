#Step 2 - Converter arquivos Jstor para csv

# Versão MAC

tweets <- bind_tweets("/Users/mauriciofernandes/Downloads/Redes Sociais", user = FALSE, verbose = TRUE, output_format = NA) 


users <- bind_tweets(data_path = "/Users/mauriciofernandes/Downloads/Redes Sociais", user = TRUE)


convert_json("/Users/mauriciofernandes/Downloads/Redes Sociais", output_format = "tidy")



# bind json files in the directory "data" into a "tidy" data frame / tibble 
tweets <- bind_tweets(data_path = "/Users/mauriciofernandes/Downloads/Redes Sociais", user = TRUE, output_format = "tidy")



write.csv(tweets,"/Users/mauriciofernandes/Downloads/Redes Sociais\\T2.csv", row.names = FALSE)



#################################

# Versão Windows 

path <- "C:\\Users\\Mauricio\\Downloads\\Redes Sociais"


tweets <- bind_tweets("C:\\Users\\Mauricio\\Downloads\\Redes Sociais", user = FALSE, verbose = TRUE, output_format = NA) 


users <- bind_tweets(data_path = "C:\\Users\\Mauricio\\Downloads\\Redes Sociais", user = TRUE)


convert_json("C:\\Users\\Mauricio\\Downloads\\Redes Sociais", output_format = "tidy")


tweets <- bind_tweets(data_path = "C:\\Users\\Mauricio\\Downloads\\Redes Sociais", user = TRUE, output_format = "tidy")


write.csv(tweets,"C:\\Users\\Mauricio\\Downloads\\Redes Sociais\\T2.csv", row.names = FALSE)


