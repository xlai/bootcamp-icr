
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
usethis::use_data(tumours)

star_signs = c('Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 'Libra', 
               'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces', NA)
tno <- tumours$TNO %>% unique()
num_extra_patients <- 10
tno <- c(tno, max(tno) + 1:num_extra_patients)
set.seed(123)
ages <- rnorm(length(tno), mean = 50, sd = 10)
library(lubridate)
dob <- ymd('2019-10-31') - floor(ages * 365.25)
reg = ymd('2019-10-31') - 
  runif(length(tno), min = 1, max = 365) %>% floor %>% sort %>% rev
patients <- tibble(
  TNO = tno,
  StarSign = sample(star_signs, size = length(tno), replace = TRUE) %>% 
    as.factor(),
  DateOfBirth = dob,
  DateOfReg = reg
)
usethis::use_data(patients, overwrite = TRUE)
