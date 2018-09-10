# extract_sample.R

library(lubridate)

# file extracted from Power-Networks-LCL-June2015(withAcornGps).csv_Pieces.zip
# downloaded from https://files.datapress.com/london/dataset/smartmeter-energy-use-data-in-london-households/Power-Networks-LCL-June2015(withAcornGps).csv_Pieces.zip

dta <- read.csv( "../data/Power-Networks-LCL-June2015(withAcornGps)v2_1.csv"
               , as.is = TRUE
               , check.names = FALSE
               )

head(dta)
table(dta$LCLid)

mac2a <- subset( dta, "MAC000002" == LCLid )

table( mac2a$stdorToU ) # unique, so leave out of subset
table( mac2a$Acorn ) # unique, so leave out of subset
table( mac2a$Acorn_grouped ) # unique, so leave out of subset

mac2 <- subset( dta
              , "MAC000002" == LCLid
              , c( LCLid, DateTime, `KWH/hh (per half hour)` ) 
              )

write.csv( mac2, "../data/MAC000002.csv", row.names = FALSE, quote = FALSE )
