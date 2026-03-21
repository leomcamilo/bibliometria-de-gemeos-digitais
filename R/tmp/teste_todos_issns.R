#!/usr/bin/env Rscript
# Teste: filtrar os .bib usando TODOS os ISSNs do CSV SCImago Urban Studies
# (todos os quartis: Q1-Q4) e verificar quantos artigos ficam após deduplicação.

library(here)
library(bibliometrix)

# ─── 1. Ler ISSNs do CSV ────────────────────────────────────────────────────
csv_path <- here("data", "raw", "scimagojr 2024  Subject Category - Urban Studies.csv")
scimago <- read.csv2(csv_path, stringsAsFactors = FALSE)

cat("Total de journals no CSV:", nrow(scimago), "\n")
cat("Por quartil:\n")
print(table(scimago$SJR.Quartile, useNA = "ifany"))

# Extrair e normalizar todos os ISSNs (campo Issn pode ter vários separados por ", ")
issns_raw <- unlist(strsplit(scimago$Issn, ",\\s*"))
issns_raw <- trimws(gsub('"', '', issns_raw))
issns_norm <- gsub("-", "", toupper(issns_raw))
issns_norm <- issns_norm[nchar(issns_norm) > 0]

cat("\nTotal de ISSNs extraídos do CSV:", length(issns_norm), "\n")

# Separar ISSNs apenas Q1
scimago_q1 <- scimago[scimago$SJR.Quartile == "Q1", ]
issns_q1_raw <- unlist(strsplit(scimago_q1$Issn, ",\\s*"))
issns_q1_raw <- trimws(gsub('"', '', issns_q1_raw))
issns_q1_norm <- gsub("-", "", toupper(issns_q1_raw))
issns_q1_norm <- issns_q1_norm[nchar(issns_q1_norm) > 0]

cat("Total de ISSNs Q1:", length(issns_q1_norm), "\n")

# ─── 2. Função de filtro por ISSN ───────────────────────────────────────────
filtrar_bib_por_issn <- function(arquivo_bib, issns_norm) {
  linhas <- readLines(arquivo_bib, warn = FALSE)
  inicio <- grep("^@", linhas)
  if (length(inicio) == 0) return(character(0))
  fim <- c(inicio[-1] - 1, length(linhas))
  
  entradas_filtradas <- character(0)
  for (i in seq_along(inicio)) {
    bloco <- linhas[inicio[i]:fim[i]]
    bloco_texto <- paste(bloco, collapse = " ")
    issn_matches <- regmatches(
      bloco_texto,
      gregexpr("(?:issn|eissn)\\s*=\\s*\\{([^}]+)\\}", bloco_texto, ignore.case = TRUE)
    )[[1]]
    if (length(issn_matches) == 0) next
    issns_bib <- gsub("(?:issn|eissn)\\s*=\\s*\\{|\\}", "", issn_matches, ignore.case = TRUE)
    issns_bib <- gsub("-", "", toupper(trimws(issns_bib)))
    if (any(issns_bib %in% issns_norm)) {
      entradas_filtradas <- c(entradas_filtradas, bloco, "")
    }
  }
  return(entradas_filtradas)
}

# ─── 3. Filtrar com TODOS os ISSNs ──────────────────────────────────────────
cat("\n========================================\n")
cat("  TESTE: TODOS OS ISSNs (Q1-Q4)\n")
cat("========================================\n\n")

arquivo_scopus <- here("data", "raw", "scopus_2.bib")
arquivo_wos <- here("data", "raw", "savedrecs.bib")

bib_scopus_all <- filtrar_bib_por_issn(arquivo_scopus, issns_norm)
bib_wos_all <- filtrar_bib_por_issn(arquivo_wos, issns_norm)

n_scopus_all <- sum(grepl("^@", bib_scopus_all))
n_wos_all <- sum(grepl("^@", bib_wos_all))

cat("Scopus (todos ISSNs):", n_scopus_all, "\n")
cat("WoS (todos ISSNs):   ", n_wos_all, "\n")
cat("Total bruto:         ", n_scopus_all + n_wos_all, "\n\n")

# Salvar temporariamente para deduplicar
tmp_scopus <- tempfile(fileext = ".bib")
tmp_wos <- tempfile(fileext = ".bib")
writeLines(bib_scopus_all, tmp_scopus)
writeLines(bib_wos_all, tmp_wos)

# Deduplicar com bibliometrix
scopus_df <- tryCatch(convert2df(tmp_scopus, dbsource = "scopus", format = "bibtex"), error = function(e) NULL)
wos_df <- tryCatch(convert2df(tmp_wos, dbsource = "wos", format = "bibtex"), error = function(e) NULL)

if (!is.null(scopus_df) && !is.null(wos_df)) {
  merged <- mergeDbSources(scopus_df, wos_df, remove.duplicated = TRUE)
  n_dedup <- nrow(merged)
  n_dupes <- (n_scopus_all + n_wos_all) - n_dedup
  cat("Após deduplicação:   ", n_dedup, "\n")
  cat("Duplicatas removidas:", n_dupes, "\n")
} else {
  cat("Erro ao converter — verificar manualmente\n")
  if (is.null(scopus_df)) cat("  Scopus df falhou\n")
  if (is.null(wos_df)) cat("  WoS df falhou\n")
}

# ─── 4. Comparar com filtro Q1 apenas ───────────────────────────────────────
cat("\n========================================\n")
cat("  COMPARAÇÃO: APENAS Q1\n")
cat("========================================\n\n")

