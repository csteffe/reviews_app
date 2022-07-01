library(shiny)

# get monthly data and cleaning

source(here::here("R/web_scraping.R"))
source(here::here("R/data_preparation.R"))
source(here::here("R/tf_plot.R"))
source(here::here("R/sentiment.R"))
source(here::here("R/emotions.R"))




# Define UI for application that draws a histogram
shinyUI(fluidPage(

  
  # Add theme
  theme = bslib::bs_theme(bootswatch = "flatly"),


  
  titlePanel(
    title=div(img(src="batmaid_logo.jpeg"), "Customer reviews")
    ),

  # Add toc
  navlistPanel(id = "tabset",


    tabPanel("Reviews of the month",
             tableOutput("comments")),




    tabPanel("Term frequencies",
             plotOutput("term_frequencies"),
             plotOutput("cloud_of_words")),

    tabPanel("Sentiment analysis",
   plotOutput("sentiment"),
   plotOutput("emotions")),
   




    tabPanel("Link between words",
             plotOutput("link")),

    #         selectInput("record_st", "Choose a record type:",
     #                    c(unique(data$record)),
      #                   multiple = FALSE),

       #      selectInput("indicator_st", "Choose an indicator:",
        #                 c("crop_land", "grazing_land", "forest_land",
         #                  "fishing_ground", "built_up_land", "carbon", "total"),
          #               multiple = FALSE),

  #           selectInput(inputId =  "start_year",
   #                      label = "Select start of the period",
    #                     choices = 1961:2016),

     #        selectInput(inputId =  "end_year",
      #                   label = "Select end of the period",
       #                  choices = 1961:2016),
#
 #            tableOutput("Statistics"))

    )
  )
)






