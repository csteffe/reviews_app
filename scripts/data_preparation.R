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