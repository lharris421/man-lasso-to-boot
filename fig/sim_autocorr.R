source("./fig/setup.R")

for (i in 1:length(methods)) {
  methods[[i]]$method_arguments["alpha"] <- 0.05
}

simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_data_distribution", simulation_arguments = list(
                          n = 200, p = 3000, beta = c(rep(c(0, 0, 0, 0, 1, 0, 0, 0, 0, 0), 30), rep(0, 2700)),
                          rho = 0.6, corr = "autoregressive"
                        ), script_name = "distributions")

## Adjusting betas to be larger has same eff

## Load data back in
methods <- methods[c("pipe")]

files <- expand.grid(
  "method" = names(methods),
  stringsAsFactors = FALSE
)

results <- list()
for (i in 1:nrow(files)) {
  
  results[[i]] <- indexr::read_objects(
    rds_path,
    c(methods[[files[i,"method"]]], simulation_info)
  ) %>%
    mutate(method = files[i,,drop=FALSE] %>% pull(method))
}

variables_of_interest <- c("V0001", "V0002", "V0003", "V0004", "V0005", "V0006", "V0007", "V0008", "V0009", "V0010")
pdf("./fig/sim_autocorr.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()
