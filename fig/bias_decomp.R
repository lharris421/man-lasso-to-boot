## Setup and read in data
source("./fig/setup.R")

# Load simulation parameters and results
params <- list(
  seed = 1234,
  iterations = 1000,
  simulation_function = "gen_data_abn",
  simulation_arguments = list(
    n = 100, p = 100, a = 1, b = 0, rho = 0,
    beta = 2
  ),
  script_name = "bias_decomposition"
)

res <- indexr::read_objects(rds_path, params)

plots <- bias_decomp_plots(res, params)

# Create density plots using ggplot2
pdf("./fig/bias_decomp.pdf", height = 5, width = 7)
plots[[1]]
dev.off()

pdf("./fig/bias_decomp_orig.pdf", height = 5, width = 7)
plots[[2]]
dev.off()

pdf("./fig/bias_decomp_boot.pdf", height = 5, width = 7)
plots[[3]]
dev.off()
