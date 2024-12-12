source("./fig/setup.R")

for (i in 1:length(methods)) {
  methods[[i]]$method_arguments["alpha"] <- 0.05
}

simulation_info <- list(seed = 1234, iterations = 1000,
               simulation_function = "gen_data_distribution", simulation_arguments = list(
                 p = 100, a = 8, b = 2, rho = 0.5,
                 beta = c(-2, 2, -1, 1, -0.5, 0.5, -0.5, 0.5)
               ), script_name = "distributions")

## Load data back in
methods <- methods[c("pipe", "relaxed_lasso", "lasso_proj")]
ns <- c(100)
distributions <- c( "abn")

files <- expand.grid("method" = names(methods), "n" = ns, "distribution" = distributions, stringsAsFactors = FALSE)

results <- list()
for (i in 1:nrow(files)) {
  
  simulation_info$simulation_arguments$n <- files[i,] %>% pull(n)
  simulation_info$simulation_arguments$distribution <- files[i,] %>% pull(distribution)
  
  results[[i]] <- indexr::read_objects(
    rds_path,
    c(methods[[files[i,"method"]]], simulation_info)
    # args
  ) %>%
    mutate(method = files[i,] %>% pull(method), distribution = files[i,] %>% pull(distribution), n = files[i,] %>% pull(n))
}

variables_of_interest <- c("A1", "B1", "B2", "A3", "B5", "B6", "A5", "B9", "B10", "N1", "N2")

pdf("./fig/sim_abn.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()
