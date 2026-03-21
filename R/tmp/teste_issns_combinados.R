#!/usr/bin/env Rscript
# Fase 8: Combinar ISSNs de 3 categorias SCImago e testar cobertura dos top citados
# Categorias:
#   1. Urban Studies (Subject Category)
#   2. Geography, Planning and Development (Subject Category)
#   3. Decision Sciences (Subject Area)

library(here)
library(bibliometrix)

# ─── 1. Ler os 3 CSVs do SCImago ────────────────────────────────────────────

csv_urban <- here("data", "raw", "scimagojr 2024  Subject Category - Urban Studies.csv")
csv_geo   <- here("data", "raw", "scimagojr 2024  Subject Category - Geography, Planning and Development.csv")
csv_dec   <- here("data", "raw", "scimagojr 2024  Subject Area - Decision Sciences.csv")

scimago_urban <- read.csv2(csv_urban, stringsAsFactors = FALSE)
scimago_geo   <- read.csv2(csv_geo,   stringsAsFactors = FALSE)
scimago_dec   <- read.csv2(csv_dec,   stringsAsFactors = FALSE)

cat("=== RESUMO DOS CSVs SCImago 2024 ===\n\n")
cat("Urban Studies:                     ", nrow(scimago_urban), "journals\n")
cat("Geography, Planning & Development: ", nrow(scimago_geo),   "journals\n")
cat("Decision Sciences:                 ", nrow(scimago_dec),   "journals\n\n")

# ─── 2. Extrair e normalizar ISSNs ──────────────────────────────────────────

extrair_issns <- function(df, nome) {
  issns_raw <- unlist(strsplit(df$Issn, ",\\s*"))
  issns_raw <- trimws(gsub('"', '', issns_raw))
  issns_norm <- gsub("-", "", toupper(issns_raw))
  issns_norm <- issns_norm[nchar(issns_norm) > 0]
  cat(sprintf("  %s: %d ISSNs extraídos\n", nome, length(issns_norm)))
  return(issns_norm)
}

cat("ISSNs extraídos por categoria:\n")
issns_urban <- extrair_issns(scimago_urban, "Urban Studies")
issns_geo   <- extrair_issns(scimago_geo,   "Geography, Planning & Dev")
issns_dec   <- extrair_issns(scimago_dec,   "Decision Sciences")

# Combinar e deduplicar
issns_combinados <- unique(c(issns_urban, issns_geo, issns_dec))
cat(sprintf("\nTotal ISSNs combinados (únicos): %d\n", length(issns_combinados)))
cat(sprintf("  Somente Urban Studies: %d\n", length(issns_urban)))
cat(sprintf("  + Geography, Planning & Dev: %d novos\n", 
            length(setdiff(issns_geo, issns_urban))))
cat(sprintf("  + Decision Sciences: %d novos\n", 
            length(setdiff(issns_dec, c(issns_urban, issns_geo)))))

# Overlap entre categorias
cat("\nOverlap entre categorias:\n")
cat(sprintf("  Urban ∩ Geography: %d ISSNs\n", length(intersect(issns_urban, issns_geo))))
cat(sprintf("  Urban ∩ Decision:  %d ISSNs\n", length(intersect(issns_urban, issns_dec))))
cat(sprintf("  Geography ∩ Decision: %d ISSNs\n", length(intersect(issns_geo, issns_dec))))

# ─── 3. Carregar corpus Fase 1 e analisar top citados ───────────────────────

cat("\n=== CARREGANDO CORPUS FASE 1 ===\n\n")

scopus <- convert2df(here("data", "raw", "fase1", "scopus_1.bib"), 
                     dbsource = "scopus", format = "bibtex")
cat("Scopus:", nrow(scopus), "artigos\n")

wos <- convert2df(here("data", "raw", "fase1", "wos_completo_1.bib"), 
                  dbsource = "wos", format = "bibtex")
cat("WoS:", nrow(wos), "artigos\n")

merged <- mergeDbSources(scopus, wos, remove.duplicated = TRUE)
cat("Corpus único:", nrow(merged), "artigos\n\n")

# ─── 4. Extrair ISSNs do corpus e comparar ──────────────────────────────────

# Função para normalizar ISSN de um artigo
normalizar_issn_artigo <- function(issn_str) {
  if (is.na(issn_str) || issn_str == "") return(NA)
  issns <- unlist(strsplit(as.character(issn_str), "[;,]\\s*"))
  issns <- gsub("-", "", toupper(trimws(issns)))
  issns <- issns[nchar(issns) > 0]
  return(issns)
}

