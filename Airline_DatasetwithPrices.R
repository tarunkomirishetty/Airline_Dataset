library(tidyr)
library(dplyr)
library(ggplot2)
library(psych)
library(sqldf)
library(stringr)
library(usmap)
library(fpp2)

d <- read.csv("Airfare Information.csv")
#Removing the table name
d1 <- d[,-1]

#Analysis for the last 10 years
d1 <- d1 %>% filter(between(d1$Year,2012,2022) )

#Getting the top5 carriers based on number of passengers
top5 <- sqldf("select car,count(carpax) as count from d1 group by car
              order by count")
top5 <- tail(top5,5)
#Filtering for the top5 carriers
d1 <- d1 %>% filter(d1$car %in% top5$car)
unique(d1$car)
#checking for NA Values
table(is.na(d1))

#Observed few values were given as empty in Geocoded columns 
table(d1=="")
# d1$Geocoded_City1 <- ifelse(d1$Geocoded_City1=="",NA,d1$Geocoded_City1)
# d1$Geocoded_City2 <- ifelse(d1$Geocoded_City2=="",NA,d1$Geocoded_City2)
d1 <- na.omit(d1)
table(is.na(d1))
table(d1=="")
str(d1)
d1$quarter <- as.factor(d1$quarter)

#To get the correct latitude and longitude
dcity1 <- as.data.frame(d1$city1)
dcity2 <- as.data.frame(d1$city2)
colnames(dcity2) <- colnames(dcity1)
dcity <- as.data.frame(rbind(dcity1,dcity2))
dcity <- sqldf("select distinct d1$city1 from dcity")
# dcity$latlong <- geocode(dcity$`d1$city1`) #can be performed after google api key registration
# write.csv(dcity,"LatLong.csv") #To create a new file for latitudes and longitudes
dcity <- read_csv("LatLong") #reading the file for future use
dcity <- dcity[,-1]
colnames(dcity) <- c("City","Long","Lat")
rm(dcity1,dcity2)

#To calculate distance between the cities
d1 <- sqldf("select a.*,b.lat as lat1, b.long as lon1 from d1 as a
            left join dcity as b on a.city1=b.city")
d1 <- sqldf("select a.*,b.lat as lat2, b.long as lon2 from d1 as a
            left join dcity as b on a.city2=b.city")

library(gmt)
library(ggmap)
# a <- d1$city1[1]
# b <- d1$city2[1]
# mapdist(a,b)
d1$distance <- geodist(d1$lat1,d1$lon1,d1$lat2,d1$lon2,units="km")

# write.csv(d1,"airfare_modfied.csv")

#Generate class based on distance between source and destination
d1 <- d1[,-c(21:24)]
summary(d1$distance)
d1$distance <- ifelse(d1$distance==0,NA,d1$distance)
d1 <- na.omit(d1)
dist <- summary(d1$distance)

d1$class <- (ifelse(d1$distance>0 & d1$distance<=dist[2],"Short",
                    ifelse(d1$distance>dist[2] & d1$distance<dist[5],"Mid","Long")))
table(d1$class)
ggplot(d1,aes(distance,class))+
  geom_point(color="darkgreen")+
  labs(title="Distance of each class",x="Distance in kms",y="Class Based on Distance")+
  theme_light()
    
ggplot(d1,aes(class,caravgfare))+
  geom_point(color="darkblue")+
  coord_flip()+
  labs(title="Average Fare of each class",x="Class Based on Distance",
       y="Average Fare of carriers")+
  theme_light()
  

#According to number of flights
colnames(d1)
d1r2 <- d1
d1r2$route <- paste(d1r2$city1,d1r2$city2)
d1r2 <- sqldf("select quarter,route,count(quarter) as count,
               city1,city2
              from d1r2 group by quarter,route")
d1r2 <- sqldf("select a.*,b.lat as lat1,b.long as long1 from d1r2 as a
              left join dcity as b on a.city1=b.city")
d1r2 <- sqldf("select a.*,b.lat as lat2,b.long as long2 from d1r2 as a
              left join dcity as b on a.city2=b.city")
colnames(d1r2)
d1r2 <- sqldf("select quarter,city1,city2,route,long1,lat1,long2,lat2,max(count) as count from d1r2
              group by quarter")
# 
# 
# MainStates <- map_data("state")
# ggplot() + worldmap +
#   geom_point(data = d1r2, aes(x = long1, y = lat1), col = "#970027") +
#   geom_curve(data = d1r2, aes(x = long1, y = lat1, xend = long2, yend = lat2), col = "#b29e7d", size = .4) +
#   theme_void()


#Route Analysis According to Most filled flights
colnames(d1)
d1p2 <- d1
d1p2$route <- paste(d1p2$city1,d1p2$city2)
d1p21 <- sqldf("select quarter,city1,city2,route,avg(carpaxshare) as passengers_share
              from d1p2 group by quarter,route")
d1p21 <- sqldf("select quarter,city1,city2,route,max(passengers_share) as passengers_share from d1p21
              group by quarter")
#We can see that this route is often travelled by many people, we'll now see how many flights operate per carrier in this route
d1p2 <- d1p2 %>% filter(d1p2$city1 %in% d1p21$city1 & d1p2$city2 %in% d1p21$city2)
d1p2 <- sqldf("select car,count(*) as count from d1p2 group by car")
ggplot(d1p2,aes(car,count))+
  geom_bar(stat="Identity",width=0.6,color="Red",fill="orange")+
  coord_flip()+
  labs(title="Flights operated by carriers in Most Demanded Route",x="Carrier",y="Number of Flights Operated")+
  theme_light()

#best destinations
d1d <- sqldf("select quarter,city2,sum(carpax) as count from d1 
             group by city2 order by count desc")
# d1d <- sqldf("select quarter,city2,max(count) from d1d
#              group by quarter order by count desc")
med <- summary(d1d$count)
d1d <- d1d %>% filter(d1d$count>med[3])
ggplot(d1d,aes(x=reorder(city2,count),y=count))+
  geom_bar(stat="identity",color="black",fill="red",width=0.7)+
  coord_flip()+labs(title="Most Travelled Destinations",x="City",y="Number of Travellers")+
  theme_light()

d1d <- sqldf("select quarter,city2,sum(carpax) as count from d1 
             group by city2 order by count desc")
d1d <- sqldf("select quarter,city2,max(count) as count from d1d
             group by quarter order by count desc")

ggplot(d1d,aes(quarter,count,label=city2))+
  geom_bar(stat="Identity",width=0.5,color="red",fill="orange")+
  geom_text(vjust=-0.5,size=3) +
  labs(title="Most Travelled destinations in each Quarter",
       x="Quarter",y="Number of Passengers")+
  theme_classic()


colnames(d1)
#Best airline interms of range and number of passengers
cr <- d1[,c(9,10,11,22)]
cr <- sqldf("select car,class,sum(carpax) as passengers from cr
            group by car,class")
cr <- sqldf("select car,class,max(passengers) as passengers from cr
            group by class")
ggplot(cr,aes(class,passengers,label=car))+
  geom_bar(stat="Identity",width=0.5)+
  geom_text(hjust=-.18)+
  coord_flip()


#Fitting with distance
daa <- d1 
#taking the req feild 
daa <- daa[,c(1:3,10:17,21)]
summary(daa)
plot(daa$distance,daa$mkt_fare,xlab = "Distance in km",ylab="Market Fare in $")
abline(lm(mkt_fare~distance,data=daa),col="red")
title("Scatter Plot between Market Fare and Distance")
# pairs.panels(daa)
library(leaps)
colnames(daa)
fit1 <- lm(mkt_fare~distance,daa)
summary(fit1)
c <- coef(fit1)

#Function to calculate Market Fare from 
#latitude and longitude from source to destination
fareprice <- function(latfrom,longfrom,latto,longto){
  a <- geodist(latfrom,longfrom,latto,longto,units="km")
  price <- as.numeric(c[1])+(a*as.numeric(c[2]))
  return(round(price,2))
}
#Calculating the Fare price from Chicago to New York
fareprice(41.87811,-87.62980,40.71278,-74.00597)


#Cluster Analysis
daak <- daa[,c(3,12)]
ggplot(daa,aes(distance,mkt_fare))+
  geom_point()
set.seed(101)
Centroids=3
km <- kmeans(daak, centers=Centroids, nstart=20)
summary(km)
centers <- data.frame(cluster=factor(1:Centroids), km$centers)
daak$cluster <- factor(km$cluster)
ggplot(data=daak, aes(x=distance, y=mkt_fare, color=cluster, shape=cluster)) +
  geom_point(alpha=.8) +
  scale_shape_manual(values = 1:Centroids,
                     guide = guide_legend(override.aes=aes(size=1))) + 
  geom_point(data=centers,  aes(x=distance, y=mkt_fare), size=2, stroke=2)+
  labs(title="Cluster Analysis of Market Fare and Distance",
       x="Market Fare",y="Distance in kms")+
  theme_light()

#Fitting a time series function for Prediction
unique(d1$Year)
Market_Fare <- ts(d1$mkt_fare,start=min(d1$Year),end=max(d1$Year),frequency=4)
plot(Market_Fare,xlab="Year",ylab="Market Price")
title("Time Series Plot of Market Price and Year")

tsfit2 <- auto.arima(Market_Fare,d=1,D=1)
summary(tsfit2)
checkresiduals(tsfit2)
fcst <- forecast(tsfit2,h=8)
autoplot(fcst,include=20,xlab="Year",ylab="Market Price") + theme_light()+
  labs(title="Forecasting of Market Fare")
summary(fcst)

#Ticket Price and MArket Share
d11 <- sqldf("select car,avg(mkt_fare) as mkt_fare,sum(carpax) as carpax from d1
             group by car")
s <- sum(d11$carpax)
d11$carpaxshare <- (d11$carpax/s)*100
ggplot(d11,aes(mkt_fare,carpaxshare))+
  geom_point(aes(color=car),size=5)+
  labs(title="Variation of Market Share depending on the Market Fare",
       x="Market Fare",y="Market Share")+
  theme_light()


