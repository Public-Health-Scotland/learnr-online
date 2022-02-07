# Packages
library(learnr)
library(dplyr)
library(janitor)
library(stringr)
library(openxlsx)

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

graph1 <- data %>%
ggplot(aes(sepal_length, sepal_width, color = species))+
geom_point()+
theme_classic()+
labs(x="Sepal Length", y="Sepal Width",
title = "Sepal Length by Sepal Width Across Different Species",
color = "Species")

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
file = "ATI Workbook.xlsx",

# Whether you want to overwrite the file already there
overwrite = TRUE)

## Creating Styles
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
  1, 
  
  # Name of object we want to write
  data_table, 
  
  # Which column/row should we start writing the data to
  startCol = 2, startRow = 4)

# Apply style to table body
addStyle(
  
  # Name of workbook object we're working on
  wb, 
  
  # Sheet to apply style to, can either use sheet number or sheet name
  sheet = 1, 
  
  # Style to apply
  style = body_style, 
  
  # Rows and Columns to apply style to
  rows = 7, 
  cols = 4)

# Apply border style
addStyle(
  wb,
  1, 
  border_style_thick, 
  rows = 4:7, cols = 2:4, gridExpand = TRUE,
  stack = TRUE)

addStyle(wb, 1, blue_style, rows = 4:7, cols = 2:4, gridExpand = TRUE,
         stack = TRUE)


saveWorkbook(
  # Workbook to save
  wb = wb,
  
  # The file path to save out to
  # - only short version here as working directory is set by the project
  file = "ATI Workbook.xlsx",
  
  # Whether you want to overwrite the file already there
  overwrite = TRUE)  
