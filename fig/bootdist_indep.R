source("./fig/setup.R")

## Specify the simulation information
simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_data", simulation_arguments = list(
                          n = 100, p = 100,
                          beta = c(-2, 2, -1, 1, -0.5, 0.5, -0.5, 0.5, rep(0, 92))
                        ), script_name = "sim_data_raw")


res <- indexr::read_objects(rds_path, simulation_info)

# Ensure that boot data is correctly formatted
which_var <- 2
boot_data <- as.numeric(res$debiased$boot$partial_correlations[, which_var])

# Reference the pipe data estimates and intervals correctly
pipe_lower <- as.numeric(res$pipe[which_var, "lower"])
pipe_upper <- as.numeric(res$pipe[which_var, "upper"])
pipe_estimate <- as.numeric(res$pipe[which_var, "estimate"])
mean(boot_data > pipe_estimate)

# Create a data frame for ggplot
df <- data.frame(partial_correlations = boot_data)

# Calculate the bootstrapped 95% confidence interval
boot_ci <- quantile(boot_data, c(0.025, 0.975))

# Create the plot using ggplot2
ggp <- ggplot(df, aes(x = partial_correlations)) +
  geom_histogram(binwidth = 0.05, fill = "grey", color = "white") +
  # geom_vline(aes(xintercept = pipe_lower, col = "Normal Approx"), linetype = "dashed") +
  # geom_vline(aes(xintercept = pipe_upper, col = "Normal Approx"), linetype = "dashed") +
  geom_vline(aes(xintercept = pipe_estimate, col = "Original Zj"), lwd = 1.5) +
  geom_vline(aes(xintercept = mean(boot_data), col = "Mean Bootstrap"), lwd = 1.5) +
  geom_vline(aes(xintercept = boot_ci[1], col = "Debiased Bootstrap"), linetype = "dotted") +
  geom_vline(aes(xintercept = boot_ci[2], col = "Debiased Bootstrap"), linetype = "dotted") +
  labs(
    title = "",
    x = "Partial Correlations",
    y = "Frequency"
  ) +
  theme_bw() +
  scale_color_manual(
    name = "Estimates and CIs",
    values = c(
     #  "Normal Approx" = "red",
      "Original Zj" = "black",
      "Mean Bootstrap" = "red",
      "Debiased Bootstrap" = "blue"
    )
  ) +
  theme(legend.position = "top")

pdf("./fig/bootdist_indep.pdf", height = 4, width = 6)
ggp
dev.off()

