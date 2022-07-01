library(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {


  # Generate a plot to show the sustainability of the chosen country
  output$comments <- renderTable({

    data_trust
  })

  output$term_frequencies <- renderPlot({
tf_plot
  })
  
  output$cloud_of_words <- renderPlot({
    textplot_wordcloud(data_trust.dfm, min_count = 1) 
  })

  output$sentiment <- renderPlot({
  senti_plot
  })
  
  output$emotions <- renderPlot({
    emotion_plot
  })
  
  output$link <- renderPlot({
    link_plot
  })

 # output$Statistics <- renderTable({
  #  G6_stats(input$countries_st, input$record_st, input$indicator_st, (input$start_year:input$end_year))
#  })

 })

