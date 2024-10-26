source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(
  simulation_function = "gen_data_abn",
  simulation_arguments = list(
    n = 100, p = 100, a = 8, b = 2, rho = 0.5,
    beta = c(-2, 2, -1, 1, -0.5, 0.5, -0.5, 0.5, rep(0, 92))
  )
)

variables_of_interest <- c("A1", "B1", "B2", "A3", "B5", "B6", "A5", "B9", "B10", "N1", "N2")

## Load data back in
methods <- methods[c("pipe", "debiased", "pipe_mcp")]
# methods <- methods[c("pipe", "normal_approx", "debiased", "mcp_pipe", "pipe_mcp")]
results <- list()
for (i in 1:length(methods)) {
  results[[names(methods)[i]]] <- indexr::read_objects(
    rds_path, 
    c(function_name = "sim", methods[[i]], simulation_info)
  )$results %>%
    mutate(method = names(methods)[i])
}

pdf("./fig/sim_abn.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()