# Verificar se um artigo tem ISSN nos ISSNs combinados
artigo_em_issns <- function(issn_str, issns_ref) {
  issns_art <- normalizar_issn_artigo(issn_str)
  if (length(issns_art) == 0 || all(is.na(issns_art))) return(FALSE)
  any(issns_art %in% issns_ref)
}

# Verificar qual categoria contém o ISSN
categorias_artigo <- function(issn_str) {
  issns_art <- normalizar_issn_artigo(issn_str)
  if (length(issns_art) == 0 || all(is.na(issns_art))) return("Nenhuma")
  cats <- c()
  if (any(issns_art %in% issns_urban)) cats <- c(cats, "Urban Studies")
  if (any(issns_art %in% issns_geo))   cats <- c(cats, "Geo/Planning/Dev")
  if (any(issns_art %in% issns_dec))   cats <- c(cats, "Decision Sci")
  if (length(cats) == 0) return("Nenhuma")
  paste(cats, collapse = " + ")
}

# ─── 5. TOP 20 mais citados com categorias ──────────────────────────────────

cat("=== TOP 20 ARTIGOS MAIS CITADOS vs ISSNs COMBINADOS ===\n\n")

merged$TC <- as.numeric(merged$TC)
top <- merged[order(-merged$TC), ]
top20 <- head(top, 20)

# Determinar coluna de ISSN (pode ser ISSN ou SN)
issn_col <- if ("ISSN" %in% names(top20)) "ISSN" else if ("SN" %in% names(top20)) "SN" else NA

match_count <- 0
for (i in 1:nrow(top20)) {
  r <- top20[i, ]
  au <- if (is.na(r$AU)) "NA" else {
    autores <- unlist(strsplit(as.character(r$AU), ";"))[1]
    trimws(autores)
  }
  py <- if (is.na(r$PY)) "?" else as.character(r$PY)
  tc <- if (is.na(r$TC)) "?" else as.character(r$TC)
  so <- if (is.na(r$SO)) "NA" else as.character(r$SO)
  
  issn_val <- if (!is.na(issn_col)) as.character(r[[issn_col]]) else NA
  
  in_combined <- artigo_em_issns(issn_val, issns_combinados)
  cats <- categorias_artigo(issn_val)
  
  flag <- if (in_combined) "✅" else "❌"
  if (in_combined) match_count <- match_count + 1
  
  cat(sprintf("%2d. [TC=%4s] %s (%s) %s\n", i, tc, au, py, flag))
  cat(sprintf("    Journal: %s\n", so))
  cat(sprintf("    ISSN: %s | Categorias: %s\n\n", 
              ifelse(is.na(issn_val), "N/A", issn_val), cats))
}

cat(sprintf("\n=== RESULTADO: %d de 20 artigos seminais cobertos (%d%%) ===\n\n",
            match_count, round(match_count / 20 * 100)))

# ─── 6. Comparação: Urban Studies vs Combinado ──────────────────────────────

cat("=== COMPARAÇÃO DE COBERTURA (Top 20) ===\n\n")

urban_count <- sum(sapply(1:nrow(top20), function(i) {
  issn_val <- if (!is.na(issn_col)) as.character(top20[i, issn_col]) else NA
  artigo_em_issns(issn_val, issns_urban)
}))

combined_count <- match_count

cat(sprintf("  Urban Studies apenas: %d/20 (%d%%)\n", 
            urban_count, round(urban_count / 20 * 100)))
cat(sprintf("  Combinado (Urban + Geo + Decision): %d/20 (%d%%)\n", 
            combined_count, round(combined_count / 20 * 100)))
cat(sprintf("  Ganho com categorias adicionais: +%d artigos\n\n", 
            combined_count - urban_count))

# ─── 7. Top 50 — cobertura ──────────────────────────────────────────────────

cat("=== COBERTURA NOS TOP 50 ===\n\n")

top50 <- head(top, 50)

urban_50 <- sum(sapply(1:nrow(top50), function(i) {
  issn_val <- if (!is.na(issn_col)) as.character(top50[i, issn_col]) else NA
  artigo_em_issns(issn_val, issns_urban)
}))

