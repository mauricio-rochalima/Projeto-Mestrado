library(dplyr)     # Para manipulação de dados
library(ggplot2)   # Para criar o gráfico
library(tidyr)     # Para dividir o texto em palavras
library(googlesheets4)
library(googledrive)
library(tidytext)  

tweets %>%
  mutate(data_publicacao = lubridate::as_date(created_at)) %>%
  ggplot() +
  geom_bar(aes(x=data_publicacao)) +
  theme_light() +
  labs(
    x=NULL,
    y="Número de tweets"
  )

seu_dataframe <- hashtags2


seu_dataframe <- seu_dataframe %>%
  mutate(palavras = strsplit(Hashtags, " "))

seu_dataframe <- seu_dataframe %>%
  unnest_tokens(palavra, palavras) %>%
  filter(palavra != "NA")


tabela_A %>%
  count(values, sort = TRUE) %>%
  head(15) %>%
  ggplot(aes(x = reorder(values, n), y = n)) +
  geom_bar(stat = "identity") +
  labs(x = "Palavra", y = "Frequência") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotação das etiquetas no eixo x para melhor legibilidade

tabela_frequencia <- tabela_A %>%
  count(values, sort = TRUE)


tabela_A <- stack(hashtags2)

tabela_A <- na.omit(tabela_A)

tabela_A$ind <- NULL

tabela_A %>% filter %>% tabelaA$values != ""

tabela_A <- tabela_A %>% filter(values!="")

#####################################################################################################################

# Exportação / Importação da Tabela com as # Hashtags

# Exportação

sheet_id <- "https://docs.google.com/spreadsheets/d/1QdUc9dMyGZYqakLvS4JoKMG4USslhPwJUNfH0mhITig/edit?usp=sharing"
sheet_name <- "Hashtags"


write_sheet(tabela_A,ss= sheet_id,sheet = sheet_name)






#####################################################################################################################
# Importação



library(googlesheets4)
library(googledrive)


sheet_id <- "https://docs.google.com/spreadsheets/d/1QdUc9dMyGZYqakLvS4JoKMG4USslhPwJUNfH0mhITig/edit?usp=sharing"
sheet_name <- "import"
df <- read_sheet(ss = sheet_id, sheet = sheet_name)







#####################################################################################################################

tabela_frequencia <- tabela_A %>%
  count(values, sort = TRUE) %>%
  head(20)


p <- ggplot(tabela_frequencia,aes(x= reorder(values,n),n)) + geom_bar(stat ="identity",fill="#457B9D",width = .6) +
  coord_flip() +
  geom_text(size = 4, mapping = aes(label = n),hjust=-.2) +
  theme_minimal(base_size = 20) 

p <- p + theme(
  # axis.text.x=element_blank(),  #remove y axis labels
  axis.ticks.x=element_blank()  #remove y axis ticks
)


p <- p + ylab("") + xlab("")
p <- p + ggtitle("20 # hashtags mais frequentes")

p <- p + theme(panel.grid = element_blank())

#p <- p + expand_limits(y=c(0, 350))

# q <- p + theme(panel.grid = element_blank())


p <- p + theme_classic()

p <-  p + theme(axis.text.y = element_text(size = 12))

p <-  p + theme(axis.text.y = element_text(face = "italic"))

p <-  p  + scale_y_continuous(breaks = NULL) + 
  theme(plot.title = element_text(size = 25, hjust = 0.5, margin = margin(b = 20)))  # Aumentar a distância entre o título e o gráfico


p <- p + scale_x_discrete(labels = function(x) paste0("#", x))  

p















