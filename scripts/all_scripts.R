# loading web-scraping packages

library(rvest)
library(XML)
library(RCurl)
library(dplyr)
library(lubridate)
library(stringr)


### TRUST PILOT WEB SCRAPING

# webscraping to get all the comments from every pages

text <- vector()
titles <- vector()
consumers <- vector()
date <- vector()
ratings <- vector()

for (i in 1:16){
  trustpilot_site <- read_html(paste("https://www.trustpilot.com/review/batmaid.ch?page=",i, sep=""))
  text_page <- trustpilot_site %>% html_nodes("div.styles_reviewContent__0Q2Tg") %>% html_text()
  title_page <-trustpilot_site %>% html_nodes("div.styles_reviewContent__0Q2Tg h2") %>% html_text()
  consumer_page <-trustpilot_site %>% html_nodes("div.styles_consumerName__dP8Um") %>% html_text()
  date_page <- trustpilot_site %>% html_nodes("div.styles_reviewHeader__iU9Px time") %>% html_text()
  date <- append(date, date_page)
  text <- append(text,text_page)
  consumers <- append(consumers, consumer_page)
  rating_page <- trustpilot_site %>% html_nodes("div.star-rating_starRating__4rrcf")
  rating_page <- as.character(rating_page)
  rating_page <- rating_page[3:(length(rating_page)-3)]
  rating_page <- str_extract(rating_page, "(?<=Rated )(.+)(?=\\ out of 5 stars)")
  ratings <- append(ratings, rating_page)
  
}

# create trust pilot data

data_trust <- data.frame(matrix(NA, nrow = length(text), ncol = 4))
colnames(data_trust) <- c("comment_id","rating", "text","date")




for (i in 1:length(text)){
  data_trust$comment_id[i] <- paste("TrustPilot",i,consumers[i], sep="_")
  data_trust$text[i]<-text[i]
  data_trust$date[i]<-date[i]
  data_trust$rating[i]<-ratings[i]
}

# if want to display per month

# remove "Updated " in date variable
for (i in 1:nrow(data_trust)){
  if(grepl('Updated ', date[i])){
    data_trust$date[i] <- gsub("Updated ","",as.character(data_trust$date[i]))
  }
}

# keep date with ago in it
data_trust_recent <- data_trust %>% filter(grepl('ago', date)) %>% select(comment_id,rating, text)

# filter older dates
data_trust_old <- data_trust %>% filter(grepl('ago', date)== FALSE)

# turn character date to date
data_trust_old$date <- mdy(data_trust_old$date)

# get the week number of today
week_today <- week(Sys.Date())
year_today <- year(Sys.Date())



# filter old date to keep only recent ( 4 weeks before today)
data_trust_week <- data_trust_old %>% filter(between(week(date), week_today - 4, week_today)& year(date)==year_today) %>% select(comment_id, rating, text)

# merge data frames with recent comment + coments from 4 weeks before today
data_trust <- rbind(data_trust_recent,data_trust_week)


data_trust$text <- gsub("([A-Z])", " \\1", data_trust$text)

data_trust$text<- str_replace(gsub("\\s+", " ", str_trim(data_trust$text)), "B", "b")


library(quanteda)

# turn data to corpus
data_trust.cp <- corpus(data_trust$text)

# tokenize data
data_trust.tk <- tokens(data_trust.cp,
                        remove_numbers=TRUE, 
                        remove_punct=TRUE, 
                        remove_symbols=TRUE, 
                        remove_separators=TRUE)

# turn to lowercase + remove stop word (like "a", "of", "the"...), remove word cleaning
data_trust.tk <- data_trust.tk %>% tokens_tolower() %>% tokens_remove(pattern = stopwords("en")) %>% tokens_remove(c("cleaning","batmaid"))

# lemmatization, maybe need to use stemming in case of multiple languages
library(lexicon)
data_trust.tk <- data_trust.tk %>% tokens_replace(pattern=hash_lemmas$token, replacement = hash_lemmas$lemma) %>% tokens_select(min_nchar = 3)

