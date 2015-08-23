shinyUI(fluidPage(
        titlePanel("Omaha Odds Calculator"),
        
        sidebarLayout(
                sidebarPanel(
                        helpText("Please input your hand and opponent hand and the 
                                current board. Use hands like 'Ks' to represent
                                Spade of King:For color of deck, 
                                d is for diamond, h for heart and c for clubs,
                                Ten to Ace straight is TJQKA.Rest is 2~9.
                                 A typical Omaha hands could be 'AdAhJdTh'or '5h6h7d8d'."),
                        helpText("Board could be flop which contains three cards,
                                 eg,'5s6h9h', or left blank as the preflop odds.
                        For details about Omaha poker, check it on"),
                        a("https://en.wikipedia.org/wiki/
                          Omaha_hold_%27em"),
                        
                textInput("h1","Hand 1",value="AhAs7h7s"),
                textInput("h2","Hand 2",value="QdQc4h5s"),
                textInput("b","Board"),
                actionButton("run","Run")
                
                ),
                mainPanel(
                h3("Odds"),
                helpText("Warning: it will take long time if you specify the 
                                 board like 3card flop, it's about 40~50 seconds to 
                                wait, please be kindly patient.:)."),
                textOutput("text1"),
                textOutput("text2"),
                textOutput("text3"),
                "The winrate Hand 1 vs Hand 2 is (win/tie/lose) :",
                verbatimTextOutput("vtext1")
                )
                
        
        )
))
