## This script looks at exploratory data analysis 
## Last modified: 2025-03-31
############################
## libraries we are using 
library(ggplot2)
############################
df <- data.frame(x = rnorm(100))

plot1 <- ggplot(data = df, aes(x = x)) + geom_histogram()

ggsave(plot = plot1, filename = "figures/plot1.pdf")
