###############################################################################
# Openxlsx PHS Training
# Exercises
###############################################################################

### Housekeeping -----
# Load necessary packages for exercises
library(learnr)
library(dplyr)
library(janitor)
library(stringr)
library(openxlsx)
library(ggplot2)

### Exercise 1a ----
# Create a workbook and add 4 pages:
# - a notes page with no gridlines, 
# - a page for episode data
# - a page for charts with no gridlines
# Make sure to give all the sheets suitable names


### Exercise 1b -----
# Add some text to the notes page, include your name, the date and a short description of the data.
# Merge the cells containing the data description


### Exercise 1c ----
# Run the code below to read in the episode data and then add it to the episode sheet.
# Give each table an appropriate title
hb_by_qtr_eps <- readRDS("hb_by_qtr_eps.Rds")
hb_by_yr_eps <- readRDS("hb_by_yr_eps.Rds")


### Exercise 1d ----
# Add borders to the tables and bold the title and Scotland row. 
# Also change the colour of the total (Scotland) row to red



### Exercise 1e ----
# Run code below to create the charts
# Then add to these to the charts sheet, give each chart a suitable, formatted title.
sex_chart <- sex_chart_data %>% 
  ggplot( aes(x = year, y = stays, group = sex, color = sex)) +
  geom_line()

age_chart <- age_chart_data %>% 
  ggplot( aes(x = year, y = stays, group = age, color = age)) +
  geom_line() +
  scale_y_continuous(labels = comma)


### Exercise 1f - Save out workbook ----



### Exercise 2 ----
# Create your excel workbook using the Openxlsx package containing
# (at least) the following:
# * 3 worksheets
# * 1 graph
# * 1 table
# * 2 colours using hexcodes (anywhere in workbook)
# * 1 Email hyperlink
# * Change row heights/column widths on one page

# You can use any data you like but here's some ideas:
# Data you use in your own team, 
# Open data:  https://www.opendata.nhs.scot/,
# TidyTuesday data: https://github.com/rfordatascience/tidytuesday
