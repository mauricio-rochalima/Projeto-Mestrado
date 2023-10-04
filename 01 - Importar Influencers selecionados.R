###############################################################################################################

# Limpeza do Enviroment
rm(list = ls())



# Importação da tabela com os caminhos das tabelas no Dropbox

sheet_id <- 'https://docs.google.com/spreadsheets/d/1_-O2K_nVAms9jln6WhpZ3Ew-Ej4VxbEZg4F4J6zi7K0/edit?usp=sharing'
Tabelas_caminhos <- read_sheet(ss = sheet_id, sheet = 'Export')


#############################################################################################################################

influencers <- data.frame()


# Criar um loop de i=1 a 17
for (i in 1:17) {
  # Extrair o caminho da planilha a partir da Tabela_caminhos
  ss <- toString(Tabelas_caminhos[i, 2])
  
  # Ler a planilha 'Influencers Selecionados'
  import <- read_sheet(ss = ss, sheet = 'Influencers Selecionados')
  
  # Adicionar os valores importados à tabela acumulada
  influencers <- rbind(influencers, import)
  
  # Imprima algo para indicar que a planilha foi importada com sucesso (opcional)
  cat("Planilha", i, "importada com sucesso.\n")
}




#############################################################################################################################




acumulado <- influencers

# Suponha que 'acumulado' seja a tabela acumulada após a importação

# Remover pontos da coluna N. Seguidores e converter para numérico
acumulado$`N. Seguidores` <- as.numeric(gsub("\\.", "", acumulado$`N. Seguidores`))

# Ordenar a tabela pelo número de seguidores em ordem decrescente
acumulado <- acumulado[order(-acumulado$`N. Seguidores`), ]

# Remover linhas duplicadas com base na coluna User_Name
acumulado <- acumulado[!duplicated(acumulado$User_Name), ]

# Agora, 'acumulado' contém os valores únicos na coluna User_Name, mantendo o registro com o maior número de seguidores entre registros com nomes de usuário iguais


#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################



# Importando a tabela BD de todas as planilhas


BD <- data.frame()


# Criar um loop de i=1 a 17
for (i in 5:12) {
  # Extrair o caminho da planilha a partir da Tabela_caminhos
  ss <- toString(Tabelas_caminhos[i, 2])
  
  # Ler a planilha 'Influencers Selecionados'
  import <- read_sheet(ss = ss, sheet = 'BD')
  
  # Adicionar os valores importados à tabela acumulada
  BD <- rbind(BD, import)
  
  # Imprima algo para indicar que a planilha foi importada com sucesso (opcional)
  cat("Planilha", i, "importada com sucesso.\n")
}

#############################################################################################################################


# Suponha que 'acumulado' seja a tabela acumulada após a importação

# Remover pontos da coluna N. Seguidores e converter para numérico
BD$`N. Seguidores` <- as.numeric(gsub("\\.", "", BD$`N. Seguidores`))

# Ordenar a tabela pelo número de seguidores em ordem decrescente
BD <- BD[order(-BD$`N. Seguidores`), ]

# Remover linhas duplicadas com base na coluna User_Name
BD <- BD[!duplicated(BD$User_Name), ]

# Agora, 'acumulado' contém os valores únicos na coluna User_Name, mantendo o registro com o maior número de seguidores entre registros com nomes de usuário iguais



