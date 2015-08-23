## try use exaustive way rather than sample to find the equity.
##set  data 
card_num<-c("A",2,3,4,5,6,7,8,9,"T","J","Q","K")
color<-c("s","h","d","c")

fulldeck<-NULL
for (i in 1:length(card_num)){
        
        
        fulldeck<-c(fulldeck,
                    paste(card_num[i],color[1],sep=""),
                    paste(card_num[i],color[2],sep=""),
                    paste(card_num[i],color[3],sep=""),
                    paste(card_num[i],color[4],sep=""))
        
}


##hand interpretor 

cardv<-function(c1=as.character(c1)){
        ##judge if it's only A without suit, it also works.
        c1<-unlist(strsplit(c1,split=""))[1]
        switch(c1,"A"=1,"2"=2,"3"=3,"4"=4,"5"=5,"6"=6,"7"=7,
               "8"=8,"9"=9,"T"=10,"J"=11,"Q"=12,"K"=13)
}



cardc<-function(c1=as.character(c1)){
        c1<-unlist(strsplit(c1,split=""))[2]
        switch(c1,"s"="spade","h"="heart","d"="diamond","c"="club")
        
}

##currently no use
hand<-function(h1,h2,h3,h4){
        
        c(cardv(h1),cardv(h2),cardv(h3),cardv(h4))
        
}


##ranking system
rank<-c("1HC","2SP","3TP","4TR","5ST","6FL","7FH","8QZ","9SF")

##decide strength
###decide if it's flush  , high card is the higher card in hand.
## say if it's K high , it will be 612FL as the 6 for FL and 12 for K
is.FL<-function(hand=c(h1,h2,h3,h4,h5)){
        col<-sapply(hand,cardc,USE.NAMES=FALSE)
        if (length(unique(col))==1){
                return(TRUE)                
        }
        return(FALSE)
}



###decide if straight  
is.ST<-function(hand=c(h1,h2,h3,h4,h5)){
        val<-sapply(hand,cardv,USE.NAMES=FALSE)
        val<-val[order(val)]
        if (length(unique(val))!=5){
                return(FALSE)
        }
        ## Ace special case treat first
        else if (!(1 %in% val)){
                if( val[5]-val[1]==4){return(TRUE)
                }
                return(FALSE)
        }else{
                if(val[5]-val[1]==4){
                        
                        return(TRUE)
                }else{
                        val[val==1]<-14
                        val<-val[order(val)]
                        if (val[5]-val[1]==4){
                                return(TRUE)
                                
                        }
                        return(FALSE)      
                }
                
        }
        
}

## this function decide the hand strength (flush, Full house etc.)
handstr<-function(hand=c(h1,h2,h3,h4,h5)){
        val<-sapply(hand,cardv,USE.NAMES=FALSE)
        if (1 %in% val) val[val==1]<-14
        val<-val[order(val)]
        count<-table(val)
        if(is.FL(hand)&is.ST(hand)){
                ## if Ace linked with Deuce
                if (14 %in% val& 2%in% val){
                        return(paste(901,"SF"))
                        
                }
                return(paste(900+min(val),"SF"))
        } 
        else if (4 %in% count) "8 QZ"
        else if (3 %in% count& 2 %in% count ) {
                ## find which is trips and which is pair
                head<-as.numeric(names(which(count==3)))
                tail<-as.numeric(names(which(count==2)))
                return(paste(70000+100*head+tail,"FH"))
        }
        else if (is.FL(hand)) {
                return(paste(6E10+val[5]*1E8+val[4]*1E6+
                                     val[3]*1E4+val[2]*100+val[1],"FL"))       
                
                
        }
        else if (is.ST(hand)) {
                if (14 %in% val& 2%in% val){return(paste(501,"ST"))} 
                return(paste(500+min(val),"ST"))
        }
        
        
        else if (length(unique(val))==3& (3 %in% count)) {
                head<-as.numeric(names(which(count==3)))
                tail<-max(as.numeric(names(which(count==1))))
                return(paste(40000+100*head+tail,"TR"))
                
        }
        
        
        else if (length(unique(val))==3& (2 %in% count)) {
                head<-max(as.numeric(names(which(count==2))))
                tail<-min(as.numeric(names(which(count==2))))
                return(paste(30000+100*head+tail,"TP"))
                
        }
        
        
        else if (length(unique(val))==4) {
                head<-as.numeric(names(which(count==2)))
                tail<-max(as.numeric(names(which(count==1))))
                return(paste(20000+100*head+tail,"SP"))
                
        }
        else       return(paste(1E10+val[5]*1E8+val[4]*1E6+val[3]*1E4+
                                        val[2]*100+val[1],"HC"))
        
}




##best hand picker(BHP)
library(gtools)
BHP<-function (hand=c(h1,h2,h3,h4),fboard=c(b1,b2,b3,b4,b5)){
        handpick<-combinations(4,2,v=hand)
        boardpick<-combinations(5,3,v=fboard)
        best.str<-vector()
        for (i in 1:nrow(handpick)){
                for (j in 1:nrow(boardpick)){
                        hand<-c(handpick[i,],boardpick[j,])
                        best.str<-max(best.str,handstr(hand))
                        
                }
        }
        return(best.str)  
}




##sampling tool to run different sample deck and calculate the odds
odds<-function(hand1=c(h1,h2,h3,h4),
               hand2=c(h5,h6,h7,h8),
               board=vector()){
        winrate<-c(win=0,tie=0,lose=0)
        
        ##m is number of card to deal
        m<-5-length(board)
        #if (length(board)>2) 
        ncards<-52-4-4-length(board)
        restdeck<-fulldeck[(!fulldeck%in%hand1)&(!fulldeck%in%hand2)
                           &(!fulldeck%in% board)]
        if (m<3){
                n<-choose(ncards,m)
                restboard<-combinations(ncards,m,v=restdeck)
                
                for (i in 1:n){
                        finalboard<-c(board,restboard[i,])        
                        str1<-BHP(hand1,finalboard)
                        str2<-BHP(hand2,finalboard)
                        if( str1>str2) {winrate[1]<-winrate[1]+1
                        }
                        else if (str1==str2) {winrate[2]<-winrate[2]+1}
                        else {winrate[3]<-winrate[3]+1}
                }
                options(digits=4)
                return (winrate/sum(winrate))
        }else{
                n<-100
                for (i in 1:n){
                        finalboard<-c(board,sample(restdeck,m))        
                        str1<-BHP(hand1,finalboard)
                        str2<-BHP(hand2,finalboard)
                        if( str1>str2) {winrate[1]<-winrate[1]+1
                        }
                        else if (str1==str2) {winrate[2]<-winrate[2]+1}
                        else {winrate[3]<-winrate[3]+1}
                }
                options(digits=4)
                return (winrate/sum(winrate))
                
                
        }
        
        
}


