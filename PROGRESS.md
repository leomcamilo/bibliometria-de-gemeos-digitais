# Diário de Progresso — Bibliometria de Gêmeos Digitais

**Projeto:** Artigo científico de bibliometria sobre gêmeos digitais e tomada de decisão em cidades inteligentes.

**Título provisório:** *"Digital Twins for Smart Cities: A Bibliometric Analysis of the Decision Support Gap (2018–2024)"*

**Revista-alvo:** Cities (Elsevier, Q1/A1) — plano A. Planos alternativos: Sustainable Cities and Society (A1/A2), Smart Cities MDPI (A2/A3), Government Information Quarterly (A2).

**Disciplina vinculada:** ADM 804 – Introdução ao Pacote Estatístico R (COPPEAD/UFRJ, Prof. Jorge Antunes)

**Objetivo do artigo:** Mapear a produção científica sobre gêmeos digitais aplicados a cidades inteligentes com foco na dimensão de suporte à decisão gerencial pública, identificando o gap entre desenvolvimento tecnológico e aplicação gerencial.

---

## Fase 1 — Query ampla (corpus de mapeamento)

A decisão inicial foi desenvolver uma bibliometria de mapeamento do campo amplo de gêmeos digitais em cidades inteligentes, antes de qualquer refinamento temático. A ideia era capturar a paisagem completa do campo para depois demonstrar, com dados, que a dimensão gerencial pública é marginal.

A query original utilizada no Scopus foi:

```
TITLE-ABS-KEY("digital twin*" AND ("smart cit*" OR "urban*"))
Filtros: Article, English, 2015–2024
```

Os dados foram exportados tanto do Scopus quanto do Web of Science. Os arquivos brutos ficaram em `data/raw/`:

- `scopus_1.bib` — Scopus, query ampla: **671 artigos**
- `wos_completo_1.bib` — WoS, query ampla: **1.052 artigos**
- Total bruto: 1.723
- Duplicatas removidas (via `bibliometrix::mergeDbSources`): 464
- **Corpus único após deduplicação: 1.258 artigos**

Uma descoberta empírica importante surgiu já nesta fase: o campo não apresenta publicações anteriores a 2018. Não há artigos sobre gêmeos digitais em cidades inteligentes antes disso. Com base nesse achado, o período de análise foi ajustado para **2018–2024** em todas as análises subsequentes.

As análises da Fase 1 foram todas executadas com sucesso no R, utilizando o pacote bibliometrix. Cada notebook gerou um PDF correspondente:

- `00_setup.qmd` — ambiente configurado (pacotes instalados e verificados) ✅
- `01_data_import.qmd` — importação do corpus Scopus, geração de `df_bibliometria.rds` ✅
- `02_descriptive_analysis.qmd` — evolução temporal, países, journals, autores ✅
- `03_network_analysis.qmd` — redes de co-autoria e colaboração entre países ✅
- `04_keyword_analysis.qmd` — co-ocorrência de keywords e mapa temático ✅
- `05_results_summary.qmd` — síntese dos resultados ✅

As figuras geradas ficaram em `output/figures/` (01 a 10, exceto 07 — ver nota abaixo) e as tabelas em `output/tables/`.

**Nota sobre co-citação:** A rede de co-citação (07_rede_cocitacao.png) e o coupling bibliográfico (08_coupling_autores.png) **não foram gerados** porque os dados exportados do Scopus não incluíram o campo CR (referências citadas). O script detectou a ausência e pulou automaticamente. Os dados do WoS incluem CR, o que será explorado nas fases seguintes.

Os achados principais da análise descritiva com o corpus amplo do Scopus foram:

- Crescimento exponencial: 2 artigos em 2018 → 286 em 2024
- China domina com 132 artigos (2× o segundo colocado, UK com 49)
- Brasil ausente do top 10 — evidência do gap do Global South
- Top journals: Sustainability (30), Sustainable Cities and Society (22), IEEE Access (19)
- Cities **não aparece** no top 10 — evidência estrutural do viés tecnológico do campo
- Top autores: Wang Y (15), Lv Z (15), Li X (14) — predominância asiática

A decisão estratégica que emergiu desta fase foi manter a query ampla para sustentar o argumento central do gap: o campo é dominado por perspectivas tecnológicas e de infraestrutura, enquanto a gestão pública urbana é periférica. Adicionar "decision making" na query eliminaria exatamente o gap que se quer demonstrar.

---

## Fase 2 — Consulta ao Professor Jorge Antunes (ADM 804)

Foi enviado um e-mail ao Professor Jorge apresentando a proposta, a query, os filtros e dúvidas sobre a inclusão de Conference Papers e refinamento da string de busca.

A resposta do professor trouxe orientações importantes:

