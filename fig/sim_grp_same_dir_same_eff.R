source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(
  simulation_function = "gen_data_grp",
  simulation_arguments = list(
    n = 100, J = 25, K = 4, beta = c(1, 1, 1, rep(0, 97)),
    J1 = 1, K1 = 3, rho.g = 0.5, rho.gz = 0 # K1 doesn't actually matter here (not used)
  )
)

## Load data back in
methods <- methods[c("debiased", "normal_approx", "pipe", "relaxed_lasso")]
results <- list()
for (i in 1:length(methods)) {
  results[[names(methods)[i]]] <- indexr::read_objects(
    rds_path, 
    c(function_name = "sim", methods[[i]], simulation_info)
  )$results %>%
    mutate(method = names(methods)[i])
}

variables_of_interest <- c("G01_V1", "G01_V2", "G01_V3", "G01_V4", "G10_V1", "G10_V2", "G10_V3", "G10_V4")
pdf("./fig/sim_grp_same_dir_same_eff.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()
