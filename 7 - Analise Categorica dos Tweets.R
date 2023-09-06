chisqmatrix <- function(x) {
  names = colnames(x);  num = length(names)
  m = matrix(nrow=num,ncol=num,dimnames=list(names,names))
  for (i in 1:(num-1)) {
    for (j in (i+1):num) {
      m[i,j] = chisq.test(x[,i],x[,j],)$p.value
    }
  }
  return (m)
}

fisher <- function(x) {
  names = colnames(x);  num = length(names)
  m = matrix(nrow=num,ncol=num,dimnames=list(names,names))
  for (i in 1:(num-1)) {
    for (j in (i+1):num) {
      m[i,j] = fisher.test(x[,i],x[,j],)$p.value
    }
  }
  return (m)
}


mat = chisqmatrix(colunas_selecionadas[2:10])

BD2 <- BD[,-1]

colSums(BD2)

colunas_selecionadas2 <- BD2[, colSums(BD2) > 0]

colSums(colunas_selecionadas)


mat = chisqmatrix(colunas_selecionadas)

mat2 = fisher(colunas_selecionadas2)

write.csv(mat2, file = "mat2.csv", row.names = TRUE)


mat2 <- data.frame(mat2)

mat21 <- select(mat2,mat2$v_1110,mat2$v_1101,mat2$v_1100,mat2$v_2100,mat2$v_2101,mat2$v_2102,mat2$v_2103)
mat21 <- select(mat2,v_1110,v_1101,v_1100,v_2100,v_2101,v_2102,v_2103)
___________________
install.packages("devtools")


remotes::install_github('haozhu233/kableExtra')

library(devtools)
library(kableExtra)

mat2$v_1110 %>%
  kbl() %>%
  kable_paper("hover", full_width = F)


mat2[indices] %>%
  kbl() %>%
  kable_paper("hover", full_width = F)



kable(tabela_resultados2, format = "latex", booktabs = T) 



kable(tabela_resultados, format = "latex", booktabs = T) 


indices <- which(mat2 < .05, arr.ind = TRUE)
mat2[indices]

linhas <- row(which(mat2 < .05, arr.ind = TRUE))
colunas <- col(which(mat2 < .05, arr.ind = TRUE))

print(linhas)
print(colunas)


indices <- which(abs(mat2) < 0.05 & upper.tri(mat2), arr.ind = TRUE)

var1 <- row.names(mat2)[indices[, 1]]
var2 <- colnames(mat2)[indices[, 2]]

print(var1)
print(var2)

_____________________________

indices <- which(abs(mat2) < 0.5 & upper.tri(mat2), arr.ind = TRUE)
correlations <- mat2[indices]
var1 <- row.names(mat2)[indices[, 1]]
var2 <- colnames(mat2)[indices[, 2]]
result <- data.frame(var1, var2, correlations)


results2 %>%
  kbl() %>%
  kable_paper("hover", full_width = F)


results2 <- subset(result,correlations<0.05)

rownames(results2) <- NULL


kable(results2, format = "latex", booktabs = T) 



