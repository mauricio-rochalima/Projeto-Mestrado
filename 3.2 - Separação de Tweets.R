library(dplyr)

# Classifica os tweets
classified_tweets <- tweets %>%
  mutate(tweet_category = case_when(
    grepl("^@\\w+", tweets$text) ~ "mention",        # Menção
    grepl("^RT @\\w+", tweets$text) ~ "retweet",     # Retweet
    grepl("^@\\w+", tweets$text) ~ "reply",          # Resposta
    TRUE ~ "tweet"                                  # Tweet
  ))


tweets <- filter(classified_tweets,tweet_category!="tweet")


# Exibe o resultado
print(classified_tweets)
