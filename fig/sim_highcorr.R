source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(
  simulation_function = "gen_data_abn",
  simulation_arguments = list(
    n = 100, p = 100, a = 1, b = 1, rho = 0.99,
    beta = 1
  )
)


variables_of_interest <- c("A1", "B1", "N1", "N2", "N3")

## Load data back in
methods <- methods[c("mcp_pipe", "pipe", "pipe_mcp")]
results <- list()
for (i in 1:length(methods)) {
  results[[names(methods)[i]]] <- indexr::read_objects(
    rds_path, 
    c(function_name = "sim", methods[[i]], simulation_info)
  )$results %>%
    mutate(method = names(methods)[i])
}

pdf("./fig/sim_highcorr.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()