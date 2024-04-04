## ----setup, include=FALSE-------------------
knitr::opts_chunk$set(echo = TRUE)


## -------------------------------------------
library(readxl)
library(tidyr)
library(ggplot2)
library(dplyr)
library(ggthemes)



## -------------------------------------------
# Load dataset - FSA score from 2007/2008 - 2016/2017
FSA0716 <- read_excel("foundational_skills_assessment_2007-08_to_2016-17_residents_only.xlsx")
print(FSA0716)

## -------------------------------------------
# Load dataset - FSA score from 2017/2018 - 2020/2021
FSA1721 <- read_excel("foundational_skills_assessment_2017-18_to_2020-21_residents_only.xlsx")
print(FSA1721)

## -------------------------------------------
# Combine the two datasets "FSA0716" and "FSA1721" into one dataset called "FSA"
FSA <- rbind(FSA0716,FSA1721)


## -------------------------------------------
# Compute descriptive statistics
summary(FSA)


## -------------------------------------------
# See if there's any NA value in this dataset
sum(is.na(FSA))

## -------------------------------------------
# Display the names of columns with missing values
columns_with_na <- colnames(FSA)[colSums(is.na(FSA)) > 0]
print(columns_with_na)


## -------------------------------------------
# Clean NA valuse
# replace 000 with NA in DISTRICT_NUMBER and "Unknown" with NA in DISTRICT_NAME
FSA <- FSA %>% mutate(DISTRICT_NUMBER = ifelse(is.na(DISTRICT_NUMBER), "000", DISTRICT_NUMBER))
FSA <- FSA %>% mutate(DISTRICT_NAME = ifelse(is.na(DISTRICT_NAME), "Unknown", DISTRICT_NAME))


## -------------------------------------------
sum(is.na(FSA))


## -------------------------------------------
# Modify data type
FSA$NUMBER_EXPECTED_WRITERS = as.numeric(as.character(FSA$NUMBER_EXPECTED_WRITERS)) 

## -------------------------------------------
# Cleaning "Msk"(values are fewer than 10) values
# Drop columns that contains Msk value (or NA value after data type transformation) in the “NUMBER_EXPECTED_WRITERS” column and store the new dataset in "FSA_filtered" 
FSA_filtered <- FSA[complete.cases(FSA$NUMBER_EXPECTED_WRITERS), ]



## -------------------------------------------
# Counting the total number of "Msk"
sum(FSA_filtered == "Msk", na.rm = TRUE)


## -------------------------------------------
# Replace all the MSK with values
# Condition 1: when value in the "NUMBER_EXPECTED_WRITERS" column is between 10-49, replace all "Msk" values with 5

selected_columns <- c("NUMBER_WRITERS","NUMBER_UNKNOWN", "NUMBER_EMERGING", "NUMBER_ONTRACK", "NUMBER_EXTENDING")

FSA_filtered <- FSA_filtered %>%
  mutate_at(vars(selected_columns), function(x) ifelse(FSA_filtered$NUMBER_EXPECTED_WRITERS < 50 & x == "Msk", 5, x))



## -------------------------------------------
# Condition 2: when value in the "NUMBER_EXPECTED_WRITERS" column is greater than 50, replace all "Msk" values with 10

selected_columns <- c("NUMBER_WRITERS","NUMBER_UNKNOWN", "NUMBER_EMERGING", "NUMBER_ONTRACK", "NUMBER_EXTENDING")

FSA_filtered <- FSA_filtered %>%
  mutate_at(vars(selected_columns), function(x) ifelse(FSA_filtered$NUMBER_EXPECTED_WRITERS >= 50 & x == "Msk", 10, x))



## -------------------------------------------
sum(FSA_filtered == "Msk", na.rm = TRUE)


## -------------------------------------------
# change data type for the "NUMBER_WRITERS", "NUMBER_UNKNOWN", "NUMBER_EMERGING", "NUMBER_ONTRACK", "NUMBER_EXTENDING",and "SCORE" columns.
FSA_filtered <- FSA_filtered %>%
  mutate(GRADE = as.numeric(GRADE),
         NUMBER_WRITERS = as.numeric(NUMBER_WRITERS),
         NUMBER_UNKNOWN = as.numeric(NUMBER_UNKNOWN),
         NUMBER_EMERGING = as.numeric(NUMBER_EMERGING),
         NUMBER_ONTRACK = as.numeric(NUMBER_ONTRACK),
         NUMBER_EXTENDING = as.numeric(NUMBER_EXTENDING),
         SCORE = as.numeric(SCORE))


## -------------------------------------------
# Convert SCHOOL_YEAR to numeric
FSA_filtered$SCHOOL_YEAR <- as.character(FSA_filtered$SCHOOL_YEAR)
FSA_filtered$SCHOOL_YEAR <- as.numeric(substring(FSA_filtered$SCHOOL_YEAR, 1, 4))


