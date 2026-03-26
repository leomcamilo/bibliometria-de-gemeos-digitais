# Digital Twins for Smart Cities: A Bibliometric Analysis of the Decision Support Gap (2018–2024)

## Description

This project presents a systematic bibliometric analysis of scientific literature on **Digital Twins applied to Smart Cities**, covering the period **2018–2024**. The central research question investigates how this field has evolved and to what extent the dimension of **public management decision support** is represented in the literature.

> **Note:** Although the search was not restricted by year, no publications were found before 2018, confirming this as an emerging field. The period start date was therefore set empirically at 2018.

## Research Question

> *"How has the scientific production on digital twins applied to smart cities evolved between 2018 and 2024, and to what extent is the dimension of public management decision support represented in this literature?"*

## Corpus

| Source | Raw articles | Filtered articles |
|--------|-------------|-------------------|
| Scopus | 398 | 145 (`scopus_2_filt.bib`) |
| Web of Science | 369 | 134 (`wos_2_filt.bib`) |
| **After deduplication** | — | **159 unique articles** |

**Filtering strategy:** Articles were filtered by journal ISSN against a combined set of 2,545 unique ISSNs from three SCImago 2024 categories:
- Urban Studies (279 journals)
- Geography, Planning and Development (842 journals)
- Decision Sciences (564 journals)

This combined filter quadrupled coverage of seminal articles compared to Urban Studies alone (40% vs. 10% of top-20 most cited), while keeping the corpus within the target range of 110–130 articles before PRISMA screening.

## Methodology

- **Approach:** Systematic bibliometrics using the R `bibliometrix` package
- **Data Sources:** Scopus and Web of Science (WoS)
- **Search String (Scopus):**
  ```
  TITLE-ABS-KEY(
    "digital twin*" AND
    ("smart cit*" OR "urban*") AND
    ("decision support" OR "decision-making" OR
     "public management" OR "urban management" OR "governance")
  )
  Filters: Article, English, 2018–2024
  ```
- **Search String (WoS):**
  ```
  TS=(
    "digital twin*" AND
    ("smart cit*" OR "urban*") AND
    ("decision support" OR "decision-making" OR
     "public management" OR "urban management" OR "governance")
  )
  Filters: Article, English, 2018–2024
  ```
- **Deduplication:** `bibliometrix::mergeDbSources()` + manual deduplication by title
- **PRISMA protocol:** Managed via Parsif.al — currently in title/abstract screening phase
- **Theoretical Positioning:** Critical realism (ontology), Pragmatism (epistemology), Engaged Scholarship (Van de Ven)

### Data Source Asymmetry

| Aspect | Scopus | Web of Science |
|--------|--------|----------------|
| Articles retrieved (raw) | 398 | 369 |
| Articles after journal filter | 145 | 134 |
| Export format | BibTeX (.bib) | BibTeX (.bib) |
| Cited references included | No | Yes |
| Analyses enabled | Descriptive, keywords, collaboration | All, including co-citation and bibliographic coupling |

## Academic Context

