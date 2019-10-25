

library(foreign)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lme4)
library(broom)


# hHis teaches:
# tidyr::gather, which also warrants tidyr::spread
# case_when
getwd()
noisedata <- read.spss('~/Downloads/noisedata.sav')
noisedata %>% 
  as.data.frame() %>% 
  gather(Occasion, Score, -SUBJECT, -GENDER) %>% 
  mutate(SUBJECT = as.factor(SUBJECT),
         Time = case_when(
           Occasion == 'NONE' ~ 0,
           Occasion == 'LOW' ~ 1,
           Occasion == 'MEDIUM' ~ 2,
           Occasion == 'HIGH' ~ 3,
         )) %>% 
  as_tibble() -> noisedata_tall


noisedata_tall %>% 
  ggplot(aes(x = Time, y = Score)) +
  geom_point() + 
  geom_line(aes(group = SUBJECT, col = GENDER))

noisedata_tall %>% 
  ggplot(aes(x = Time, y = Score)) +
  geom_point() + 
  geom_line(aes(group = SUBJECT), alpha = 0.1) -> p; p


lm0 <- lm(Score ~ 1 + Time, data = noisedata_tall)
summary(lm0)
augment(lm0)
p + geom_line(
  aes(y = .fitted), 
  data = augment(lm0) %>% distinct(Time, .fitted)
)

library(nlme)
lme0 <- lme(fixed = Score ~ 1 + Time, random = ~ 1 | SUBJECT, 
            data = noisedata_tall)
summary(lme0)
ranef(lme0)
augment(lme0)
p + geom_line(aes(y = .fitted), data = augment(lme0))

lme1 <- lme(fixed = Score ~ 1 + Time, random = ~ 1 + Time | SUBJECT, 
            data = noisedata_tall)
summary(lme1)
augment(lme1)
p + geom_line(aes(y = .fitted), data = augment(lme1))

library(brms)
bm0 <- brm(Score ~ 1 + Time + (1 | SUBJECT), data = noisedata_tall, 
           family = gaussian())
summary(bm0)
predict(bm0)
predict(bm0) %>% 
  as_tibble() %>% 
  mutate(SUBJECT = rep(1:20, 4), Time = rep(0:3, each = 20)) %>% 
  ggplot(aes(x = Time, y = Estimate)) + 
  geom_point() + 
  geom_line(aes(group = SUBJECT))
# Bullshit!
p


# The other way
lme0 <- lmer(Score ~ 1 + Time + (1 | SUBJECT), data = noisedata_tall)
? isSingular
isSingular(lme0)
augment(lme0)
p + geom_line(aes(y = .fitted), data = augment(lme0))
# Bullshit!



# TODO:
cycledata
noisedata2
