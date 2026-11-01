# ==============================================================================
# PARTE 2.1: EVENT LOOP E PROMISES EM R (pacotes 'promises' e 'later')
# ==============================================================================
# O R puro é síncrono e bloqueante. O ecossistema modernizou-se com os pacotes
# 'promises' e 'later', que simulam um Event Loop para operações assíncronas
# sem bloquear a thread principal (essencial no framework Shiny).

library(promises)
library(later)

cat("--- Demonstração de Event Loop e Promises em R ---\n\n")

cat("1. A agendar tarefas assíncronas no Event Loop...\n")

# Promessa 1: Demora 1.5 segundos
p1 <- promise(function(resolve, reject) {
  later(function() {
    resolve("Dados do Serviço A recebidos (1.5s)")
  }, delay = 1.5)
}) %...>% (function(res) {
  cat("   [Promise 1 Resolvida]:", res, "\n")
})

# Promessa 2: Demora 0.5 segundos (deve resolver PRIMEIRO que a Promise 1)
p2 <- promise(function(resolve, reject) {
  later(function() {
    resolve("Dados do Serviço B recebidos (0.5s)")
  }, delay = 0.5)
}) %...>% (function(res) {
  cat("   [Promise 2 Resolvida]:", res, "\n")
})

cat("2. Código síncrono principal continua a executar livremente!\n")
cat("3. A processar eventos no Event Loop...\n\n")

# Processa o Event Loop do R (executa callbacks pendentes do 'later')
for (i in 1:20) {
  run_now() # Processa eventos agendados sem travar a sessão
  Sys.sleep(0.1)
}

cat("\n--- Event Loop concluído com sucesso! ---\n")