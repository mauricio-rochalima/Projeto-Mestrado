library(dplyr)     # Para manipulação de dados
library(ggplot2)   # Para criar o gráfico
library(tidyr)     # Para dividir o texto em palavras
library(googlesheets4)
library(googledrive)
library(tidytext)  



tabela_A <- tweets %>%
  select(`Hashtags in Tweet`) %>%
  rename(Hashtags = `Hashtags in Tweet`)



tabela_A <- tabela_A %>%
  mutate(palavras = strsplit(Hashtags, " ")) %>%
  unnest(palavras)


tabela_A <- tabela_A %>%
  unnest_tokens(palavra, palavras) %>%
  filter(palavra != "NA")


tabela_frequencia <- tabela_A %>%
  count(palavra, sort = TRUE) %>%
  head(40)

#####################################################################################################################


# Exportação / Importação da Tabela com as # Hashtags

# Exportação

sheet_id <- "https://docs.google.com/spreadsheets/d/1QdUc9dMyGZYqakLvS4JoKMG4USslhPwJUNfH0mhITig/edit?usp=sharing"
sheet_name <- "Hashtags"


write_sheet(tabela_frequencia,ss= sheet_id,sheet = sheet_name)






#####################################################################################################################
# Importação


tabela_frequencia <- read_sheet(ss = sheet_id, sheet = sheet_name)


#####################################################################################################################


p <- ggplot(tabela_frequencia,aes(x= reorder(palavra,n),n)) + geom_bar(stat ="identity",fill="#457B9D",width = .6) +
  coord_flip() +
  geom_text(size = 4, mapping = aes(label = n),hjust=-.2) +
  theme_minimal(base_size = 20) 

p <- p + theme(
  # axis.text.x=element_blank(),  #remove y axis labels
  axis.ticks.x=element_blank()  #remove y axis ticks
)


p <- p + ylab("") + xlab("")
p <- p + ggtitle("# co-hashtags mais frequentes")

p <- p + theme(panel.grid = element_blank())

#p <- p + expand_limits(y=c(0, 350))

# q <- p + theme(panel.grid = element_blank())


p <- p + theme_classic()

p <-  p + theme(axis.text.y = element_text(size = 12))

p <-  p + theme(axis.text.y = element_text(face = "italic"))

p <-  p  + scale_y_continuous(breaks = NULL) + 
  theme(plot.title = element_text(size = 22, hjust = 0.5, margin = margin(b = 20)))  # Aumentar a distância entre o título e o gráfico


p <- p + scale_x_discrete(labels = function(x) paste0("#", x))  

p


#####################################################################################################################
# Exportar Gráfico


# Defina o nome do arquivo de saída
nome_do_arquivo <- '/Users/mauriciofernandes/Dropbox/Projeto Mestrado/NodeXL/4- EducaçãoFinanceira/Freq_#s.pdf'


ggsave(plot = p, nome_do_arquivo,
       width = 14, height = 8.5, dpi = 600, units = "in")













