# ==============================================================================
# PARTE 1.1: GERAÇÃO DE THREADS E PROCESSOS EM R
# ==============================================================================
# Como o R é nativamente single-threaded, a concorrência base faz-se através 
# de processos separados (forking ou sockets) e não de threads com memória partilhada.

library(parallel)

cat("--- Análise do Hardware ---\n")
num_cores <- detectCores()
cat("Núcleos de CPU detectados:", num_cores, "\n\n")

# Função que simula um processamento pesado (ex: ler uma base de dados grande)
trabalho_pesado <- function(id) {
  Sys.sleep(1) # Simula espera de 1 segundo bloqueante
  
  # Retorna o ID da tarefa e o PID (Process ID) que a executou
  return(paste("Tarefa", id, "concluída pelo Processo PID:", Sys.getpid()))
}

tarefas <- 1:4

# --- 1. Execução Sequencial ---
cat("--- Execução Sequencial ---\n")
tempo_seq <- system.time({
  res_seq <- lapply(tarefas, trabalho_pesado)
})
print(res_seq)
cat("Tempo sequencial:", tempo_seq["elapsed"], "segundos\n\n")

# --- 2. Execução Paralela (Sockets) ---
cat("--- Execução Paralela (Processos Isolados) ---\n")
# Cria um cluster de processos em background (igual ou menor ao número de núcleos)
cl <- makeCluster(min(num_cores, 4)) 

tempo_par <- system.time({
  # Executa a mesma tarefa, mas distribui pelos processos do cluster
  res_par <- parLapply(cl, tarefas, trabalho_pesado)
})

stopCluster(cl) # Boa prática: encerrar os processos criados

print(res_par)
cat("Tempo paralelo:", tempo_par["elapsed"], "segundos\n")