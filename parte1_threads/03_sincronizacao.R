# ==============================================================================
# PARTE 1.3: SINCRONIZAÇÃO ENTRE PROCESSOS EM R (Lock Files)
# ==============================================================================
# Como o R opera com processos isolados em vez de threads com memória partilhada,
# a sincronização de acesso a recursos partilhados (ex: ficheiros) é feita
# através de 'Lock Files' (ficheiros de bloqueio) que garantem exclusão mútua.

library(parallel)

cat("--- Sincronização de Processos via Lock File (Secção Crítica) ---\n\n")

lock_file <- "recurso.lock"
log_file  <- "output_sincronizado.txt"

# Garante que os ficheiros de teste anteriores são removidos
if (file.exists(lock_file)) unlink(lock_file)
if (file.exists(log_file))  unlink(log_file)

# Função para adquirir o bloqueio (Spinlock simples)
adquirir_lock <- function(file) {
  while (!file.create(file, showWarnings = FALSE)) {
    Sys.sleep(0.05) # Aguarda até o ficheiro de bloqueio ser libertado
  }
}

# Função para libertar o bloqueio
libertar_lock <- function(file) {
  unlink(file)
}

# Operação que acede ao recurso partilhado garantindo secção crítica
escrever_seguro <- function(worker_id) {
  # Entrar na Secção Crítica (Apenas 1 processo passa de cada vez)
  adquirir_lock(lock_file)
  
  # Acesso ao recurso partilhado (escrita concorrente no ficheiro log)
  cat(paste("Worker", worker_id, "entrou na secção crítica às", Sys.time(), "\n"),
      file = log_file, append = TRUE)
  
  Sys.sleep(0.2) # Simula o tempo de processamento da secção crítica
  
  # Sair da Secção Crítica
  libertar_lock(lock_file)
  
  return(paste("Worker", worker_id, "concluiu a escrita com sucesso."))
}

cl <- makeCluster(2)
clusterExport(cl, c("lock_file", "log_file", "adquirir_lock", "libertar_lock", "escrever_seguro"))

# Executa 4 tarefas concorrentes partilhando o mesmo recurso
res <- parLapply(cl, 1:4, escrever_seguro)
stopCluster(cl)

print(res)

cat("\n--- Conteúdo do Ficheiro Partilhado (Acessos Ordenados Sem Corrupção) ---\n")
if (file.exists(log_file)) {
  cat(readLines(log_file), sep = "\n")
  # Limpeza dos ficheiros temporários
  unlink(log_file)
  if (file.exists(lock_file)) unlink(lock_file)
}