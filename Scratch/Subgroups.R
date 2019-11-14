
library(bootcamp)
library(dplyr)
library(ggplot2)
library(broom)
library(lme4)
library(tidyr)

# Load ----
format_num <- function(x, dp) {
  format(round(x, dp), nsmall = dp)  
}
format_num(1.15, 2)
format_num(1.15, 1)

tumours <- tumours %>% 
  mutate(
    Arm = case_when(
      Arm == 1 ~ 0,
      Arm == 2 ~ 1),
    Time = case_when(
      Time == 0 ~ 0,
      Time == 9 ~ 1)) %>% 
  as_tibble()

tumours %>% head
tumours %>% tail
patients %>% head

# Analyses of whole sample ----
tumours %>% 
  filter(Time == 1) %>% 
  group_by(Arm) %>% 
  summarise(mean(TumourSize))
# 3.74 vs 4.69, differ of 0.95

tumours %>% 
  filter(Time == 1) %>% 
  mutate(Arm = factor(Arm)) %>% 
  ggplot(aes(x =Arm, y = TumourSize)) + 
  geom_boxplot(aes(group = Arm)) + 
  geom_point()

# Approaches ignorant to baseline value
tumours %>% 
  filter(Time == 1) %>% 
  filter(Arm == 0) %>% 
  select(TumourSize) %>% .[[1]] -> x1
tumours %>% 
  filter(Time == 1) %>% 
  filter(Arm == 1) %>% 
  select(TumourSize) %>% .[[1]] -> x2
t.test(x1, x2, paired = FALSE, var.equal = FALSE)
# t-stat is -5, tmt effect is ~1

tumours %>% 
  filter(Time == 1) %>% 
  lm(TumourSize ~ Arm, data = .) %>% 
  tidy()
# Confirming, t-stat is 5, tmt effect is ~ 1

# Approaches adjusted for baseline
tumours %>% 
  filter(Time %in% c(0, 1)) %>% 
  lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time, data = .) %>% 
  tidy()
# t-stat is 6.8, tmt effect is ~ 0.92

# Analyses of subgroups ----

## Subset method ----
patients %>% count(StarSign) %>% arrange(n)

### Largest group - Cancer
tumours %>% 
  semi_join(patients %>% filter(StarSign == 'Cancer'), by = 'TNO') %>% 
  filter(Time %in% c(0, 1)) %>% 
  lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time, data = .) %>% 
  tidy()
# t-stat is 1.2, tmt effect is ~ 0.48

### Smaller group
tumours %>% 
  semi_join(patients %>% filter(StarSign == 'Leo'), by = 'TNO') %>% 
  filter(Time %in% c(0, 1)) %>% 
  lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time, data = .) %>% 
  tidy()
# t-stat is 2.7, tmt effect is ~ 1.03

### Even smaller group
tumours %>% 
  semi_join(patients %>% filter(StarSign == 'Libra'), by = 'TNO') %>% 
  filter(Time %in% c(0, 1)) %>% 
  lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time, data = .) %>% 
  tidy()
# t-stat is 3.7, tmt effect is ~ 1.29

### Smallest group
tumours %>% 
  semi_join(patients %>% filter(StarSign == 'Taurus'), by = 'TNO') %>% 
  filter(Time %in% c(0, 1)) %>% 
  lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time, data = .) %>% 
  tidy()
# Fails, unsurprisingly.


## Interaction method ----
tumours %>% 
  left_join(patients, by = 'TNO') %>% 
  mutate(Complement = StarSign != 'Cancer') %>% 
  replace_na(list(Complement = TRUE)) %>% 
  filter(Time %in% c(0, 1)) %>% 
  lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time + Complement:Arm:Time, 
       data = .) %>% 
  tidy()
# t-stat is 2.29, tmt effect is ~ 0.729

tumours %>% 
  left_join(patients, by = 'TNO') %>% 
  mutate(Complement = StarSign != 'Leo') %>% 
  replace_na(list(Complement = TRUE)) %>% 
  filter(Time %in% c(0, 1)) %>% 
  lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time + Complement:Arm:Time, 
       data = .) %>% 
  tidy()
# t-stat is 2.64, tmt effect is ~ 0.775

tumours %>% 
  left_join(patients, by = 'TNO') %>% 
  mutate(Complement = StarSign != 'Libra') %>% 
  replace_na(list(Complement = TRUE)) %>% 
  filter(Time %in% c(0, 1)) %>% 
  lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time + Complement:Arm:Time, 
       data = .) %>% 
  tidy()
# t-stat is 3, tmt effect is ~1.06

tumours %>% 
  left_join(patients, by = 'TNO') %>% 
  mutate(Complement = StarSign != 'Taurus') %>% 
  replace_na(list(Complement = TRUE)) %>% 
  filter(Time %in% c(0, 1)) %>% 
  lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time + Complement:Arm:Time, 
       data = .) %>% 
  tidy()
# t-stat is 1.34, tmt effect is ~0.657

# tumours %>% 
#   left_join(patients, by = 'TNO') %>% 
#   mutate(Subgroup = StarSign == 'Taurus') %>% 
#   replace_na(list(Subgroup = FALSE)) %>% 
#   filter(Time %in% c(0, 1)) %>% 
#   lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time + Subgroup:Arm:Time, data = .) %>% 
#   tidy()
# # t-stat is 0.6, tmt effect is ~ 0.932 - 0.275


