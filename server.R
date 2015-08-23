# server.R
library(shiny)
source("evaluator.R")
shinyServer(function(input, output) {
        
        output$text1<-renderText({paste("You have input Hand 1: ",
                                       input$h1,sep="")
        })
        output$text2<-renderText({paste("You have input Hand 2: ",
                                        input$h2,sep="")
        })
        output$text3<-renderText({paste("You have input Board: ",
                                        input$b,sep="")
        })
        observe({
                if (input$run==0)
                return()
                isolate({
                        hand1<-vector()
                        for (i in 1:4) hand1[i]<-substr(input$h1,i*2-1,i*2)
                        hand2<-vector()
                        for (i in 1:4) hand2[i]<-substr(input$h2,i*2-1,i*2)        
                        ##flop or turn is specified
                        if (nchar(input$b)>5){
                                board<-vector()
                                for (i in 1:(nchar(input$b)/2))
                                        board[i]<-substr(input$b,i*2-1,i*2)
                                
                                output$vtext1<-renderText({
                                odds(hand1,hand2,board)        
                                })
                        }
                        else{
                        output$vtext1<-renderText({
                                odds(hand1,hand2)        
                        })
                        }
                })
        
        })
        
        
})

