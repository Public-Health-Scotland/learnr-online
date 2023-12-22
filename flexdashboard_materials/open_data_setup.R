## Information -----------------------------------

#' Name of file:    open_data_setup.R
#' Author:          Ross Burns
#' Date:            September 2023
#' Written/run on:  Posit Workbench
#' R Version:       4.1.2

#' Credits:
#' - Sally Thompson (Flexdashboard ATI Training Script)


## Description -----------------------------------

#' Import Covid 19 case trends data from the PHS Open Data repository. 
#' Use this data to create plots and htmlwidgets for the flexdashboard training material. 
#' (flexdashboard.Rmd and flexdashboard_example.Rmd)


## 1 - Setup -----------------------------------

#### Load packages ----

libs <- c("dplyr", 
          "janitor",        # Tidy open data
          "tidyr",          # Re-organise dataframes
          "phsopendata",    # Access open data from PHS
          "phsstyles",      # PHS colours for formatting
          "ggplot2",        # Create static plots
          "scales",         # Number formatting
          "lubridate",      # Parse dates
          "plotly",         # Create interactive charts
          "DT",             # Create interactive data tables with sorting/filtering/pagination
          "crosstalk",      # Add filters/linked brushing to htmlwidgets
          "flexdashboard")
lapply(libs, require, character.only = TRUE)



#### Import Open Data ----

# Get Covid-19 Daily Case Trends by Local Authority
# https://www.opendata.nhs.scot/dataset/covid-19-in-scotland/resource/427f9a25-db22-4014-a3bc-893b68243055
daily_la <- get_resource(res_id = "427f9a25-db22-4014-a3bc-893b68243055") %>%
  # Tidy column names & date formats
  clean_names() %>%
  mutate(date = ymd(date))

# Get Daily and Cumulative counts and rates for positive COVID-19 cases and deaths.
# https://www.opendata.nhs.scot/dataset/covid-19-in-scotland/resource/287fc645-4352-4477-9c8c-55bc054b7e76
daily_totals <- get_resource("287fc645-4352-4477-9c8c-55bc054b7e76") %>%
  # Tidy column names & date formats
  clean_names() %>%
  mutate(date = ymd(date))

#### Lookups ----

# Create a lookup for Council Authorities
ca_lookup <- daily_la %>%
  select("code" = ca, ca_name) %>%
  unique()



## 2 - Value Box -----------------------------------

current_totals <- daily_totals %>% 
  filter(date == max(date))

cum_total_cases <- current_totals %>% 
  pull(cumulative_cases)



## 3 - Gauge ---------------------------------------

current_percent_reinfections <- current_totals %>%
  pull(percent_reinfections)



## 4 - R Graphics ----------------------------------

# Get the cumulative total infections by Local Authority (Council Area) for the most recent date available
current_totals_la <- daily_la %>%
  filter(date == max(date)) %>%
  # Select only the necessary columns for our chart, 
  # we want also want to show how many infections were First Infections vs Reinfections
  select(date, ca_name, "First Infection" = first_infections_cumulative, "Reinfection" = reinfections_cumulative) %>%
  # Pivot the Infections columns in order to plot the number of infections by infection type
  pivot_longer(cols = c("First Infection", "Reinfection"), 
               names_to = "infection_type", 
               values_to = "infections")
  
# Plot the cumulative total infections per CA and how many were first infections vs reinfections
current_totals_la_plot <- current_totals_la %>%
  ggplot(aes(infections, ca_name, fill = infection_type)) +
  geom_col() +
  
  # Use label_comma() to force numbers to display in decimal format and add more axis breaks  
  scale_x_continuous(labels = label_comma(), n.breaks = 6) +
  
  # Reverse the order in which Council Areas are displayed on the chart
  scale_y_discrete(limits = rev) +
  
  # Use PHS colours to distinguish between infection types
  scale_fill_discrete_phs(type = "qual", palette = "main") +
  
  # Add annotations and theme options
  labs(title = "Cumulative number of positive Covid-19 cases by Council Area",
       x = "Cumulative Total Cases",
       y = "Council Area",
       fill = "Infection Type") +
  theme_minimal()



## 5 - Tables --------------------------------------

# Create a simple data table with kable()
# Council Areas ranked in order of total positive infections in the most recent full week of data
last_week_totals_ca <- daily_la %>%
  select(date, ca_name, daily_positive) %>%
  mutate(week = floor_date(date, "week")) %>%
  # Filter for the week prior to the most recent week of data,
  # due to incomplete data/no. of days in the final week
  filter(week == max(week) - 7) %>%
  group_by(week, ca_name) %>%
  summarise(weekly_positive = sum(daily_positive)) %>%
  ungroup() %>%
  arrange(desc(weekly_positive))

# Obtain last week's date for dashboard annotations
last_week_start <- last_week_totals_ca %>% pull(week) %>% unique()



## 6 - Plotly --------------------------------------

# Get the weekly counts for Covid-19 cases in Scotland
# to remove some of the jitter when plotted as a time-series chart
weekly_totals <- daily_totals %>%
  select(date, daily_cases) %>%
  mutate(week = floor_date(date, "week")) %>% 
  group_by(week) %>%
  summarise(weekly_cases = sum(daily_cases)) %>%
  filter(week != max(week))

# Plot the weekly counts for Covid-19 cases in a ggplot line chart
weekly_totals_plot <- weekly_totals %>%
  ggplot(aes(week, weekly_cases)) +
  
  # Add PHS colour formatting
  geom_line(colour = phs_colours("phs-magenta")) +
  
  labs(title = "Weekly cases of Covid-19 across Scotland",
       x = "Week",
       y = "Number of cases") +
  theme_minimal()


