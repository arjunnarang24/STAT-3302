library(ggplot2)
library(dplyr)
library(broom)
############################
df <- data.frame(x = rnorm(100))

plot1 <- ggplot(data = df, aes(x = x)) + geom_histogram()
