library(tidytext)


data_trust.tb <- as_tibble(data.frame(data_trust))
data_trust.tok <- unnest_tokens(data_trust.tb, output="word", input="text", to_lower=TRUE, strip_punct=TRUE, 
                           strip_numeric=TRUE)

data_trust.sent <- data_trust.tok %>%
  inner_join(get_sentiments("nrc"))

emotion_plot <- data_trust.sent %>% group_by(comment_id, sentiment) %>% summarize(n = n()) %>% 
  ggplot(aes(x = sentiment, y = n, fill = sentiment)) + 
  geom_bar(stat = "identity", alpha = 0.8) + 
  facet_wrap(~ comment_id) + coord_flip()
