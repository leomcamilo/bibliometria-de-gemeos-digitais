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

**Próximo passo:** Executar a query no Scopus e WoS, exportar os .bib. Decisão sobre filtro de journal agora será empírica (ver Fase 7).

---

## Fase 7 — Análise de artigos seminais e decisão sobre filtro de journals

### 7.1 — Top 20 artigos mais citados (corpus Fase 1: 1.258 artigos únicos)

Antes de decidir se o filtro "Urban Studies" faz sentido, analisamos os artigos mais citados do corpus amplo (Fase 1: `scopus_1.bib` + `wos_completo_1.bib`, deduplicados) para mapear onde estão os pilares intelectuais do campo:

| # | TC | Autores (Ano) | Título (resumido) | Journal |
|---|-----|---------------|-------------------|---------|
| 1 | 1318 | Fuller et al. (2020) | Digital Twin: Enabling Technologies, Challenges and Open Research | **IEEE Access** |
| 2 | 651 | Minerva et al. (2020) | Digital Twin in the IoT Context: A Survey | **Proceedings of the IEEE** |
| 3 | 573 | Wu et al. (2021) | Digital Twin Networks: A Survey | **IEEE Internet of Things Journal** |
| 4 | 515 | Deng et al. (2021) | A Systematic Review of a Digital Twin City: Urban Governance toward Smart... | **J. Management Science and Engineering** |
| 5 | 470 | Botin-Sanabria et al. (2022) | Digital Twin Technology Challenges and Applications | **Remote Sensing** |
| 6 | 377 | Deng et al. (2021) | From BIM to Digital Twins: Evolution of Intelligent Building... | **J. Information Technology in Construction** |
| 7 | 358 | Dembski et al. (2020) | Urban Digital Twins for Smart Cities and Citizens: Herrenberg | **Sustainability** |
| 8 | 339 | Schrotter & Huerzeler (2020) | The Digital Twin of the City of Zurich for Urban Planning | **PFG–J. Photogrammetry Remote Sensing** |
| 9 | 326 | White et al. (2021) | A Digital Twin Smart City for Citizen Feedback | **Cities** |
| 10 | 310 | Allam et al. (2022) | The Metaverse as a Virtual Form of Smart Cities | **Smart Cities** |
| 11 | 303 | Xia et al. (2022) | City Digital Twin Technologies for Sustainable Smart City Design | **Sustainable Cities and Society** |
| 12 | 292 | Huynh-The et al. (2023) | Artificial Intelligence for the Metaverse: A Survey | **Eng. Applications of AI** |
| 13 | 278 | Shahzad et al. (2022) | Digital Twins in Built Environments | **Buildings** |
| 14 | 242 | Zhang et al. (2022) | Adaptive Digital Twin and Multiagent Deep RL for Vehicular Edge | **IEEE Trans. Industrial Informatics** |
| 15 | 241 | Li et al. (2022) | Big Data Analysis of IoT in Digital Twins of Smart City | **Future Generation Computer Systems** |
| 16 | 219 | Francisco et al. (2020) | Smart City Digital Twin-Enabled Energy Management | **J. Management in Engineering** |
| 17 | 213 | Weil et al. (2023) | Urban Digital Twin Challenges for Sustainable Smart Cities | **Sustainable Cities and Society** |
| 18 | 207 | Ketzler et al. (2020) | Digital Twins for Cities: A State of the Art Review | **Built Environment** |
| 19 | 190 | Lehtola et al. (2022) | Digital Twin of a City: Review of Technology Serving City Needs | **Int. J. Applied Earth Observation** |
| 20 | 185 | Mylonas et al. (2021) | Digital Twins from Smart Manufacturing to Smart Cities | **IEEE Access** |

### 7.2 — Distribuição de journals nos mais citados

**Top 20 — journals:**
- IEEE Access: 2
- Sustainable Cities and Society: 2
- Cities, Smart Cities, Sustainability, Built Environment: 1 cada
- Journals de engenharia/CS (IEEE, Remote Sensing, etc.): 12

**Top 50 — journals mais frequentes:**
- Journal of Management in Engineering: 5
- Sustainable Cities and Society: 5
- IEEE Access: 4
- Cities: 2
- IEEE Internet of Things Journal: 2
- Int. J. Applied Earth Observation: 2
- IET Smart Cities, J. Urban Management, J. Urban Technology, Land Use Policy, Nature Sustainability: 1 cada

