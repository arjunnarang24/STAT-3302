## This script looks at exploratory data analysis 
## Last modified: 2025-04-16
## Moved the season variable to data cleaning and changed it so that the working directory is in the scripts (feel free to alter this if not satisfactory just let group know) - AN
## added our raw adoption percentage and number of animals adopted, plotted intake condition, intake type, sex, and color as we said in our proposal. - LW
############################
## libraries we are using 
library(ggplot2)
library(dplyr)
library(broom)
############################
df <- data.frame(x = rnorm(100))

plot1 <- ggplot(data = df, aes(x = x)) + geom_histogram()

longbeach <- readRDS("~/STAT 3302/template_for_project/template_for_project/data/longbeach_clean.rds")

head(longbeach)

str(longbeach)

# Summary of Variables
summary(longbeach)

# Get Dimensions
dim(longbeach)

# Check for N/A 
colSums(is.na(longbeach))

# Number of animals adopted
table(longbeach$adopted)

# % of animals adopted 
numberAdopted <- 6290/(23310+6290) *100

# Check Adoption Rates
adoption_rates <- longbeach_clean %>%
  group_by(animal_type) %>%
  summarise(adoption_rate = mean(adopted) * 100) %>%
  arrange(desc(adoption_rate))

print(adoption_rates)

# Number of animals per animal type
animal_counts <- longbeach %>%
  count(animal_type)

# Plotting raw numbers to just see how many of each animal we have
animals <- ggplot(animal_counts, aes(x = reorder(animal_type, -n), y = n)) +
  geom_col(fill = "steelblue") +
  labs(title = "Number of Animals per Animal Type",
       x = "Animal Type",
       y = "Number of Animals")
ggsave(plot = animals, filename = "../figures/NumberofEachAnimal.pdf")

# Adoption Rates by Animal Type
rateByType <- ggplot(adoption_rates, aes(x = reorder(animal_type, -adoption_rate), y = adoption_rate)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Adoption Rates by Animal Type",
       x = "Animal Type",
       y = "Adoption Rate (%)") +
  theme_minimal()

ggsave(plot = rateByType, filename = "../figures/AdoptionRatesByAnimal.pdf")


# Plot proportions
adoptionProp <- ggplot(adoption_counts, aes(x = adoption_status, y = proportion, fill = adoption_status)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::percent_format()) +  # Convert to percentage format
  labs(title = "Proportion of Adopted vs. Non-Adopted Animals",
       x = "Adoption Status",
       y = "Proportion (%)") +
  theme_minimal()

ggsave(plot = adoptionProp, filename = "../figures/AdoptionProportions.pdf")

longbeach <- longbeach %>%
  mutate(outcome_date = as.Date(outcome_date))


# Check if seasons are correctly assigned
table(longbeach$season)

seasonal_adoption <- longbeach %>%
  filter(!is.na(season) & !is.na(adopted)) %>%  # Remove NAs
  group_by(season) %>%
  summarise(adoption_rate = mean(adopted, na.rm = TRUE) * 100) %>%
  arrange(factor(season, levels = c("Winter", "Spring", "Summer", "Fall")))  # Ensure correct order

print(seasonal_adoption)

seasonalPlot <- ggplot(seasonal_adoption, aes(x = season, y = adoption_rate, fill = season)) +
  geom_bar(stat = "identity") +
  labs(title = "Seasonal Trends in Pet Adoptions",
       x = "Season",
       y = "Adoption Rate (%)") +
  theme_minimal()

ggsave(plot = seasonalPlot, filename = "../figures/adoptionsBySeason.pdf")

# Adoption rate by intake condition
intakeCondition <- longbeach %>%
  filter(!is.na(intake_condition) & !is.na(adopted)) %>%
  group_by(intake_condition) %>%
  summarise(adoption_rate = mean(adopted) * 100) %>%
  arrange(desc(adoption_rate))

# Plot adoption rate by intake condition
rateByCondition <- ggplot(intakeCondition, aes(x = reorder(intake_condition, -adoption_rate), y = adoption_rate)) +
  geom_col(fill = "steelblue") +
  labs(title = "Adoption Rates by Intake Condition",
       x = "Intake Condition",
       y = "Adoption Rate (%)") +
  theme_minimal() + coord_flip()

ggsave(plot = rateByCondition, filename = "../figures/adoptionByCondition.pdf")

# Adoption rate by Sex
rateSex <- longbeach %>%
  filter(!is.na(sex) & !is.na(adopted)) %>%
  group_by(sex) %>%
  summarise(adoption_rate = mean(adopted) * 100) %>%
  arrange(desc(adoption_rate))

# Plot adoption rate by Sex
rateBySex <- ggplot(rateSex, aes(x = reorder(sex, -adoption_rate), y = adoption_rate)) +
  geom_col(fill = "steelblue") +
  labs(title = "Adoption Rates by Sex",
       x = "Sex",
       y = "Adoption Rate (%)") +
  theme_minimal()

ggsave(plot = rateBySex, filename = "../figures/adoptionBySex.pdf")


# Adoption rate by intake type - different than intake condition
# There are 2 different types of returns so I combined them here using mutate
intakeType <- longbeach %>%
  filter(!is.na(intake_type) & !is.na(adopted)) %>%
  mutate(intake_type = case_when(
    intake_type %in% c("return", "adopted animal return") ~ "return",
    TRUE ~ intake_type)) %>%
  group_by(intake_type) %>%
  summarise(adoption_rate = mean(adopted) * 100) %>%
  arrange(desc(adoption_rate))

# Plot adoption rate by intake type
rateByType <- ggplot(intakeType, aes(x = reorder(intake_type, -adoption_rate), y = adoption_rate)) +
  geom_col(fill = "steelblue") +
  labs(title = "Adoption Rates by Intake Type",
       x = "Intake Type",
       y = "Adoption Rate (%)") +
  theme_minimal() + coord_flip() 

ggsave(plot = rateByType, filename = "../figures/adoptionByType.pdf")


# Adoption rate by Primary Color
rateColor <- longbeach %>%
  filter(!is.na(primary_color) & !is.na(adopted)) %>%
  group_by(primary_color) %>%
  summarise(adoption_rate = mean(adopted) * 100) %>%
  arrange(desc(adoption_rate))

# Top 20 adoption rate colors. There are too many to graph all on one chart
topColors <- rateColor %>%
  slice_max(adoption_rate, n = 20)

# Plot Adoption Rate by colors using only the top 20 with the highest adoption
rateByColor <- ggplot(topColors, aes(x = reorder(primary_color, -adoption_rate), y = adoption_rate)) +
  geom_col(fill = "steelblue") +
  labs(title = "Adoption Rates by Primary Color",
       x = "Primary Color",
       y = "Adoption Rate (%)") +
  theme_minimal() + theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(plot = rateByColor, filename = "../figures/adoptionByColor.pdf")
