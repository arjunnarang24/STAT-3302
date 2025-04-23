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
adoption_rates <- longbeach %>%
  group_by(animal_type) %>%
  summarise(adoption_rate = mean(adopted) * 100) %>%
  arrange(desc(adoption_rate))

print(adoption_rates)

# Number of animals per animal type
animal_counts <- longbeach %>%
  count(animal_type)

# Count and proportion of adopted vs. non-adopted animals
adoption_counts <- longbeach %>%
  mutate(adoption_status = ifelse(adopted == 1, "Adopted", "Not Adopted")) %>%
  count(adoption_status) %>%
  mutate(proportion = n / sum(n))


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

# putting colors into more simple categories that are easier to understand for reader
longbeach <- longbeach %>%
  mutate(color = case_when(
    tolower(primary_color) %in% c("tricolor", "calico", "tabby", "ticked", "dapple", "blue merle", "blue tick", "brown tiger", "liver tick", "point", "seal point") ~ "Patterns",
    tolower(primary_color) %in% c("brown", "brown tabby", "brown brindle", "ch lynx point", "chocolate", "chocolate point", "brown merle", "sable", "snowshoe", "tan", "yellow brindle") ~ "Browns",
    tolower(primary_color) %in% c("blue", "blue brindle", "blue lynx point", "blue cream", "blue point", "blue tabby", "gray", "gray tabby", "gray tiger", "lynx point", "seal", "silver", "silver tabby", "st lynx point", "tortie dilute") ~ "Grays and blues", 
    tolower(primary_color) %in% c("apricot", "calico dilute", "calico point", "calico tabby", "fawn", "lilac_cream point", "liver", "orange", "orange tabby", "peach", "pink", "red", "red merle", "red point", "ruddy") ~ "Orange and Red",
    tolower(primary_color) %in% c("black", "black lynx point", "black smoke", "black tabby", "black tiger", "torbie", "tortie") ~ "Black or Dark",
    tolower(primary_color) %in% c("white", "flame point", "lilac lynx point", "lilac point", "silver lynx point") ~ "White Based",
    tolower(primary_color) %in% c("green") ~ "Greens",
    tolower(primary_color) %in% c("yellow", "blonde", "buff", "cream", "cream point", "cream tabby", "gold", "wheat") ~ "Cream and yellows",
    TRUE ~ NA_character_
  ))
# Check if colors are correctly assigned
table(longbeach$color)


# Adoption rate by Primary Color
rateColor <- longbeach %>%
  filter(!is.na(color) & !is.na(adopted)) %>%
  group_by(color) %>%
  summarise(adoption_rate = mean(adopted) * 100) %>%
  arrange(desc(adoption_rate))

# Plot Adoption Rate by colors using the categories we just made
rateByColor <- ggplot(rateColor, aes(x = reorder(color, -adoption_rate), y = adoption_rate, fill = color)) +
  geom_col() +
  labs(title = "Adoption Rates by Primary Color",
       x = "Primary Color",
       y = "Adoption Rate (%)") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c(
    "Patterns" = "darkorchid",
    "Browns" = "brown",
    "Grays and blues" = "steelblue",
    "Orange and Red" = "red",
    "Black or Dark" = "black",
    "White Based" = "lightgray",
    "Greens" = "darkgreen",
    "Cream and yellows" = "wheat"
  ))

ggsave(plot = rateByColor, filename = "../figures/adoptionByColor.pdf")
