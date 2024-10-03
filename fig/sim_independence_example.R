source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(
  simulation_function = "gen_data",
  simulation_arguments = list(
    n = 100, p = 100,
    beta = c(-2, 2, -1, 1, -0.5, 0.5, -0.5, 0.5, rep(0, 92))
  )
)

data <- do.call(simulation_info$simulation_function, simulation_info$simulation_arguments)
truth_df <- data.frame(var = names(data$beta), truth = data$beta)

methods <- methods[c("debiased", "normal_approx")]
## Load data back in
results <- list()
for (i in 1:length(methods)) {
  results[[names(methods)[i]]] <- indexr::read_objects(rds_path, c(function_name = "sim", methods[[i]], simulation_info))$results %>%
    filter(iteration == 1)
}

variables_of_interest <- glue('V{stringr::str_pad(1:10, width = 3, pad = "0")}')
pdf("./fig/sim_independence_example.pdf", height = 4, width = 6)
compare_methods(results, vars = variables_of_interest)
dev.off()

results[["debiased"]]