## Hierarchical method ----
tumours %>% 
  left_join(patients, by = 'TNO') %>% 
  filter(Time %in% c(0, 1)) %>% 
  lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time + (0 + Arm:Time | StarSign), 
       data = .) -> full_subgroup_model

summary(full_subgroup_model)
fixef(full_subgroup_model)
ranef(full_subgroup_model)
ranef(full_subgroup_model)$StarSign[[1]] %>% hist

full_subgroup_model %>% 
  tidy()


# Comparison
star_signs <- c('Aquarius', 'Aries', 'Cancer', 'Capricorn', 'Gemini', 'Leo', 
                'Libra', 'Pisces', 'Sagittarius', 'Scorpio', 'Taurus', 'Virgo')

library(purrr)
subset_models <- map(
  star_signs, 
  function(x) {
    tumours %>% 
      semi_join(patients %>% filter(StarSign == x), by = 'TNO') %>% 
      filter(Time %in% c(0, 1)) %>% 
      lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time, data = .) %>% 
      tidy() %>% 
      mutate(Group = x, Method = 'Subset')
  })
subset_models

interaction_models <- map(
  star_signs,
  function(x) {
    tumours %>% 
      left_join(patients, by = 'TNO') %>% 
      mutate(Complement = StarSign != x) %>% 
      replace_na(list(Complement = TRUE)) %>% 
      filter(Time %in% c(0, 1)) %>% 
      lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time + Complement:Arm:Time, 
           data = .) %>% 
      tidy() %>% 
      mutate(Group = x, Method = 'Interaction')
  }
)
interaction_models

bind_rows(
  map_df(subset_models, bind_rows),
  map_df(interaction_models, bind_rows)
) %>% 
  mutate(estimate_u = estimate + 1.96 * std.error,
         estimate_l = estimate - 1.96 * std.error) %>% 
  filter(term == 'Time:Arm') %>% 
  ggplot(aes(x = estimate, y = Method, col = Method)) + 
  geom_point() + 
  geom_errorbarh(aes(xmax = estimate_u, xmin = estimate_l), height = 0.1) + 
  geom_vline(xintercept = 1, col = 'orange', linetype = 'dashed') + 
  facet_wrap(~ Group) + 
  labs(x = 'Star-sign-specific treatment effect')


# Compare interaction models to hierarchical model
# Respecify models so that subgroup tmt effect is expressed as adjustment to 
# population tmt effect, as hierarchical model does.
interaction_models_alt <- map(
  star_signs,
  function(x) {
    tumours %>%
      left_join(patients, by = 'TNO') %>%
      mutate(Subgroup = StarSign == x) %>%
      replace_na(list(Subgroup = FALSE)) %>%
      filter(Time %in% c(0, 1)) %>%
      lmer(TumourSize ~ 1 + (1 | TNO) + Time + Arm:Time + Subgroup:Arm:Time,
           data = .) %>%
      tidy() %>%
      mutate(Group = x, Method = 'Interaction')
  }
)
interaction_models_alt

group_effects <- ranef(full_subgroup_model)$StarSign
group_effects_df <- data.frame(
  Group = rownames(group_effects),
  estimate = group_effects[, 1],
  Method = 'Hierarchical'
)

bind_rows(
  map_df(interaction_models_alt, bind_rows) %>% 
    filter(term == 'Time:Arm:SubgroupTRUE') %>% 
    select(Group, estimate, Method),
  group_effects_df
) %>% 
  ggplot(aes(x = estimate, y = Method, col = Method)) + 
  geom_point() + 
  geom_vline(xintercept = 0, col = 'orange', linetype = 'dashed') + 
  facet_wrap(~ Group) + 
  labs(x = 'Star-sign-specific treatment effect')

# How to get SE of cohort-specific treatment effects?
group_effects
sqrt(attr(group_effects, "postVar")[1, , ])

# 
group_effects_df <- data.frame(
  Group = rownames(group_effects),
  estimate = group_effects[, 1],
  std.error = sqrt(attr(group_effects, "postVar")[1, , ]),
  Method = 'Hierarchical'
)
# However, pls note, with reference to this page:
# https://stats.stackexchange.com/questions/48254/standard-error-of-random-effects-in-r-lme4-vs-stata-xtmixed
# I am not sure whether the SEs for the two methods are comparable because the
# the SEs might not adjust for uncertainty in the fixed effects.
# Regardless:
bind_rows(
  map_df(interaction_models_alt, bind_rows) %>% 
    filter(term == 'Time:Arm:SubgroupTRUE') %>% 
    select(Group, estimate, std.error, Method),
  group_effects_df
) %>% 
  mutate(estimate_u = estimate + 1.96 * std.error,
         estimate_l = estimate - 1.96 * std.error) %>%
  ggplot(aes(x = estimate, y = Method, col = Method)) + 
  geom_point() + 
  geom_errorbarh(aes(xmax = estimate_u, xmin = estimate_l), height = 0.1) +
  geom_vline(xintercept = 0, col = 'orange', linetype = 'dashed') + 
  facet_wrap(~ Group) + 
  labs(x = 'Star-sign-specific treatment effect adjustment')





