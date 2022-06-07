###############################################################################
# Openxlsx PHS Training
# Solutions
# Note these are suggested solutions only - there are many ways to get to the answer!
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
wb <- createWorkbook()

addWorksheet(
  wb = wb,
  sheetName = "Notes",
  gridLines = FALSE)

addWorksheet(
  wb = wb,
  sheetName = "Episodes")

addWorksheet(
  wb = wb,
  sheetName = "Charts", 
  gridLines = FALSE)


### Exercise 1b -----
# Add some text to the notes page, include your name, the date and a short description of the data.
# Merge the cells containing the data description
notes <- c("Inpatient and Daycase data for NHS Scotland, 2016 - 2021")
name <- c("Ciara Gribben")
date <- c("06/06/2022")

writeData(wb, sheet = "Notes", x = name, startCol = 2, startRow = 7)
writeData(wb, sheet = "Notes", x = date, startCol = 2, startRow = 8)
writeData(wb,"Notes", notes, startCol = 2, startRow = 9)

mergeCells(
  wb, 
  sheet = "Notes",
  cols = 2:7, rows = 9:10)


### Exercise 1c ----
# Run the code below to read in the episode data and then add it to the episode sheet.
# Give each table an appropriate title
hb_by_qtr_eps <- readRDS("hb_by_qtr_eps.Rds")
hb_by_yr_eps <- readRDS("hb_by_yr_eps.Rds")

writeData(
  wb,
  "Episodes",
  x = hb_by_qtr_eps,
  startCol = 2,
  startRow = 4)

writeData(
  wb,
  "Episodes",
  x = "Episodes by Quarter and Board, 2016 - 2021",
  startCol = 2,
  startRow = 2)

writeData(
  wb,
  "Episodes",
  x = hb_by_qtr_eps,
  startCol = 9,
  startRow = 4)

writeData(
  wb,
  "Episodes",
  x = "Episodes by Year and Board, 2016 - 2021",
  startCol = 9,
  startRow = 2)


### Exercise 1d ----
# Add borders to the tables and bold the title and Scotland row. 
# Also change the colour of the total (Scotland) row to red
header_style <- createStyle(fontSize = 11,
                            fontName = "Arial",
                            halign = "Left", # Horizontal Align
                            valign = "Center", # Vertical align
                            # Can add multiple decorations in a vector
                            textDecoration = c("bold"))

total_style <- createStyle(fontSize = 11,
                           fontName = "Arial",
                           valign = "Bottom",
                           halign = "Center",
                           border = "TopBottomLeftRight",
                           numFmt = "TEXT",
                           textDecoration = "bold", 
                           fgFill = "red")

border_style_thick = createStyle(border = "TopBottomLeftRight",
                                 borderStyle = c("thick"))

addStyle(
  wb,
  "Episodes", 
  border_style_thick, 
  rows = 4:21, 
  cols = 2:6, 
  gridExpand = TRUE,
  stack = TRUE)

addStyle(
  wb,
  "Episodes", 
  border_style_thick, 
  rows = 4:21, 
  cols = 9:13, 
  gridExpand = TRUE,
  stack = TRUE)

addStyle(
   wb,
  "Episodes",
  style = total_style,
  rows = 21,
  cols = c(2:6, 9:13))

addStyle(
  wb,
  "Episodes",
  style = header_style,
  rows = 2,
  cols = c(2, 9))


### Exercise 1e ----
# Run code below to create the charts
# Then add to these to the charts sheet, give each chart a suitable, formatted title.
sex_chart <- sex_chart_data %>% 
  ggplot( aes(x = year, y = stays, group = sex, color = sex)) +
  geom_line()

print(sex_chart)

insertPlot(wb = wb, 
           sheet = "Charts",
           width = 6, 
           height = 4, 
           startRow = 4, 
           startCol = 2, 
           dpi = 300) 

sex_chart_title <- "Stays by year and sex, 2016 - 2021"

writeData(
  wb,
  "Charts",
  x = sex_chart_title,
  startCol = 2,
  startRow = 2)

addStyle(
  wb,
  "Charts",
  style = header_style,
  rows = 2,
  cols = 2)

age_chart <- age_chart_data %>% 
  ggplot( aes(x = year, y = stays, group = age, color = age)) +
  geom_line() +
  scale_y_continuous(labels = comma)

print(age_chart)

insertPlot(wb = wb, 
           sheet = "Charts",
           width = 6, 
           height = 4, 
           startRow = 4, 
           startCol = 10, 
           dpi = 300)

sex_chart_title <- "Stays by year and age group, 2016 - 2021"

writeData(
  wb,
  "Charts",
  x = sex_chart_title,
  startCol = 10,
  startRow = 2)

addStyle(
  wb,
  "Charts",
  style = header_style,
  rows = 2,
  cols = 10)


### Exercise 1f - Save out workbook ----
saveWorkbook(
  wb = wb,
  file = "openxlsx_training.xlsx",
  overwrite = TRUE)