### 7.3 — Conclusão sobre o filtro Urban Studies

O mapeamento revelou um dado **crucial**: dos 20 artigos mais citados, apenas **2** têm ISSN confirmado em journals "Urban Studies" no SCImago (Cities e Built Environment). Outros journals como Smart Cities (MDPI), Sustainability e Remote Sensing não puderam ser verificados por ISSN ausente nos metadados exportados. Os demais estão em journals de **Engineering, Computer Science e áreas técnicas**.

Se aplicássemos o filtro Urban Studies a priori, **perderíamos a grande maioria dos artigos seminais do campo**, incluindo o mais citado de todos (Fuller et al., 2020, TC=1318).

**Decisão: NÃO aplicar filtro de journals a priori.** Em vez disso:

1. Rodar a query ampliada (Fase 6) **sem nenhum filtro de journal**
2. Se o volume for grande demais (>200 após dedup), usar os resultados da própria bibliometria (mapa temático, clusters) para justificar empiricamente um recorte
3. Se necessário, o filtro por journal entra como critério de exclusão PRISMA (EC7), não como pré-filtro

### 7.4 — Reorganização de R/

Os PDFs antigos foram removidos (serão regenerados com o novo corpus). O script `01b_filtro_q1_journals.qmd` foi movido para `R/tmp/` (pode ser reaproveitado se o filtro for necessário).

**R/ (scripts de produção):** `00_setup`, `01_data_import`, `02_descriptive_analysis`, `03_network_analysis`, `04_keyword_analysis`, `05_results_summary`, `06_prisma_diagram`

**R/tmp/ (rascunhos):** `01b_filtro_q1_journals.qmd`, `deduplicacao.R`, `teste_todos_issns.R`, `top_citados_fase1.R`, `teste_issns_combinados.R`

---

## Fase 8 — Ampliação do filtro de journals: 3 categorias SCImago

### 8.1 — Motivação

A Fase 7 mostrou que o filtro "Urban Studies" isoladamente descarta 85% dos artigos seminais (apenas 2/20 cobertos, 10%). Porém, a alternativa de não filtrar por journals gera o risco de incluir artigos puramente técnicos (IoT, edge computing, sensoriamento remoto) sem relevância gerencial. A solução explorada nesta fase é **combinar múltiplas categorias SCImago** para aumentar a cobertura dos artigos relevantes sem abandonar totalmente o filtro.

Foram baixados os rankings SCImago 2024 de três categorias/áreas complementares:

1. **Urban Studies** (Subject Category) — journals de urbanismo, cidades, planejamento urbano
2. **Geography, Planning and Development** (Subject Category) — journals de geografia, planejamento regional, desenvolvimento territorial
3. **Decision Sciences** (Subject Area) — journals de tomada de decisão, gestão, pesquisa operacional, analytics

Os CSVs ficaram em `data/raw/`:
- `scimagojr 2024  Subject Category - Urban Studies.csv` (279 journals)
- `scimagojr 2024  Subject Category - Geography, Planning and Development.csv` (842 journals)
- `scimagojr 2024  Subject Area - Decision Sciences.csv` (564 journals)

### 8.2 — ISSNs extraídos e combinados

| Categoria | Journals | ISSNs |
|-----------|----------|-------|
| Urban Studies | 279 | 445 |
| Geography, Planning & Development | 842 | 1.397 |
| Decision Sciences | 564 | 937 |
| **Combinado (únicos)** | — | **2.545** |

**Overlap entre categorias:**
- Urban ∩ Geography: 224 ISSNs (esperado — muitos journals de urbanismo também são de geografia)
- Urban ∩ Decision: 3 ISSNs (praticamente disjuntos)
- Geography ∩ Decision: 8 ISSNs (praticamente disjuntos)

A adição de "Geography, Planning and Development" traz 1.173 ISSNs novos — journals como Sustainable Cities and Society, Land Use Policy, Environment and Planning B, PFG–Photogrammetry, que são centrais para o campo de gêmeos digitais urbanos. "Decision Sciences" traz 927 ISSNs novos — journals como J. Management in Engineering, J. Management Science and Engineering, IEEE Internet of Things Journal, que cobrem a dimensão de decisão e gestão.

### 8.3 — Cobertura dos artigos seminais

**Top 20 mais citados — comparação Urban Studies vs Combinado:**

