## Setup and read in data
source("./fig/setup.R")

pal <- c("#31543B", "#48628A", "#94AA3D", "#7F9CB1", "#D9D1BE", "#3E3C3A")

params <- list(seed = 1234, iterations = 1000,
               simulation_function = "gen_data_abn", simulation_arguments = list(
                 n = 100, p = 100, a = 1, b = 1, rho = 0.5,
                 beta = c(2, rep(0, 99))
               ), script_name = "b_selection")
res <- indexr::read_objects(rds_path, params)

## Avg B vars in bootstrapping
pdf("./fig/sim_b_selection.pdf", height = 5, width = 7)
data.frame(
  avg_bs = apply(res$bs, 1, mean),
  iter = 1:1000
) %>%
  ggplot(aes(x = iter, ymin = 0, ymax = avg_bs)) +
  geom_errorbar() +
  geom_hline(yintercept = mean(res$orig_bs), color = "red") +
  ylab("Avg B Beta Est") + xlab("") +
  theme_bw()
dev.off()

## Correlations vs bias
## First histogram (res$ests)
df <- data.frame(
  ests = res$ests[which_sim, ],
  corrs = res$corrs[which_sim, ],
  bs = res$bs[which_sim, ]
)
df_vline <- data.frame(
  ests = res$orig_est[which_sim],
  corrs = res$orig_corrs[which_sim],
  bs = res$orig_bs[which_sim],
  LineType = "Original Estimate"
)
p1 <- ggplot(df, aes(x = ests)) +
  geom_histogram(binwidth = diff(range(df_ests$ests)) / 30, 
                 fill = pal[1], color = "white") +
  geom_vline(data = df_vline, aes(xintercept = ests, color = LineType),
             linetype = "dashed", size = 1) +
  scale_color_manual(name = "", values = c("Original Estimate" = "red")) +
  labs(
    title = paste("Bootstrapped Debiased A Variable Estimates - Simulation", which_sim),
    x = "Estimates",
    y = "Frequency"
  ) +
  theme_minimal()

## Second histogram (res$corrs)
p2 <- ggplot(df, aes(x = corrs)) +
  geom_histogram(binwidth = diff(range(df_corrs$corrs)) / 30, 
                 fill = pal[2], color = "white") +
  geom_vline(data = df_vline, aes(xintercept = corrs, color = LineType),
             linetype = "dashed", size = 1) +
  scale_color_manual(name = "", values = c("Original Estimate" = "red")) +
  labs(
    title = paste("Bootstrapped AB Variable Correlations - Simulation", which_sim),
    x = "Correlations",
    y = "Frequency"
  ) +
  theme_minimal()

## Third histogram (res$bs)
p3 <- ggplot(df, aes(x = bs)) +
  geom_histogram(binwidth = diff(range(df_bs$bs)) / 30, 
                 fill = pal[3], color = "white") +
  geom_vline(data = df_vline, aes(xintercept = bs, color = LineType),
             linetype = "dashed", size = 1) +
  scale_color_manual(name = "", values = c("Original Estimate" = "red")) +
  labs(
    title = paste("Bootstrapped B Variable Estimates - Simulation", which_sim),
    x = "bs",
    y = "Frequency"
  ) +
  theme_minimal()

# Combine the plots vertically with a shared legend
(p1 / p2 / p3) +
  plot_layout(guides = "collect") &
  theme(legend.position = "bottom")

pdf("./fig/sim_b_selection_single.pdf", height = 7, width = 7)
(p1 / p2 / p3) +
  plot_layout(guides = "collect") &
  theme(legend.position = "bottom")
dev.off()


# Using sapply to extract slopes across simulations
corr_bias_rel <- sapply(1:1000, function(which_sim) {
  x <- res$corrs[which_sim, ] - res$orig_corrs[which_sim]
  y <- res$orig_est[which_sim] - res$ests[which_sim, ]
  fit <- lm(y ~ x)
  coef(fit)["x"]
})

 # ggtitle("Slope estimates for regression of boot debiased estimate vs corr")

