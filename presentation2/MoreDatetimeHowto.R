## ----setup, include=FALSE------------------------------------------------
#knitr::opts_chunk$set(echo = FALSE)
suppressPackageStartupMessages( library(zoo) )

## ------------------------------------------------------------------------
dta <- read.csv( "../data/MAC000002clean.csv", as.is = TRUE )
str(dta)

## ------------------------------------------------------------------------
Sys.setenv( TZ = "GMT" ) # when you don't know how the data was coded, use GMT to get started

## ------------------------------------------------------------------------
dta_b <- dta  # make a copy so we can compare approaches later
dta_b$Dtm <- as.POSIXct( dta_b$DateTime ) # assumes TZ is set
str( dta_b$Dtm ) # confirming new column type

## ------------------------------------------------------------------------
dta_b$DtmGMT <- as.POSIXct( dta_b$DateTime, tz = "GMT" )
attr( dta_b$Dtm, "tzone" )
attr( dta_b$DtmGMT, "tzone" )

## ------------------------------------------------------------------------
Sys.setenv( TZ = "UTC" )
# see ?as.POSIXlt
dtm2 <- as.POSIXlt( c( "2016-03-13 01:00:00", "2016-03-13 03:00:00" ) )
dtm2
dtm2[ 1 ] < dtm2[ 2 ]
diff( dtm2 )

## ------------------------------------------------------------------------
str( unclass( dtm2 ) )
dtm2$year + 1900

## ------------------------------------------------------------------------
Sys.setenv( TZ = "UTC" )
dt1a <- as.Date( "2013-03-13" ) # see ?as.Date
dt1b <- as.Date( "3/21/2013", format="%m/%d/%Y" ) # see ?strptime
dt1b
as.numeric( dt1b )
dt1a < dt1b
dt1b - dt1a

## ------------------------------------------------------------------------
Sys.setenv( TZ = "UTC" )
dtm1 <- as.POSIXct( c( "2016-03-13 01:00:00", "2016-03-13 03:00:00" ) )
dtm1
as.numeric( dtm1 )
dtm1[ 1 ] < dtm1[ 2 ]
diff( dtm1 )

## ------------------------------------------------------------------------
Sys.setenv( TZ = "UTC" )
# see ?as.POSIXlt
dtm2 <- as.POSIXlt( c( "2016-03-13 01:00:00", "2016-03-13 03:00:00" ) )
dtm2
dtm2[ 1 ] < dtm2[ 2 ]
diff( dtm2 )

## ------------------------------------------------------------------------
str( unclass( dtm2 ) )
dtm2$year + 1900

## ------------------------------------------------------------------------
diftm1 <- as.difftime( 30, units="mins" ) # see ?as.difftime
dtm1[ 1 ] + diftm1 
dtm1[ 1 ] + as.difftime( 2, units="weeks" )

## ------------------------------------------------------------------------
as.numeric( diftm1 ) # not recommended
as.numeric( diftm1, units="mins" )
as.numeric( diftm1, units="secs" )

## ------------------------------------------------------------------------
on <- OlsonNames()
tail( on ) # a few examples
grep( "Los_Angeles", on, value=TRUE )

## ------------------------------------------------------------------------
library(lubridate)
mdy( "3/14/2013" ) == as.Date( "3/14/2013", format="%m/%d/%Y" )
dmy_hms( "14/3/13 1:15:45" ) == as.POSIXct( "14/3/13 1:15:45", format = "%d/%m/%y %H:%M:%S")

## ------------------------------------------------------------------------
dtm1[ 1 ]
force_tz( dtm1, "US/Pacific" ) # this is a different point in time

## ------------------------------------------------------------------------
with_tz( dtm1, "US/Pacific" )
# which is easier to remember than
# attr( dtm1, "tzone" ) <- "US/Pacific"

## ------------------------------------------------------------------------
interval( dtm1[ 1 ], dtm1[ 2 ] ) # a very specific interval of time
dtm1PT <- force_tz( dtm1[ 1 ], "US/Pacific" )
dtm1PT + days( 1 ) # add a 1 day period (acts like a calendar)
dtm1PT + ddays( 1 ) # add a 1 day duration (much like difftime(1,units="days"))

## ------------------------------------------------------------------------
x <- 0.3     # floating point is always approximate
0.6 == 2 * x # works
0.9 == 3 * x # but you cannot rely on it

## ------------------------------------------------------------------------
0.9 - 3 * x

## ----echo=TRUE-----------------------------------------------------------
library(chron)
dtm1 <- chron( dates. = c( "3/13/2016", "3/13/2016" )
             , times. = c( "01:00:00", "03:00:00" )
             )
dtm1  # automatically formatted for display

## ------------------------------------------------------------------------
unclass( dtm1 )

## ------------------------------------------------------------------------
dtm1[ 1 ] < dtm1[ 2 ]
diff( dtm1 )

## ----fig.height=3,fig.width=6--------------------------------------------
library(ggplot2)
dtms1 <- seq( dtm1[ 1 ], dtm1[ 2 ], times( "00:30:00" ) ); dtms1

## ----fig.height=3,fig.width=6--------------------------------------------
Sys.setenv( TZ = "GMT" )
qplot( seq_along( dtms1 ), dtms1 ) +
  chron::scale_y_chron( format="%m/%d/%y %H:%M" )

## ------------------------------------------------------------------------
dtm2a <- chron( "02/20/13", "00:00:00" )
dtm2b <- chron( "07/03/18", "15:30:00" ) # stop at 3:30pm
dtm2 <- seq( from=dtm2a, to=dtm2b, by=times( "00:15:00" ) )
tail( dtm2 ) # stops one value too soon
length( dtm2 )

## ------------------------------------------------------------------------
Sys.setenv( TZ="GMT" ) # emulate chron behavior
dtm3a <- as.POSIXct( "02/20/13 00:00:00"
                   , format = "%m/%d/%y %H:%M:%S"
                   )
dtm3b <- as.POSIXct( "07/03/18 15:30:00"
                   , format = "%m/%d/%y %H:%M:%S" 
                   )
dtm3 <- seq( from = dtm3a
           , to = dtm3b
           , by = as.difftime( 15, units="mins" )
           )
tail( dtm3 )   # does include final value
length( dtm3 ) # one more than cron example

## ----echo=TRUE-----------------------------------------------------------
library(zoo)
dt1 <- as.yearmon( c( "2016-03", "2016-04" ) )
dt1  # automatically formatted for display

## ------------------------------------------------------------------------
unclass( dt1 )

## ------------------------------------------------------------------------
dt1[ 1 ] < dt1[ 2 ]
diff( dt1 ) # displayed nonsensically

## ------------------------------------------------------------------------
n <- 1416
f2a <- seq( 1900
          , 1900 + n/12
          , by = 1/12 # unsafe practice
          )
d2a <- as.yearmon( f2a ) # rounded when converted
tail( d2a ) #  internal round-to-month is very robust
f2b <- 1900 + seq( 0, n )/12 # safer way to handle fractions
d2b <- as.yearmon( f2b )
tail( d2b ) # no difference


## ------------------------------------------------------------------------
as.numeric( f2a[ length( f2a ) ] ) - as.numeric( f2b[ length( f2b ) ] )