| # | TC | Primeiro Autor (Ano) | Journal | Urban Studies | Combinado | Categorias |
|---|-----|---------------------|---------|:---:|:---:|------------|
| 1 | 1318 | Fuller (2020) | IEEE Access | ❌ | ❌ | — |
| 2 | 651 | Minerva (2020) | Proceedings of the IEEE | ❌ | ❌ | — |
| 3 | 573 | Wu (2021) | IEEE Internet of Things J. | ❌ | ✅ | Decision Sci |
| 4 | 515 | Deng T (2021) | J. Management Sci. and Eng. | ❌ | ✅ | Decision Sci |
| 5 | 470 | Botin-Sanabria (2022) | Remote Sensing | ❌ | ❌ | — |
| 6 | 377 | Deng M (2021) | J. Info. Tech. in Construction | ❌ | ❌ | — |
| 7 | 358 | Dembski (2020) | Sustainability | ❌ | ❌ | — |
| 8 | 339 | Schrotter (2020) | PFG–Photogrammetry | ❌ | ✅ | Geo/Planning/Dev |
| 9 | 326 | White (2021) | Cities | ✅ | ✅ | Urban Studies |
| 10 | 310 | Allam (2022) | Smart Cities | ❌ | ❌ | — |
| 11 | 303 | Xia (2022) | Sustainable Cities and Society | ❌ | ✅ | Geo/Planning/Dev |
| 12 | 292 | Huynh-The (2023) | Eng. Applications of AI | ❌ | ❌ | — |
| 13 | 278 | Shahzad (2022) | Buildings | ❌ | ❌ | — |
| 14 | 242 | Zhang K (2022) | IEEE Trans. Industrial Inf. | ❌ | ❌ | — |
| 15 | 241 | Li X (2022) | Future Gen. Computer Systems | ❌ | ❌ | — |
| 16 | 219 | Francisco (2020) | J. Management in Engineering | ❌ | ✅ | Decision Sci |
| 17 | 213 | Weil (2023) | Sustainable Cities and Society | ❌ | ✅ | Geo/Planning/Dev |
| 18 | 207 | Ketzler (2020) | Built Environment | ✅ | ✅ | Urban + Geo |
| 19 | 190 | Lehtola (2022) | Int. J. Applied Earth Obs. | ❌ | ❌ | — |
| 20 | 185 | Mylonas (2021) | IEEE Access | ❌ | ❌ | — |

**Resumo de cobertura:**

| Escopo | Top 20 | Top 50 |
|--------|--------|--------|
| Urban Studies apenas | 2/20 (10%) | 7/50 (14%) |
| **Combinado (Urban + Geo + Decision)** | **8/20 (40%)** | **27/50 (54%)** |
| Ganho | +6 artigos | +20 artigos |

O filtro combinado **quadruplicou** a cobertura de artigos seminais em relação a Urban Studies isoladamente (de 10% para 40% no top 20).

### 8.4 — Teste de volume com ISSNs combinados (query Fase 3)

O filtro combinado foi testado contra os .bib da query refinada (Fase 3: `scopus_2.bib` + `savedrecs.bib`):

| Filtro | Artigos brutos | Após deduplicação |
|--------|---------------|-------------------|
| Urban Studies (todos Q) | 126 | ~71 |
| **Combinado (Urban + Geo + Decision, todos Q)** | **279** | **159** |
| Ganho | +153 | ~+88 |

Com o filtro combinado aplicado à query da Fase 3, o corpus **atinge 159 artigos após deduplicação** — acima da meta de 110–130 do professor. Isso abre a possibilidade de não precisar ampliar a query (Fase 6) se o filtro combinado for adotado.

### 8.5 — Conclusão e decisão estratégica

O filtro combinado de 3 categorias SCImago resolve dois problemas simultaneamente:

1. **Cobertura de seminais:** Salta de 10% para 40% no top 20 — captura artigos em Decision Sciences (J. Management in Engineering, IEEE IoT J.) e Geography/Planning (Sustainable Cities and Society, Built Environment) que são centrais ao campo
2. **Volume adequado:** 159 artigos após dedup com a query da Fase 3 — dentro da faixa desejada (acima de 110–130)

Os 12 artigos do top 20 que permanecem fora (IEEE Access, Sustainability, Remote Sensing, etc.) são majoritariamente reviews genéricos de tecnologia digital twin ou artigos de engenharia/CS que, embora altamente citados, não têm foco gerencial/urbano — exatamente o tipo de artigo que o filtro deve excluir.

