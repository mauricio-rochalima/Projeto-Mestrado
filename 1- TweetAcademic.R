# Step 1

library(igraph)
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
library(smglr)
library(miniCRAN)
library(magrittr)
library(remotes)
library(intergraph)
library(UserNetR)
library(Cairo)
library(ggrepel)




setwd("/Users/mauriciofernandes/Documents/Projetos R/Twitter/Dados") 
getwd()
bearer_token <- 'AAAAAAAAAAAAAAAAAAAAAJpAXQEAAAAAyiF294zwWJZywErg7UT406nYIf8%3DHG1FfUrDgbeEi3yA3ow38LcgFALyETNWKKzMLaEcY3HdcdhdDw' 

set_bearer()
get_bearer()


tweets <- NULL
users <- NULL

#Apenas Educação Financeira

tweets <-
  get_all_tweets(
    query = c("educaçãofinanceira","finançaspessoais","#educaçãofinanceira","#educacaofinanceira"),
    exclude = c("lula","moro","jairbolsonaro","bolsonaro","política","carlosbolsonaro","eduardobolsonaro","esquerda","direita","Bolsonaro","curso"),
    #has_cashtags = TRUE,
    lang = 'pt',
    start_tweets = "2022-01-01T00:00:00Z",
    end_tweets = "2022-02-28T00:00:00Z",
    file = "blmtweets",
    data_path = "data/"
    ,n = 1000,
  )


tweets <- NULL
users <- NULL

e <- c("lula","moro","jairbolsonaro","bolsonaro","política","carlosbolsonaro","eduardobolsonaro","esquerda","direita","Bolsonaro","curso")

q <- c("mercadofinanceiro","bolsa","mercado","financeiro","banco","renda","valor","salario","fgts","juros","cartão","dinheiro","inflação","taxa","mei","selic","poupança","empréstimo","ação")

q <- c("educaçãofinanceira","finançaspessoais","#educaçãofinanceira","#educacaofinanceira","finanças pessoais","educação financeira")

q <- c("mercado financeiro","educaçãofinanceira","finançaspessoais","#educaçãofinanceira","#educacaofinanceira","finanças pessoais","educação financeira")



tweets <- NULL
users <- NULL

tweets <-
  get_all_tweets(
    query = q,
#   exact_phrase = q,
    exclude = e,
#   has_cashtags = FALSE,
    is_verified = TRUE,
    has_hashtags = TRUE,
    has_links = TRUE,
#   has_media = TRUE,
    lang = 'pt',
    start_tweets = "2021-01-01T00:00:00Z",
    end_tweets = "2022-04-02T00:00:00Z",
    file = "blmtweets",
    data_path = "data/"
    ,n = 4000
  )






#busca fintwits
tweets <-
  get_all_tweets(
    query = c("fintwit"),
    exclude = c("lula","moro","jairbolsonaro","bolsonaro","política","carlosbolsonaro","eduardobolsonaro","esquerda","direita","Bolsonaro","curso"),
    #has_cashtags = TRUE,
    lang = 'pt',
    start_tweets = "2022-01-01T00:00:00Z",
    end_tweets = "2022-02-12T00:00:00Z",
    file = "blmtweets",
    data_path = "data/"
    ,n = 8000,
  )






tweets_users <- get_all_tweets(
  users = c("MePoupenaweb"), 
  start_tweets = "2021-01-01T00:00:00Z", 
  end_tweets = "2022-04-18T00:00:00Z", 
  file = "blmtweets",
  data_path = "data/"
  ,n = 15000
)


