# source("./fig/setup.R")
# 
# 
# simulation_info <- list(seed = 1234, iterations = 1000,
#                         simulation_function = "gen_data_distribution", simulation_arguments = list(
#                           n = 50, J = 10, K = 10, beta = c(rep(1, 10), rep(0, 90)),
#                           J1 = 4, K1 = 10, rho.g = 0.7, distribution = "group"
#                         ), script_name = "distributions")
# variables_of_interest <- c("G01_V01", "G02_V01", "G03_V01", "G04_V01", "G05_V01", "G06_V01")
# 
# # simulation_info <- list(seed = 1234, iterations = 1000,
# #                         simulation_function = "gen_data_distribution", simulation_arguments = list(
# #                           n = 50, p = 100, beta = c(rep(1, 50), rep(0, 50)),
# #                           corr = "exchangeable", rho = 0.5
# #                         ), script_name = "distributions")
# # variables_of_interest <- c("V001", "V002", "V003", "V080", "V081", "V082")
# 
# ## Load data back in
# methods <- methods[c("pipe")]
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
#     mutate(method = files[i,])
# }
# 
# pdf("./fig/testing.pdf", height = 5, width = 7)
# ci_coverage_plot(results, variables_of_interest)
# dev.off()
