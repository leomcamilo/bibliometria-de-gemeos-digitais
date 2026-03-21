# Planejamento e Execução — Bibliometria de Gêmeos Digitais

## Objetivo do Artigo

Este artigo realiza uma análise bibliométrica sistemática da literatura sobre gêmeos digitais aplicados a cidades inteligentes (2015–2024), utilizando o pacote `bibliometrix` no R. O objetivo central é mapear a evolução da produção científica nesse campo e identificar em que medida a dimensão de suporte à decisão gerencial pública está representada na literatura. O trabalho atende simultaneamente aos requisitos da disciplina ADM 804 (COPPEAD/UFRJ) e busca contribuir como artigo publicável na revista Cities (Elsevier, Q1/A1), servindo ainda como estudo exploratório para a tese de doutorado do autor.

---

## Cronograma

| Semana | Período | Tarefa | Entregável | Status |
|--------|---------|--------|------------|--------|
| 1–2 | Sem. 1–2 | Coleta de dados no Scopus/WoS + setup do R | `data/raw/` populada, `00_setup.qmd` funcional | ✅ |
| 3–4 | Sem. 3–4 | Importação, limpeza e análises descritivas | `01_data_import.qmd`, `02_descriptive_analysis.qmd`, figuras | ✅ |
| 5–6 | Sem. 5–6 | Análises de rede e keywords | `03_network_analysis.qmd`, `04_keyword_analysis.qmd`, mapas temáticos | ✅ |
| 6–7 | Sem. 6–7 | Artigo consolidado com todas as análises | `R/artigo.qmd` renderizado para PDF | ✅ |
| 7–8 | Sem. 7–8 | Escrita: Metodologia + Resultados | Seções redigidas do manuscrito | ⏳ |
| 9 | Sem. 9 | Escrita: Introdução + Referencial Teórico + Conclusão | Draft completo do artigo | ⏳ |
| 10 | Sem. 10 | Revisão final + formatação Cities + submissão | Manuscrito final submetido | ⏳ |

**Legenda:** ⏳ Pendente · 🔄 Em andamento · ✅ Concluído

---

## Protocolo de Busca Bibliográfica

### Base de dados
- **Scopus** (Elsevier) — escolhida pela ampla cobertura de periódicos indexados em engenharia, tecnologia e gestão urbana.

### String de busca
```
TITLE-ABS-KEY("digital twin*" AND ("smart cit*" OR "urban*"))
```

### Filtros aplicados
- **Período:** 2015–2024
- **Tipo de documento:** Article
- **Idioma:** English

### Formato de exportação
- BibTeX (.bib) — para importação com `bibliometrix::convert2df()`
- Exportar **todos os campos** disponíveis (citações, abstract, keywords, afiliações, referências)

### Critérios PRISMA

| Etapa | Critério | Descrição |
|-------|----------|-----------|
| Identificação | String de busca | Aplicação da query no Scopus |
| Triagem | Tipo de documento | Apenas artigos (excluir conference papers, reviews, etc.) |
| Triagem | Idioma | Apenas em inglês |
| Triagem | Período | 2015–2024 |
| Elegibilidade | Relevância temática | Artigos efetivamente sobre gêmeos digitais em contexto urbano/cidades |
| Inclusão | Dataset final | Base limpa para análise bibliométrica |

### Dados a coletar do Scopus
- Autores, afiliação, país
- Título, abstract, keywords (autor e indexadas)
- Periódico, volume, páginas
- Ano de publicação
- Contagem de citações
- DOI
- Referências citadas

---

## Checklist de Submissão — Revista Cities (Elsevier)

### Requisitos do manuscrito
- [ ] Extensão: 7.000–9.000 palavras (excluindo referências e legendas)
- [ ] Idioma: Inglês
- [ ] Abstract estruturado, máximo ~250 palavras
- [ ] Keywords: 4–6 palavras-chave (evitar termos que já estão no título)
- [ ] Highlights: 3–5 bullets, máximo 85 caracteres cada, arquivo separado
- [ ] Referências no formato Elsevier (Harvard/APA, consistente)
- [ ] Figuras em alta resolução (mínimo 300 DPI)
- [ ] Legendas descritivas em todas as figuras e tabelas
- [ ] Declaração de conflito de interesses (mesmo que não haja)
- [ ] Datasets citados nas referências com tag [dataset]
- [ ] Declaração de uso de IA (obrigatória pela política Elsevier)
- [ ] IA não listada como autora

### Requisitos de submissão
- [ ] Formato do arquivo: .docx ou .tex
- [ ] Submissão via sistema Elsevier Editorial (EES)
- [ ] Cover letter (carta de apresentação ao editor)
- [ ] Suggested reviewers (2–3 revisores sugeridos)
- [ ] Arquivo de highlights separado
- [ ] Processo: double-blind peer review (remover identificação dos autores no manuscrito)

### Escopo da revista (verificar aderência)
- [x] Urban management e planejamento urbano
- [x] Technological innovation and urban planning
- [x] Public-private cooperation
- [x] Smart cities e decisão pública

---

## Anotações e Decisões Metodológicas

*Registre aqui as decisões tomadas ao longo do projeto, justificando cada escolha.*

| Data | Decisão | Justificativa |
|------|---------|---------------|
| | | |

---

## Próximos Passos

### Concluídos

1. ✅ ~~Decidir query + filtro definitivos~~ — query Fase 3 + filtro combinado 3 categorias SCImago (159 artigos)
2. ✅ ~~Exportar .bib filtrados~~ — `scopus_2_filt.bib` e `wos_2_filt.bib` gerados
3. ✅ ~~Configurar ambiente R e renderizar pipeline~~ — Todos os 7 QMDs renderizados com sucesso
4. ✅ ~~Adaptar `01_data_import.qmd` para corpus filtrado~~ — paths atualizados para `scopus_2_filt.bib` + `wos_2_filt.bib`
5. ✅ ~~Criar `R/artigo.qmd` consolidado~~ — todas as 10 análises do professor + exploratórias, renderizado para PDF

### Pendentes

6. ⏳ **Rerodar QMDs individuais (02–06) com corpus filtrado** — os QMDs 02–06 ainda usam `df_bibliometria.rds` antigo (767 artigos sem filtro de journal); precisam ser rerodados após `01_data_import.qmd` gerar novo .rds com 159 artigos
7. ⏳ **Ler 2–3 reviews existentes** — Deng et al. (2021, TC=515), Weil et al. (2023, TC=213) — para posicionar o artigo na literatura
8. ⏳ Importar .bib filtrados no Parsif.al para triagem PRISMA (título/abstract screening)
9. ⏳ BERTopic no Google Colab — análise de tópicos por modelagem de linguagem
10. ⏳ Gerar PRISMA flowchart definitivo (valores do Parsif.al + DiagrammeR R)
11. ⏳ VOSviewer — visualizações de redes complementares
12. ⏳ Escrita do manuscrito final — adaptar `artigo.qmd` para formato da revista Cities (7.000–9.000 palavras)
13. ⏳ Revisão final + formatação + submissão