pdf("./fig/sim_b_selection_corr_slopes.pdf", height = 7, width = 7)
ggplot(data.frame(x = corr_bias_rel), aes(x = x)) +
  geom_histogram(color = "white", fill = pal[3], binwidth = 0.05) +
  theme_bw() + ylab("") +
  xlab("") 
dev.off()

pdf("./fig/sim_b_selection_single_corr_bias_est.pdf", height = 5, width = 7)
data.frame(
  corr = res$corrs[which_sim, ] - res$orig_corrs[which_sim],
  diff_est = res$orig_est[which_sim] - res$ests[which_sim, ],
  b_diffs = res$bs[which_sim,] - res$orig_bs[which_sim]
) %>%
  ggplot(aes(x = corr, y = diff_est)) +
  geom_vline(aes(xintercept = 0), alpha = 0.5) +
  geom_hline(aes(yintercept = 0), alpha = 0.5) +
  geom_point(aes(color = b_diffs)) +
  labs(
    title = paste("Simulation", which_sim),
    x = "Additional Correlation",
    y = "Additional Bias",
    color = "Additional B est"
  ) +
  theme_bw() +
  scale_color_viridis_b()
dev.off()

## Is a greater B est correlated with a higher correlation between A and B?
## Annotations
bdiffs <- res$bs[which_sim,] - res$orig_bs[which_sim]
aabbg <- mean(bdiffs[res$corrs[which_sim, ] > res$orig_corrs[which_sim]])
aabbl <- mean(bdiffs[res$corrs[which_sim, ] < res$orig_corrs[which_sim]])

## Plot
pdf("./fig/sim_b_selection_single_corr_bias.pdf", height = 5, width = 7)
data.frame(
  corr = res$corrs[which_sim, ],
  diff_est = res$orig_est[which_sim] - res$ests[which_sim, ],
  b_diffs = res$bs[which_sim,] - res$orig_bs[which_sim]
) %>%
  ggplot(aes(x = corr, y = b_diffs)) +
  geom_hline(aes(yintercept = 0), alpha = 0.5) +
  geom_point(alpha = 0.2) +
  theme_bw() +
  geom_vline(aes(xintercept = res$orig_corrs[which_sim]), color = "red") +
  labs(
    title = paste("Simulation", which_sim),
    x = "Correlation",
    y = "Additional B Bias"
  ) + 
  annotate("text", x = res$orig_corrs[which_sim] + 0.1, y = aabbg, label = glue("Average Additional B Bias: {round(aabbg, 3)}")) +
  annotate("text", x = res$orig_corrs[which_sim] - 0.1, y = aabbl, label = glue("Average Additional B Bias: {round(aabbl, 3)}"))
dev.off()

###################################
########## All Simulations ########
###################################
aabb_diff <- sapply(1:1000, function(which_sim) {
  
  bdiffs <- res$bs[which_sim,]
  aabbg <- mean(bdiffs[res$corrs[which_sim, ] > res$orig_corrs[which_sim]])
  aabbl <- mean(bdiffs[res$corrs[which_sim, ] < res$orig_corrs[which_sim]]) 
  aabbg - aabbl
  
})
pdf("./fig/sim_b_selection_corr_bias.pdf", height = 5, width = 7)
ggplot(data.frame(x = aabb_diff), aes(x = x)) +
  geom_histogram(binwidth = 0.001, color = "white", fill = pal[3]) +
  theme_bw() + xlab("") + ylab("") 
dev.off()
  ## ggtitle("Diff avg. B est between boot draws with cor < and > the orig sample corr between AB")

# addtl_bias <- res$orig_est - apply(res$ests, 1, mean)
# addtl_bias_est <- apply(res$bs * res$corrs, 1, mean) - res$orig_bs * res$orig_corrs
# plot(addtl_bias_est, addtl_bias)