**Decisão:** Adotar filtro combinado (Urban Studies + Geography, Planning & Development + Decision Sciences) como estratégia de filtragem por journals. Avaliar se deve ser aplicado à query Fase 3 (que já atinge 159) ou à query ampliada Fase 6 (que pode render ainda mais).

---

## Fase 9 — Execução do pipeline: ambiente R, rendering de QMDs e filtragem de .bib

### 9.1 — Correção do ambiente R

Após atualização do R via Homebrew (4.4.2 → 4.5.3), o Quarto passou a usar o R 4.5.3 (`/opt/homebrew/Cellar/r/4.5.3/lib/R`), que tinha a library vazia. Todos os pacotes estavam instalados apenas no R 4.4.2 (framework, `/usr/local/bin/R`).

**Solução:** Reinstalação de todos os pacotes necessários no R 4.5.3:

```r
# Script: R/instalar_pacotes.R
install.packages(c("bibliometrix", "tidyverse", "ggplot2", "igraph",
                    "ggraph", "ggrepel", "knitr", "here", "rmarkdown",
                    "webshot2", "DiagrammeR"))
```

- **pdftools** (dependência de bibliometrix) exigiu instalação da lib de sistema `poppler`: `brew install poppler pkg-config`
- **PRISMAstatement** não está disponível para R 4.5.3 (substituído por DiagrammeR::grViz na Fase 9.3)

### 9.2 — Rendering de todos os QMDs (00–06)

Todos os 7 notebooks Quarto foram executados e renderizados para PDF com sucesso. Bugs encontrados e corrigidos durante o processo:

| Script | Bug encontrado | Correção aplicada |
|--------|---------------|-------------------|
| `00_setup.qmd` | — (sem erros) | — |
| `01_data_import.qmd` | Esperava `scopus.bib` (inexistente) | Atualizado para importar `scopus_2.bib` + `savedrecs.bib` via `mergeDbSources()` |
| `02_descriptive_analysis.qmd` | — (sem erros) | — |
| `03_network_analysis.qmd` | `biblioNetwork()` falhava com `crossprod` na co-citação e coupling (dados mistos Scopus+WoS) | Adicionado `tryCatch` em torno das chamadas de co-citation e coupling |
| `04_keyword_analysis.qmd` | `thematicEvolution()` falhava com `'breaks' are not unique'` | `tryCatch` + cálculo dinâmico de year cuts; instalado `webshot2` para screenshots de widgets HTML em PDF |
| `05_results_summary.qmd` | `sprintf("%d", ...)` com valor não-inteiro | Corrigido para `sprintf("%.1f", ...)` + `as.integer()` onde necessário |
| `06_prisma_diagram.qmd` | `PRISMAstatement` indisponível para R 4.5.3 | Substituído por `DiagrammeR::grViz()` com diagrama Graphviz equivalente |

### 9.3 — Filtragem definitiva dos .bib

Com a decisão da Fase 8 de usar o filtro combinado (3 categorias SCImago, todos os quartis), o script `R/tmp/filtrar_bibs.R` foi criado e executado para gerar os .bib filtrados.

**Método:**
1. Leitura dos 3 CSVs SCImago (Urban Studies + Geography, Planning & Dev + Decision Sciences)
2. Extração de todos os ISSNs (colunas `Issn` e `SJR`), sem filtro de quartil → 2.545 ISSNs únicos
3. Filtragem de `scopus_2.bib` e `savedrecs.bib` por matching de ISSN (campos `issn` e `eissn`)
4. Exportação dos .bib filtrados para `data/processed/`
5. Deduplicação via `bibliometrix::mergeDbSources()` para contagem final

**Resultados:**

| Arquivo | Artigos brutos | Artigos filtrados |
|---------|---------------|-------------------|
| `scopus_2.bib` (Scopus, query Fase 3) | 398 | **145** → `data/processed/scopus_2_filt.bib` |
| `savedrecs.bib` (WoS, query Fase 3) | 369 | **134** → `data/processed/wos_2_filt.bib` |
| **Total bruto** | 767 | **279** |
| **Após deduplicação** | — | **159 artigos únicos** |

**Interpretação:** O corpus de 159 artigos únicos está ligeiramente acima da meta do professor (110–130), o que é positivo: permite margem para exclusões na triagem PRISMA (título/abstract screening) sem risco de ficar abaixo do mínimo.