combined_50 <- sum(sapply(1:nrow(top50), function(i) {
  issn_val <- if (!is.na(issn_col)) as.character(top50[i, issn_col]) else NA
  artigo_em_issns(issn_val, issns_combinados)
}))

cat(sprintf("  Urban Studies apenas: %d/50 (%d%%)\n", 
            urban_50, round(urban_50 / 50 * 100)))
cat(sprintf("  Combinado (Urban + Geo + Decision): %d/50 (%d%%)\n", 
            combined_50, round(combined_50 / 50 * 100)))
cat(sprintf("  Ganho: +%d artigos\n\n", combined_50 - urban_50))

# ─── 8. Filtrar .bib da Fase 3 com ISSNs combinados ─────────────────────────

cat("=== TESTE DE VOLUME: ISSNs combinados na query Fase 3 ===\n\n")

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

arquivo_scopus <- here("data", "raw", "scopus_2.bib")
arquivo_wos    <- here("data", "raw", "savedrecs.bib")

# Urban Studies apenas
bib_scopus_urban <- filtrar_bib_por_issn(arquivo_scopus, issns_urban)
bib_wos_urban    <- filtrar_bib_por_issn(arquivo_wos, issns_urban)
n_urban <- sum(grepl("^@", bib_scopus_urban)) + sum(grepl("^@", bib_wos_urban))

# Combinado
bib_scopus_comb <- filtrar_bib_por_issn(arquivo_scopus, issns_combinados)
bib_wos_comb    <- filtrar_bib_por_issn(arquivo_wos, issns_combinados)
n_comb <- sum(grepl("^@", bib_scopus_comb)) + sum(grepl("^@", bib_wos_comb))

cat(sprintf("  Urban Studies (todos Q): %d artigos brutos\n", n_urban))
cat(sprintf("  Combinado (Urban + Geo + Decision, todos Q): %d artigos brutos\n", n_comb))
cat(sprintf("  Ganho: +%d artigos\n\n", n_comb - n_urban))

# Deduplicar combinado
tmp_scopus <- tempfile(fileext = ".bib")
tmp_wos    <- tempfile(fileext = ".bib")
writeLines(bib_scopus_comb, tmp_scopus)
writeLines(bib_wos_comb, tmp_wos)

n_scopus_comb <- sum(grepl("^@", bib_scopus_comb))
n_wos_comb    <- sum(grepl("^@", bib_wos_comb))

if (n_scopus_comb > 0 && n_wos_comb > 0) {
  df_scopus <- convert2df(tmp_scopus, dbsource = "scopus", format = "bibtex")
  df_wos    <- convert2df(tmp_wos, dbsource = "wos", format = "bibtex")
  df_merged <- mergeDbSources(df_scopus, df_wos, remove.duplicated = TRUE)
  cat(sprintf("  Após deduplicação: %d artigos\n\n", nrow(df_merged)))
} else if (n_scopus_comb > 0) {
  df_scopus <- convert2df(tmp_scopus, dbsource = "scopus", format = "bibtex")
  cat(sprintf("  Apenas Scopus: %d artigos\n\n", nrow(df_scopus)))
} else if (n_wos_comb > 0) {
  df_wos <- convert2df(tmp_wos, dbsource = "wos", format = "bibtex")
  cat(sprintf("  Apenas WoS: %d artigos\n\n", nrow(df_wos)))
} else {
  cat("  Nenhum artigo encontrado!\n\n")
}

# ─── 9. Journals fora das 3 categorias nos top 20 ───────────────────────────

cat("=== JOURNALS FORA DAS 3 CATEGORIAS (Top 20) ===\n")
cat("(Journals que seriam excluídos pelo filtro combinado)\n\n")

for (i in 1:nrow(top20)) {
  r <- top20[i, ]
  issn_val <- if (!is.na(issn_col)) as.character(r[[issn_col]]) else NA
  
  if (!artigo_em_issns(issn_val, issns_combinados)) {
    au <- if (is.na(r$AU)) "NA" else trimws(unlist(strsplit(as.character(r$AU), ";"))[1])
    py <- if (is.na(r$PY)) "?" else as.character(r$PY)
    tc <- if (is.na(r$TC)) "?" else as.character(r$TC)
    so <- if (is.na(r$SO)) "NA" else as.character(r$SO)
    cat(sprintf("  [TC=%s] %s (%s) — %s\n", tc, au, py, so))
  }
}

cat("\n=== FIM DA ANÁLISE ===\n")
