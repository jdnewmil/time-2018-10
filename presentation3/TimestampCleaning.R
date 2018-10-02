## ----setup, include=FALSE------------------------------------------------
#knitr::opts_chunk$set(echo = FALSE)
suppressPackageStartupMessages( library(dplyr) )
suppressPackageStartupMessages( library(ggplot2) )
suppressPackageStartupMessages( library(lubridate) )

## ------------------------------------------------------------------------
dta <- read.csv( "../data/MAC000002.csv"
               , as.is = TRUE # don't convert character to factor
               , check.names = FALSE # don't replace odd characters in column names
               )
str(dta)

## ------------------------------------------------------------------------
Sys.setenv( TZ = "GMT" ) # when you don't know how the data was encoded, use GMT

## ------------------------------------------------------------------------
dta_b <- dta  # make a copy so we can compare methods later
dta_b$Dtm <- as.POSIXct( dta_b$DateTime )
str( dta_b$Dtm ) # confirming new column type

## ------------------------------------------------------------------------
head( diff( dta_b$Dtm ) )

## ------------------------------------------------------------------------
head( as.numeric( diff( dta_b$Dtm ) 
                , units="mins" # convert from "whatever" to "minutes"
                ) 
      )

## ------------------------------------------------------------------------
table( as.numeric( diff( dta_b$Dtm ), units="mins" ) )

## ----fig.height=4--------------------------------------------------------
library(ggplot2)
dtmdif <- as.numeric( diff( dta_b$Dtm ), units="hours" )
qplot( dta_b$Dtm[ -nrow( dta_b ) ], dtmdif, geom = "line", xlab="Time", ylab = "Difftime (hours)" )

## ------------------------------------------------------------------------
dupidx <- which( duplicated( dta_b$Dtm ) ) # get integer indexes where duplicated is true
head( dta_b[ dta_b$Dtm %in% dta_b$Dtm[ dupidx ], ] )

## ----fig.height=4--------------------------------------------------------
dta_b2 <- dta_b[ !duplicated( dta_b ), ]
dtmdif2 <- as.numeric( diff( dta_b2$Dtm ), units="hours" )
qplot( dta_b2$Dtm[ -nrow( dta_b2 ) ], dtmdif2, geom = "line", xlab="Time", ylab = "Difftime (hours)" )

## ------------------------------------------------------------------------
smalldifidx <- which( dtmdif2 < 0.5 )
smalldifidx
dta_b2[ 3237:3240, ]

## ----fig.height=4--------------------------------------------------------
dta_b3 <- dta_b2[ -3239, ]
dtmdif3 <- as.numeric( diff( dta_b3$Dtm ), units="hours" )
qplot( dta_b3$Dtm[ -nrow( dta_b3 ) ]
     , dtmdif3
     , geom = "line"
     , xlab="Time"
     , ylab = "Difftime (hours)" )

## ------------------------------------------------------------------------
dta_b3$KWH <- as.numeric( trimws( dta_b3$`KWH/hh (per half hour)` ) )
str( dta_b3 )
sum( is.na( dta_b3$KWH ) )

## ------------------------------------------------------------------------
sum( ".0000000" != substr( dta_b3$DateTime, 20, 27 ) )

## ------------------------------------------------------------------------
dta_b4 <- dta_b3
dta_b4$DateTime <- substr( dta_b4$DateTime, 1, 19 )

## ------------------------------------------------------------------------
write.csv( dta_b4[ , c( "LCLid", "DateTime", "KWH" ) ]
         , file = "../data/MAC000002clean.csv"
         , row.names = FALSE
         , quote = FALSE
         )

## ------------------------------------------------------------------------
Sys.setenv( TZ = "US/Pacific" )
dta_b5 <- dta_b4
dta_b5$DateTime <- as.character( dta_b5$Dtm ) 
write.csv( dta_b5[ , c( "LCLid", "DateTime", "KWH" ) ]
         , file = "../data/MAC000002cleanPT.csv"
         , row.names = FALSE
         , quote = FALSE
         )

