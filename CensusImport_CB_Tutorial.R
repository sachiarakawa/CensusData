##### Load libraries, set working directory #####
if(!require(pacman)){install.packages("pacman");library(pacman)}
p_load(tidyverse,tidycensus,rio,data.table,sf,tigris)

options(tigris_class = "sf",tigris_use_cache = T)
options(stringsAsFactors = F)
#stringAsFactors will recognize string variables as characters with no latent order (instead of factors, which get ordered)
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

#call data using get_acs(). 
#Year, state, county, and city can be changed as desired.
#the "output" element specifies whether or not you want your data in "wide" or "tidy" (long) format 
#the "wide" format is what you typically want for displaying geospatial data b/c you don't want multiple polygons stacked on each other
get_acs(geography = "tract",variables = c("DP04_0141P","DP04_0142P") ,year = 2018,state = "OR", county="Multnomah", place="Portland
    ",output = "wide", geometry = F)%>% select(-NAME) %>%
        head()

#Rename fields to something understandable
#Note that this is the same code as above, just adding in the new field names. You do not need to run both, but it's fine if you do.
get_acs(geography = "tract",variables = 
           c("costburden_3034"="DP04_0141P",
             "costburden_35"="DP04_0142P"),year = 2018,state = "OR",county = "Multnomah", place="Portland City", output = "wide", geometry = F) %>% select(-NAME) %>% head()


#Create objects for putting the data in "tidy" and "wide" format. Wide format is necessary to recalculate MOE after combining the two estimate columns
#Note that this is ONLY A NECESSARY STEP IS YOU HAVE COMBINED (ADDED TOGETHER) COLUMNS
cb_tidy<-get_acs(geography = "tract",variables = c("costburden_3034"="DP04_0141P",
                                                   "costburden_35"="DP04_0142P"), year = 2017,state = "OR",output = "tidy",   geometry = F)

cb_wide<-get_acs(geography = "tract",variables = c("costburden_3034"="DP04_0141P",
                                                   "costburden_35"="DP04_0142P"), year = 2017,state = "OR",output = "wide",   geometry = F)

