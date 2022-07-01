library(sentimentr)
library(lexicon)
library(ggplot2)
library(tidyverse)

data_trust.sentdoc <- sentiment_by(data_trust$text)

senti_plot <- data_trust.sentdoc %>% mutate(Document=factor(paste("text_", element_id, sep=""))) %>% 
  ggplot(aes(x=Document, y=ave_sentiment, fill = ifelse(ave_sentiment<=0,"green","red"))) + geom_bar(stat="identity") + coord_flip() + theme(legend.position = "none") + xlab("Review") + ylab("average sentiment")

