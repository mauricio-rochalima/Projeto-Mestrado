# Step 4 - Exportando para o googlesheets
#install.packages("googlesheets4")
#library(googlesheets4)
#library(googledrive)


drive_auth()

ss <- "https://docs.google.com/spreadsheets/d/1QdUc9dMyGZYqakLvS4JoKMG4USslhPwJUNfH0mhITig/edit?usp=sharing"

tweets2 <- select(tweets,user_username,user_name,text,sourcetweet_text,retweet_count,user_followers_count,like_count,user_location,user_description,user_url,sourcetweet_type)



write_sheet(rts.df,ss= ss,sheet = "Matrix")


write_sheet(tweets2,ss= ss,sheet = "tweets")


write_sheet(w,ss= ss,sheet = "Metricas")




#Planilha para o caso de usuário específico
tweets3 <- select(tweets_users,text,created_at)
write_sheet(tweets3,ss= ss,sheet = "usuario_especifico")


# Windowns





