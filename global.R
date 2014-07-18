# global.R
library(shiny)
library(rCharts)

dat <- read.csv(file            = "2014_05_trip_data.csv"
   , sep             = ","
   , header          = T
   , stringsAsFactor = F
   , na.strings = "\\N"
   , nrows = 1501
)

dat <- dat[, c(2:12)]

# set starttime and stoptime of type posixct
dat$starttime <- as.POSIXct(dat$starttime, format = "%Y-%m-%d %H:%M:%S", tz = "EST")
#dat$stoptime <- as.POSIXct(dat$stoptime, format = "%Y-%m-%d %H:%M:%S", tz = "EST")
#dat$usertype <- as.factor(dat$usertype)
#dat$birth.year <- as.factor(dat$birth.year)
#dat$gender <- as.factor(dat$gender)
