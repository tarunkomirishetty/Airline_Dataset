# Airline_Dataset
Analyzing Domestic Airline Routes in the US and predicting Prices based on Distance

I've created a project based on the airline dataset. In this project I've used 3 tools, SQL, Python and R Studio. Most of the programming is done in R Studio. I've used Python to Visualize the data. SQL is used for Data Manipulation to view the aggregation of the Data. R Studio is used to clean up and standardise the dataset. I've used linear regression to fit a model for predicting the Price of the airline based on a single predictor which is distance. In future study the regression can be modified to inlude other predictor variables like Airline Carrier, Day of the week, Day of the month, Destination etc. Time series analysis is done to view the mean price of Airlines over the past 2 years and prediction is done for the next months.

FILE DESCRIPTIONS:
Airline_Information.csv : It is the raw dataset. The dataset was taken from U.S Department of Transportation, consumer Airfare Table 5 which was available online. It contains attributes that tell us the year, quarter, Market Fare of the route, source city market id, destination city market id, source city name, destination city name, id of the aeroplane, name of the carrier, Number of passengers for that carrier, market share of the carrier, average fare of the carrier, increase in market share, increase in fare and geocoded locations of source and destination cities.
Airline_Dataset.sql : It is a MySQL file in which I've performed data manipulation.
Airline_Dataset_Plots.py : A python code file that contains visualizations for the dataset.
Airline_DatasetwithPRices.R : It is an R Studio file in which most of the coding is done. The input of this code is the raw data file. It generates results of the linear regression, Time series analysis etc. I've used google API to standardise the latitudes and longitutdes of the airport locations and find the distance between the source and destinations.
LatLong.csv : The information of Latitude and Longitudes extracted from the Google API.
MAp Visual.pbix : This is a Power BI file that has a Map visual which visualizes all the airport locations based on the latitude and longitudes.
airfare_modified.csv : This is a modified CSV file which has the standardised longitude and latitude values for all the cities.
