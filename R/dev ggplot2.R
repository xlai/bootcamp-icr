

library(ggplot2)
library(dplyr)

diamonds
? diamonds

set.seed(123)
diamonds1k <- diamonds %>% sample_n(1000)

diamonds1k %>% 
  ggplot(aes(x = carat, y = price)) + 
  geom_point()

diamonds1k %>% 
  ggplot(aes(x = carat, y = price)) + 
  geom_point(aes(col = cut))

diamonds1k %>% 
  ggplot(aes(x = carat, y = price)) + 
  geom_point(aes(col = cut)) + 
  facet_wrap(~ cut)

diamonds1k %>% 
  ggplot(aes(x = carat, y = price)) + 
  geom_point(aes(col = cut)) + 
  facet_wrap(~ cut, ncol = 2)

diamonds1k %>% 
  ggplot(aes(x = carat, y = price)) + 
  geom_point(aes(col = cut)) + 
  geom_smooth() + 
  facet_wrap(~ cut, ncol = 2)

diamonds1k %>% 
  ggplot(aes(x = carat, y = price)) + 
  geom_point(aes(col = cut)) + 
  geom_smooth() + 
  facet_wrap(~ cut, ncol = 2) + 
  geom_vline(xintercept = 1, col = 'red', linetype = 'dashed')

diamonds1k %>% 
  ggplot(aes(x = carat, y = price)) + 
  geom_point(aes(col = clarity)) + 
  geom_smooth() + 
  facet_wrap(~ clarity, ncol = 2) + 
  geom_vline(xintercept = 1, col = 'red', linetype = 'dashed')




# Tumour size
n_pat <- 50
times <- c(0, 3, 6, 9)
n_time <- length(times)

mu1 <- c(5, 4.5, 4, 3.8)
mu2 <- c(5, 4.9, 4.8, 4.8)
Sigma1 <- matrix(c(1, 0.9, 0.8, 0.7,
                   0.9, 1, 0.9, 0.8,
                   0.8, 0.9, 1, 0.9,
                   0.7, 0.8, 0.9, 1), ncol = length(mu1), byrow = TRUE)
set.seed(123)
X1 <- MASS::mvrnorm(n = n_pat, mu = mu1, Sigma = Sigma1)
X2 <- MASS::mvrnorm(n = n_pat, mu = mu2, Sigma = Sigma1)
df1 <- data.frame(
  TNO = rep(1:n_pat, n_time),
  TumourSize = as.numeric(X1),
  Time = rep(times, each = n_pat),
  Arm = 1
)
df2 <- data.frame(
  TNO = rep(n_pat + 1:n_pat, n_time),
  TumourSize = as.numeric(X2),
  Time = rep(times, each = n_pat),
  Arm = 2
)
tumours <- bind_rows(df1, df2)

tumours %>% head

# Plots of tumour size
tumours %>% 
  ggplot(aes(x = Time, y = TumourSize)) + 
  geom_point()

tumours %>% 
  ggplot(aes(x = Time, y = TumourSize)) + 
  geom_point() + 
  geom_line()
# Wrong

tumours %>% 
  ggplot(aes(x = Time, y = TumourSize)) + 
  geom_point() + 
  geom_line(aes(group = TNO))
# Right


tumours %>% 
  left_join(
    tumours %>% 
      filter(Time == 0) %>% 
      select(TNO, Baseline = TumourSize), by = 'TNO'
  ) %>% 
  mutate(ChangeFromBL = TumourSize / Baseline) %>% 
  ggplot(aes(x = Time, y = ChangeFromBL, group = TNO)) + 
  geom_point() + 
  geom_line() + 
  geom_hline(yintercept = 0.7, col = 'red', linetype = 'dashed')

tumours %>% 
  left_join(
    tumours %>% 
      filter(Time == 0) %>% 
      select(TNO, Baseline = TumourSize), by = 'TNO'
  ) %>% 
  mutate(ChangeFromBaseline = TumourSize / Baseline) %>% 
  ggplot(aes(x = Time, y = ChangeFromBaseline, group = TNO)) + 
  geom_point() + 
  geom_line() + 
  geom_hline(yintercept = 0.7, col = 'red', linetype = 'dashed') + 
  facet_wrap(~ Arm)

tumours %>% 
  left_join(
    tumours %>% 
      filter(Time == 0) %>% 
      select(TNO, Baseline = TumourSize), by = 'TNO'
  ) %>% 
  mutate(ChangeFromBaseline = TumourSize / Baseline) %>% 
  ggplot(aes(x = Time, y = ChangeFromBaseline)) + 
  geom_point() + 
  geom_line(aes(group = TNO)) + 
  geom_hline(yintercept = 0.7, col = 'red', linetype = 'dashed') + 
  geom_smooth() + 
  facet_wrap(~ Arm)

