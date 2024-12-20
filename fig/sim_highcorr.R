source("./fig/setup.R")

for (i in 1:length(methods)) {
  methods[[i]]$method_arguments["alpha"] <- 0.05
}

simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_data_distribution", simulation_arguments = list(
                          n = 100, p = 100, distribution = "high_corr"
                        ), script_name = "distributions")

## Load data back in
methods <- methods[c("pipe", "debiased")]

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

variables_of_interest <- c("A1", "B1", "N1", "N2", "N3")
pdf("./fig/sim_highcorr.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()