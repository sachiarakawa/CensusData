if(!require(pacman)){install.packages("pacman");library(pacman)}
p_load(tidyverse,tidycensus,rio,data.table,sf,tigris)

options(tigris_class = "sf",tigris_use_cache = T)
options(stringsAsFactors = F)
options(dplyr.width = Inf)
options(digits = 4)
options(survey.replicates.mse = T)
options(scipen = 999)
options(datatable.fread.datatable=F)
rm(list=ls())

setwd("C:\Users\sachi\Desktop\R Files Local") #set whatever file path you are using for your working directory (wd)
list.files()

Sys.getenv("CENSUS_API_KEY") #assuming you have already loaded your census API key to your Renviron. If not, get an API key from census website and run: census_api_key("insert API key number", install = T)

#can change the year here to whatever you are looking for
#sf1 = Summary Profile 1. This is an ACS table. 
#dp5 = Data Profile 5. This is an ACS table.
sf1<-load_variables(2010,"sf1",cache=T)
detailed1<- load_variables(2018,"acs5",cache=T)
dp5<- load_variables(2018,"acs5/profile",cache = T)
subject1<-load_variables(2018,"acs1/subject",cache = T)

view(dp5)
view (sf1)


