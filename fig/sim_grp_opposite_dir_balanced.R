source("./fig/setup.R")

for (i in 1:length(methods)) {
  methods[[i]]$method_arguments["alpha"] <- 0.05
}

simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_data_distribution", simulation_arguments = list(
                          J = 25, K = 4, beta = 0.5,
                          J1 = 1, K1 = 4, rho.g = 0.5
                        ), script_name = "distributions")

## Load data back in
methods <- methods[c("pipe", "relaxed_lasso", "lasso_proj")]
ns <- c(100)
distributions <- c( "group")

files <- expand.grid(
  "method" = names(methods),
  "n" = ns, "distribution" = distributions,
  stringsAsFactors = FALSE
)

results <- list()
for (i in 1:nrow(files)) {
  
  simulation_info$simulation_arguments$n <- files[i,] %>% pull(n)
  simulation_info$simulation_arguments$distribution <- files[i,] %>% pull(distribution)
  
  results[[i]] <- indexr::read_objects(
    rds_path,
    c(methods[[files[i,"method"]]], simulation_info)
  ) %>%
    mutate(method = files[i,] %>% pull(method), distribution = files[i,] %>% pull(distribution), n = files[i,] %>% pull(n))
}

# results[[1]] %>%
#   filter(stringr::str_detect(variable, "G01")) %>%
#   mutate(selected = betahat != 0) %>%
#   group_by(variable) %>%
#   summarise(prop_selected = mean(selected))

variables_of_interest <- c("G01_V1", "G01_V2", "G01_V3", "G01_V4", "G10_V1", "G10_V2", "G10_V3", "G10_V4")
pdf("./fig/sim_grp_opposite_dir_balanced.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()
