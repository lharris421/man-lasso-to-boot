source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(
  simulation_function = "gen_data_grp",
  simulation_arguments = list(
    n = 100, J = 20, K = 5, beta = 0.5,
    J1 = 2, K1 = 3, SNR = 1, rho.g = 0.5
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

results$pipe %>%
  filter(stringr::str_detect(variable, "G01")) %>%
  mutate(selected = betahat != 0) %>%
  group_by(variable) %>%
  summarise(prop_selected = mean(selected))
  

variables_of_interest <- c("G01_V1", "G01_V2", "G01_V3", "G01_V4", "G01_V5", "G10_V1", "G10_V2", "G10_V3", "G10_V4", "G10_V5")
pdf("./fig/sim_grp_opposite_dir.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()
