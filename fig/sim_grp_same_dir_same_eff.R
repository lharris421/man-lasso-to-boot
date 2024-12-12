source("./fig/setup.R")

for (i in 1:length(methods)) {
  methods[[i]]$method_arguments["alpha"] <- 0.05
}

simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_data_distribution", simulation_arguments = list(
                          n = 100, J = 25, K = 4, beta = c(1, 1, 1, rep(0, 97)),
                          J1 = 1, K1 = 3, rho.g = 0.5, rho.gz = 0, distribution = "group"
                        ), script_name = "distributions")

## Load data back in
methods <- methods[c("pipe", "relaxed_lasso", "lasso_proj")]

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

variables_of_interest <- c("G01_V1", "G01_V2", "G01_V3", "G01_V4", "G10_V1", "G10_V2", "G10_V3", "G10_V4")
pdf("./fig/sim_grp_same_dir_same_eff.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()
