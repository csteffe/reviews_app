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
