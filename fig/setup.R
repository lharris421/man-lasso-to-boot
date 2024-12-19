rm(list=ls())

res_dir <- switch(Sys.info()['user'],
                  'pbreheny' = '~/res/lasso-boot',
                  'loganharris' = '../lasso-boot')

devtools::load_all(res_dir)
rds_path <- glue::glue("{res_dir}/rds/")

packages <- c(
  "dplyr", "tidyr", "ggplot2", "kableExtra",
  "glue", "indexr", "hdrm", "stringr",
  "patchwork", "mgcv"
)

quietlyLoadPackage <- function(package) {
  suppressPackageStartupMessages(library(package, character.only = TRUE))
}
lapply(packages, quietlyLoadPackage)

colors <- palette()[c(2, 4, 3, 6, 7, 5)]
sec_colors <- c("black", "grey62")
background_colors <- c("#E2E2E2", "#F5F5F5")

methods_pretty <- c(
  "lasso_boot" = "Hybrid",
  "lasso_boot_reed" = "Hybrid",
  "lasso" = "PIPE Posterior"
)
methods <- list(
  "debiased" = list(method = "boot_ncv", method_arguments = list(penalty = "lasso", submethod = "debiased")),
  "pipe"  = list(method = "pipe_ncvreg", method_arguments = list()),
  "pipe_mcp"  = list(method = "pipe_ncvreg", method_arguments = list(penalty = "MCP")),
  "normal_approx"  = list(method = "pipe_ncvreg", method_arguments = list(original_n = TRUE)),
  "mcp_pipe"   = list(method = "posterior", method_arguments = list(penalty = "MCP", adjust_ss = TRUE)),
  "mcp_cond"   = list(method = "posterior", method_arguments = list(penalty = "MCP", adjust_ss = TRUE, relaxed = TRUE)),
  "relaxed_lasso"  = list(method = "pipe_ncvreg", method_arguments = list(relaxed = TRUE)),
  "lasso_boot" = list(method = "boot_ncv", method_arguments = list(penalty = "lasso", submethod = "hybrid")),
  "mcp_boot" = list(method = "boot_ncv", method_arguments = list(penalty = "MCP", submethod = "hybrid")),
  "lasso" = list(method = "pipe_ncvreg", method_arguments = list(posterior = TRUE)),
  "mcp"   = list(method = "posterior", method_arguments = list(penalty = "MCP")),
  "lasso_relaxed" = list(method = "posterior", method_arguments = list(penalty = "lasso", relaxed = TRUE)),
  "mcp_relaxed"   = list(method = "posterior", method_arguments = list(penalty = "MCP", relaxed = TRUE)),
  "lasso_proj" = list(method = "lp", method_arguments = list()),
  "lasso_boot_reed" = list(method = "boot_ncv", method_arguments = list(penalty = "lasso", submethod = "hybrid", sigma2_reed = TRUE))
  # "pipe_poisson" = list(method = "pipe", method_arguments = list(family = "poisson", level = 0.95)),
  # "pipe_binomial" = list(method = "pipe", method_arguments = list(family = "binomial", level = 0.95)),
  # "pipe"  = list(method = "pipe", method_arguments = list(level = 0.95, penalty = "lasso"))
)
for (i in 1:length(methods)) {
  methods[[i]]$method_arguments["alpha"] <- 0.05
}