bib_scopus_q1 <- filtrar_bib_por_issn(arquivo_scopus, issns_q1_norm)
bib_wos_q1 <- filtrar_bib_por_issn(arquivo_wos, issns_q1_norm)

n_scopus_q1 <- sum(grepl("^@", bib_scopus_q1))
n_wos_q1 <- sum(grepl("^@", bib_wos_q1))

cat("Scopus (Q1):         ", n_scopus_q1, "\n")
cat("WoS (Q1):            ", n_wos_q1, "\n")
cat("Total bruto Q1:      ", n_scopus_q1 + n_wos_q1, "\n\n")

tmp_scopus_q1 <- tempfile(fileext = ".bib")
tmp_wos_q1 <- tempfile(fileext = ".bib")
writeLines(bib_scopus_q1, tmp_scopus_q1)
writeLines(bib_wos_q1, tmp_wos_q1)

scopus_q1_df <- tryCatch(convert2df(tmp_scopus_q1, dbsource = "scopus", format = "bibtex"), error = function(e) NULL)
wos_q1_df <- tryCatch(convert2df(tmp_wos_q1, dbsource = "wos", format = "bibtex"), error = function(e) NULL)

if (!is.null(scopus_q1_df) && !is.null(wos_q1_df)) {
  merged_q1 <- mergeDbSources(scopus_q1_df, wos_q1_df, remove.duplicated = TRUE)
  n_dedup_q1 <- nrow(merged_q1)
  n_dupes_q1 <- (n_scopus_q1 + n_wos_q1) - n_dedup_q1
  cat("Após deduplicação Q1:", n_dedup_q1, "\n")
  cat("Duplicatas removidas:", n_dupes_q1, "\n")
}

# ─── 5. Teste intermediário: Q1 + Q2 ────────────────────────────────────────
cat("\n========================================\n")
cat("  TESTE: Q1 + Q2\n")
cat("========================================\n\n")

scimago_q1q2 <- scimago[scimago$SJR.Quartile %in% c("Q1", "Q2"), ]
issns_q1q2_raw <- unlist(strsplit(scimago_q1q2$Issn, ",\\s*"))
issns_q1q2_raw <- trimws(gsub('"', '', issns_q1q2_raw))
issns_q1q2_norm <- gsub("-", "", toupper(issns_q1q2_raw))
issns_q1q2_norm <- issns_q1q2_norm[nchar(issns_q1q2_norm) > 0]

bib_scopus_q1q2 <- filtrar_bib_por_issn(arquivo_scopus, issns_q1q2_norm)
bib_wos_q1q2 <- filtrar_bib_por_issn(arquivo_wos, issns_q1q2_norm)

n_scopus_q1q2 <- sum(grepl("^@", bib_scopus_q1q2))
n_wos_q1q2 <- sum(grepl("^@", bib_wos_q1q2))

cat("Scopus (Q1+Q2):      ", n_scopus_q1q2, "\n")
cat("WoS (Q1+Q2):         ", n_wos_q1q2, "\n")
cat("Total bruto Q1+Q2:   ", n_scopus_q1q2 + n_wos_q1q2, "\n\n")

tmp_scopus_q1q2 <- tempfile(fileext = ".bib")
tmp_wos_q1q2 <- tempfile(fileext = ".bib")
writeLines(bib_scopus_q1q2, tmp_scopus_q1q2)
writeLines(bib_wos_q1q2, tmp_wos_q1q2)

scopus_q1q2_df <- tryCatch(convert2df(tmp_scopus_q1q2, dbsource = "scopus", format = "bibtex"), error = function(e) NULL)
wos_q1q2_df <- tryCatch(convert2df(tmp_wos_q1q2, dbsource = "wos", format = "bibtex"), error = function(e) NULL)

if (!is.null(scopus_q1q2_df) && !is.null(wos_q1q2_df)) {
  merged_q1q2 <- mergeDbSources(scopus_q1q2_df, wos_q1q2_df, remove.duplicated = TRUE)
  n_dedup_q1q2 <- nrow(merged_q1q2)
  n_dupes_q1q2 <- (n_scopus_q1q2 + n_wos_q1q2) - n_dedup_q1q2
  cat("Após deduplicação:   ", n_dedup_q1q2, "\n")
  cat("Duplicatas removidas:", n_dupes_q1q2, "\n")
}

# ─── 6. Resumo final ────────────────────────────────────────────────────────
cat("\n\n========================================\n")
cat("  RESUMO COMPARATIVO\n")
cat("========================================\n")
cat("Meta do professor: 110-130 artigos após deduplicação\n\n")
cat(sprintf("%-20s  Bruto  Dedup\n", "Cenário"))
cat(sprintf("%-20s  %5d  %5d\n", "Q1 apenas", n_scopus_q1 + n_wos_q1, ifelse(exists("n_dedup_q1"), n_dedup_q1, NA)))
cat(sprintf("%-20s  %5d  %5d\n", "Q1 + Q2", n_scopus_q1q2 + n_wos_q1q2, ifelse(exists("n_dedup_q1q2"), n_dedup_q1q2, NA)))
cat(sprintf("%-20s  %5d  %5d\n", "Todos (Q1-Q4)", n_scopus_all + n_wos_all, ifelse(exists("n_dedup"), n_dedup, NA)))
cat("========================================\n")
