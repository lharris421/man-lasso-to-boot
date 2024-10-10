source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(
  simulation_function = "gen_data_abn",
  simulation_arguments = list(
    n = 100, p = 100, a = 1, b = 1, rho = 0.5,
    beta = c(2, rep(0, 99))
  )
)

## Load data back in
methods <- methods[c("debiased")]
results <- list()
for (i in 1:length(methods)) {
  results[[names(methods)[i]]] <- indexr::read_objects(
    rds_path, 
    c(function_name = "sim", methods[[i]], simulation_info)
  )$results %>%
    mutate(method = names(methods)[i])
}


results[["debiased"]] %>%
  pull(estimate) %>%
  {. - 2}


pdf("./fig/sim_abn.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()