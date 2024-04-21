
#install.packages("googlesheets4")
#library(googlesheets4)
#library(googledrive)
#library(dplyr)
#library(kableExtra)

#gs4_auth()

sheet_id <- "https://docs.google.com/spreadsheets/d/1zSYy3F3d-KNO6YUYZh24ER64TG91MuoKnwonJP6lPjw/edit?usp=sharing"
sheet_name <- "Tema"


df <- read_sheet(ss = sheet_id, sheet = sheet_name)




# Substituir NA por strings vazias na Tabela

for (coluna in names(df)) {
  df[[coluna]][is.na(df[[coluna]])] <- ""
}





text <- kbl(df, longtable = T, booktabs = T,format = "latex") %>%
  kable_styling(latex_options = c("repeat_header")) %>%
  kableExtra::kable_styling(font_size = 13) 


remover <- as.character('\n\\end{longtable}\n\\endgroup{}')

texto_limpo <- gsub(remover, "",text,fixed="true")


remover <- '\\begingroup\\fontsize{13}{15}'
remover <- as.character(remover)

texto_limpo <- gsub(remover, "",texto_limpo,fixed="true")


remover <-'\\selectfont\n\n\\begin{longtable}[t]{lll}'
remover <- as.character(remover)
texto_limpo <- gsub(remover, "",texto_limpo,fixed="true")



remover <-'\\selectfont\n\n\\begin{longtable}[t]{lll}'
remover <- as.character(remover)
texto_limpo <- gsub(remover, "",texto_limpo,fixed="true")


remover <- as.character("\n\\toprule\nCódigo & Subcódigo & Descrição\\\\\n\\midrule\n\\endfirsthead\n\\multicolumn{3}{@{}l}{\\textit{(continued)}}\\\\\n\\toprule\nCódigo & Subcódigo & Descrição\\\\\n\\midrule\n\\endhead\n\n\\endfoot\n\\bottomrule\n\\endlastfoot\n")
texto_limpo <- gsub(remover, "",texto_limpo,fixed="true")


remover <- as.character("textbackslash{}")
texto_limpo <- gsub(remover, "",texto_limpo,fixed="true")

remover <- as.character("\\{")
texto_limpo <- gsub(remover, "{",texto_limpo,fixed="true")

remover <- as.character("\\_")
texto_limpo <- gsub(remover, "_",texto_limpo,fixed="true")

remover <- as.character("\\}")
texto_limpo <- gsub(remover, "}",texto_limpo,fixed="true")


# Gravar a string no clipboard
writeClipboard(texto_limpo)


# Criar uma string com 10 linhas em branco
linhas_em_branco <- paste(rep("\n", 40), collapse = "")

# Adicionar as 10 linhas em branco a uma string existente
texto_limpo <- paste(linhas_em_branco,texto_limpo)


cat(texto_limpo)