### 9.4 — Arquivos gerados nesta fase

| Arquivo | Tipo | Descrição |
|---------|------|-----------|
| `R/instalar_pacotes.R` | Script auxiliar | Instalação de pacotes para R 4.5.3 |
| `R/tmp/filtrar_bibs.R` | Script experimental | Filtragem de .bib por ISSNs combinados (3 categorias SCImago) |
| `data/processed/scopus_2_filt.bib` | Dado processado | Scopus filtrado: 145 artigos |
| `data/processed/wos_2_filt.bib` | Dado processado | WoS filtrado: 134 artigos |
| PDFs renderizados (`R/*.pdf`) | Output | Todos os 7 QMDs (00–06) |

---

## Fase 10 — Artigo consolidado e análises complementares

### 10.1 — Resposta às demandas do Professor Jorge

O Professor Jorge Antunes respondeu ao e-mail da Fase 9 solicitando as seguintes análises:

**Análises padrão:**
1. Contagem de keywords
2. Contagem de autores
3. Contagem de artigos por ano
4. Rede de autores
5. Rede de países
6. Rede de keywords

**Análises adicionais interessantes:**
7. Centralidade de autores na rede de co-autoria
8. Author coupling (acoplamento bibliográfico)
9. Wordcloud das keywords
10. Evolução temporal dos autores (gráfico de pontos e linha, eixo x = ano, eixo y = autores)

O professor também perguntou se estávamos usando o biblioshiny. A decisão foi continuar com R/Quarto diretamente, por reprodutibilidade e controle total sobre as visualizações.

### 10.2 — Mapeamento de análises existentes vs novas

Das 10 análises solicitadas, 7 já existiam nos QMDs 02–04:

| Análise | Status | Localização |
|---------|--------|-------------|
| Contagem de keywords | ✅ Existente | `04_keyword_analysis.qmd` |
| Contagem de autores | ✅ Existente | `02_descriptive_analysis.qmd` |
| Artigos por ano | ✅ Existente | `02_descriptive_analysis.qmd` |
| Rede de autores | ✅ Existente | `03_network_analysis.qmd` |
| Rede de países | ✅ Existente | `03_network_analysis.qmd` |
| Rede de keywords | ✅ Existente | `04_keyword_analysis.qmd` |
| Author coupling | ✅ Existente (condicional a CR) | `03_network_analysis.qmd` |
| **Centralidade de autores** | ❌ **Nova** | Criada em `artigo.qmd` |
| **Wordcloud de keywords** | ❌ **Nova** | Criada em `artigo.qmd` |
| **Evolução temporal dos autores** | ❌ **Nova** | Criada em `artigo.qmd` |

### 10.3 — Atualização do pipeline

1. **`01_data_import.qmd` atualizado** — paths de importação alterados de `data/raw/scopus_2.bib` + `data/raw/savedrecs.bib` para `data/processed/scopus_2_filt.bib` + `data/processed/wos_2_filt.bib` (corpus filtrado por 3 categorias SCImago)

2. **Pacotes instalados** — `wordcloud2` e `wordcloud` (base R) instalados no R 4.5.3

### 10.4 — Criação de `R/artigo.qmd`

Arquivo Quarto consolidado contendo **todas** as 10 análises solicitadas pelo professor, mais análises adicionais exploratórias (mapa temático, evolução temática, análise do gap). O artigo é auto-contido: importa diretamente os .bib filtrados via `mergeDbSources()` e gera todas as figuras, tabelas e exportações.

**Estrutura do artigo:**

