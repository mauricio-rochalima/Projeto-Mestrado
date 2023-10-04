###############################################################################################################

# Limpeza do Enviroment
rm(list = ls())



# Importação da tabela com os caminhos das tabelas no Dropbox

sheet_id <- 'https://docs.google.com/spreadsheets/d/1_-O2K_nVAms9jln6WhpZ3Ew-Ej4VxbEZg4F4J6zi7K0/edit?usp=sharing'
Tabelas_caminhos <- read_sheet(ss = sheet_id, sheet = 'Export')


#############################################################################################################################

influencers <- data.frame()


# Criar um loop de i=1 a 17
for (i in 3:17) {
  # Extrair o caminho da planilha a partir da Tabela_caminhos
  ss <- toString(Tabelas_caminhos[i, 2])
  
  # Ler a planilha 'Influencers Selecionados'
  import <- read_sheet(ss = ss, sheet = 'Influencers Selecionados')
  
  # Adicionar os valores importados à tabela acumulada
  influencers <- rbind(influencers, import)
  
  # Imprima algo para indicar que a planilha foi importada com sucesso (opcional)
  cat("Planilha", i, "importada com sucesso.\n")
}