# compute document term frequency matrice
data_trust.dfm <- dfm(data_trust.tk)

# compute frequencies

library(quanteda.textstats)
data_trust.freq <- textstat_frequency(data_trust.dfm)

# compute term frequency-inverse document frequency ( frequent words only appearing to specific documents)
data_trust.tfidf <- dfm_tfidf(data_trust.dfm)  


library(quanteda)

# turn data to corpus
data_trust.cp <- corpus(data_trust$text)

# tokenize data
data_trust.tk <- tokens(data_trust.cp,
                        remove_numbers=TRUE, 
                        remove_punct=TRUE, 
                        remove_symbols=TRUE, 
                        remove_separators=TRUE)

# turn to lowercase + remove stop word (like "a", "of", "the"...), remove word cleaning
data_trust.tk <- data_trust.tk %>% tokens_tolower() %>% tokens_remove(pattern = stopwords("en")) %>% tokens_remove(c("cleaning","batmaid"))

# lemmatization, maybe need to use stemming in case of multiple languages
library(lexicon)
data_trust.tk <- data_trust.tk %>% tokens_replace(pattern=hash_lemmas$token, replacement = hash_lemmas$lemma) %>% tokens_select(min_nchar = 3)

# compute document term frequency matrice
data_trust.dfm <- dfm(data_trust.tk)

# compute frequencies

library(quanteda.textstats)
data_trust.freq <- textstat_frequency(data_trust.dfm)

# compute term frequency-inverse document frequency ( frequent words only appearing to specific documents)
data_trust.tfidf <- dfm_tfidf(data_trust.dfm)  


library(ggplot2)
library(quanteda.textplots)

# frequency plot

tf_plot <- data_trust.freq %>% top_n(20, frequency) %>%
  ggplot(aes(x=reorder(feature, frequency), y=frequency)) + geom_bar(stat="identity", color='red',fill='black') + coord_flip() +
  xlab("Frequency") + ylab("term") +ggtitle("top 20 most frequent words")

library(tidytext)
library(broom)
tf_id_plot <- data_trust.tfidf %>% tidy() %>%
  group_by(term) %>%
  summarize(count = max(count)) %>% arrange(desc(count)) %>%
  top_n(15, count) %>%
  ggplot(aes(x=reorder(term, count), y=count)) + geom_bar(stat = "identity") + coord_flip() +
  xlab("Max TF-IDF") + ylab("term")

cloud_words <- textplot_wordcloud(data_trust.dfm, min_count = 1) 


library(sentimentr)
library(lexicon)
library(ggplot2)
library(tidyverse)

data_trust.sentdoc <- sentiment_by(data_trust$text)

senti_plot <- data_trust.sentdoc %>% mutate(Document=factor(paste("text_", element_id, sep=""))) %>% 
  ggplot(aes(x=Document, y=ave_sentiment, fill = ifelse(ave_sentiment<=0,"green","red"))) + geom_bar(stat="identity") + coord_flip() + theme(legend.position = "none") + xlab("Review") + ylab("average sentiment") + ggtitle("proportion of negative vs positive terms")

library(tidytext)


data_trust.tb <- as_tibble(data.frame(data_trust))
data_trust.tok <- unnest_tokens(data_trust.tb, output="word", input="text", to_lower=TRUE, strip_punct=TRUE, 
                                strip_numeric=TRUE)

data_trust.sent <- data_trust.tok %>%
  inner_join(get_sentiments("nrc"))

emotion_plot <- data_trust.sent %>% group_by(comment_id, sentiment) %>% summarize(n = n()) %>% 
  ggplot(aes(x = sentiment, y = n, fill = sentiment)) + 
  geom_bar(stat = "identity", alpha = 0.8) + 
  facet_wrap(~ comment_id) + coord_flip() + ggtitle("Emotions by review")
