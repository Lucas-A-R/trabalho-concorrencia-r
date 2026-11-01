# Análise Detalhada de Concorrência, Memória e Modelos Assíncronos em R

Este repositório contém o código-fonte e scripts de demonstração prática sobre mecanismos de concorrência, gestão de memória compartilhada, sincronização e modelos assíncronos na linguagem R.

---

## 📁 Estrutura do Repositório

```text
trabalho-concorrencia-r/
├── parte1_threads/
│   ├── 01_threads_e_processos.R     # Multi-processamento e PIDs (PSOCK Clusters)
│   ├── 02_memoria_compartilhada.R   # Copy-on-Write vs. Ponteiros C++ (bigmemory)
│   └── 03_sincronizacao.R           # Exclusão Mútua & Secção Crítica (Lock Files)
├── parte2_modelos/
│   ├── 01_promises_event_loop.R     # Event Loop reativo e assincronia (promises/later)
│   └── 02_future_paradigmas.R       # Avaliação assíncrona unificada (future) & Paradigmas
└── README.md                        # Documentação técnica do projeto
