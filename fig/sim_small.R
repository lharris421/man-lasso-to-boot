source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(
  simulation_function = "gen_data",
  simulation_arguments = list(
    n = 50, p = 100,
    beta = c(rep(0.1, 50), rep(0, 50))
    # corr = "autoregressive", rho = 0.5
  )
)

# set.seed(07803715)
# exp_beta <- rexp(50, 10) * sample(c(-1, 1), 50, replace = TRUE)
# # exp_beta <- rexp(50, 1) * sample(c(-1, 1), 50, replace = TRUE)
# simulation_info <- list(
#   simulation_function = "gen_data",
#   simulation_arguments = list(
#     n = 100, p = 100,
#     beta = c(exp_beta, rep(0, 50))
#     # corr = "autoregressive", rho = 0.5
#   )
# )

## 50 betas = 0.1 w and w/o autoregressive correlation, n = 50
## same as above, w/o AR cor with n = 100

## 50 beta = 0.5 w AR corr rho = 0.5, n = 50

## 50 betas from exp with rate = 1, n = 50, 100
## 50 betas from exp with rate = 10, n = 100


variables_of_interest <- glue('V{stringr::str_pad(1:10, width = 3, pad = "0")}')

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
  # filter(stringr::str_detect(variable, "G01")) %>%
  mutate(selected = betahat != 0) %>%
  group_by(variable) %>%
  summarise(prop_selected = mean(selected))


pdf("./fig/sim_small.pdf", height = 5, width = 7)
ci_coverage_plot(results, variables_of_interest)
dev.off()