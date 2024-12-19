source("./fig/setup.R")

for (i in 1:length(methods)) {
  methods[[i]]$method_arguments["alpha"] <- 0.05
}

simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_data_distribution", simulation_arguments = list(
                          n = 50, J = 15, K = 10, beta = c(rep(1, 50), rep(-1, 50), rep(0, 50)),
                          J1 = 10, K1 = 10, rho.g = 0.7, distribution ="group"
                        ), script_name = "distributions")

simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_data_distribution", simulation_arguments = list(
                          n = 50, J = 50, K = 3, beta = c(rep(0.5, 48), rep(-0.5, 48), rep(0, 54)),
                          J1 = 32, K1 = 3, rho.g = 0.5, distribution = "group"
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

variables_of_interest <- c("G01_V1", "G01_V2", "G01_V3", "G33_V1", "G33_V2", "G33_V3")
pdf("./fig/sim_grp_many_small_cor.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest) + coord_cartesian(ylim = c(-10, 10))
dev.off()
