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

results[[1]] %>%
  filter(stringr::str_detect(variable, "G01")) %>%
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
