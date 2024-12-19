# source("./fig/setup.R")
# 
# simulation_info <- list(seed = 1234, iterations = 1000,
#                         simulation_function = "gen_data_distribution", simulation_arguments = list(
#                           n = 400, p = 100, p1 = 10, family = "binomial"
#                         ), script_name = "distributions")
# 
# ## Load data back in
# methods <- methods[c("pipe_binomial")]
# 
# files <- expand.grid(
#   "method" = names(methods),
#   stringsAsFactors = FALSE
# )
# 
# results <- list()
# for (i in 1:nrow(files)) {
#   
#   results[[i]] <- indexr::read_objects(
#     rds_path,
#     c(methods[[files[i,"method"]]], simulation_info)
#   ) %>%
#     mutate(method = files[i,,drop=FALSE] %>% pull(method))
# }
# 
# variables_of_interest <- glue('V{stringr::str_pad(1:14, width = 3, pad = "0")}')
# pdf("./fig/sim_binomial.pdf", height = 4, width = 7)
# ci_coverage_plot(results, variables_of_interest)
# dev.off()
