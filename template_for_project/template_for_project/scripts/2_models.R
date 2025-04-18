library(tidyverse)
library(dplyr)
library(animalshelter)
library(ggplot2)
library(broom)
library(sjPlot)

############

m1 = glm(adopted ~ animal_type, data = longbeach_clean)
#summary(m1)

m2 = glm(adopted ~ intake_condition, data = longbeach_clean)
#summary(m2)

m3 = glm(adopted ~ sex, data = longbeach_clean)
#summary(m3)

m4 = glm(adopted ~ intake_type, data = longbeach_clean)
#summary(m4)

r = resid(m1, type = "pearson")
d = resid(m1, type = "deviance")


fibt = m1$fitted.values
plot(fibt, r, ylim = c(-2.5, 2.5), pch = 16, main = "Pearson Residuals for Animal Type", xlab = "Fitted Values", ylab = "Residuals")
abline(h = 0, lty = 2, col = 2)
plot(fibt, d, ylim = c(-2.5, 2.5), pch = 16, main = "Deviance for Intake Condition: identical to pearson residuals for all plots", xlab = "Fitted Values", ylab = "Residuals")
abline(h = 0, lty = 2, col = 2)



r2 = resid(m2, type = "pearson")

fibt2 = m2$fitted.values
plot(fibt2, r2, ylim = c(-2.5, 2.5), pch = 16, main = "Pearson Residuals for Intake Condition", xlab = "Fitted Values", ylab = "Residuals")
abline(h = 0, lty = 2, col = 2)




r3 = resid(m3, type = "pearson")

fibt3 = m3$fitted.values
plot(fibt3, r3, ylim = c(-2.5, 2.5), pch = 16, main = "Pearson Residuals for Sex", xlab = "Fitted Values", ylab = "Residuals")
abline(h = 0, lty = 2, col = 2)



r4 = resid(m4, type = "pearson")

fibt4 = m4$fitted.values
plot(fibt4, r4, ylim = c(-2.5, 2.5), pch = 16, main = "Pearson Residuals for Intake Type", xlab = "Fitted Values", ylab = "Residuals")
abline(h = 0, lty = 2, col = 2)


################

#building model step by step to compare AIC
null = glm(adopted ~ 1, data = longbeach_clean, family = binomial)
gm1 = glm(adopted ~ animal_type, data = longbeach_clean, family = binomial)
gm2 = glm(adopted ~ animal_type + intake_condition, data = longbeach_clean, family = binomial)
gm3 = glm(adopted ~ animal_type + intake_condition + sex, data = longbeach_clean, family = binomial)
gm4 = glm(adopted ~ animal_type + intake_condition + sex + intake_type, data = longbeach_clean, family = binomial)
gm5 = glm(adopted ~ animal_type + intake_condition + sex + intake_type + primary_color, data = longbeach_clean, family = binomial)

AIC(null, gm1, gm2, gm3, gm4, gm5)

step(null, scope = list(lower = nyull, upper = gm5), direction = "both")


##################


#Prints the Test Fit regression model
#and displays odds ratios

coef.gm4 = exp(coef(gm4))

longbeach_clean$animal_type = relevel(longbeach_clean$animal_type, ref = "dog")
longbeach_clean$intake_condition = relevel(longbeach_clean$intake_condition, ref = "normal")
longbeach_clean$sex = relevel(longbeach_clean$sex, ref = "Male")
gm42 = glm(adopted ~ animal_type + intake_condition + sex + intake_type, data = longbeach_clean, family = binomial)

summary(gm42)

coef.gm42 = exp(coef(gm42))
names1 = names(coef.gm42)

kept = c("animal_typebird", "animal_typecat", "animal_typelivestock", "animal_typeother", "animal_typerabbit", "intake_conditionaged", "intake_conditionbehavior  moderate", "intake_conditionbehavior  severe", "intake_conditionill severe", "intake_conditioninjured  severe", "intake_conditionbehavior  mild", "intake_conditionferal", "intake_conditionfractious", "intake_conditionill mild", "intake_conditionill moderatete", "intake_conditioninjured  mild", "intake_conditioninjured  moderate", "intake_conditionunder age/weight", "sexNeutered", "sexSpayed", "intake_typetrap, neuter, return")
sub.set = coef.gm42[kept]

print(sub.set)

##########################


#better regression modeling plots

#####################
#animal type
#####################

nyew2 = data.frame(animal_type = levels(longbeach_clean$animal_type))
pred2 = predict(m1, newdata = nyew2, type = "link", se.fit = T)

