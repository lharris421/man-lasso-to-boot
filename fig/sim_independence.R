source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(
  simulation_function = "gen_data",
  simulation_arguments = list(
    n = 100, p = 100,
    beta = c(-2, 2, -1, 1, -0.5, 0.5, -0.5, 0.5, rep(0, 92))
  )
)

variables_of_interest <- glue('V{stringr::str_pad(1:10, width = 3, pad = "0")}')

## Load data back in
methods <- methods[c("debiased", "normal_approx", "pipe", "relaxed_lasso")]
results <- list()
for (i in 1:length(methods)) {
  results[[names(methods)[i]]] <- indexr::read_objects(
    rds_path, 
    c(function_name = "sim", methods[[i]], simulation_info)
    # c(methods[[i]], simulation_info)
  )$results %>%
    mutate(method = names(methods)[i])
}

pdf("./fig/sim_independence.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()