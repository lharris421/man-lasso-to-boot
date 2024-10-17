source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(
  simulation_function = "gen_data_grp",
  simulation_arguments = list(
    n = 100, J = 50, K = 2, beta = c(0.8, 0.2, rep(0, 98)),
    J1 = 1, K1 = 2, rho.g = 0.5, rho.gz = 0 # K1 doesn't actually matter here (not used)
  )
)

## Load data back in
methods <- methods[c("debiased", "normal_approx", "pipe")]
results <- list()
for (i in 1:length(methods)) {
  results[[names(methods)[i]]] <- indexr::read_objects(
    rds_path, 
    c(function_name = "sim", methods[[i]], simulation_info)
  )$results %>%
    mutate(method = names(methods)[i])
}

variables_of_interest <- c("G01_V1", "G01_V2", "G02_V1", "G02_V2", "G40_V1", "G40_V2", "G45_V1", "G45_V2", "G50_V1", "G50_V2")
pdf("./fig/sim_grp_same_dir.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()