nyew2$prob = invlogit(pred2$fit)

nyew2$prob_lower = invlogit(pred2$fit - 1.96*pred2$se.fit)
nyew2$prob_upper = invlogit(pred2$fit + 1.96*pred2$se.fit)

anyimal <- ggplot(longbeach_clean, aes(x = animal_type, y = adopted)) +
  geom_jitter(height = 1/80, size = 3, alpha = 1/4) +
  geom_pointrange(aes(y = prob, ymin = prob_lower, ymax = prob_upper), 
                  data = nyew2, size = 1, color = scales::muted('blue')) +
  labs(title = "Probability of Adoption based on Animal Type", x = "Animal Type", y = "p(Adopted)")
#anyimal
ggsave(plot = anyimal, filename = "../figures/AnimalType.pdf")

#Max: livestock (small number, high prob)
#Min: Amphibian (small number, small prob)


#####################
#intake condition
#####################

nyew3 = data.frame(intake_condition = levels(longbeach_clean$intake_condition))
pred3 = predict(m2, newdata = nyew3, type = "link", se.fit = T)

nyew3$prob = invlogit(pred3$fit)

nyew3$prob_lower = invlogit(pred3$fit - 1.96*pred3$se.fit)
nyew3$prob_upper = invlogit(pred3$fit + 1.96*pred3$se.fit)

conydibtiony = ggplot(longbeach_clean, aes(x = intake_condition, y = adopted)) +
  geom_jitter(height = 1/80, size = 3, alpha = 1/4) +
  geom_pointrange(aes(y = prob, ymin = prob_lower, ymax = prob_upper), 
                  data = nyew3, size = 1, color = scales::muted('blue')) +
  labs(title = "Probability of Adoption based on Intake Condition", x = "Intake Condition", y = "p(Adopted)")

ggsave(plot = conydibtiony, filename = "../figures/intakeCondition")

#IGNORE MAX WITH LARGE INTERVAL (weird variable)
#Max: Mild
#Min: Severely injured



#####################
#Sex
#####################

nyew = data.frame(sex = levels(longbeach_clean$sex))
pred = predict(m3, newdata = nyew, type = "link", se.fit = T)

nyew$prob = invlogit(pred$fit)
nyew$prob_lower = invlogit(pred$fit - 1.96*pred$se.fit)
nyew$prob_upper = invlogit(pred$fit + 1.96*pred$se.fit)



sex <- ggplot(longbeach_clean, aes(x = sex, y = adopted)) +
  geom_jitter(height = 1/80, size = 3, alpha = 1/4) +
  geom_pointrange(aes(y = prob, ymin = prob_lower, ymax = prob_upper), 
                  data = nyew, size = 1, color = scales::muted('blue')) +
  labs(title = "Probability of Adoption based on Sex", x = "Sex", y = "p(Adopted)")

ggsave(plot = sex, filename = "../figures/sex")

#Max: Spayed
#Min: Unknown, then male, barely more than female



#####################
#intake type
#####################

nyew4 = data.frame(intake_type = levels(longbeach_clean$intake_type))
pred4 = predict(m4, newdata = nyew4, type = "link", se.fit = T)

nyew4$prob = invlogit(pred4$fit)

nyew4$prob_lower = invlogit(pred4$fit - 1.96*pred4$se.fit)
nyew4$prob_upper = invlogit(pred4$fit + 1.96*pred4$se.fit)

btnype = ggplot(longbeach_clean, aes(x = intake_type, y = adopted)) +
  geom_jitter(height = 1/80, size = 3, alpha = 1/4) +
  geom_pointrange(aes(y = prob, ymin = prob_lower, ymax = prob_upper), 
                  data = nyew4, size = 1, color = scales::muted('blue')) +
  labs(title = "Probability of Adoption based on Intake Type", x = "Intake Type", y = "p(Adopted)")

ggsave(plot = btnype, filename = "../figures/intakeType")

#Min: Technically "euthenasia required" and "foster", But I'd say "trap, neuter, return" (more samples)
#Max: return


######################

#First, residuals of the full model (best fitting one)
#Then Individual Residuals 

resid.df = data.frame(fitted = gm42$fitted.values,
                      deviance = resid(gm42, type = "deviance"), 
                      Adopted = longbeach_clean$adopted,
                      Animal = longbeach_clean$animal_type,
                      intake_condition = longbeach_clean$intake_condition,
                      Sex = longbeach_clean$sex,
                      intake_type = longbeach_clean$intake_type)