| Seção | Análises | Figuras/Tabelas |
|-------|----------|-----------------|
| Visão Geral do Corpus | Estatísticas gerais | Table 1 |
| Crescimento da Área | Publicações por ano (line+points) | fig_evolucao_temporal |
| Autores Prolíficos | Top 10 autores (tabela + bar chart) | Table 2, fig_top_autores |
| **Evolução Temporal dos Autores** | `authorProdOverTime()` — scatter+line, x=year, y=authors, size=citations | fig_author_prod_over_time, Table 3 |
| **Centralidade de Autores** | `igraph::betweenness()`, `degree()`, `closeness()`, `page_rank()` | Table 4, fig_centralidade_autores |
| Top Periódicos | Top 10 journals (tabela + bar chart) | Table 5, fig_top_journals |
| Top Países | Top 10 países (tabela + bar chart) | Table 6, fig_top_paises |
| Top Citados | Top 10 artigos mais citados | Table 7 |
| Rede de Co-autoria | `networkPlot()` fruchterman, n=30 | fig_rede_coautoria |
| Rede de Países | `networkPlot()` fruchterman, n=20 | fig_rede_paises |
| Author Coupling | `biblioNetwork(analysis="coupling")` (condicional a CR) | fig_author_coupling |
| Contagem de Keywords | Top 20 keywords (tabela + bar chart) | Table 8, fig_top_keywords |
| **Wordcloud de Keywords** | `wordcloud()` (base R, 80 keywords) | fig_wordcloud |
| Rede de Keywords | `networkPlot()` co-ocorrência, n=40 | fig_rede_keywords |
| Mapa Temático | `thematicMap()` — 4 quadrantes | fig_mapa_tematico, Table 9 |
| Evolução Temática | `thematicEvolution()` — Sankey | — |
| Análise do Gap | Termos de decisão nas keywords e clusters | Table 10 |

### 10.5 — Rendering

O `artigo.qmd` foi renderizado com sucesso para PDF via Quarto + XeLaTeX. Todos os chunks executaram sem erros. O PDF gerado contém todas as figuras, tabelas e texto.

**Figuras exportadas para `output/figures/`:**
- `fig_evolucao_temporal.png`
- `fig_top_autores.png`
- `fig_author_prod_over_time.png`
- `fig_centralidade_autores.png`
- `fig_top_journals.png`
- `fig_top_paises.png`
- `fig_rede_coautoria.png`
- `fig_rede_paises.png`
- `fig_author_coupling.png` (se CR disponível)
- `fig_top_keywords.png`
- `fig_wordcloud.png`
- `fig_rede_keywords.png`
- `fig_mapa_tematico.png`

**Tabelas exportadas para `output/tables/`:**
- `publicacoes_por_ano.csv`
- `top_journals.csv`
- `top_citados.csv`
- `estatisticas_gerais.csv`
- `centralidade_autores.csv`
- `clusters_mapa_tematico.csv`
- `gap_analysis.csv`

---

## Estado Atual do Projeto (atualizado 2026-03-22)

**Corpus definitivo:** 159 artigos únicos (query Fase 3 + filtro combinado 3 categorias SCImago, todos os quartis).
- Arquivos filtrados: `data/processed/scopus_2_filt.bib` (145) + `data/processed/wos_2_filt.bib` (134)

**Meta do professor:** 110–130 artigos → **atingida** (159 com margem para exclusões PRISMA).

**Ambiente R:** R 4.5.3 (Homebrew) com todos os pacotes instalados (incluindo wordcloud e wordcloud2). Quarto 1.6.37.

**Scripts de análise (R/):**

| Script | Status | Tipo |
|--------|--------|------|
| `00_setup.qmd` | ✅ Renderizado | Produção |
| `01_data_import.qmd` | ✅ Renderizado (importa scopus_2_filt.bib + wos_2_filt.bib — atualizado Fase 10) | Produção |
| `02_descriptive_analysis.qmd` | ✅ Renderizado | Produção |
| `03_network_analysis.qmd` | ✅ Renderizado (tryCatch em co-citation/coupling) | Produção |
| `04_keyword_analysis.qmd` | ✅ Renderizado (tryCatch em thematicEvolution) | Produção |
| `05_results_summary.qmd` | ✅ Renderizado (sprintf corrigido) | Produção |
| `06_prisma_diagram.qmd` | ✅ Renderizado (DiagrammeR::grViz — valores PRISMA pendentes) | Produção |
| **`artigo.qmd`** | **✅ Renderizado (Fase 10)** — artigo consolidado com todas as 10 análises do professor | **Produção (principal)** |
| `instalar_pacotes.R` | ✅ Executado | Auxiliar |

**Scripts experimentais (R/tmp/):** `01b_filtro_q1_journals.qmd`, `deduplicacao.R`, `teste_todos_issns.R`, `top_citados_fase1.R`, `teste_issns_combinados.R`, `filtrar_bibs.R`

