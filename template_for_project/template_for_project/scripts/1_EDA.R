## This script looks at exploratory data analysis 
## Last modified: 2025-04-15
## Moved the season variable to data cleaning and changed it so that the working directory is in the scripts (feel free to alter this if not satisfactory just let group know) - AN
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

# Check Adoption Rates
adoption_rates <- longbeach_clean %>%
  group_by(animal_type) %>%
  summarise(adoption_rate = mean(adopted) * 100) %>%
  arrange(desc(adoption_rate))

print(adoption_rates)


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


