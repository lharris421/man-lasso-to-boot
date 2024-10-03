source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(
  simulation_function = "gen_data_ldpe",
  simulation_arguments = list(
    n = 200, p = 3000,
    corr = "autoregressive",
    rho = 0.8, a = 1
  )
)


variables_of_interest <- glue('V{stringr::str_pad(c(1, 2, 3, 1500, 1499, 1501, 1800, 2100, 2400, 2700, 2998, 2999, 3000), width = 4, pad = "0")}')

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

pdf("./fig/sim_ldpe.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()