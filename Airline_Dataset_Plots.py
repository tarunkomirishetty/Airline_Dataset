# -*- coding: utf-8 -*-
"""
Created on Thu Dec  1 15:55:26 2022

@author: Admin
"""

import os
import pandas as pd
import matplotlib.pyplot as plt
os.getcwd()
os.chdir("C:/Users/Admin/Desktop/1st Semester/AIT 580/AIT_project")
os.getcwd()
df = pd.read_csv("airfare_modfied.csv")
df
df.info()
print(df.describe())

#Histograms for relevant column
df.mkt_fare.plot(kind="hist",color="#86bf91")
plt.xlabel('Market Fare')
plt.ylabel('Frequency')
plt.title('Histogram for Market Fare')


df.caravgfare.plot(kind="hist",color="#86bf91")
plt.xlabel('Average Fare of Carriers')
plt.ylabel('Frequency')
plt.title('Histogram for Average Fare of Carriers')


#Plot of #of passengers and mkt_fare by quater
pasbyquarter = df.groupby("quarter").agg({'carpax': ['sum'],'mkt_fare':['mean']}).reset_index()
pasbyquarter.carpax = pasbyquarter.carpax.div(1000000)

pasbyquarter.plot(kind="bar", x="quarter", y="carpax",color="skyblue")
plt.xlabel("Quarter of the Year")
plt.ylabel("Number of passengers in millions")
plt.title("Number of Passengers travelling according to quarter")
plt.legend('',frameon=False)

pasbyquarter.plot(kind="scatter", x="quarter", y="mkt_fare",color="lightblue")
plt.plot(pasbyquarter.quarter, pasbyquarter.mkt_fare)
plt.xlabel("Quarter of the Year")
plt.ylabel("Market Fare in $")
plt.title("Market Fare per Quarter")
plt.legend('',frameon=False)
plt.ylim(0,260)

#Plot of #of passengers and mkt_fare by year
pasbyyear = df.groupby("Year").agg({'carpax':['sum'], 'mkt_fare':['mean']}).reset_index()
pasbyyear.carpax = pasbyyear.carpax.div(1000000)

pasbyyear.plot(kind="bar",x="Year",y="carpax",color="darkblue")
plt.xlabel("Year")
plt.ylabel("Number of passengers in millions")
plt.title("Number of Passengers travelling per year")
plt.legend('',frameon=False)



pasbyyear.plot(kind="scatter",x="Year",y="mkt_fare",color="lightblue")
plt.plot(pasbyyear.Year,pasbyyear.mkt_fare)
plt.xlabel("Year")
plt.ylabel("Market Fare")
plt.title("Average Market Fare per Year")
plt.legend('',frameon=False)
plt.ylim(0,300)