- **Institution:** COPPEAD/UFRJ — Instituto de Pós-Graduação e Pesquisa em Administração
- **Program:** Doctoral Program in Business Administration
- **Course:** ADM 804 — Introdução ao Pacote Estatístico R (Prof. Jorge Antunes)
- **Target Journal:** [Cities](https://www.sciencedirect.com/journal/cities) (Elsevier, Q1/A1)
- **Broader Context:** This bibliometric study serves as foundational mapping for a doctoral thesis on digital twins as decision support tools for urban public management.

## Project Structure

```
bibliometria-de-gemeos-digitais/
│
├── README.md                          # Project documentation (this file)
├── PROGRESS.md                        # Detailed decision log and phase history
├── execucao.md                        # Execution plan and timeline (Portuguese)
│
├── data/
│   ├── raw/                           # Raw data exported from Scopus/WoS
│   │   ├── fase1/                     # Phase 1: broad query (historical, not reused)
│   │   │   ├── scopus_1.bib           # Scopus, broad query: 671 articles
│   │   │   └── wos_completo_1.bib     # WoS, broad query: 1,052 articles
│   │   ├── scopus_2.bib               # Scopus, refined query (Phase 3): 398 articles
│   │   ├── savedrecs.bib              # WoS, refined query (Phase 3): 369 articles
│   │   └── scimagojr 2024 *.csv       # SCImago 2024 journal rankings (3 categories)
│   └── processed/                     # Filtered and cleaned data
│       ├── scopus_2_filt.bib          # Scopus filtered (3-category ISSN): 145 articles ← ACTIVE
│       └── wos_2_filt.bib             # WoS filtered (3-category ISSN): 134 articles ← ACTIVE
│
├── output/
│   ├── figures/                       # Generated plots and visualizations
│   └── tables/                        # Exported tables (CSV)
│
├── manuscript/
│   └── highlights.md                  # Required highlights for Cities journal
│
└── R/
    ├── artigo.qmd                     # ★ MAIN: consolidated article with all analyses
    ├── 00_setup.qmd                   # Package installation and verification
    ├── 01_data_import.qmd             # Data import and cleaning
    ├── 02_descriptive_analysis.qmd    # Scientific production analysis
    ├── 03_network_analysis.qmd        # Co-authorship and collaboration networks
    ├── 04_keyword_analysis.qmd        # Keyword co-occurrence and thematic map
    ├── 05_results_summary.qmd         # Results synthesis
    ├── 06_prisma_diagram.qmd          # PRISMA flowchart (DiagrammeR)
    ├── instalar_pacotes.R             # Package installation script (R 4.5.3)
    └── tmp/                           # Experimental/archived scripts
```

## Analysis Pipeline

The main analysis is in `R/artigo.qmd` — a self-contained Quarto document that imports the filtered `.bib` files directly and generates all figures, tables, and exports. It includes all 10 analyses requested by the course instructor plus exploratory analyses:

| Analysis | Output |
|----------|--------|
| General corpus statistics | Table 1 |
| Annual publication growth | `fig_evolucao_temporal.png` |
| Top 10 prolific authors | Table 2, `fig_top_autores.png` |
| Author production over time | `fig_author_prod_over_time.png`, Table 3 |
| Author centrality (betweenness, degree, PageRank) | Table 4, `fig_centralidade_autores.png` |
| Top 10 journals | Table 5, `fig_top_journals.png` |
| Top 10 countries | Table 6, `fig_top_paises.png` |
| Top 10 most cited articles | Table 7 |
| Co-authorship network | `fig_rede_coautoria.png` |
| International collaboration network | `fig_rede_paises.png` |
| Bibliographic coupling (conditional on CR field) | `fig_author_coupling.png` |
| Top 20 author keywords | Table 8, `fig_top_keywords.png` |
| Keyword word cloud | `fig_wordcloud.png` |
| Keyword co-occurrence network | `fig_rede_keywords.png` |
| Thematic map (strategic diagram) | `fig_mapa_tematico.png`, Table 9 |
| Thematic evolution | — |
| Decision support gap analysis | Table 10 |

## Reproducing This Project

### Prerequisites

- **R** ≥ 4.3.0 (tested on R 4.5.3)
- **RStudio** (recommended) or any IDE with Quarto support
- **Quarto** ≥ 1.3 (tested on 1.6.37)

### Step-by-step

1. **Clone the repository:**
   ```bash
   git clone https://github.com/leomcamilo/bibliometria-de-gemeos-digitais.git
   cd bibliometria-de-gemeos-digitais
   ```

2. **Install R dependencies:**
   ```bash
   Rscript R/instalar_pacotes.R
   ```

3. **Run the main analysis:**
   ```bash
   quarto render R/artigo.qmd
   ```

### Key Dependencies

| Package | Purpose |
|---------|---------|
| `bibliometrix` | Bibliometric analysis framework |
| `tidyverse` | Data manipulation and visualization |
| `ggplot2` | Scientific plotting |
| `igraph` | Network analysis |
| `ggraph` | Network visualization |
| `ggrepel` | Non-overlapping labels |
| `knitr` + `kableExtra` | Table formatting and PDF rendering |
| `wordcloud` | Static word cloud (PDF-compatible) |
| `here` | Reproducible file paths |

## Project Status

🟡 **In development** — Bibliometric analysis complete; PRISMA screening in progress (title/abstract phase); manuscript writing pending.

| Phase | Status |
|-------|--------|
| Data collection & filtering | ✅ Complete |
| R environment setup | ✅ Complete (R 4.5.3) |
| All QMDs rendered | ✅ Complete |
| Consolidated `artigo.qmd` | ✅ Complete |
| PRISMA screening (Parsifal) | 🔄 In progress — title/abstract screening |
| Manuscript writing | ⏳ Pending |
| Submission to Cities | ⏳ Pending |

## Key Methodological Decisions

| Decision | Rationale |
|----------|-----------|
| Period 2018–2024 (not 2015) | No publications found before 2018 — confirmed empirically |
| Refined query with decision/management terms | Prof. Jorge's guidance; focused corpus for course deliverable |
| Combined journal filter (3 SCImago categories) | Urban Studies alone covered only 10% of top-20 seminal articles; combined filter reaches 40% |
| No a priori journal filter on query | Filtering by Urban Studies alone would exclude 85% of seminal articles |
| R/Quarto directly (no biblioshiny) | Full reproducibility and control over visualizations |
| `wordcloud` (base R) instead of `wordcloud2` | wordcloud2 generates interactive HTML incompatible with PDF rendering |
| `DiagrammeR::grViz` instead of PRISMAstatement | PRISMAstatement not available for R 4.5.3 |
| `tryCatch` throughout pipeline | Co-citation/coupling and thematicEvolution fail with mixed Scopus+WoS data; graceful degradation preferred |

## Author

**Leonardo Mello Camilo da Silva** — Doctoral Student, COPPEAD/UFRJ

---

*This project uses AI tools (Claude/Anthropic) for code assistance and text drafting. AI usage is fully disclosed in accordance with Elsevier's AI policy. AI is not listed as an author.*
