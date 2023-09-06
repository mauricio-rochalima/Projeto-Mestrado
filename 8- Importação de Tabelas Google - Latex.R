gs4_auth()

#install.packages("googlesheets4")
library(googlesheets4)
library(googledrive)
library(dplyr)
library(kableExtra)

sheet_id <- "https://docs.google.com/spreadsheets/d/1QdUc9dMyGZYqakLvS4JoKMG4USslhPwJUNfH0mhITig/edit?usp=sharing"
sheet_name <- "import"
df <- read_sheet(ss = sheet_id, sheet = sheet_name)


df<-select(df,user_username,user_name,user_followers_count,page_rank_2)


colnames(df) <- c("Usuário","Nome","Seguidores","PageRank")


df$Seguidores <- format(df$Seguidores, big.mark = ".")
df$PageRank <- format(df$PageRank, decimal.mark = ",")


# Formato Latex
kable(df, format = "latex", booktabs = T) %>%
  kableExtra::kable_styling(font_size = 7) 




# Latex com LongTable
kbl(df, longtable = T, booktabs = T, caption = "Seleção da amostra de Influenciadores Digitais",format = "latex") %>%
  kable_styling(latex_options = c("repeat_header")) %>%
  kableExtra::kable_styling(font_size = 11) 




# Formato HTML
df %>%
  kbl() %>%
  kable_paper("hover", full_width = F)




# Latex com LongTable
kbl(df, longtable = T, booktabs = T, caption = "Seleção da amostra de Influenciadores Digitais",format = "latex") %>%
  kable_styling(latex_options = c("repeat_header")) %>%
  kableExtra::kable_styling(font_size = 13) 








