
# Install rstan if it is missing
if(!require(rstan)) {
  install.packages('rstan')
} 


# Install brms if it is missing
if(!require(brms)) {
  install.packages('brms')
} 


# Install rstanarm if it is missing
if(!require(rstanarm)) {
  install.packages('rstanarm')
} 


# Install tidybayes if it is missing
if(!require(tidybayes)) {
  install.packages('tidybayes')
} 
