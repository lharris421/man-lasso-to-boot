source("./fig/setup.R")

for (i in 1:length(methods)) {
  methods[[i]]$method_arguments["alpha"] <- 0.05
}

simulation_info <- list(seed = 1234, iterations = 1000, same_lambda = TRUE,
                        simulation_function = "gen_data_distribution", simulation_arguments = list(
                          n = 100, p = 100, ortho = TRUE,
                          beta = c(-2, 2, -1, 1, -0.5, 0.5, -0.5, 0.5, rep(0, 92))
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

variables_of_interest <- glue('V{stringr::str_pad(1:10, width = 3, pad = "0")}')
pdf("./fig/sim_ortho.pdf", height = 4, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()
