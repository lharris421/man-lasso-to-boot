source("./fig/setup.R")


simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_data_distribution", simulation_arguments = list(
                          n = 200, p = 3000, beta = c(rep(c(0.001, 0.001, 0.001, 0.001, 0.85, 0.001, 0.001, 0.001, 0.001, 0.001), 30), rep(0, 2700)),
                          rho = 0.8, corr = "autoregressive"
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
  mutate(selected = coef != 0) %>%
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
  writeLines("tab/testing_selection_freq.tex")
