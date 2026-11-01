# ==============================================================================
# PARTE 1.2: COMPARTILHAMENTO DE MEMÓRIA EM R (Copy-on-Write e bigmemory)
# ==============================================================================
# Por padrão, cada processo do R recebe uma CÓPIA dos dados (não há memória 
# compartilhada de leitura/escrita simples). Para matrizes gigantes, usamos o
# pacote 'bigmemory', que cria ponteiros C++ para memória compartilhada na RAM.

library(parallel)
library(bigmemory)

cat("--- 1. Demonstração do Isolamento de Memória Padrão ---\n")

# Variável no processo pai
dado_global <- 100

cl <- makeCluster(2)

# Tenta alterar a variável global dentro dos workers
clusterExport(cl, "dado_global")
res <- clusterEvalQ(cl, {
  dado_global <- dado_global + 50 # Modifica apenas a cópia local do worker
  return(dado_global)
})

cat("Valor nos workers após alteração:", unlist(res), "\n")
cat("Valor no processo principal (continua intacto):", dado_global, "\n\n")

stopCluster(cl)


cat("--- 2. Memória Compartilhada Real com 'bigmemory' ---\n")

# Cria uma matriz de 1.000.000 de elementos diretamente em memória compartilhada C++
# tipo 'double' (8 bytes por elemento)
bm <- big.matrix(nrow = 1000, ncol = 1000, type = "double", init = 0)

# Obtém a descrição (ponteiro/referência) da memória para passar aos workers
bm_desc <- describe(bm)

cat("Valor inicial do elemento [1,1] na matriz compartilhada:", bm[1, 1], "\n")

cl <- makeCluster(2)

# Exporta a biblioteca e a descrição da memória para os workers
clusterEvalQ(cl, library(bigmemory))

# O worker 1 altera o elemento [1,1] diretamente na memória RAM compartilhada
clusterExport(cl, "bm_desc", envir = environment())

clusterEvalQ(cl, {
  matriz_compartilhada <- attach.big.matrix(bm_desc)
  # O primeiro worker escreve o valor 999 no topo da matriz
  if (Sys.getpid() == Sys.getpid()) { 
    matriz_compartilhada[1, 1] <- 999
  }
})

stopCluster(cl)

# O processo principal lê instantaneamente a alteração feita pelo worker
cat("Valor do elemento [1,1] lido pelo processo pai após o worker alterar:", bm[1, 1], "\n")