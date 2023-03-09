library(rstudioapi)
library(devtools)
library(ggmap)
devtools::install_github("dkahle/ggmap")
library(fpp2)


ggmap::register_google(key = "ENTER YOUR KEY",write = TRUE)

d <- read.csv("Airfare Information.csv")
c1 <- as.data.frame(unique(d$city1))
c2 <- as.data.frame(unique(d$city2))
colnames(c2) <- colnames(c1)
c <- rbind(c1,c2)
c <- as.data.frame(unique(c$`unique(d$city1)`))
colnames(c) <- "Cities"
c$Geocode <- ggmap::geocode(c$Cities)