## -------------------------------------------
summary(FSA_filtered)



## -------------------------------------------
# Calculate the mean score for each year
mean_scores <- FSA_filtered %>%
  group_by(SCHOOL_YEAR, FSA_SKILL_CODE, GRADE) %>%
  summarise(mean_score = mean(SCORE, na.rm = TRUE))

print(mean_scores)


## -------------------------------------------
ggplot(mean_scores, aes(x = SCHOOL_YEAR, y = mean_score, color = FSA_SKILL_CODE, linetype = factor(GRADE))) +
  geom_line() +
  labs(title = "Yearly Growth in Numeracy, Reading, and Writing Skills Assessment",
       x = "Year",
       y = "Mean Score") +
  theme_minimal()


## -------------------------------------------
overall_mean_scores <- FSA_filtered %>%
  group_by(DISTRICT_NAME, FSA_SKILL_CODE) %>%
  summarise(mean_score = mean(SCORE, na.rm = TRUE))

# Identify the top 5 districts
top_districts <- overall_mean_scores %>%
  group_by(FSA_SKILL_CODE) %>%
  top_n(5, wt = mean_score) %>%
  ungroup()

# Identify the worst 5 districts 
worst_districts <- overall_mean_scores %>%
  group_by(FSA_SKILL_CODE) %>%
  top_n(-5, wt = mean_score) %>%
  ungroup()


## -------------------------------------------
# Visualize the top 5 districts
ggplot(top_districts, aes(x = reorder(DISTRICT_NAME, mean_score), y = mean_score, fill = FSA_SKILL_CODE)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Top 5 Districts with Best Overall Scores",
       x = "District",
       y = "Mean Score",
       fill = "Subject") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c("Numeracy" = "blue", "Reading" = "orange", "Writing" = "darkgreen")) +
  facet_wrap(~FSA_SKILL_CODE, scales = "free_y", ncol = 1)



## -------------------------------------------
# Visualize the worst 5 districts 

ggplot(worst_districts, aes(x = reorder(DISTRICT_NAME, mean_score), y = mean_score, fill = FSA_SKILL_CODE)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Worst 5 Districts with Lowest Overall Scores",
       x = "District",
       y = "Mean Score",
       fill = "Subject") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c("Numeracy" = "blue", "Reading" = "yellow", "Writing" = "darkgreen")) +
  facet_wrap(~FSA_SKILL_CODE, scales = "free_y", ncol = 1)



## -------------------------------------------
# Filter for the relevant columns and subpopulations
FSA_sub <- FSA_filtered %>%
  select(SUB_POPULATION, SCHOOL_YEAR, FSA_SKILL_CODE, SCORE) %>%
  filter(SUB_POPULATION %in% c('Indigenous', 'Diverse Abilities', 'Non Indigenous', 'Non Diverse Abilities'))



## -------------------------------------------
ggplot(FSA_sub, aes(x = SUB_POPULATION, y = SCORE, fill = FSA_SKILL_CODE)) +
  geom_boxplot() +
  labs(title = "Overall Performance Among Subpopulations",
       x = "Subpopulation",
       y = "Score",
       fill = "Subject") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c("Numeracy" = "lightblue", "Reading" = "orange", "Writing" = "darkgreen"))


## -------------------------------------------
# Filter for the relevant columns
FSA_performance <- FSA_filtered %>%
  select(SCHOOL_YEAR, GRADE, NUMBER_EMERGING, NUMBER_ONTRACK, NUMBER_EXTENDING)


## -------------------------------------------

# Visualize "NUMBER_EMERGING"
ggplot(FSA_performance, aes(x = factor(SCHOOL_YEAR), y = NUMBER_EMERGING, fill = factor(GRADE))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Distribution of NUMBER_EMERGING for Grade 4 and Grade 7",
       x = "Year",
       y = "Number",
       fill = "Grade") +
  theme_minimal()



## -------------------------------------------
# Visualize "NUMBER_ONTRACK"
ggplot(FSA_performance, aes(x = factor(SCHOOL_YEAR), y = NUMBER_ONTRACK, fill = factor(GRADE))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Distribution of NUMBER_ONTRACK for Grade 4 and Grade 7",
       x = "Year",
       y = "Number",
       fill = "Grade") +
  theme_minimal()


## -------------------------------------------
# Visualize "NUMBER_EXTENDING"
ggplot(FSA_performance, aes(x = factor(SCHOOL_YEAR), y = NUMBER_EXTENDING, fill = factor(GRADE))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Distribution of NUMBER_EXTENDING for Grade 4 and Grade 7",
       x = "Year",
       y = "Number",
       fill = "Grade") +
  theme_minimal()

