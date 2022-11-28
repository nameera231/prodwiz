library(shiny)
library(tidyverse)
library(spData) 
library(sf) 
library(leaflet) 
library(DT) 

# Load study data
studentinfo <- read.csv("data/studentinfo.csv")



# Clean the study data
studentinfo <- filter(studentinfo, Stars != "Unrated")
studentinfo$Stars <- as.numeric(as.character(studentinfo$Stars))


# Define UI for application
ui <- fluidPage(
  
  # 
   # CSS
   tags$head(
     tags$style(HTML("
       body { display: grid; margin:auto; background-color: #ebf3ff; font-family: 'Rock Salt', cursive;}
       .container-fluid { background-color: #ebfcf7; width: 1100px; padding: 15px; }
       .topimg { width: 120px; display: block; margin: 0px auto 40px auto; }
       .title { text-align: center; font-family: 'Rock Salt', cursive;}
       .toprow { display: block; margin:40;  padding: 3px; }
       .filters { padding: 3px; margin:30;display: block; padding: 15px}
       .bar { margin: auto; padding:15px; background-color:#a3c7ff; }
       .navbar .navbar-default .navbar-static-top {margin-bottom: 0px}
       .tabs { 
          padding: 30px;
          margin-bottom: 40px;
          margin-top: 5px;
          max-width: 1000px;
          background-color: #fff;
          border-radius: 10px;}
       
       .well {
          min-height: 100px;
          max-width: 200px;
          padding: 4px;
          margin-bottom: 20px;
          margin-top: 5px;
          background-color: #fff;
          border-radius: 10px;
          -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.05);
          box-shadow: inset 0 1px 1px rgba(0,0,0,.05);
          font-family: 'Rock Salt', cursive;}
       "))
     ),
   

   # Image Icon (royalty free)
   img(class = "topimg", src = "https://i.ibb.co/jkTMvNh/gr.png"),
  
   # Application title
   h1("Productivity Wiz", class = "title"),
   
   navbarPage( 
                "Find your perfect study spot!",
              tabPanel("Learn",h3("Learn about Productivity Wiz"),
                       navlistPanel(
                
                well=TRUE,
                
                tabPanel(class="tabs","About",
                         h3("About Productivity Wiz"),
                         p("Productivity Wiz is the solution for students who want to know the best location to study. It takes into account the student's location and the amount of time they are likely to spend studying. We use aggregated data about students' productivity in different locations to provide you with the best options."),
                         p("The results are displayed in a bar chart, so students can choose the location that is best for them.The bar chart is helpful because it allows students to see at a glance which locations are the most productive for studying. It also makes it easy to compare different locations."),
                         h2("How to use the app"),
                         p("1. Scroll down to the interactive part of the app."),
                         p("2. Select a major from the drop down menu to find the top 5 locations for studying in Grinnell College based on your major."),
                         p("3. Scroll down below the major chart. Select a class year from the drop down menu to find the top 5 locations for studying in Grinnell College based on your class year"),
                ),
                tabPanel(class="tabs",
                         "Acknowledgements",
                         h3("Acknowledements"),
                         p("The following resources were really helpful in the making of the Shiny app:   
              the Shiny website (https://shiny.rstudio.com/)
              ,the Shiny cheatsheet (https://shiny.rstudio.com/articles/cheatsheet.html)
              ,the Shiny gallery (https://shiny.rstudio.com/gallery/), Guidance on making app interactive(https://unc-libraries-data.github.io/R-Open-Labs/Extras/shiny/shiny.html).

              These resources were helpful in developing the app because they provide a wealth of information on Shiny and how to use it."),
                         p("R packages were extremely helpful in creating the app. Shiny allowed me to create an interactive web app, while tidyverse and sf allowed me to manipulate and preserve the spatial data. leaflet and DT were used to create the maps and tables, respectively and made them look very professional. Although not all the packages made it into my end product, I would still like to acknowledge them for all I learned.")
                ),
                tabPanel(class="tabs","Design"
                         ,h3("The Design Process")
                         ,p("The textbooks suggested by the professor helped me design Productivity Wiz by providing a clear understanding of what web app design is and how to create a process that will respond to user needs. It was helpful in informing the design of the app because it helped me understand how to design a system that would be easy to use and understand.
                  Some examples of how I made sure my app has good design include:
                  -Making sure the app is easy to use and understand
                  -Creating a streamlined user journey
                  -Focusing on responsive site elements
                  -Ensuring performance across multiple devices")
                         ,p("When designing this web app, there are a few key things I kept in mind in order to create an effective design. First, I thought about who will be using the app and what their needs are. I considered the overall goals of the app and how it will stand out from other similar products. Additionally, I focused on creating a minimal, responsive and intuitive user interface, as well as ensuring that the app performs well across multiple devices. Finally, I made sure to offer some offline functionality in the app so that users can still use the Learn page of the app even if they do not have a strong internet connection.")
                         ,p("The app design process involved making a wireframe of key features and then a mockup.")
                         ,p("The mockup was not entirely translated into the app because I wanted to display the interactive part of the app as a separate area in the app rather than a  alongside the educational tabs of the app. I did not want users who are more hands-on learners to be bogged down by the guides and details if they wanted to skip that and just interact with the app. Since interacting with the app is really easy, I wanted to make sure that as the user is reading the About page or the Design page, they can test out and engage with the app by switching easily.")
                         
                ))),
              tabPanel("Interact", h3("Explore study spots"),
                       fluidRow(class = "toprow",
                                fluidRow (class = "filters",
                                          
                                          column(5,
                                                 # Allow user to select major
                                                 selectInput("style", "Major", c("All",
                                                                                 "Biology",
                                                                                 "Computer Science",
                                                                                 "Chemistry",
                                                                                 "Economics",
                                                                                 "English",
                                                                                 "History",
                                                                                 "Mathematics",
                                                                                 "Philosophy",
                                                                                 "Physics",
                                                                                 "Political Science",
                                                                                 "Psychology",
                                                                                 "Sociology"))
                                          )
                                )
                       ),
                       
                       fluidRow (
                         
                         column(10, class = "bar",
                                # Bar Chart by major
                                plotOutput("brandBar")
                                
                         )
                         
                         
                       ),
                       fluidRow(class = "toprow",
                                fluidRow (class = "filters",
                                          
                                          column(5,
                                                 # Class year menu
                                                 selectInput("country", "Class Year", c("All","First","Second","Third","Fourth")) # Sort options alphabetically
                                                 
                                          )
                                )
                       ),
                       fluidRow (
                         
                         
                         
                         column(10, class = "bar",
                                # Bar Chart class year
                                plotOutput("typeBar")
                         )))
   
   
))

# Define server logic
server <- function(input, output) {

  # Create bar chart of majors
  output$brandBar <- renderPlot( {
    
    # Filter data based on selected Major
    if (input$style != "All") {
      studentinfo <- filter(studentinfo, Style == input$style)
    }
    
    # Error message for when user has filtered out all data
    validate (
      need(nrow(studentinfo) > 0, "No data found. Please make another selection.")
    )
    
    # Get top 5 places to study
    brands <- group_by(studentinfo, Brand) %>% 
      summarise(avgRating = mean(Stars)) %>% 
      arrange(desc(avgRating)) %>% 
      top_n(5)
    
    # Bar chart
    ggplot(brands, aes(reorder(Brand, avgRating))) +
      geom_bar(aes(weight = avgRating), fill = "tomato3") + 
      coord_flip() +
      ggtitle("Top 5 Places to study based on major") +
      xlab("Location") +
      ylab("Avg. Hours studied") +
      theme_bw(base_size = 13)
    
    
  })
  
  # Create bar chart of class year
  output$typeBar <- renderPlot( {
    
    
    # Filter data based on selected class year
    if (input$country != "All") {
      studentinfo <- filter(studentinfo, Country == input$country)
    }
    
    # Error message for when user has filtered out all data
    validate (
      need(nrow(studentinfo) > 0, "No data found. Please make another selection.")
    )
    
    # Get top 5 places to study based on year
    brands <- group_by(studentinfo, Brand) %>% 
      summarise(avgRating = mean(Stars)) %>% 
      arrange(desc(avgRating)) %>% 
      top_n(5)
    
    # Bar chart
    ggplot(brands, aes(reorder(Brand, avgRating))) +
      geom_bar(aes(weight = avgRating), fill = "tomato3") + 
      coord_flip() +
      ggtitle("Top 5 Places to study based on class year") +
      xlab("Location") +
      ylab("Avg. Hours studied") +
      theme_bw(base_size = 13)
    
    
  })
  
  
   
}

# Run the application 
shinyApp(ui = ui, server = server)

