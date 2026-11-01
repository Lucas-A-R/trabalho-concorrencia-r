# Análise Detalhada de Concorrência, Memória e Modelos Assíncronos em R

Este repositório contém o código-fonte, scripts de demonstração prática e evidências experimentais sobre mecanismos de concorrência, gestão de memória compartilhada, sincronização e modelos assíncronos na linguagem R.

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
├── assets/                          # Evidências de execução (Capturas de tela)
│   ├── print_01_pids.png
│   ├── print_02_bigmemory.png
│   ├── print_03_sincronizacao.png
│   ├── print_04_promises.png
│   └── print_05_future.png
└── README.md                        # Documentação técnica do projeto
