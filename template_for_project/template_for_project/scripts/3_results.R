```{r}
Results

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
```

The final logistic regression model included four key predictors: animal_type, intake_condition, sex, and intake_type. 
The model with these variables achieved the lowest AIC, indicating the best fit among the tested models. 
The baseline animal for comparison is a normally behaved, male, foster-intake dog.
## Animal Type
Adoption likelihood varied significantly by species:
- Birds were 2.84 times more likely to be adopted than the baseline.
- Cats and rabbits also had significantly higher odds of adoption, with log-odds of 1.15 and 0.56.
- Livestock had the highest effect, with a log-odds coefficient of 13.11, though this may reflect a small sample size or special intake circumstances.
- Other animals like reptiles were 1.80 log-odds more likely to be adopted than the baseline dog.

## Intake Condition

Animals arriving in better condition were more likely to be adopted:
- Mildly ill or injured animals showed higher adoption likelihoods than those with severe conditions. For example:
    - Ill (mild): 1.13
    - Injured (mild): 0.88
    - Under age/weight animals were also more likely to be adopted (1.25).
- Behavioral concerns reduced adoption probability:
    - Severe behavior issues: 0.30
    - Feral: 0.07
    - Fractious (aggressive): 0.18

## Sex
Sterilization status had a strong impact:
- Neutered animals: log-odds = 11.10
- Spayed animals: log-odds = 11.36
- This shows that sterilized animals were far more likely to be adopted than intact males (the baseline group).

## Intake Type
- Animals coming in through Trap-Neuter-Return (TNR) programs had much lower chances of adoption, with a coefficient of 0.03, indicating that these animals were likely returned to their environment rather than adopted.
- Foster intake (baseline) served as the reference for comparison.


## Now looking at the peason residual models

Model Diagnostics: Pearson Residuals
To assess model fit, we examined Pearson residuals versus fitted values for each predictor included in the final logistic regression model.
1. Animal Type
- Most residuals are clustered around 0, indicating that the model fits well for most categories of animal type.
- A few points with residuals above 1 suggest some minor underfitting (for instance, maybe actual adoption outcomes were higher than predicted) for certain less common animal types.
- However, no residuals exceed ±2, indicating that there are no extreme outliers or poor-fitting categories.
Conclusion: The model captures adoption patterns by animal type reasonably well.

2. Intake Condition
- Once again, the residuals are tightly clustered around zero.
- Similar to animal type, mild under- and over-prediction appears for certain conditions, especially at lower fitted probabilities.
- No concerning deviations or extreme values are observed.
Conclusion: The intake condition variable is well-modeled, with no evidence of poor fit for any specific category.

3. Sex

- The residuals are mostly centered around zero, with fewer distinct fitted values due to the small number of sex categories.
- Slight underfitting is seen in some categories, possibly due to class imbalance (like fewer unknown animals).
Conclusion: The sex variable contributes significantly to prediction, and residual patterns are acceptable.

4. Intake Type

- There is a wider spread of residuals, especially for low fitted values.
- This is most likely due to variation in adoption rates between standard intake types (like “foster” vs. “TNR”) and rarer or edge-case types.
Conclusion: The model performs well overall but could benefit from further refinement or splitting of nuanced intake categories.

Overall Model Fit
Across all predictors:
- Most residuals fall within the ±2 range, indicating no strong violations of model assumptions.
- The horizontal spread of residuals proves there is no clear pattern of heteroscedasticity.
- These plots all collectively support the use of the chosen predictors, and the model appears to generalize well to the observed data.

## Looking at AIC output and Stepwise Regression

Step 1: Starting from the Null Model

Null model AIC = 30623.21
Adding sex reduces the AIC to 22953.39, a substantial improvement of nearly 7,670 points, making it the strongest single predictor.
Other predictors also lowered the AIC:
intake_type: AIC = 25533.36
animal_type: AIC = 26776.34
intake_condition: AIC = 29932.68

Step 2: Adding to the Model with sex
The updated model is adopted ~ sex (AIC = 22953.39)
Adding intake_condition yields a large drop in AIC to 22216.39, proving this variable meaningfully improves model performance
Adding other variables instead gives higher AICs:
intake_type: AIC = 22616.49
animal_type: AIC = 22769.29

Step 3: Adding to the Model with sex + intake_condition
Current AIC = 22216.39
Adding intake_type lowers AIC further to 21928.34
Other options:
animal_type: AIC = 22021.64
intake_type is selected as the next best variable.
Summary of Optimal Model (Lowest AIC = 21928.34)

The best model identified by stepwise selection includes:
adopted ~ sex + intake_condition + intake_type
This model reduces the AIC by 8,695 points compared to the null model, showing a large improved fit. 

Sex had the largest individual effect.
Intake condition captures medical and behavioral differences in animals.
Intake type reflects the context in which animals entered the shelter (for instance, foster, stray, TNR).

## Interpretting the Regression model and odds ratios
Model Overview
This logistic regression model estimates the log-odds of an animal being adopted based on:
Animal type
Intake condition
Sex
Intake type
The baseline category (intercept) is:

A male, unaltered dog with normal intake condition, from a foster intake type.
The model has:
Null deviance: 30,621 on 29,599 degrees of freedom
Residual deviance: 21,683 on 29,559 degrees of freedom
AIC: 21,765 — suggesting strong improvement over the null model.


Animal Type
- bird: Estimate = 1.044, p < 0.001
    - Birds are significantly more likely to be adopted than the baseline (dogs). Odds increase by exp(1.044) ≈ 2.84 times.
- cat: Estimate = 0.142, p = 0.0004
    - Cats also have higher odds than dogs; odds ratio ≈ 1.15.
