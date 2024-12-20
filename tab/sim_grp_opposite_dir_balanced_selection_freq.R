source("./fig/setup.R")

for (i in 1:length(methods)) {
  methods[[i]]$method_arguments["alpha"] <- 0.05
}

simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_data_distribution", simulation_arguments = list(
                          n = 100, J = 25, K = 4, beta = 0.5,
                          J1 = 1, K1 = 4, rho.g = 0.5, distribution = "group"
                        ), script_name = "distributions")

simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_data_distribution", simulation_arguments = list(
                          n = 100, p = 100, distribution = "high_corr"
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
    mutate(method = files[i,])
}

results[[1]] %>%
  # filter(stringr::str_detect(variable, "G01")) %>%
  mutate(selected = betahat != 0) %>%
  group_by(variable) %>%
  summarise(prop_selected = mean(selected)) %>%
  kbl(
    format = "latex",
    align = "lc",
    booktabs = TRUE,
    digits = 3,
    linesep = "",
    col.names = c("Variable", "Selection Frequency"),
    table.envir = NULL
  ) %>%
  kable_styling(latex_options = c("hold_position")) %>%
  gsub("\\\\begin\\{table\\}\\[.*?\\]", "", .) %>%
  gsub("\\\\centering", "", .) %>%
  gsub("\\\\end\\{table\\}", "", .) %>%
  writeLines("tab/sim_grp_opposite_dir_balanced_selection_freq.tex")
