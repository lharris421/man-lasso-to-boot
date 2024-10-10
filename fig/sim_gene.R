source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(
  simulation_function = "gen_data",
  simulation_arguments = list(
    n = 100, p = 100, rho = 0.7,
    corr = "autoregressive",
    beta = c(rep(0, 10), 0.1, 0.2, 0.3, 0.5, 1, 0.5, 0.3, 0.2, 0.1, 0.1, rep(0, 80))
  )
)

variables_of_interest <- glue('V{stringr::str_pad(8:21, width = 3, pad = "0")}')


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


pdf("./fig/sim_gene.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()