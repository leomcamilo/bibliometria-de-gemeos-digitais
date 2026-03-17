library(bibliometrix)
library(here)

# Importar dados do Scopus
scopus <- convert2df(here("data", "raw", "scopus.bib"),
                     dbsource = "scopus", format = "bibtex")

# Importar dados do WoS
wos <- convert2df(here("data", "raw", "wos_completo.bib"),
                  dbsource = "wos", format = "bibtex")

# Números brutos
cat("Scopus:", nrow(scopus), "\n")
cat("WoS:", nrow(wos), "\n")

# Deduplicação
combinado <- mergeDbSources(scopus, wos, remove.duplicated = TRUE)
cat("Após deduplicação:", nrow(combinado), "\n")
cat("Duplicatas:", nrow(scopus) + nrow(wos) - nrow(combinado), "\n")

# Visualizar estrutura
str(combinado, max.level = 1)

# Salvar resultado (opcional - ao final, quando definir a estratégia)
# saveRDS(combinado, here("data", "processed", "df_bibliometria.rds"))
