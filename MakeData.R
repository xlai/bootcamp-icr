
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
tumours <- dplyr::bind_rows(df1, df2)

library(devtools)
use_data(tumours)
