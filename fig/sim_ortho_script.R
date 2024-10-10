source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_ortho", simulation_arguments = list(
                          n = 100, p = 100,
                          beta = c(-2, 2, -1, 1, -0.5, 0.5, -0.5, 0.5, rep(0, 92))
                        ), script_name = "sim_ortho_lam")

methods$lp$method_arguments$original <- NULL
variables_of_interest <- glue('V{stringr::str_pad(1:10, width = 3, pad = "0")}')

## Load data back in
methods <- methods[c("normal_approx", "debiased")]
results <- list()
for (i in 1:length(methods)) {
  #args <- c(methods[[i]], simulation_info)
  #args$method_arguments <- NULL
  results[[names(methods)[i]]] <- indexr::read_objects(
    rds_path, 
    c(methods[[i]], simulation_info)
    # args
  )$results %>%
    mutate(method = names(methods)[i])
}


pdf("./fig/sim_ortho_script.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()
