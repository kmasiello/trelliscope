library(trelliscopejs)
library(tidyverse)
library(shiny)


# reprex based on https://stackoverflow.com/questions/61939011/use-trelliscope-with-shiny

ui <- shinyUI(fluidPage(
    trelliscopeOutput(outputId = "plot")
))


server <- shinyServer(function(input, output) {
    output$plot <- renderTrelliscope({
        
        ggplot2::mpg %>%
            group_by(manufacturer, class) %>%
            nest() %>%
            mutate(
                panel = map_plot(data, ~
                                     ggplot(data = ., aes(x = cty, y = hwy)) +
                                     geom_point(color = I("red")) +
                                     theme_bw())) %>%
            ungroup() %>%  # May or may not need this line. I ran into this issue without `ungroup` https://github.com/hafen/trelliscopejs/issues/102
            ### both of these options will work in deploying to Connect
            # trelliscope(name = "output", self_contained = TRUE)
            trelliscope(name = "output", self_contained = TRUE, path="www/trelliscope")
    })
})


shinyApp(ui = ui, server = server)