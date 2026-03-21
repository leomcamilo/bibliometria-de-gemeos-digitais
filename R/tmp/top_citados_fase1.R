library(bibliometrix)

cat("=== Carregando Scopus (Fase 1) ===\n")
scopus <- convert2df("data/raw/fase1/scopus_1.bib", dbsource = "scopus", format = "bibtex")
cat("Scopus:", nrow(scopus), "artigos\n\n")

cat("=== Carregando WoS (Fase 1) ===\n")
wos <- convert2df("data/raw/fase1/wos_completo_1.bib", dbsource = "wos", format = "bibtex")
cat("WoS:", nrow(wos), "artigos\n\n")

cat("=== Deduplicando ===\n")
merged <- mergeDbSources(scopus, wos, remove.duplicated = TRUE)
cat("Corpus unico:", nrow(merged), "artigos\n\n")

# Top 20 mais citados
cat("=== TOP 20 ARTIGOS MAIS CITADOS (corpus Fase 1 completo) ===\n\n")
merged$TC <- as.numeric(merged$TC)
top <- merged[order(-merged$TC), ]
top20 <- head(top, 20)

for (i in 1:nrow(top20)) {
  r <- top20[i, ]
  au <- if (is.na(r$AU)) "NA" else as.character(r$AU)
  ti <- if (is.na(r$TI)) "NA" else substr(as.character(r$TI), 1, 90)
  so <- if (is.na(r$SO)) "NA" else as.character(r$SO)
  py <- if (is.na(r$PY)) "NA" else as.character(r$PY)
  tc <- if (is.na(r$TC)) "NA" else as.character(r$TC)
  di <- if (is.na(r$DI)) "NA" else as.character(r$DI)
  
  cat(sprintf("%2d. [TC=%s] %s (%s)\n", i, tc, au, py))
  cat(sprintf("    \"%s\"\n", ti))
  cat(sprintf("    Journal: %s\n", so))
  cat(sprintf("    DOI: %s\n\n", di))
}

# Distribuicao de journals no top 20
cat("\n=== JOURNALS DOS TOP 20 ===\n")
journals_top20 <- table(top20$SO)
journals_top20 <- sort(journals_top20, decreasing = TRUE)
for (j in names(journals_top20)) {
  cat(sprintf("  %s: %d\n", j, journals_top20[j]))
}

# Top 50 - quais journals concentram os mais citados
cat("\n=== TOP JOURNALS NOS 50 MAIS CITADOS ===\n")
top50 <- head(top, 50)
journals_top50 <- table(top50$SO)
journals_top50 <- sort(journals_top50, decreasing = TRUE)
for (j in names(journals_top50)) {
  cat(sprintf("  %s: %d\n", j, journals_top50[j]))
}
