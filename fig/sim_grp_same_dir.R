source("./fig/setup.R")

for (i in 1:length(methods)) {
  methods[[i]]$method_arguments["alpha"] <- 0.05
}

simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_data_distribution", simulation_arguments = list(
                          n = 50, J = 75, K = 2, beta = c(1, 1, rep(0, 148)),
                          J1 = 1, K1 = 2, rho.g = 0.7, distribution = "group"
                        ), script_name = "distributions")

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

variables_of_interest <- c("G01_V1", "G01_V2", "G02_V1", "G02_V2", "G40_V1", "G40_V2", "G45_V1", "G45_V2", "G50_V1", "G50_V2")
pdf("./fig/sim_grp_same_dir.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()
