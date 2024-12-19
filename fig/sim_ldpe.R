source("./fig/setup.R")

for (i in 1:length(methods)) {
  methods[[i]]$method_arguments["alpha"] <- 0.05
}

simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_data_distribution", simulation_arguments = list(
                          n = 200, p = 3000, a = 1, corr = "autoregressive", rho = 0.8, distribution = "ldpe"
                        ), script_name = "distributions")

## Load data back in
methods <- methods[c("pipe")]

files <- expand.grid(
  "method" = names(methods),
  stringsAsFactors = FALSE
)

results <- list()
for (i in 1:nrow(files)) {
  
  results[[i]] <- indexr::read_objects(
    rds_path,
    c(methods[[files[i,"method"]]], simulation_info)
  ) %>%
    mutate(method = files[i,,drop=FALSE] %>% pull(method))
}


variables_of_interest <- glue('V{stringr::str_pad(c(1499, 1500, 1501, 1799, 1800, 1801), width = 4, pad = "0")}')
pdf("./fig/sim_ldpe.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()
