source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(
  simulation_function = "gen_data_grp",
  simulation_arguments = list(
    n = 100, J = 25, K = 4, beta = 0.5,
    J1 = 1, K1 = 4, rho.g = 0.5
  )
)


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

results$pipe %>%
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