1. A query retorna artigos demais — adicionar termos de suporte à decisão (decision making, stakeholders e palavras similares)
2. Usar período 2000–2025 (ou 2016–2025 se volume grande)
3. Se volume ainda grande, filtrar por journals usando o Scimago
4. Manter apenas artigos em inglês
5. Cities é o melhor journal da área, portanto difícil — montar plano A, B, C, D de journals
6. PRISMA é necessário, mas RSL completa não é obrigatória para a disciplina — um bom filtro de conteúdo basta
7. A RSL pode ser desenvolvida depois, em cima da bibliometria, para submissão à revista

A decisão foi seguir a orientação do professor para o trabalho da disciplina, refinando a query. O argumento da query ampla foi preservado para o artigo final.

---

## Fase 3 — Query refinada (corpus focado)

Para atender à orientação do professor de focar em um corpus menor com dimensão de decisão explícita, a query foi refinada.

Query refinada no Scopus:

```
TITLE-ABS-KEY(
  "digital twin*" AND
  ("smart cit*" OR "urban*") AND
  ("decision support" OR "decision-making" OR
   "public management" OR "urban management" OR "governance")
)
Filtros: Article, English, 2018–2024
```

Query equivalente no WoS:

```
TS=(
  "digital twin*" AND
  ("smart cit*" OR "urban*") AND
  ("decision support" OR "decision-making" OR
   "public management" OR "urban management" OR "governance")
)
Filtros: Article, English, 2018–2024
```

Os novos arquivos brutos ficaram em `data/raw/`:

- `scopus_2.bib` — Scopus, query refinada: **398 artigos**
- `savedrecs.bib` — WoS, query refinada: **369 artigos**
- Total bruto: 767

Uma decisão metodológica importante foi documentada: a query refinada muda o argumento. Em vez de "gestão é marginal no campo", o argumento passa a ser "mesmo dentro da literatura que menciona decisão, a perspectiva gerencial pública é subrepresentada em relação à técnica/infraestrutura."

---

## Fase 4 — Parsif.al (protocolo PRISMA)

