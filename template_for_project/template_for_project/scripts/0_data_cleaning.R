############################
## This script performs data cleaning
## Last modified: 2025-03-31
## SP: I removed some variables
############################
## libraries we are using 
library(tidyverse)
install.packages("tidytuesdayR")
install.packages("devtools")
devtools::install_github("EmilHvitfeldt/animalshelter")
library(dplyr)
library(animalshelter)
library(ggplot2)
library(broom)
############################

# Load Data
tuesdata <- tidytuesdayR::tt_load('2025-03-04')
longbeach_raw_data <- tuesdata$longbeach
saveRDS(longbeach_raw_data, "../data/longbeach_raw.rds")

## some cleaning 
longbeach <- longbeach_raw_data |>
  dplyr::mutate(
    was_outcome_alive = as.logical(was_outcome_alive),
    dplyr::across(
      c(
        "animal_type",
        "primary_color",
        "secondary_color",
        "sex",
        "intake_condition",
        "intake_type",
        "intake_subtype",
        "reason_for_intake",
        "jurisdiction",
        "outcome_type",
        "outcome_subtype"
      ),
      as.factor
    )
  )

saveRDS(longbeach, "../data/longbeach_partial.rds")

# Create a binary variable: 1 if adopted, 0 otherwise
longbeach <- longbeach %>%
  mutate(adopted = ifelse(tolower(trimws(outcome_type)) == "adoption", 1, 0))

# Make animal type a factor
longbeach <- longbeach %>%
  mutate(
    animal_type = as.factor(animal_type),
    intake_condition = as.factor(intake_condition),
    sex = as.factor(sex),
    intake_type = as.factor(intake_type)
  )

# Make seasons
longbeach <- longbeach %>%
  mutate(season = case_when(
    format(outcome_date, "%m") %in% c("12", "01", "02") ~ "Winter",
    format(outcome_date, "%m") %in% c("03", "04", "05") ~ "Spring",
    format(outcome_date, "%m") %in% c("06", "07", "08") ~ "Summer",
    format(outcome_date, "%m") %in% c("09", "10", "11") ~ "Fall",
    TRUE ~ NA_character_
  ))

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

longbeach_clean <- na.omit(longbeach %>%
                             select(adopted, animal_type, intake_condition, sex, intake_type, outcome_date, primary_color, season, color))

## .rds format
saveRDS(longbeach_clean, "../data/longbeach_clean.rds")
## read with 
## readRDS("../data/clean_data.rds")

#write.table(cleaned_data, "../data/clean_data.csv",sep = ",", row.names = FALSE)
