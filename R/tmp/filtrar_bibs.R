library(here)
library(bibliometrix)

# 1. Ler os 3 CSVs e extrair ISSNs (sem filtro de quartil)
extrair_issns <- function(arquivo) {
  df <- read.csv2(arquivo, stringsAsFactors = FALSE)
  issns_raw <- unlist(strsplit(df$Issn, ",\\s*"))
  issns_raw <- trimws(gsub('"', '', issns_raw))
  issns_norm <- gsub("-", "", toupper(issns_raw))
  issns_norm[nchar(issns_norm) > 0]
}

issns <- unique(c(
  extrair_issns(here("data", "raw", "scimagojr 2024  Subject Category - Urban Studies.csv")),
  extrair_issns(here("data", "raw", "scimagojr 2024  Subject Category - Geography, Planning and Development.csv")),
  extrair_issns(here("data", "raw", "scimagojr 2024  Subject Area - Decision Sciences.csv"))
))
cat("ISSNs combinados (unicos):", length(issns), "\n\n")

# 2. Funcao para filtrar .bib
filtrar_bib <- function(arquivo, issns_ref) {
  linhas <- readLines(arquivo, warn = FALSE)
  inicio <- grep("^@", linhas)
  if (length(inicio) == 0) return(list(linhas = character(0), n = 0))
  fim <- c(inicio[-1] - 1, length(linhas))

  filtradas <- character(0)
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
    if (any(issns_bib %in% issns_ref)) {
      filtradas <- c(filtradas, bloco, "")
    }
  }
  list(linhas = filtradas, n = sum(grepl("^@", filtradas)))
}

# 3. Filtrar
scopus_filt <- filtrar_bib(here("data", "raw", "scopus_2.bib"), issns)
cat("scopus_2.bib -> scopus_2_filt.bib:", scopus_filt$n, "artigos\n")

wos_filt <- filtrar_bib(here("data", "raw", "savedrecs.bib"), issns)
cat("savedrecs.bib -> wos_2_filt.bib:", wos_filt$n, "artigos\n")

cat("Total bruto (antes de dedup):", scopus_filt$n + wos_filt$n, "\n\n")

# 4. Salvar
writeLines(scopus_filt$linhas, here("data", "processed", "scopus_2_filt.bib"))
writeLines(wos_filt$linhas, here("data", "processed", "wos_2_filt.bib"))
cat("Arquivos salvos em data/processed/\n\n")

# 5. Dedup via bibliometrix
df_s <- convert2df(here("data", "processed", "scopus_2_filt.bib"), dbsource = "scopus", format = "bibtex")
df_w <- convert2df(here("data", "processed", "wos_2_filt.bib"), dbsource = "wos", format = "bibtex")
df_m <- mergeDbSources(df_s, df_w, remove.duplicated = TRUE)
cat("\nApos deduplicacao entre bases:", nrow(df_m), "artigos\n")