O protocolo PRISMA foi configurado no Parsif.al (https://parsif.al) sob o título "Bibliometrics in Digital Twins and Decision Making in Smart Cities".

Na aba Planning foram configurados:

**Objectives:** Mapear a estrutura intelectual da produção científica sobre gêmeos digitais aplicados à tomada de decisão em contextos de cidades inteligentes (2018–2024), identificando temas dominantes, autores-chave, países produtivos e o grau de representação do suporte à decisão gerencial pública.

**PICOC:**

- Population: Smart cities, urban environments, urban managers, public administrators
- Intervention: Digital twin systems, urban digital twins, IoT-based digital platforms
- Comparison: não aplicável — bibliometria
- Outcome: Decision-making support, urban management, governance, strategic decision, public policy
- Context: Smart city development, urban planning, public administration, 2018–2024

**Research Questions:**

- RQ1: Como evoluiu a produção científica sobre gêmeos digitais aplicados a cidades inteligentes e tomada de decisão entre 2018 e 2024?
- RQ2: Quais países, instituições, autores e journals concentram a produção sobre o tema?
- RQ3: Quais são os temas dominantes e emergentes, e em que medida o suporte à decisão gerencial pública aparece como tema consolidado?

**Critérios de Inclusão:**

- IC1: Artigos de periódico revisados por pares
- IC2: Publicados entre 2018 e 2024
- IC3: Escritos em inglês
- IC4: Abordam gêmeos digitais em contextos urbanos ou cidades inteligentes
- IC5: Incluem dimensão de tomada de decisão, gestão ou governança

**Critérios de Exclusão:**

- EC1: Conference papers, proceedings, capítulos de livro
- EC2: Fora do período 2018–2024
- EC3: Idioma diferente do inglês
- EC4: Aplicações de gêmeos digitais fora do contexto urbano (industrial, médico, manufatura)
- EC5: Sem abstract ou metadados incompletos
- EC6: Duplicatas identificadas por DOI ou título + autores

**Quality Assessment Checklist:**

- Q1: O artigo aborda explicitamente gêmeos digitais em contexto urbano ou de smart city?
- Q2: O artigo aborda dimensões de tomada de decisão, gestão ou governança?
- Q3: O artigo está publicado em journal revisado por pares indexado no Scopus ou WoS?
- Q4: O artigo contém abstract completo com objetivo de pesquisa identificável?
- Q5: O artigo contém keywords de autores utilizáveis para análise bibliométrica?
- Score: Yes=1, Partially=0.5, No=0 | Cutoff: 3.0/5.0

A primeira importação no Parsif.al (query refinada, ambas as bases) resultou em 765 artigos brutos, que após deduplicação automática pelo Parsif.al ficaram em **466 artigos**.

---

## Fase 5 — Filtro por journals Q1 Urban Studies (SCImago 2024)

A motivação para este filtro adicional foi excluir artigos de áreas muito técnicas (engenharia, sensoriamento remoto, construção civil) que passaram pela query mas não têm relevância para o foco gerencial/urbano. O professor havia sugerido filtrar por journals usando o Scimago se o volume fosse grande.

A fonte dos dados foi o SCImago Journal Rankings 2024, categoria Urban Studies (https://www.scimagojr.com/journalrank.php?category=3322), que lista 69 journals Q1 com 111 ISSNs únicos (impressos e eletrônicos).

O filtro foi implementado no notebook `R/01b_filtro_q1_journals.qmd`, que lê os arquivos .bib originais e filtra diretamente por ISSN, preservando a formatação BibTeX original para importação no Parsif.al. Nenhuma deduplicação é feita neste passo — isso fica para o Parsif.al.

Resultados após filtro Q1:

- Scopus Q1: **57 artigos** → `data/processed/scopus_2_q1.bib`
- WoS Q1: **54 artigos** → `data/processed/wos_2_q1.bib`
- Total bruto: 111

Após importação no Parsif.al e deduplicação automática:

- Duplicatas removidas: 47
- **Corpus atual após deduplicação: 61 artigos**

Journals Q1 de Urban Studies presentes no corpus filtrado incluem: Smart Cities (MDPI), Cities (Elsevier), Urban Climate, Environment and Planning B, Journal of Urban Technology, IET Smart Cities, International Journal of Urban Sciences, Urban Science, Journal of Planning Education and Research, entre outros.

---

## Estado Atual do Projeto

**Corpus ativo:** 61 artigos únicos em journals Q1 de Urban Studies, com query focada em gêmeos digitais + decisão/gestão + smart cities/urban, período 2018–2024.

**Arquivos de dados atuais:**

| Arquivo | Descrição | Artigos |
|---------|-----------|---------|
| `data/raw/scopus_1.bib` | Scopus, query ampla | 671 |
| `data/raw/wos_completo_1.bib` | WoS, query ampla | 1.052 |
| `data/raw/scopus_2.bib` | Scopus, query refinada | 398 |
| `data/raw/savedrecs.bib` | WoS, query refinada | 369 |
| `data/processed/scopus_2_q1.bib` | Scopus, refinada + Q1 | 57 |
| `data/processed/wos_2_q1.bib` | WoS, refinada + Q1 | 54 |

**Análises do R (Fase 1) — todas com PDF gerado:**

| Notebook | Status | Figuras geradas |
|----------|--------|-----------------|
| `00_setup.qmd` | ✅ Completo | — |
| `01_data_import.qmd` | ✅ Completo | — |
| `01b_filtro_q1_journals.qmd` | ✅ Completo | — |
| `02_descriptive_analysis.qmd` | ✅ Completo | 01–04 |
| `03_network_analysis.qmd` | ✅ Completo | 05, 06 (07, 08 pendentes — campo CR ausente no Scopus) |
| `04_keyword_analysis.qmd` | ✅ Completo | 08–10 |
| `05_results_summary.qmd` | ✅ Completo | — |
| `06_prisma_diagram.qmd` | ⏳ Pendente | — |

**Próximos passos pendentes:**

1. ⏳ Triagem título/abstract no Parsif.al (61 artigos)
2. ⏳ Quality Assessment (checklist configurado)
3. ⏳ Exportar corpus final do Parsif.al
4. ⏳ Rerodar análises bibliometrix (01–05) com corpus final
5. ⏳ BERTopic no Google Colab
6. ⏳ Gerar PRISMA flowchart (Parsif.al + DiagrammeR R)
7. ⏳ VOSviewer — visualizações de redes
8. ⏳ Escrita do manuscrito (`manuscript.qmd`)

---

## Fase 6 — Teste de cobertura com todos os ISSNs + Nova query ampliada

### 6.1 — Teste: filtro por journals resolve?

Antes de alterar a query, testamos se o problema era a restrição a journals Q1. O professor indicou que o ideal seria ter **110 a 130 artigos após deduplicação**. Rodamos o script `R/teste_todos_issns.R` que filtra os .bib da Fase 3 usando todos os ISSNs do CSV SCImago 2024 (Urban Studies, todas as categorias):

| Cenário | ISSNs | Bruto (Scopus + WoS) | Após deduplicação |
|---------|-------|----------------------|-------------------|
| Q1 apenas | 111 | 111 (57 + 54) | **60** |
| Q1 + Q2 | 221 | 125 (66 + 59) | **70** |
| Todos (Q1–Q4) | 445 | 126 (67 + 59) | **71** |

**Conclusão:** Ampliar o filtro de journals não resolve. Mesmo usando todos os 279 journals de Urban Studies (Q1 a Q4), o corpus após deduplicação fica em apenas 71 artigos — bem abaixo da meta de 110–130. O gargalo é a query de busca, que está restritiva demais (os termos de decisão são muito específicos: "decision support", "decision-making", "public management", "urban management", "governance").

### 6.2 — Nova query ampliada (3ª iteração)

A solução é ampliar os termos de decisão/gestão na query. A query da Fase 3 usava apenas 5 termos muito específicos. A nova query expande para termos mais abrangentes:

**Formato genérico (independente de base):**

```
Conceito 1 (Tecnologia):   "digital twin*"
     AND
Conceito 2 (Contexto):     "smart cit*" OR "urban*"
     AND
Conceito 3 (Gestão):       "decision*" OR "management" OR "governance"
                            OR "policy" OR "stakeholder*" OR "planning"

Filtros: Article | English | 2018–2024
```

**Formato Scopus:**

```
TITLE-ABS-KEY(
  "digital twin*" AND
  ("smart cit*" OR "urban*") AND
  ("decision*" OR "management" OR "governance" OR
   "policy" OR "stakeholder*" OR "planning")
)
AND DOCTYPE(ar) AND LANGUAGE(english) AND PUBYEAR > 2017 AND PUBYEAR < 2025
```

**Formato Web of Science:**

```
TS=(
  "digital twin*" AND
  ("smart cit*" OR "urban*") AND
  ("decision*" OR "management" OR "governance" OR
   "policy" OR "stakeholder*" OR "planning")
)

Filtros manuais: Article | English | 2018–2024
```

**Mudanças em relação à query da Fase 3:**

| Aspecto | Fase 3 (query refinada) | Fase 6 (query ampliada) |
|---------|------------------------|------------------------|
| Termos de decisão | "decision support", "decision-making" | "decision*" (captura decision support, decision-making, decision making, decisions, etc.) |
| Termos de gestão | "public management", "urban management", "governance" | "management", "governance", "policy", "stakeholder*", "planning" |
| Nº de termos no Conceito 3 | 5 (muito específicos) | 6 (mais genéricos, com wildcard) |
| Mudança esperada | — | Captura artigos sobre planejamento urbano, políticas públicas, gestão de stakeholders que a query anterior perdia |

**Justificativa:** A query anterior exigia termos compostos ("decision support", "public management") que limitavam o recall. A nova query usa termos simples com truncamento ("decision*", "stakeholder*") e adiciona "policy" e "planning", que são dimensões centrais da gestão urbana frequentemente presentes em artigos relevantes.

**Próximo passo:** Executar a query no Scopus e WoS, exportar os .bib, e aplicar o filtro Q1 Urban Studies para verificar se o corpus atinge a meta de 110–130 artigos após deduplicação.

---

## Decisões Metodológicas Acumuladas

| Decisão | Justificativa | Fase |
|---------|---------------|------|
| Período 2018–2024 (não 2015) | Corpus empírico confirma ausência de publicações anteriores a 2018 | 1 |
| Manter query ampla para argumento do gap | Filtrar por "decision making" eliminaria o gap que se quer demonstrar | 1→2 |
| Query refinada para disciplina ADM 804 | Orientação do Prof. Jorge — corpus focado ~200 artigos | 3 |
| Dual database Scopus + WoS | Cobertura complementar — Visser et al. (2021) | 1 |
| Filtro Q1 Urban Studies (SCImago 2024) | Excluir artigos técnicos fora do escopo gerencial/urbano | 5 |
| Parsif.al para gestão PRISMA | Automatizar fluxograma e documentar triagem | 4 |
| Saídas .bib separadas por base (sem dedup no R) | Deduplicação delegada ao Parsif.al | 5 |
| Ampliar query (não o filtro de journals) | Teste mostrou que todos os ISSNs (Q1–Q4) rendem apenas 71 artigos — gargalo é a query | 6 |
| Termos genéricos + wildcard no Conceito 3 | "decision*" captura mais variações que "decision support" OR "decision-making" | 6 |
| Adicionar "policy", "planning", "stakeholder*" | Dimensões centrais da gestão urbana ausentes na query anterior | 6 |

---

## Referências Metodológicas Chave

- Aria, M., & Cuccurullo, C. (2017). bibliometrix. *Journal of Informetrics*, 11(4), 959–975.
- Page, M. J. et al. (2021). PRISMA 2020. *BMJ*, 372, n71.
- Visser, M. et al. (2021). Large-scale comparison of bibliographic data sources. *Quantitative Science Studies*, 2(1), 20–41.
- Nica et al. (2026). *Cities*, 171, 106797. [referência metodológica principal]
- Sacoto-Cabrera et al. (2025). *Smart Cities*, 8(5), 175. [referência metodológica secundária]
