rm(list=ls())

res_dir <- switch(Sys.info()['user'],
                  'pbreheny' = '~/res/lasso-to-boot',
                  'loganharris' = '../lasso-to-boot')
devtools::load_all(res_dir)
rds_path <- glue::glue("{res_dir}/rds/")

packages <- c(
  "dplyr", "tidyr", "ggplot2", "kableExtra",
  "glue", "indexr", "hdrm", "stringr"
)

quietlyLoadPackage <- function(package) {
  suppressPackageStartupMessages(library(package, character.only = TRUE))
}
lapply(packages, quietlyLoadPackage)

colors <- palette()[c(2, 4, 3, 6, 7, 5)]
sec_colors <- c("black", "grey62")
background_colors <- c("#E2E2E2", "#F5F5F5")

methods <- list(
  "debiased" = list(method = "boot_ncv", method_arguments = list(penalty = "lasso", submethod = "debiased")),
  "pipe"  = list(method = "pipe_ncvreg", method_arguments = list()),
  "pipe_mcp"  = list(method = "pipe_ncvreg", method_arguments = list(penalty = "MCP")),
  "normal_approx"  = list(method = "pipe_ncvreg", method_arguments = list(original_n = TRUE)),
  "mcp_pipe"   = list(method = "posterior", method_arguments = list(penalty = "MCP", studentize = FALSE, adjust_ss = TRUE))
)
for (i in 1:length(methods)) {
  methods[[i]]$method_arguments["alpha"] <- 0.05
}