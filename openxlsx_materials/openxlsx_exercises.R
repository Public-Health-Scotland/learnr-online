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

### Exercise 1 ----
# Create a workbook and add 4 pages:
# - a notes page with no gridlines, 
# - a page for episode data
# - a page for charts with no gridlines
# Make sure to give all the sheets suitable names
wb <- createWorkbook()

addWorksheet(
  # Name of the workbook we want to add the sheet to
  wb = wb,
  
  # Define the name of the worksheet 
  sheetName = "Notes",
  
  # No gridlines
  gridLines = FALSE)

addWorksheet(
  # Name of the workbook we want to add the sheet to
  wb = wb,
  
  # Define the name of the worksheet 
  sheetName = "Episodes")

addWorksheet(
  # Name of the workbook we want to add the sheet to
  wb = wb,
  
  # Define the name of the worksheet 
  sheetName = "Charts", 

  # No gridlines
  gridLines = FALSE)


### Exercise 2 -----
# Add some text to the notes page, include your name, the date and a short description of the data.
#Merge the cells containing the data description
notes <- c("Inpatient and Daycase data for NHS Scotland, 2016 - 2021")
name <- c("Ciara Gribben")
date <- c("06/06/2022")

writeData(wb, sheet = "Notes", x = name, startCol = 2, startRow = 7)
writeData(wb, sheet = "Notes", x = date, startCol = 2, startRow = 8)
writeData(wb,"Notes", notes, startCol = 2, startRow = 9)

mergeCells(
  # Specify workbook to apply to
  wb, 
  
  # Define worksheet for formatting to apply to
  sheet = "Notes",
  
  # Define columns and rows to merge
  cols = 2:7, rows = 9:10)


### Exercise 3 ----
# Run the code below to read in the episode data and then add it to the episode sheet.
# Give each table an appropriate title
# hb_by_qtr_eps <- readRDS("hb_by_qtr_eps.Rds")
# hb_by_yr_eps <- readRDS("hb_by_yr_eps.Rds")
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


### Exercise 4 ----
# Add borders to the tables and bold the title and Scotland row. 
# Also change the colour of the total row to red
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
  
  # Name of workbook object we're working on
  wb,
  
  # Sheet to apply style to
  "Episodes",
  
  # Style to apply
  style = total_style,
  
  # Rows and Columns to apply style to
  rows = 21,
  cols = c(2:6, 9:13))

addStyle(
  
  # Name of workbook object we're working on
  wb,
  
  # Sheet to apply style to
  "Episodes",
  
  # Style to apply
  style = header_style,
  
  # Rows and Columns to apply style to
  rows = 2,
  cols = c(2, 9))

### Exercise 5 ----
# Run code below to create in charts and add to charts sheet
# Give each chart a suitable title and format it like the title on the Episodes sheet
print(sex_chart)

insertPlot(wb = wb, 
           
           # Sheet number/name
           sheet = "Charts",
           
           # Width/height of the graph - you might need to play around to get the right ratio
           width = 6, 
           height = 4, 
           
           # Define where the top and left side of the chart should sit
           startRow = 4, 
           startCol = 2, 
           
           # Resolution of the chart
           dpi = 300) 

sex_chart_title <- "Stays by year and sex, 2016 - 2021"

writeData(
  wb,
  "Charts",
  x = sex_chart_title,
  startCol = 2,
  startRow = 2)

addStyle(
  
  # Name of workbook object we're working on
  wb,
  
  # Sheet to apply style to
  "Charts",
  
  # Style to apply
  style = header_style,
  
  # Rows and Columns to apply style to
  rows = 2,
  cols = 2)

print(age_chart)

insertPlot(wb = wb, 
           
           # Sheet number/name
           sheet = "Charts",
           
           # Width/height of the graph - you might need to play around to get the right ratio
           width = 6, 
           height = 4, 
           
           # Define where the top and left side of the chart should sit
           startRow = 4, 
           startCol = 10, 
           
           # Resolution of the chart
           dpi = 300)

sex_chart_title <- "Stays by year and age group, 2016 - 2021"

writeData(
  wb,
  "Charts",
  x = sex_chart_title,
  startCol = 10,
  startRow = 2)

addStyle(
  
  # Name of workbook object we're working on
  wb,
  
  # Sheet to apply style to
  "Charts",
  
  # Style to apply
  style = header_style,
  
  # Rows and Columns to apply style to
  rows = 2,
  cols = 10)

saveWorkbook(
  # Workbook to save
  wb = wb,
  
  # The file path to save out to
  # - only short version here as working directory is set by the project
  file = "openxlsx_training.xlsx",
  
  # If a file with the same name exists, do you want to overwrite it?
  overwrite = TRUE)


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
