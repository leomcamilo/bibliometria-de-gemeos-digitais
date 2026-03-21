# Instalar pacotes necessários para o projeto bibliometria
# Execute este script no R 4.5.3 (Homebrew):
#   /opt/homebrew/Cellar/r/4.5.3/lib/R/bin/Rscript R/instalar_pacotes.R

pacotes <- c(
  "rmarkdown",
  "knitr",
  "here",
  "tidyverse",
  "ggplot2",
  "ggrepel",
  "igraph",
  "ggraph",
  "bibliometrix"
)

cat("=== Instalando pacotes no R", R.version$major, ".", R.version$minor, "===\n")
cat("Library path:", .libPaths()[1], "\n\n")

for (pkg in pacotes) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat(pkg, ": já instalado\n")
  } else {
    cat(pkg, ": instalando...\n")
    install.packages(pkg, repos = "https://cloud.r-project.org", dependencies = TRUE)
  }
}

cat("\n=== Verificação final ===\n")
for (pkg in pacotes) {
  ok <- requireNamespace(pkg, quietly = TRUE)
  cat(pkg, ":", ifelse(ok, "OK", "FALHOU"), "\n")
}
