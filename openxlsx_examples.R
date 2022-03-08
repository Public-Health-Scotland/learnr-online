###############################################################################
# Openxlsx PHS Training
# Example code to create workbook using Iris Dataset
###############################################################################

### 1 - Housekeeping ----
# Load packages
library(learnr)
library(dplyr)
library(janitor)
library(stringr)
library(openxlsx)
library(ggplot2)

### 2 - Creating a workbook -----
wb <- createWorkbook()

# Adding worksheets
# Add Notes Page
addWorksheet(
  # Name of the workbook we want to add the sheet to
  wb = wb,
  
  # Define the name of the worksheet 
  sheetName = "Notes",
  
  # Do we want to show gridlines? The default is TRUE so we have to specify if we don't want them
  gridLines = FALSE,
  
  # Add headers - as a character vector for positions left, centre and right
  # You can use some in built things
  # (such as page numbers, date, time, filename etc)
  header = c("&[Date]", NA, NA))

# Add Data Page
addWorksheet(
  # Name of the workbook we want to add the sheet to
  wb = wb,
  
  # Define the name of the worksheet 
  sheetName = "Data",
  
  # Do we want to show gridlines? The default is TRUE so we have to specify if we don't want them
  gridLines = FALSE,
  
  # Colour of the tab - either use from colours() list or use hex code (optional)
  tabColour = "red", # Uses in built colour
  
  # Add headers - as a character vector for positions left, centre and right
  # You can use some in built things
  # (such as page numbers, date, time, filename etc)
  header = c("ODD HEAD LEFT", "ODD HEAD CENTER", "ODD HEAD RIGHT"))

# Add Charts Page
addWorksheet(
  # Name of the workbook we want to add the sheet to
  wb = wb,
  
  # Define the name of the worksheet 
  sheetName = "Charts",
  
  # Do we want to show gridlines? The default is TRUE so we have to specify if we don't want them
  gridLines = FALSE,
  
  # Colour of the tab - either use from colours() list or use hex code (optional)
  tabColour = "blue", # Uses in built colour
  
  # Add headers - as a character vector for positions left, centre and right
  # You can use some in built things
  # (such as page numbers, date, time, filename etc)
  header = c("ODD HEAD LEFT", "ODD HEAD CENTER", "ODD HEAD RIGHT"))


### 3 - Adding Tables -----
# Read in iris data and clean
data <- iris %>%
  clean_names() %>%
  mutate(species = str_to_title(species))

# Create a table with the minimum and maximum petal length for each iris species
min_max_data <- data %>%
  group_by(species) %>%
  summarise(max_pet_length = max(petal_length),
            max_pet_width = max(petal_width)) %>% 
  rename(Species = species, 
         `Max Petal Length` = max_pet_length,
         `Max Petal Width` = max_pet_width)

# Create a table with a count of each iris species
count_data <- data %>%
  group_by(species) %>%
  summarise(number = n())

# Write out min/max dataset as a static table
writeData(
  # Name of the workbook we want to add the sheet to
  wb = wb,
  
  # Name of tab to save the data to 
  sheet = "Data", 
  
  # Name of the object we want to write out
  min_max_data, 
  
  # Row and column we want to have the top left cell of the data in
  startCol = 2, 
  startRow = 4)

# Write out count dataset as a pivot table
writeDataTable(
  # Name of the workbook we want to add the sheet to
  wb,

  # Name of tab to save the data to
  "Data",

  # Name of the object we want to write out
  count_data,

  # Row and column we want to have the top left cell of the data in
  startCol = 2,
  startRow = 12)


### 4 - Adding Charts -----
# Create a chart to insert into the workbook and view
graph1 <- data %>%
  ggplot(aes(sepal_length, sepal_width, color = species))+
  geom_point()+
  theme_classic()+
  labs(x="Sepal Length", y="Sepal Width",
       color = "Species")

graph1

# Print the chart to ensure the correct one is used
print(graph1)

# Insert chart into Charts tab of workbook
insertPlot(wb = wb, 
           
           # Sheet number/name
           sheet = "Charts",
           
           # Width/height of the graph - you might need to play around to get the right ratio
           width = 6, 
           height = 4, 
           
           # Define where the top and left side of the chart should sit
           startRow = 3, 
           startCol = 2, 
           
           # Resolution of the chart
           dpi = 300) 

### 5 - Adding Formulae ----
# Create a `Total` row at the bottom of the existing tab=le
writeData(
  wb,
  "Data",
  x = "Total",
  startCol = 2,
  startRow = 16)

# Add the excel formula to calculate the total
writeFormula(
  wb,
  "Data",
  x = "=SUM(C13:C15)",
  startCol = 3,
  startRow = 16)


### 6 - Styles -----
# Create styles for the table headers, borders, the contents/totals of any tables 
# and any non-header text
header_style <- createStyle(fontSize = 11,
                            fontName = "Arial",
                            halign = "Left", # Horizontal Align
                            valign = "Center", # Vertical align
                            # Can add multiple decorations in a vector
                            textDecoration = c("bold", "underline"))

