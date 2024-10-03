source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(
  simulation_function = "gen_data_abn",
  simulation_arguments = list(
    n = 100, p = 100, a = 1, b = 1, rho = 0.99,
    beta = 1
  )
)

data <- do.call(simulation_info$simulation_function, simulation_info$simulation_arguments)
truth_df <- data.frame(var = names(data$beta), truth = data$beta)

methods <- methods[c("pipe", "debiased", "normal_approx")]
results <- list()
for (i in 1:length(methods)) {
  results[[names(methods)[i]]] <- indexr::read_objects(rds_path, c(function_name = "sim", methods[[i]], simulation_info))$results %>%
    filter(iteration == 163)
  
}
# 1 selects a, 10 they are different, a still selected by mcp, 12 B1 is selected

pdf("./fig/sim_highcorr_example.pdf", height = 4, width = 6)
compare_methods(results, truth_df, vars = c("A1", "B1", "N1", "N2", "N3"))
dev.off()