p_resid = ggplot(resid.df, aes(x = fitted, y = deviance)) +
  geom_point() +
  geom_hline(yintercept = 0, col = 2) +
  labs(title = "Residuals", x = "Fitted", y = "Deviance")
#p_resid
ggsave(plot = p_resid, filename = "../figures/modelResid")

p_animal = ggplot(resid.df, aes(x = Animal, y = deviance)) +
  geom_point() +
  geom_hline(yintercept = 0, col = 2) +
  labs(title = "Residuals of Animal Type", x = "Animal Type", y = "Deviance")
#p_animal
ggsave(plot = p_animal, filename = "../figures/AnimalResid")


p_condition = ggplot(resid.df, aes(x = intake_condition, y = deviance)) +
  geom_point() +
  geom_hline(yintercept = 0, col = 2) +
  labs(title = "Residuals of Intake Condition", x = "Intake Condition", y = "Deviance")
#p_condition
ggsave(plot = p_condition, filename = "../figures/ConditionResid")


p_sex = ggplot(resid.df, aes(x = Sex, y = deviance)) +
  geom_point() +
  geom_hline(yintercept = 0, col = 2) +
  labs(title = "Residuals of Sex", x = "Sex", y = "Deviance")
#p_sex
ggsave(plot = p_sex, filename = "../figures/SexResid")


p_type = ggplot(resid.df, aes(x = intake_type, y = deviance)) +
  geom_point() +
  geom_hline(yintercept = 0, col = 2) +
  labs(title = "Residuals of Intake Type", x = "Intake Type", y = "Deviance")
#p_type
ggsave(plot = p_type, filename = "../figures/intakeTypeResid")


#########################
#####Results Kind of#####
#########################

#Statistically Significant Variables:
#   - animal_typebird
#   - animal_typecat
#   - animal_typedog (baseline)
#   - animal_typelivestock
#   - animal_typeother
#   - animal_typerabbit
#   - intake_conditionaged 
#   - intake_conditionnormal (baseline)
#   - intake_conditionbehavior  moderate 
#   - intake_conditionbehavior  severe 
#   - intake_conditionferal DONE
#   - intake_conditionfractious DONYE
#   - intake_conditioni/i report (don't know what this is)
#   - intake_conditionill moderate DONYE
#   - intake_conditionill severe
#   - intake_conditioninjured  moderate DONYE
#   - intake_conditioninjured  severe
#   - intake_conditionunder age/weight DONYE
#   - sexNeutered DONYE
#   - sexSpayed DONYE
#   - sexUnknown  (few entries)
#   - intake_typereturn (baseline)
#   - intake_typetrap, neuter, return DONYE

########!!!!!!!!!!!!!!

#The model with the test fit (lowest AIC) is the model with: 
#animal_type + intake_condition + sex + intake_type (in that order)
#so:
#Y_i ~ Bernoulli(p_i), i = 1, 2, ..., 29600
#logit(p_i) = β0 + β1*animal_type + β2*intake_condition + β3*sex + β4*intake_type

#######!!!!!!!!!!!!!!!!

###Baseline I used: Normally behaved, male, foster, dog

#animal_typebird:              2.84023163
#animal_typecat:               1.15281370
#animal_typelivestock:         13.11267223
#animal_typeother:             1.80466383
#animal_typerabbit:            0.56057187
#intake_conditionaged:         0.34786388
#intake_conditionbehavior  moderate:     0.59201338
#intake_conditionbehavior  severe:       0.30441861
#intake_conditionbehavior  mild:         1.52315669          
#intake_conditionferal:                  0.06770035
#intake_conditionfractious:              0.18280726
#intake_conditionill mild:               1.13264170
#intake_conditionill moderate:           0.69925536
#intake_conditionill severe:             0.41694512
#intake_conditioninjured  mild:          0.88528150
#intake_conditioninjured  moderate:      0.64599280
#intake_conditioninjured  severe:        0.29015271
#intake_conditionunder age/weight:       1.24618937
#sexNeutered:                      11.10214121
#sexSpayed:                        11.35987488
#intake_typetrap, neuter, return:        0.02729971

#i.e.: All else equal, a Bird is 2.84023163 times more likely to be adopted than a Normally behaved male (unspayed/un-neutered) foster dog.

#For the rest, see plots (residuals/invlogit) 
#(I included smallest/largest in the documentation mid-code way above)