- guinea pig: Estimate = 1.797, p < 2e-16
    - Very high adoption likelihood compared to dogs; odds ratio ≈ 6.03.
- livestock: Estimate = 2.574, p < 0.001
    - Strong effect, odds ratio ≈ 13.11.
- rabbit: Estimate = –0.579, p < 0.001
    - Rabbits are significantly less likely to be adopted than dogs; odds ratio ≈ 0.56.
- amphibian, wild, and reptile: Not statistically significant, most likely due to low sample sizes.

Intake Condition
- feral: Estimate = –2.693, p < 2e-16
    - Extremely reduced chance of adoption; odds ratio ≈ 0.07.
- fractious (aggressive): Estimate = –1.699, p < 2e-16
    - Significantly less likely to be adopted; odds ratio ≈ 0.18.
- behavior severe: Estimate = –1.189, p = 0.005
    - Odds of adoption ≈ 0.30.
- ill severe: Estimate = –0.875, p < 1e-9
    - Decreases odds to ≈ 0.42.
- injured severe: Estimate = –1.237, p < 2e-16
    - Reduces odds significantly to ≈ 0.29.
- under age/weight: Estimate = 0.220, p < 0.001
    - Slightly increases odds of adoption; odds ratio ≈ 1.25.
- behavior mild, ill mild, and injured mild: Not statistically significant.

Sex
- Neutered: Estimate = 2.407, p < 2e-16
    - Odds of adoption increase by exp(2.407) ≈ 11.10 times relative to intact males.
- Spayed: Estimate = 2.430, p < 2e-16
    - Odds increase by exp(2.430) ≈ 11.36.
- Unknown: Estimate = –1.871, p < 2e-16
    - Much lower odds of adoption; odds ratio ≈ 0.15.
- Female: Not statistically significant compared to males.
 
Intake Type
- trap, neuter, return (TNR): Estimate = –3.601, p = 0.023
    - Much lower likelihood of adoption (odds ratio ≈ 0.027), which makes sense since animals in this category are usually returned to their environment.
- Other intake types (e.g., stray, owner surrender) were not statistically significant, suggesting their effect is less pronounced or more variable in the dataset.
Conclusion
This model strongly supports:
Sterilization status is the strongest predictor of adoption (odds are much higher).
Animals with mild or no health/behavioral issues are more adoptable.
Species like birds, guinea pigs, and livestock are more likely to be adopted than dogs, while rabbits are less likely.
Animals with severe illness, injury, or behavioral issues have significantly lower odds of adoption.
TNR programs are highly associated with non-adoption outcomes, as expected.

## Looking at each indivudal model


Animal Type (Files: AnimalType.pdf & AnimalResid.pdf)
- Probability Plot (AnimalType.pdf)
This shows the estimated probability of adoption by animal type.
    - Dogs and cats have moderate probabilities of adoption (~0.5–0.6).
    - Birds, rabbits, and guinea pigs show higher probabilities.
    - Livestock and reptiles also display high estimated probabilities, but these results may be due to low sample size or outlier cases (like adoptions through special programs).
- Residual Plot (AnimalResid.pdf)
The deviance residuals mostly fall within ±2, indicating good model fit across animal types.
    - A few larger residuals are visible for less common types like wild or reptile, suggesting predictions for those types might be less accurate (less data).
Conclusion: The model captures adoption trends well for major categories. Some rare animal types may need further data.

 Intake Condition (Files: intakeCondition.pdf & ConditionResid.pdf)
- Probability Plot (intakeCondition.pdf)
Shows a clear trend:
    - “Normal”, “under age/weight”, and “ill (mild)” animals have higher adoption probabilities.
    - Severely ill, injured, feral, or fractious animals show much lower probabilities.
    - Behavioral concerns—especially severe—lower adoption chances.
- Residual Plot (ConditionResid.pdf)
Most values fall within ±2, suggesting overall good model fit.
    - Slight under- or overfitting is seen in categories with smaller sample sizes like “welfare seizures” and “i/i report”.
Conclusion: Intake condition is a strong predictor of adoption. Predictions for rare or ambiguous categories (like “i/i report”) might be less reliable.

 Intake Type (Files: intakeType.pdf & intakeTypeResid.pdf)
- Probability Plot (intakeType.pdf)
    - Animals from foster, owner surrender, and stray categories have higher adoption probabilities.
    - Trap-Neuter-Return (TNR) and wildlife have very low adoption probabilities—as expected since they are often returned, not adopted.
- Residual Plot (intakeTypeResid.pdf)
Deviance residuals mostly within ±2 again, showing decent fit.
    - Some underprediction may occur for “stray” and “welfare seized,” possibly due to mixed adoption outcomes in those groups.
Conclusion: The model fits well, and the adoption probabilities align with operational shelter expectations. Intake type strongly influences adoption likelihood.

 Sex (Files: sex.pdf & SexResid.pdf)
- Probability Plot (sex.pdf)
    - Spayed and neutered animals show significantly higher adoption probabilities.
    - Unaltered males and females are less likely to be adopted.
    - Unknown sex has the lowest probability, likely due to unclear health or behavior records.
- Residual Plot (SexResid.pdf)
Residuals are mostly near zero, indicating excellent model fit.
Conclusion: Sterilization status is one of the most important predictors.

Overall Model Fit (modelResid.pdf)
- This plot displays deviance residuals vs. fitted values.
    - Most residuals lie within the ±2 range across all predicted adoption probabilities.
    - There's no major curvature or funneling, which supports the model’s assumption of linearity on the logit scale and homoscedasticity.
Conclusion: The logistic model appears to be appropriate across the range of fitted probabilities. There are no signs of any large outliers.