table_style <- createStyle(fontSize = 11,
                           fontName = "Arial",
                           valign = "Bottom",
                           halign = "Right",
                           border = "TopBottomLeftRight",
                           numFmt = "COMMA")

total_style <- createStyle(fontSize = 11,
                          fontName = "Arial",
                          valign = "Bottom",
                          halign = "Center",
                          border = "TopBottomLeftRight",
                          numFmt = "TEXT",
                          textDecoration = "bold")

border_style_dash = createStyle(border = "TopBottomLeftRight",
                                borderStyle = c("dashed"))

border_style_thick = createStyle(border = "TopBottomLeftRight",
                                 borderStyle = c("thick"))

# Define blue and grey colours using hex codes 
blue <- "#add8e6"
gray <- "#ededed"

# Use the defined colours to create new styles which colour cells
blue_style = createStyle(
  fgFill = blue
)

gray_style = createStyle(
  fgFill = gray
)

# Add total_style to the total row of table 2
addStyle(

  # Name of workbook object we're working on
  wb,

  # Sheet to apply style to
  "Data",

  # Style to apply
  style = total_style,

  # Rows and Columns to apply style to
  rows = 16,
  cols = 2:3)

# Add border styles to both tables
addStyle(
  wb,
  "Data", 
  border_style_thick, 
  rows = 4:7, 
  cols = 2:4, 
  gridExpand = TRUE,
  stack = TRUE)

addStyle(
  wb,
  "Data", 
  border_style_dash, 
  rows = 12:16, 
  cols = 2:3, 
  gridExpand = TRUE,
  stack = TRUE)

# Apply colour to background of cells in Table 1        
addStyle(
  wb,
  "Data", 
  blue_style, 
  rows = 4:7, 
  cols = 2:4, 
  gridExpand = TRUE,
  stack = TRUE)


### 7 - Formatting ----
# Create information for the notes page 
# Title
contact <-  "Contact Details:"

# Email
email <- "mailto:first.last@phs.scot"
names(email) <- "first.last@phs.scot"
class(email) <- "hyperlink"

# Description
notes_text <- paste0("An overview of Fischer's iris data including 2 summary tables and a chart.")

# Adding Information to notes page
writeData(wb, sheet = "Notes", x = contact, startCol = 2, startRow = 9)
writeData(wb, sheet = "Notes", x = email, startCol = 3, startRow = 9)
writeData(wb,"Notes", notes_text, startCol = 2, startRow = 7)

# Merge the cells containing the description text
mergeCells(
  # Specify workbook to apply to
  wb, 
  
  # Define worksheet for formatting to apply to
  sheet = "Notes",
  
  # Define columns and rows to merge
  cols = 2:7, rows = 7:8)

# ncrease column width so that the 'Contact Details' text isn't cut off
setColWidths(
  # Specify workbook to apply to
  wb, 
  
  # Define worksheet for formatting to apply to
  sheet = "Notes", 
  
  # Columns to apply to
  cols = 2, 
  
  # Width - check within excel by right clicking on column and clicking "Column Width"
  widths = 15) 

# Table Titles and column names
## Table 1 - add table title and use header style to format it
title_table1 <- "Max Petal Length and Width in Each Species Within Iris Dataset"
writeData(wb, "Data", title_table1, startCol = 2, startRow = 2)
addStyle(wb, "Data", header_style, rows = 2, cols = 2)

## Table 1 - Column Names
names(min_max_data) <- c("Species", "Max Petal Length", "Max Petal Width")
writeData(wb, "Data", min_max_data, startCol = 2, startRow = 4)

## Table 2 - add table title and use header style to format it
title_table2 <- "Number of each Iris Species in Dataframe"
writeData(wb, "Data", title_table2, startCol = 2, startRow = 10)
addStyle(wb, "Data", header_style, rows = 10, cols = 2)

## Table 2 - add better column names
## Note that we cannot overwrite the cells containing existing pivot table 
## So we will add a new pivot table underneath the existing one
## Alternatively - rerun this script skipping lines 109 - 122 and the output
# will have only one pivot table
names(count_data) <- c("Species", "Number")
writeDataTable(wb, "Data", count_data, startCol = 2, startRow = 18)

## Chart - add chart title and use header style to format it
chart_title <- "Chart 1: Sepal Length by Sepal Width Across Different Species"
writeData(wb, "Charts", chart_title, startCol = 2, startRow = 2)
addStyle(wb, "Charts", header_style, rows = 2, cols = 2)


### 8 - Save Final workbook ----
saveWorkbook(
  # Workbook to save
  wb = wb,
  
  # The file path to save out to
  # - only short version here as working directory is set by the project
  file = "iris_openxlsx_training.xlsx",
  
  # If a file with the same name exists, do you want to overwrite it?
  overwrite = TRUE)


##### END OF SCRIPT #####