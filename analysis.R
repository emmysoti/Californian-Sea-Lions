library(tidyverse)
library(broom)
library(MASS)


### LOAD ORIGINAL DATA ###
original_data <- read.csv("https://api-proxy.edh-cde.dfo-mpo.gc.ca/catalogue/records/08f2ea2c-8fe3-4a97-b4f5-944580ac4154/attachments/California_counts_2026-03-30.csv")



### CLEAN DATA ###
# make a new copy of original data for cleaning/modification
data <- original_data 

# modify column values from "DFO Area xx" to "xx"
data$DFOArea <- substr(data$DFOArea, 10, 11) 

# convert all "ns" ("not surveyed") to NA
data[data == "ns"] <- NA

# Pup column is entirely NAs, so it will be removed
data <- dplyr::select(data, -Pup)

# make "N" into 0 and "Y" into 1 (No -> 0, Yes -> 1)
data$Inferred <- if_else(data$Inferred == "N", 0, 1)

# add column of month surveyed, and column of whether sea lions were present
data <- data %>%
  mutate(Survey_Month = substr(Survey_Date, 6, 7),
         Present = Total > 0)

# create groups for years with 5 years in each group
data$year_group <- cut(
  data$Year,
  breaks = seq(
    floor(min(data$Year, na.rm = TRUE) / 5) * 5,
    ceiling(max(data$Year, na.rm = TRUE) / 5) * 5,
    by = 5
  ),
  include.lowest = TRUE,
  right = FALSE
)



### EXPLORATORY DATA ANALYSIS ###
# total lion count histogram - Total_plot
total_plot <-
  ggplot(data, aes(x = Total)) +
  geom_histogram() +
  labs(title = "Histogram of 'Total' values")

# month vs total sea lion count boxplot - month_boxplots
month_boxplots <-
  ggplot(data, aes(x = Survey_Month, y = Total)) +
  geom_boxplot() +
  labs(x = "Month", y = "Total Counts", title = "Boxplots of total counts by month")

# year vs total sea lion count boxplot - Year_boxplots
year_boxplots <-
  ggplot(data, aes(x = year_group, y = Total)) +
  geom_boxplot() +
  labs(x = "Year", y = "Total Counts", title = "Boxplots of total counts by year") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# dataframe with site names and respective means of total sea lion counts
site_means <- data %>%
  group_by(Site) %>%
  summarise(mean_total = mean(Total, na.rm = TRUE))

# site means histogram of sites and respective means of total sea lion counts
total_site_plot <- 
  ggplot(site_means, aes(x = mean_total)) +
  geom_histogram(bins = 40) +
  labs(x = "Mean of sites", 
       y = "Count", 
       title = "Distribution of mean sea lion counts across sites")

### ANALYSIS ###
# Poisson GLM w/ total as response and year, site, month as explanatory variables
site_year_month_pois_mod <- 
  glm(
    Total ~ Year + Site + Survey_Month,
    family = "poisson",
    data = data
  )

# Negative binomial GLM w/ same response and explanatory variables as poisson
site_year_month_nb_mod <-
  glm.nb(
    Total ~ Year + Site + Survey_Month,
    data = data
  )
