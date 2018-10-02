## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(fig.height = 3, fig.width = 7, tidy = TRUE)
suppressPackageStartupMessages( library(dplyr) )
suppressPackageStartupMessages( library(ggplot2) )
suppressPackageStartupMessages( library(lubridate) )
library(DiagrammeR)

## ----introcalc,echo=FALSE------------------------------------------------
dta <- read.csv( "../data/MAC000002clean.csv", as.is = TRUE )
Sys.setenv( TZ = "GMT" ) # Data are recorded in GMT
dta$Dtm <- as.POSIXct( dta$DateTime )

Sys.setenv( TZ = "Europe/London" ) # interpret data
d <- as.POSIXlt( dta$Dtm ) # keep list time separate from data frame
dta <- (   dta
       %>% mutate( Hour = d$hour
                 , wday = factor( d$wday
                                , levels = 0:6
                                , labels = c( "Sun", "Mon", "Tue"
                                            , "Wed", "Thu", "Fri"
                                            , "Sat" )
                                )
                 , Dt = as.POSIXct( trunc( d, units = "days" ) )
                 , DTime = as.numeric( Dtm - Dt, units="hours" )
                 )
         )

## ----introplot,fig.width=6,fig.height=4,warning=FALSE,echo=FALSE---------
ggplot( dta, aes( x = DTime, y = KWH, group = Dt ) ) +
  geom_line( alpha = 0.2 ) +
  facet_wrap( ~wday ) +
  scale_x_continuous( name = "Hour of Day"
                    , breaks = 6*( 0:4 )
                    , limits = c( 0, 24 )
                    )

## ----faq1Qmessyinit, echo=FALSE------------------------------------------
Sys.setenv( TZ = "" )

## ----faq1Qmessy, fig.width=6,fig.height=3--------------------------------
dta <- read.csv( "../data/MAC000002clean.csv" )
plot( KWH ~ DateTime, data=dta, pch = "." )

## ----faq1Achr------------------------------------------------------------
dta <- read.csv( "../data/MAC000002clean.csv"
               , as.is=TRUE # avoid auto-convert to factor
               )
Sys.setenv( TZ = "US/Pacific" ) # If you forget this, this is the likely default for SFBay Area
dta$Dtm <- as.POSIXct( dta$DateTime ) # New column
str( dta )

## ----faq1Achrplot,fig.height=3-------------------------------------------
plot( KWH ~ Dtm, data = dta, pch = "." )

## ----usefultypes,echo=FALSE,results='asis'-------------------------------
oldtz <- Sys.getenv( "TZ" )
Sys.setenv( TZ = "GMT" )
s1 <- capture.output( str( unclass( as.POSIXlt( "2013-03-31 03:30:00" ) ) ) )
s2 <- capture.output( print( unclass( as.Date( "2013-03-31" ) ) ) )
s3 <- capture.output( print( unclass( as.POSIXct( "2013-03-31 03:30:00" ) ) ) )
dtminfo <- data.frame( Item = c( "from chr", "to chr", "implementation", "units" )
                     , `Date` = c( '`as.Date( "2013-03-31" )`'
                                 , '`as.character( Dt )`'
                                 , paste( paste0( "`", s2, "`" ), collapse = "<br/>" )
                                 , 'days since `1970-01-01 GMT`'
                                 )
                     , `POSIXct` = c( '`as.POSIXct( "2013-03-31 03:30:00" )`'
                                    , '`as.character( Dtm )`'
                                  , paste( paste0( "`", s3, "`" ), collapse = "<br/>" )
                                    , 'sec since `1970-01-01 00:00:00 GMT`'
                                    )
                     , POSIXlt = c( '`as.POSIXlt( "2013-03-31 03:30:00" )`'
                                  , '`as.character( Dtm )`'
                                  , paste( paste0( "`", s1, "`" ), collapse = "<br/>" )
                                  , 'separate units for each of 9 elements'
                                  )
                     )

knitr::kable( dtminfo
            , format="html"
            , escape=FALSE
            , col.names = c( "Item", "`Date`", "`POSIXct`", "`POSIXlt`")
            )
Sys.setenv( TZ = oldtz )

