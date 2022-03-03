### 1 -  Setup ----
# Packages
library(dplyr)
library(janitor)
library(stringr)
library(openxlsx)
library(ggplot2)

# Read in data
iris <- iris
head (iris)

# Clean variable names and data
data <- iris %>%
clean_names() %>%
mutate(species = str_to_title(species))

# Create a table with the minimum and maximum petal length for each iris species
data_table <- data %>%
group_by(species) %>%
summarise(max_pet_length = max(petal_length),
max_pet_width = max(petal_width)) %>% 
rename(Species = species, 
`Max Petal Length` = max_pet_length,
`Max Petal Width` = max_pet_width)

# Create a table with a count of each iris species
data_table2 <- data %>%
group_by(species) %>%
summarise(number = n())

# Create a simple chart to include in the excel document
graph1 <- data %>%
ggplot(aes(sepal_length, sepal_width, color = species))+
geom_point()+
theme_classic()+
labs(x="Sepal Length", y="Sepal Width",
title = "Sepal Length by Sepal Width Across Different Species",
color = "Species")

graph1


### 2 - Create initial excel output ----
# Create workbook
wb <- createWorkbook()

# Add worksheet
addWorksheet(
  # Name of the workbook we want to add the sheet to
  wb = wb,
  
  # Define the name of the worksheet 
  sheetName = "Table1",
  
  # Show gridlines? Default is TRUE
  gridLines = FALSE,
  
  # Colour of the tab - either use from colours() list or use hex code (optional)
  tabColour = "red", # Uses in built colour
  
  # Add headers - as a character vector for positions left, centre and right
  # You can use some in built things
  # (such as page numbers, date, time, filename etc)
  header = c("ODD HEAD LEFT", "ODD HEAD CENTER", "ODD HEAD RIGHT"))

# Write data
writeData(wb, 1, data_table, startCol = 2, startRow = 4)

# Save
saveWorkbook(
# Workbook to save
wb = wb,

# The file path to save out to
# - only short version here as working directory is set by the project
file = "openxlsx_training.xlsx",

# Whether you want to overwrite the file already there
overwrite = TRUE)


### 3 - Creating Styles ----
# Styles for the table headers, borders, the contents of any tables and any non-header text
header_style <- createStyle(fontSize = 14,
fontName = "Arial",
halign = "Center", # Horizontal Align
valign = "Center", # Vertical align
wrapText = TRUE,
# Can add multiple decorations in a vector
textDecoration = c("bold", "underline"))

table_style <- createStyle(fontSize = 11,
fontName = "Arial",
valign = "Bottom",
halign = "Right",
border = "TopBottomLeftRight",
numFmt = "COMMA")

body_style <- createStyle(fontSize = 11,
fontName = "Arial",
valign = "Bottom",
halign = "Left",
border = "TopBottomLeftRight",
numFmt = "TEXT")

border_style_dash = createStyle(border = "TopBottomLeftRight",
borderStyle = c("dashed"))

border_style_thick = createStyle(border = "TopBottomLeftRight",
borderStyle = c("thick"))

# You can also define colours using hex codes and use these colours within styles:

blue <- "#add8e6"
gray <- "#ededed"

blue_style = createStyle(
fgFill = blue
)

gray_style = createStyle(
fgFill = gray
)

### Applying styles
wb <- createWorkbook()

addWorksheet(
  # Name of the workbook we want to add the sheet to
  wb = wb,
  
  # Define the name of the worksheet 
  sheetName = "Table1",
  
  # Show gridlines? Default is TRUE
  gridLines = FALSE,
  
  # Colour of the tab - either use from colours() list or use hex code (optional)
  tabColour = "red", # Uses in built colour
  
  # Add headers - as a character vector for positions left, centre and right
  # You can use some in built things
  # (such as page numbers, date, time, filename etc)
  header = c("ODD HEAD LEFT", "ODD HEAD CENTER", "ODD HEAD RIGHT"))

writeData(
  
  # Name of workbook to add the data to
  wb, 
  
  # Sheet to insert data into
  "Table1", 
  
  # Name of object we want to write
  data_table, 
  
  # Which column/row should we start writing the data to
  startCol = 2, startRow = 4)

# Apply style to table body
addStyle(
  
  # Name of workbook object we're working on
  wb, 
  
  # Sheet to apply style to, can either use sheet number or sheet name
  sheet = "Table1", 
  
  # Style to apply
  style = body_style, 
  
  # Rows and Columns to apply style to
  rows = 7, 
  cols = 4)

# Apply border style
addStyle(
  wb,
  "Table1", 
  border_style_thick, 
  rows = 4:7, cols = 2:4, gridExpand = TRUE,
  stack = TRUE)

addStyle(wb, "Table1", blue_style, rows = 4:7, cols = 2:4, gridExpand = TRUE,
         stack = TRUE)


saveWorkbook(
  
  # Workbook to save
  wb = wb,
  
  # The file path to save out to
  # - only short version here as working directory is set by the project
  file = "openxlsx_training.xlsx",
  
  # Whether you want to overwrite the file already there
  overwrite = TRUE)  

#### 4 - Worksheet Formatting ----
wb <- createWorkbook()

addWorksheet(
  wb = wb,
  sheetName = "Data_Tables",
  gridLines = FALSE,
  tabColour = "red", # Uses in built colour
  header = c("ODD HEAD LEFT", "ODD HEAD CENTER", "ODD HEAD RIGHT"))

# Add a table title and better column names:
title_table <- "Max Petal Length and Width in Each Species Within Iris Dataset"
writeData(wb, "Data_Tables", title_table, startCol = 2, startRow = 2)

names(data_table) <- c("Species", "Max Petal Length", "Max Petal Width")
writeData(wb, "Data_Tables", data_table, startCol = 2, startRow = 4)


### 5 - Excel Functionality -----
## Pivot Table
names(data_table2) = c("Species", "Number")

# This function creates an actual table in excel
writeDataTable(wb, sheet = "Data_Tables", startCol = 6, x = data_table2,
               startRow = 4,
               # You can check the names by hovering over table styles in excel
               tableStyle = "TableStyleLight15",
               # Names the table - not necessary in most situations though
               tableName = "Data_Table_2")

# Add a title for this table
title_table2 <- "Number of each Iris Species in Dataframe"
writeData(wb, "Data_Tables", title_table2, startCol = 6, startRow = 2)

## Formulae
# Adding "Total"
writeData(wb, "Data_Tables",
          # You can just add a string here, rather than saving to objects
          # Better to save to an object if the string is long,
          # for neatness and readability
          x = "Total",
          startCol = 6, startRow = 8)

# Use this function to write excel formulae
writeFormula(wb, "Data_Tables", x = "=SUM(G5:G7)",
             startCol = 7, startRow = 8)


### 6 - Adding Plots -----
addWorksheet(
  wb = wb,
  sheetName = "Charts",
  gridLines = FALSE,
  tabColour = "blue", # Uses in built colour
  header = c("ODD HEAD LEFT", "ODD HEAD CENTER", "ODD HEAD RIGHT"))

print(graph1)

insertPlot(wb = wb, 
           sheet = 2,
           width = 6, 
           height = 4, 
           startRow = 3, 
           startCol = 2, 
           dpi = 300) 

saveWorkbook(
  # Workbook object build in the beginning
  wb = wb,
  # The file path
  # - only short version here as working directory is set by the project
  file = "openxlsx_training.xlsx",
  # Whether you want to overwrite the file already there
  overwrite = TRUE)
