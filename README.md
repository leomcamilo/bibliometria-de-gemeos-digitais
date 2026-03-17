# Digital Twins for Smart Cities: A Bibliometric Analysis of the Decision Support Gap (2015–2024)

## Description

This project presents a systematic bibliometric analysis of scientific literature on **Digital Twins applied to Smart Cities**, covering the period 2015–2024. The central research question investigates how this field has evolved and to what extent the dimension of **public management decision support** is represented in the literature.

## Subject Overview

The literature at the intersection of digital twins and smart cities spans a wide range of topics, including:

- **Urban infrastructure management** — BIM-integrated digital twins for buildings, buried utilities, excavation safety, and municipal infrastructure lifecycle management
- **Energy systems and sustainability** — Smart grid security (e.g., false data injection attack detection), renewable energy integration, net-zero modeling, and sustainable energy management
- **IoT and cyber-physical systems** — Sensor-driven urban monitoring, real-time data integration, and cyber-physical digital twins for city-scale systems
- **Transportation and mobility** — Traffic simulation, autonomous vehicle integration, and urban mobility planning
- **Environmental monitoring** — Air quality, flood risk, water distribution networks, and climate resilience modeling
- **Construction and built environment** — Smart construction, BIM interoperability, and facility management

The dataset comprises **671 articles** from Scopus (2018–2024), with a strong concentration in recent years (286 articles in 2024 alone), reflecting the rapid growth of this research domain. The predominant disciplinary lens is engineering and computer science, which motivates this study's investigation into whether **decision support for public urban management** — a governance and administration perspective — remains an underexplored gap in the field.

## Academic Context

- **Institution:** COPPEAD/UFRJ — Instituto de Pós-Graduação e Pesquisa em Administração
- **Program:** Doctoral Program in Business Administration
- **Course:** ADM 804 — Introdução ao Pacote Estatístico R (Introduction to the R Statistical Package)
- **Target Journal:** [Cities](https://www.sciencedirect.com/journal/cities) (Elsevier, Q1/A1)
- **Broader Context:** This bibliometric study serves as a foundational mapping for a doctoral thesis on digital twins as decision support tools for urban public management.

## Research Question

> *"How has the scientific production on digital twins applied to smart cities evolved between 2015 and 2024, and to what extent is the dimension of public management decision support represented in this literature?"*

## Methodology

- **Approach:** Systematic bibliometrics using the R `bibliometrix` package
- **Data Sources:** Scopus and Web of Science (WoS)
- **Search String (Scopus):** `TITLE-ABS-KEY("digital twin*" AND ("smart cit*" OR "urban*"))`
- **Search String (WoS):** `Title = ("digital twin*" AND ("smart cit*" OR "urban*")) OR Abstract = ("digital twin*" AND ("smart cit*" OR "urban*")) OR Keyword = ("digital twin*" AND ("smart cit*" OR "urban*"))`
- **Filters:** Article, English (no year filter applied — the search covered all available years; the earliest result found was 2017, confirming the field's emergence)
- **Theoretical Positioning:** Critical realism (ontology), Pragmatism (epistemology), Engaged Scholarship (Van de Ven)
- **Reporting:** PRISMA-compliant protocol

### Data Source Asymmetry

| Aspect | Scopus | Web of Science |
|--------|--------|----------------|
| Articles retrieved | 671 | 1,052 |
| Export format | BibTeX (.bib) | BibTeX (.bib) |
| Cited references included | No | Yes |
| Analyses enabled | Descriptive, keywords, collaboration | All, including co-citation and bibliographic coupling |

Both sources are combined with automated deduplication via `bibliometrix::mergeDbSources()`, followed by manual screening (title/abstract) for relevance using Parsif.al. The final PRISMA flow diagram documents all inclusion/exclusion steps.

## Project Structure

```
bibliometria-de-gemeos-digitais/
│
├── README.md                          # Project documentation (this file)
├── execucao.md                        # Execution plan and timeline (Portuguese)
│
├── data/
│   ├── raw/                           # Raw data exported from Scopus (.bib, .csv)
│   └── processed/                     # Cleaned data processed by R
│
├── output/
│   ├── figures/                       # Generated plots and visualizations
│   └── tables/                        # Exported tables
│
├── manuscript/
│   └── highlights.md                  # Required highlights for Cities journal
│
└── R/
    ├── 00_setup.qmd                   # Package installation and configuration
    ├── 01_data_import.qmd             # Data import and cleaning from Scopus
    ├── 02_descriptive_analysis.qmd    # Scientific production analysis
    ├── 03_network_analysis.qmd        # Co-citation and collaboration networks
    ├── 04_keyword_analysis.qmd        # Keyword co-occurrence and thematic map
    └── 05_results_summary.qmd         # Results synthesis for manuscript
```

## Reproducing This Project

### Prerequisites

- **R** ≥ 4.3.0
- **RStudio** (recommended) or any IDE with Quarto support
- **Quarto** ≥ 1.3

### Step-by-step

1. **Clone the repository:**
   ```bash
   git clone https://github.com/<username>/bibliometria-de-gemeos-digitais.git
   cd bibliometria-de-gemeos-digitais
   ```

2. **Install R dependencies:**
   Open `R/00_setup.qmd` in RStudio and run it. This will install all required packages.

3. **Obtain data from Scopus:**
   - Access [Scopus](https://www.scopus.com/)
   - Run the search string documented in `R/01_data_import.qmd`
   - Export results in BibTeX (.bib) format
   - Save the file to `data/raw/`

4. **Run the analysis pipeline:**
   Execute the Quarto notebooks in order (`00` through `05`). Each notebook documents its inputs and outputs.

### Key Dependencies

| Package | Purpose |
|---------|---------|
| `bibliometrix` | Bibliometric analysis framework |
| `tidyverse` | Data manipulation and visualization |
| `ggplot2` | Scientific plotting |
| `igraph` | Network analysis |
| `ggraph` | Network visualization |
| `knitr` | Table formatting and reporting |
| `here` | Reproducible file paths |

## Project Status

🟡 **In development** — Data collection and analysis phase.

## License

This project is licensed under the [MIT License](LICENSE).

## Author

[Author Name] — Doctoral Student, COPPEAD/UFRJ

For questions or collaboration inquiries, please contact: [email@example.com]

---

*This project uses AI tools (Claude/Anthropic) for code assistance and text drafting. AI usage is fully disclosed in accordance with Elsevier's AI policy. AI is not listed as an author.*
