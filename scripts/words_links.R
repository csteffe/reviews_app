

data_trust.tf <- dfm(data_trust.tk)


data_trust.feat <- textstat_frequency(data_trust.tf) %>% filter(rank <= 30) 

library(reshape2)

data_trust.fcm <- fcm(data_trust.tk, window = 3, tri = FALSE)
data_trust.fcm <- (data_trust.fcm + t(data_trust.fcm))/2 ## make the co-occurrence matrix symmetrical



data_trust.fcm.mat <- melt(as.matrix(data_trust.fcm[data_trust.feat$feature, data_trust.feat$feature]), varnames = c("Var1","Var2")) 
ggplot(data = data_trust.fcm.mat, aes(x=Var1, y=Var2, fill=value)) +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = max(data_trust.fcm.mat$value)/2, limit = c(0,max(data_trust.fcm.mat$value)), name="Co-occurrence")+
  geom_tile() + theme(axis.text.x = element_text(angle = 45, hjust = 1))



data_trust.inv_occ <- 280-as.matrix(data_trust.fcm[data_trust.feat$feature, data_trust.feat$feature]) ## 280 is the max co-occurrence here
data_trust.hc <- hclust(as.dist(data_trust.inv_occ))
plot(data_trust.hc)



library(text2vec)
library(factoextra)

data_trust.coo <- fcm(data_trust.tk, context="window", window = 5, tri=FALSE) 



set.seed(123)
p <- 2 # word embedding dimension
data_trust.glove <- GlobalVectors$new(rank = p, x_max = 10) # x_max is a needed technical option
data_trust.weC <- data_trust.glove$fit_transform(data_trust.coo) # central vectors; data_trust.glove$components contains the context vectors

data_trust.we <- t(data_trust.glove$components)+data_trust.weC # unique representation



index <- textstat_frequency(dfm(data_trust.tk))[1:40,]$feature


plot(data_trust.we[index,], type='n',  xlab="Dim 1", ylab="Dim 2")
text(x=data_trust.we[index,], labels=rownames(data_trust.we[index,]))