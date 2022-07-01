# loading web-scraping packages

library(rvest)
library(XML)
library(RCurl)
library(dplyr)
library(lubridate)



### TRUST PILOT WEB SCRAPING

# webscraping to get all the comments from every pages

text <- vector()
titles <- vector()
consumers <- vector()
date <- vector()


for (i in 1:16){
  trustpilot_site <- read_html(paste("https://www.trustpilot.com/review/batmaid.ch?page=",i, sep=""))
  text_page <- trustpilot_site %>% html_nodes("div.styles_reviewContent__0Q2Tg") %>% html_text()
  title_page <-trustpilot_site %>% html_nodes("div.styles_reviewContent__0Q2Tg h2") %>% html_text()
  consumer_page <-trustpilot_site %>% html_nodes("div.styles_consumerName__dP8Um") %>% html_text()
  date_page <- trustpilot_site %>% html_nodes("div.styles_reviewHeader__iU9Px time") %>% html_text()
  date <- append(date, date_page)
  text <- append(text,text_page)
  consumers <- append(consumers, consumer_page)
  
}

# create trust pilot data

data_trust <- data.frame(matrix(NA, nrow = length(text), ncol = 3))
colnames(data_trust) <- c("comment_id", "text","date")




for (i in 1:length(text)){
  data_trust$comment_id[i] <- paste("TrustPilot",i,consumers[i], sep="_")
  data_trust$text[i]<-text[i]
  data_trust$date[i]<-date[i]
}

# if want to display per month

# remove "Updated " in date variable
for (i in 1:nrow(data_trust)){
  if(grepl('Updated ', date[i])){
    data_trust$date[i] <- gsub("Updated ","",as.character(data_trust$date[i]))
  }
}

# keep date with ago in it
data_trust_recent <- data_trust %>% filter(grepl('ago', date)) %>% select(comment_id, text)

# filter older dates
data_trust_old <- data_trust %>% filter(grepl('ago', date)== FALSE)

# turn character date to date
data_trust_old$date <- mdy(data_trust_old$date)

# get the week number of today
week_today <- week(Sys.Date())
year_today <- year(Sys.Date())



# filter old date to keep only recent ( 4 weeks before today)
data_trust_week <- data_trust_old %>% filter(between(week(date), week_today - 4, week_today)& year(date)==year_today) %>% select(comment_id, text)

# merge data frames with recent comment + coments from 4 weeks before today
data_trust <- rbind(data_trust_recent,data_trust_week)


data_trust$text <- gsub("([A-Z])", " \\1", data_trust$text)

data_trust$text<- str_replace(gsub("\\s+", " ", str_trim(data_trust$text)), "B", "b")