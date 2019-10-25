
# devtools::install_github('brockk/bootcamp')

library(bootcamp)
# library(foreign)
library(dplyr)
# library(tidyr)
library(ggplot2)
library(nlme)
library(lme4)
library(broom)

tumours <- tumours %>% as_tibble()
tumours %>% head

tumours %>% 
  ggplot(aes(x = Time, y = TumourSize)) + 
  geom_point() + 
  geom_line(aes(group = TNO), alpha = 0.1) -> p; p


# Population-effects model
lm0 <- lm(TumourSize ~ 1 + Time, data = tumours)
summary(lm0)
augment(lm0)
p + geom_line(
  aes(y = .fitted), 
  data = augment(lm0) %>% distinct(Time, .fitted)
)

# Random intercepts
lme0 <- lme(fixed = TumourSize ~ 1 + Time, 
            random = ~ 1 | TNO, 
            data = tumours)
summary(lme0)
ranef(lme0)
augment(lme0)
p + 
  geom_line(aes(y = .fitted, group = TNO), data = augment(lme0), col = 'red') +
  facet_wrap(~ TNO)


# Random gradients
lme1 <- lme(fixed = TumourSize ~ 1 + Time, 
            random = ~ 1 + Time | TNO, 
            data = tumours)
summary(lme1)
ranef(lme1)
augment(lme1)
p + 
  geom_line(aes(y = .fitted, group = TNO), data = augment(lme1), col = 'red') +
  facet_wrap(~ TNO)

# Improvement?
anova(lme0, lme1)


# Another way
lme0b <- lmer(TumourSize ~ 1 + Time + (1 | TNO), data = tumours)
qplot(ranef(lme0)[,1], ranef(lme0b)$TNO[,1], geom = 'point')

lme1b <- lmer(TumourSize ~ (1 + Time | TNO), data = tumours)
qplot(ranef(lme1)[,1], ranef(lme1b)$TNO[,1], geom = 'point')
qplot(ranef(lme1)[,2], ranef(lme1b)$TNO[,2], geom = 'point')

anova(lme0b, lme1b)