## ----goodpractice1,echo=FALSE,fig.height=3-------------------------------
mermaid('
sequenceDiagram
  File ->> Character : read.csv(as.is=TRUE)
  Character ->> NA : as.POSIXct("2013-21-03 02:30:00")
  Character ->> POSIXct : as.POSIXct("2013-03-10 14:30:00")
  Character ->> POSIXct : as.POSIXct("3/21/13 2:30pm",format="%m/%d%y %I:%M%p")
')

## ----faq1Apart-----------------------------------------------------------
head(dta)

## ----faq1Apartplot-------------------------------------------------------
idx <- 1:(48*4) # about 4 days of 1/2 hour data 
qplot( idx, dta$Dtm[ idx ] )

## ----faq1Aforce----------------------------------------------------------
dta$Dtm <- as.POSIXct( dta$DateTime
                     , format = "%Y-%m-%d %H:%M:%S"
                     )
which( is.na( dta$Dtm ) ) # this may not work on Linux/Mac
dta[ 7105:7106, ]

## ----faq1Aforcefwd,warning=FALSE-----------------------------------------
dta[ 7103:7109, ]

## ----faq1Aforcefwdplot,warning=FALSE-------------------------------------
idx <- 7101:7109
qplot( idx, dta$Dtm[ idx ] )

## ----faq1Agmt------------------------------------------------------------
Sys.setenv( TZ = "GMT" )
dta$Dtm <- as.POSIXct( dta$DateTime )
idx <- 7101:7109
qplot( idx, dta$Dtm[ idx ] )

## ----faq1Qsummercalc-----------------------------------------------------
# find beginning of day for each record
dta$DBegin <- as.POSIXct( trunc( dta$Dtm, units="days" ) )
# find hours from midnight
dta$DTime <- as.numeric( dta$Dtm - dta$DBegin, units="hours" )
# find timestamp at beginning of month for each record
dta$MBegin <- as.POSIXct( paste0( substr( dta$DateTime, 1, 7 )
                                , "-01" ) )
dta2mo <- subset( dta
                , dta$MBegin
                   %in% as.POSIXct( c( "2013-02-01"
                                     , "2013-04-01" ) ) )

## ----faq1Qsummerplot,echo=FALSE------------------------------------------
dta2mo$MBeginf <- factor( dta2mo$MBegin )
ggplot( dta2mo, aes( x=DTime, y=KWH, group=DBegin ) ) +
  geom_line( alpha = 0.2 ) +
  facet_wrap( ~MBeginf, ncol=1 )

## ----faq2Acivilcalc------------------------------------------------------
Sys.setenv( TZ = "Europe/London" )
# find beginning of day for each record
dta$DBegin <- as.POSIXct( trunc( dta$Dtm, units="days" ) )
# find hours from midnight
dta$DTime <- as.numeric( dta$Dtm - dta$DBegin, units="hours" )
# find timestamp at beginning of month for each record
dta$MBegin <- as.POSIXct( paste0( substr( dta$DateTime, 1, 7 )
                                , "-01" ) )
dta2mo <- subset( dta
                , dta$MBegin
                   %in% as.POSIXct( c( "2013-02-01"
                                     , "2013-04-01" ) ) )

## ----faq2Acivilplot,echo=FALSE-------------------------------------------
dta2mo$MBeginf <- factor( dta2mo$MBegin )
ggplot( dta2mo, aes( x=DTime, y=KWH, group=DBegin ) ) +
  geom_line( alpha = 0.2 ) +
  facet_wrap( ~MBeginf, ncol=1 )

## ----faq3multiread,echo=FALSE--------------------------------------------
# download.file( url = "https://rredc.nrel.gov/solar/old_data/nsrdb/1961-1990/hourly/1990/23234_90.txt"
#              , destfile = "../data/23234_90.txt"
#              )
dta3 <- read.fwf( "../data/23234_90.txt", header = FALSE
                , skip = 1, stringsAsFactors = FALSE
                , widths = c( 3, 3, 3, 3, 5, 5, 5, 2, 1, 5
                            , 2, 1, 5, 2, 1 )
                , na.strings = " 9999"
                )
dta3 <- setNames( dta3
                , c( "Yr", "Mo", "Dy", "Hr", "G_etdir", "G_etdni"
                   , "G_g", "G_g_src", "G_g_unc", "G_n", "G_n_src"
                   , "G_n_unc", "G_d", "G_d_src", "G_d_unc"
                   )
                )

## ----faq3multistr--------------------------------------------------------
# dta3 import not shown
str( dta3 )

## ----faq3Amulticonvert,warning=FALSE,fig.height=4------------------------
Sys.setenv( TZ = "Etc/GMT+8" ) # yes, that is plus for West of GMT
dta3$Dtm <- with( dta3, ISOdatetime( Yr + 1900, Mo, Dy, Hr, 0, 0 ) )

## ----faq3Amultiplot, echo=FALSE,warning=FALSE----------------------------
ggplot( dta3, aes( x=Dtm, y=G_g ) ) + geom_line( size=0.2, alpha=0.5 )

## ----faq4Qseparate,echo=FALSE--------------------------------------------
# download.file( "https://rredc.nrel.gov/solar/old_data/nsrdb/1991-2010/data/hourly/724940/724940_2010_solar.csv"
#              , destfile = "../data/724940_2010_solar.csv"
#              )
dta4 <- read.csv( "../data/724940_2010_solar.csv", check.names = FALSE
                , as.is = TRUE, na.strings = "-9900" )

## ----faq4Qseparateshow---------------------------------------------------
# dta4 import not shown
str( dta4 )

## ----faq4Qseparatecalc,warning=FALSE-------------------------------------
Sys.setenv(TZ = "Etc/GMT+8" ) # local standard time only
dta4$Dt <- as.Date( dta4$`YYYY-MM-DD` )
dta4$Dtm <- as.POSIXct( paste( dta4$`YYYY-MM-DD`, dta4$`HH:MM (LST)` ) )
head( dta4[ , c( "YYYY-MM-DD", "HH:MM (LST)", "Dt", "Dtm" ) ] )
dta4$Dtm[ 1 ] - as.POSIXct( dta4$Dt[ 1 ] )

