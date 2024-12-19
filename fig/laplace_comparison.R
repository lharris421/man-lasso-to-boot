source("./fig/setup.R")

alpha <- 0.2
for (i in 1:length(methods)) {
  methods[[i]]$method_arguments["alpha"] <- alpha
}

simulation_info <- list(seed = 1234, iterations = 1000,
                        simulation_function = "gen_data_distribution", simulation_arguments = list(
                          p = 100, SNR = 1, sigma = 10
                        ), script_name = "distributions")

## Load data back in
methods <- methods[c("lasso_boot_reed", "lasso")]
# methods <- methods[c("lasso_proj_boot")]
ns <- c(50, 100, 400)
distributions <- c( "laplace")

files <- expand.grid("method" = names(methods), "n" = ns, "distribution" = distributions, stringsAsFactors = FALSE)

results <- list()
for (i in 1:nrow(files)) {
  
  simulation_info$simulation_arguments$n <- files[i,] %>% pull(n)
  simulation_info$simulation_arguments$distribution <- files[i,] %>% pull(distribution)
  
  results[[i]] <- indexr::read_objects(
    rds_path,
    c(methods[[files[i,"method"]]], simulation_info)
    # args
  ) %>%
    mutate(method = files[i,] %>% pull(method), distribution = files[i,] %>% pull(distribution), n = files[i,] %>% pull(n))
}


results <- bind_rows(results)
model_res <- calculate_model_results(results)

cutoff <- 3
line_data <- list()
line_data_avg <- list()
xvals <- seq(from = -cutoff, to = cutoff, length.out = cutoff * 100 + 1)
density_data <- data.frame(x = xvals, density = 2 * dlaplace(xvals, rate = 1.414))


for (i in 1:nrow(files)) {
  
  cat("Processing method: ", files$method[i], " for n = " , files$n[i], "\n")
  tmp <- model_res %>%
    filter(method == files$method[i], n == files$n[i], !is.na(estimate))
  
  cat("Average coverage: ", mean(tmp$covered), "\n")
  
  xs <- seq(-cutoff, cutoff, by = 0.01)
  line_data[[i]] <- predict_covered(tmp, xs, files$method[i]) %>% mutate(n = files$n[i])
  line_data_avg[[i]] <- data.frame(avg = mean(tmp$covered), method = methods_pretty[files$method[i]], n = files$n[i])
  
}

line_data_avg <- do.call(rbind, line_data_avg)
line_data <- do.call(rbind, line_data)

plots <- ggplot(line_data) +
  geom_line(data = line_data %>% mutate(method = methods_pretty[method]), aes(x = x, y = y, color = method)) +
  geom_hline(data = line_data_avg, aes(yintercept = avg, color = method), linetype = 2) +
  geom_hline(aes(yintercept = 1 - alpha), linetype = 1, alpha = .5) +
  geom_area(data = density_data, aes(x = x, y = density / max(density)), fill = "grey", alpha = 0.5) +
  theme_bw() +
  xlab(expression(abs(beta))) +
  ylab("Coverage") +
  coord_cartesian(ylim = c(0, 1)) +
  scale_color_manual(name = "Method", values = colors) +
  facet_grid(cols = vars(n))

pdf("./fig/laplace_comparison.pdf", height = 4, width = 8)
plots
dev.off()
