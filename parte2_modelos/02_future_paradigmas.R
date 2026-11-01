# ==============================================================================
# PARTE 2.2: ECOSSISTEMA FUTURE E ANÁLISE DE PARADIGMAS EM R
# ==============================================================================
# O pacote 'future' é o padrão moderno para concorrência em R. Oferece uma API
# unificada para avaliação assíncrona, permitindo alternar estratégias (plan)
# sem alterar a lógica do código.

library(future)

cat("--- 1. Avaliação Assíncrona com 'future' ---\n\n")

# Define a estratégia de execução paralela em background (processos filhos)
plan(multisession)

cat("A agendar cálculo assíncrono 1 (demora 1s)...\n")
f1 <- future({
  Sys.sleep(1)
  sum(1:1000000)
})

cat("A agendar cálculo assíncrono 2 (demora 0.5s)...\n")
f2 <- future({
  Sys.sleep(0.5)
  mean(1:1000000)
})

cat("\nVerificação de resolução não bloqueante:\n")
cat("Future 1 resolvido imediatamente?:", resolved(f1), "\n")
cat("Future 2 resolvido imediatamente?:", resolved(f2), "\n\n")

cat("A obter resultados finais com value() (bloqueia apenas ao recolher):\n")
cat("Resultado Future 1:", value(f1), "\n")
cat("Resultado Future 2:", value(f2), "\n\n")

# Restaura o plano sequencial
plan(sequential)

cat("--- 2. Análise Arquitetural dos Outros Paradigmas em R ---\n")
cat("* Corrotinas: R não possui suporte nativo a async/await ou corrotinas na sintaxe.\n")
cat("  O comportamento é simulado via 'future' e 'promises'.\n")
cat("* Modelo de Atores: Não existem bibliotecas oficiais ou maduras para Atores (Akka/Erlang) em R.\n")
cat("  O isolamento faz-se via workers de processos independentes.\n")