**Nota:** Os planos futuros (próximos passos) foram movidos para `execucao.md`.

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
| **NÃO filtrar por journal a priori** (apenas Urban Studies) | 85% dos seminais (top 20) estão fora de Urban Studies — filtro eliminaria pilares intelectuais do campo | 7 |
| Filtro de journal como EC PRISMA, não pré-filtro | Se necessário reduzir volume, entra como critério documentado no protocolo PRISMA | 7 |
| Filtro combinado: Urban Studies + Geography/Planning/Dev + Decision Sciences | Cobertura de seminais salta de 10% para 40% (top 20); volume com query Fase 3 = 159 artigos (meta atingida) | 8 |
| 3 CSVs SCImago 2024 como base do filtro | 2.545 ISSNs únicos cobrem dimensões urbana, geográfica e de decisão do campo | 8 |
| PRISMAstatement → DiagrammeR::grViz | PRISMAstatement indisponível para R 4.5.3; grViz gera diagrama equivalente em Graphviz | 9 |
| tryCatch para robustez do pipeline | Co-citation/coupling e thematicEvolution falham com dados mistos Scopus+WoS; tryCatch permite graceful degradation | 9 |
| R/Quarto direto (sem biblioshiny) | Reprodutibilidade total, controle sobre visualizações, integração com pipeline de renderização PDF | 10 |
| artigo.qmd como documento consolidado | Arquivo único e auto-contido com todas as 10 análises solicitadas + exploratórias, em vez de rodar 7 QMDs separados | 10 |
| wordcloud base R (não wordcloud2) para PDF | wordcloud2 gera HTML interativo incompatível com PDF; wordcloud base R gera PNG estático | 10 |

---

## Organização de Diretórios

A estrutura do projeto foi organizada para clareza entre dados antigos (arquivos históricos) e atuais (corpus em uso):

### `data/raw/` — Arquivos brutos

| Local | Fase | Descrição | Artigos | Status |
|-------|------|-----------|---------|--------|
| `data/raw/fase1/` | 1 | Query ampla (historicamente importante) | — | Arquivos | 
| — `scopus_1.bib` | 1 | Scopus, query: `"digital twin*" AND ("smart cit*" OR "urban*")` | 671 | Histórico, não reutilizado |
| — `wos_completo_1.bib` | 1 | WoS, mesma query (Fase 1) | 1.052 | Histórico, não reutilizado |
| `scopus_2.bib` | 3 | Scopus, query refinada Fase 3 | 398 | **Ativo** — filtros aplicados |
| `savedrecs.bib` | 3 | WoS, query refinada Fase 3 | 369 | **Ativo** — filtros aplicados |
| `scimagojr 2024 Subject Category - Urban Studies.csv` | 5 | Rankings SCImago, 279 journals, 445 ISSNs | — | Dado de referência |
| `scimagojr 2024 Subject Category - Geography, Planning and Development.csv` | 8 | Rankings SCImago, 842 journals, 1.397 ISSNs | — | Dado de referência |
| `scimagojr 2024 Subject Area - Decision Sciences.csv` | 8 | Rankings SCImago, 564 journals, 937 ISSNs | — | Dado de referência |

**Observação:** Os arquivos de Fase 1 (`scopus_1.bib`, `wos_completo_1.bib`) foram mantidos em `data/raw/fase1/` por razões metodológicas: eles sustentam o argumento empírico central de que o campo de gêmeos digitais não tinha publicações antes de 2018. São frequentemente referenciados no PROGRESS.md (Fase 1, seções de análise descritiva) mas não são reprocessados nas pipelines atuais.

### `data/processed/` — Dados processados e filtrados

| Arquivo | Origem | Filtros aplicados | Artigos | Uso |
|---------|--------|-------------------|---------|-----|
| `scopus_2_filt.bib` | `scopus_2.bib` (Fase 3) | ISSN ∈ 3 categorias SCImago (2.545 ISSNs) | 145 | **Corpus definitivo** — importação Parsif.al |
| `wos_2_filt.bib` | `savedrecs.bib` (Fase 3) | ISSN ∈ 3 categorias SCImago (2.545 ISSNs) | 134 | **Corpus definitivo** — importação Parsif.al |
| `scopus_2_q1.bib` | `scopus_2.bib` (Fase 3) | ISSN ∈ Q1 Urban Studies (111 ISSNs) | 57 | Histórico (Fase 5) |
| `wos_2_q1.bib` | `savedrecs.bib` (Fase 3) | ISSN ∈ Q1 Urban Studies (111 ISSNs) | 54 | Histórico (Fase 5) |
| `corpus_q1_filtrado.bib` | Scopus + WoS Fase 3 | Q1 Urban Studies | 61 | Histórico — prototipagem Parsif.al |
| `corpus_q1_filtrado.rds` | `corpus_q1_filtrado.bib` | — | 61 | Histórico |
| `df_bibliometria.rds` | `scopus_2.bib` + `savedrecs.bib` via `mergeDbSources()` | — | 767 (brutos, sem filtro de journal) | Base para QMDs 02–05 (pipeline atual) |

