## Setup and read in data
source("./fig/setup.R")

pal <- c("#31543B", "#48628A", "#94AA3D", "#7F9CB1", "#D9D1BE", "#3E3C3A")

params <- list(seed = 1234, iterations = 1000,
               simulation_function = "gen_data_abn", simulation_arguments = list(
                 n = 100, p = 100, a = 1, b = 1, rho = 0.5,
                 beta = 2
               ), script_name = "b_selection")
res <- indexr::read_objects(rds_path, params)


add_bias <- res$orig_est - apply(res$ests, 1, mean)
hist(add_bias)

add_b_bias <- res$orig_corrs*-res$orig_bs - apply(res$corrs*-res$bs, 1, mean)
hist(add_b_bias)

add_n_bias <- res$orig_an_bias - apply(res$an_bias, 1, mean)
hist(add_n_bias)

add_err_bias <- res$orig_err_bias - apply(res$err_bias, 1, mean)
hist(add_err_bias)

sum_bias <- add_b_bias + add_n_bias + add_err_bias

data <- data.frame(
  add_bias = add_bias,
  add_b_bias = add_b_bias,
  add_n_bias = add_n_bias,
  add_err_bias = add_err_bias,
  sum_bias = sum_bias
)

# Reshape data into long format for ggplot2
long_data <- pivot_longer(data, cols = everything(), names_to = "variable", values_to = "value") %>%
  mutate(variable = factor(variable, 
                           levels = c("add_bias", "add_b_bias", "add_n_bias", "add_err_bias", "sum_bias"),
                           labels = c("Additional Bias", "Attributable to B", "Attributable to N", "Attr. to Err Corr (Irreducible)", "Sum Attributable")))

# Create density plots using ggplot2
pdf("./fig/sim_b_selection.pdf", height = 5, width = 7)
ggplot(long_data, aes(x = value, fill = variable, color = variable)) +
  geom_density(alpha = 0.2) +
  theme_bw() +
  labs(
    title = "Additional Bootstrap Bias Compared to Original Debiased Est (Decomp)",
    x = "Bias", y = "Density", color = "Bias Type", fill = "Bias Type"
  )
dev.off()
