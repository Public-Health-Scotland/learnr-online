# PHS Learn R Online

*Interactive web-application to learn R, for employees in Public Health Scotland.*

These applications are hosted online and provide functionality around quizzes and interactive code chunks. 

* [Introduction to R](https://github.com/Public-Health-Scotland/learnr-online/blob/master/Intro.Rmd) - learning R from the basics, including its integration to PHS; workflow, tools, templates, and other resources. 
    * Currently hosted here: https://scotland.shinyapps.io/phs-learnr-intro/
* [Data Visualisation in R](https://github.com/Public-Health-Scotland/learnr-online/blob/master/DataViz.Rmd) - building on an the Intro to R course, learn data visualisation with `ggplot2` and an introduction to `plotly`. 
    * Currently hosted here: https://scotland.shinyapps.io/phs-learnr-dataviz/ 
* [Introduction to Open Data](https://github.com/Public-Health-Scotland/learnr-online/blob/master/OpenData.Rmd) - learning what open data is and how it's used in PHS, then getting interactive accessing open data using R. 
    * Currently hosted here: https://scotland.shinyapps.io/phs-learnr-opendata/ 
* [Introduction to OpenXLSX](https://github.com/Public-Health-Scotland/learnr-online/blob/master/OpenXLSX.Rmd) - a course providing an introduction to the `openxlsx`, used to read, write, and edit Excel files from R. 
    * Currently hosted here: https://scotland.shinyapps.io/phs-learnr-openxlsx/
* [IRPQ](https://github.com/Public-Health-Scotland/learnr-online/blob/master/IRPQ.Rmd)) - learning the Information Requests & Parliamentary Questions process.
    * Currently hosted here: https://scotland.shinyapps.io/phs-learn-irpq/
* [PHS Methods](https://github.com/Public-Health-Scotland/learnr-online/blob/master/PHSMethods.Rmd) - learning the internally developed R package, `phsmethods`. 
    * Currently hosted here: https://scotland.shinyapps.io/phs-learnr-phsmethods/  
* [SPSS to R](https://github.com/Public-Health-Scotland/learnr-online/blob/master/SPSStoR.Rmd) - a translation course to work alongside the Introduction to R course with a focus on translating code from SPSS to R. 
    * Currently hosted here: https://scotland.shinyapps.io/phs-learnr-spsstor/ 
* [SQL in R](https://github.com/Public-Health-Scotland/learnr-online/blob/master/SQL.Rmd) - an introductory course for SQL with details of working with SQL and databases inside R. 
    * Currently hosted here: https://scotland.shinyapps.io/phs-learnr-sql/ 

### Directories
As this is a shiny prerendered project, only certain filenames are accessible from within the app. These are outlined below:
  * `css` - css styling scripts
  * `images` - images used within the apps
  * `www` - other accessible static files
    + `data` - data files made available for use as part of the app
    
Other directories:
  * `openxlsx` - supporting files and exercises for the Introduction to OpenXLSX course
    
### Files
  * `DataViz.Rmd` - RMarkdown file containing all necessary code to build app for the data viz course
  * `Intro.Rmd` - RMarkdown file containing all necessary code to build app for the intro course
  * `IRPQ.Rmd` - RMarkdown file containing all necessary code to build app for the IRPQ course
  * `OpenData.Rmd` - RMarkdown file containing all necessary code to build app for the open data course
  * `OpenXLSX.Rmd` - RMarkdown file containing all necessary code to build app for the openxlsx course
  * `PHSMethods.Rmd` - RMarkdown file containing all necessary code to build app for the phsmethods course
  * `SPSStoR.Rmd` - RMarkdown file containing all necessary code to build app for the SPSS to R course
  * `SQL.Rmd` - RMarkdown file containing all necessary code to build app for the SQL in R course
  * `.gitignore` - tells git what files and folders *not* to track or upload to GitHub
  * `LICENSE` - MIT License 
  * `PHS-LearnR.Proj` - R project
  * `README.md` - this page


## Get in touch

* Email: phs.transformingpublishing@phs.scot