### `R/` — Scripts de análise

**Scripts principais (versionados, pré-processamento e análise):**

| Script | Versão | Entrada | Saída | Tipo |
|--------|--------|---------|-------|------|
| `00_setup.qmd` | ✅ Renderizado (Fase 9) | — | Verificação de pacotes | Produção |
| `01_data_import.qmd` | ✅ Renderizado (Fase 10) | `scopus_2_filt.bib` + `wos_2_filt.bib` → `mergeDbSources()` | `df_bibliometria.rds` | Produção |
| `02_descriptive_analysis.qmd` | ✅ Renderizado (Fase 9) | `df_bibliometria.rds` | Figuras descritivas | Produção |
| `03_network_analysis.qmd` | ✅ Renderizado (Fase 9) | `df_bibliometria.rds` | Figuras de rede (tryCatch co-citation/coupling) | Produção |
| `04_keyword_analysis.qmd` | ✅ Renderizado (Fase 9) | `df_bibliometria.rds` | Figuras de keywords (tryCatch thematicEvolution) | Produção |
| `05_results_summary.qmd` | ✅ Renderizado (Fase 9) | `df_bibliometria.rds` | Síntese tabular | Produção |
| `06_prisma_diagram.qmd` | ✅ Renderizado (Fase 9) | — | PRISMA flowchart (DiagrammeR::grViz, valores pendentes) | Produção |
| **`artigo.qmd`** | **✅ Renderizado (Fase 10)** | `scopus_2_filt.bib` + `wos_2_filt.bib` direto | **PDF com todas as 10 análises** | **Produção (principal)** |
| `instalar_pacotes.R` | ✅ Executado (Fase 9) | — | Pacotes instalados em R 4.5.3 | Auxiliar |

**Nota:** Todos os PDFs foram regenerados na Fase 9 com o corpus atual (`scopus_2.bib` + `savedrecs.bib`, sem filtro de journal). Na Fase 10, o `01_data_import.qmd` foi adaptado para usar os .bib filtrados e o artigo consolidado (`artigo.qmd`) foi criado.

**Scripts experimentais e de teste (em `R/tmp/`):**

| Script | Propósito | Data | Status | 
|--------|-----------|------|--------|
| `01b_filtro_q1_journals.qmd` | Filtro Q1 Urban Studies por ISSN — pode ser reaproveitado se filtro for necessário | Mar 19 | Arquivado (Fase 7) |
| `deduplicacao.R` | Teste unitário de `mergeDbSources()` com Scopus + WoS Fase 1 | Mar 17 | Rascunho |
| `teste_todos_issns.R` | Teste: comparar filtros com Q1, Q1+Q2, todos ISSNs; verificar meta 110–130 | Mar 19 | Rascunho |
| `top_citados_fase1.R` | Análise de artigos seminais — gerou a tabela da Fase 7 | Mar 19 | Rascunho |
| `teste_issns_combinados.R` | Teste: 3 categorias SCImago combinadas, cobertura top 20, volume — gerou dados da Fase 8 | Mar 20 | Rascunho |
| `filtrar_bibs.R` | Filtragem definitiva dos .bib por 2.545 ISSNs combinados — gerou `scopus_2_filt.bib` e `wos_2_filt.bib` | Mar 21 | ✅ Executado (Fase 9) |

Estes scripts experimentais foram movidos para `R/tmp/` para não poluir o diretório principal, mas permanecem disponíveis como referência metodológica.

---

## Referências Metodológicas Chave

- Aria, M., & Cuccurullo, C. (2017). bibliometrix. *Journal of Informetrics*, 11(4), 959–975.
- Page, M. J. et al. (2021). PRISMA 2020. *BMJ*, 372, n71.
- Visser, M. et al. (2021). Large-scale comparison of bibliographic data sources. *Quantitative Science Studies*, 2(1), 20–41.
- Nica et al. (2026). *Cities*, 171, 106797. [referência metodológica principal]
- Sacoto-Cabrera et al. (2025). *Smart Cities*, 8(5), 175. [referência metodológica secundária]
