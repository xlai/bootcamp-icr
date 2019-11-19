
N <- 1000
a <- 6
b <- 0.25
sigma <- 2

set.seed(123)
x <- rnorm(N)
epsilon <- rnorm(N, sd = sigma)
y <- a + b * x + epsilon
summary(lm(y ~ x))


#  Using Stan
library(rstan)
rstan_options(auto_write = TRUE)
fit <- stan('Scratch/stan/Univariate.stan', data = list(N = N, x = x, y = y))
fit


# Using brms
library(brms)
fit1 <- brm(y ~ x, data = data.frame(x, y))
fit1


# Using rstanarm
library(rstanarm)
fit2 <- stan_lm(y ~ x, data = data.frame(x, y), 
                prior = R2(0.5, what = 'median'))
fit2



# Posterior draws
library(dplyr)
as.data.frame(fit) %>% head
as.data.frame(fit) %>% 
  summarise(mean(b > 0.4))

as.data.frame(fit1) %>% head
as.data.frame(fit2) %>% head



library(tidybayes)

get_variables(fit)
spread_draws(fit, a, b)
gather_draws(fit, a, b)

get_variables(fit1)
spread_draws(fit1, b_Intercept, b_x)
gather_draws(fit1, b_Intercept, b_x)

get_variables(fit2)
spread_draws(fit2, `(Intercept)`, x)
gather_draws(fit2, `(Intercept)`, x)


data.frame(x, y) %>% 
  add_fitted_draws(fit1) %>% 
  group_by(x) %>% 
  mean_qi(.value) %>% 
  ggplot(aes(x = x, y = .value)) + 
  geom_point(col = 'orange') + 
  geom_errorbar(aes(ymin = .lower, ymax = .upper), alpha = 0.1) + 
  labs(y = 'y')

data.frame(x, y) %>% 
  add_predicted_draws(fit1) %>% 
  group_by(x) %>% 
  mean_qi(.prediction) %>% 
  ggplot(aes(x = x, y = .prediction)) + 
  geom_point(col = 'orange') + 
  geom_errorbar(aes(ymin = .lower, ymax = .upper), alpha = 0.1) + 
  labs(y = 'y')
