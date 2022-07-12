library(shiny)







# Define UI for application that draws a histogram
shinyUI(fluidPage(

  
  # Add theme
  theme = bslib::bs_theme(bootswatch = "flatly"),


  
  titlePanel(
    title=div(img(src="batmaid icon.png"), "Monthly customer reviews")
    ),

  # Add toc
  navlistPanel(id = "tabset",widths =c(2,8),


    tabPanel("Reviews of the month",
             tableOutput("comments")),
    
    tabPanel("Ratings of the month",
             tableOutput("ratings")),




    tabPanel("Term frequencies",
             plotOutput("term_frequencies"),
             plotOutput("cloud_of_words")),

    tabPanel("Sentiment analysis",
   plotOutput("sentiment"),
   plotOutput("emotions")),
   




    tabPanel("Words appearing together",
             plotOutput("link"))


    )
  )
)




#library(rsconnect)
#rsconnect::deployApp()

