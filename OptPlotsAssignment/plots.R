# Make a plot that answers the question: what is the relationship between mean
# covered charges (Average.Covered.Charges) and mean total payments 
# (Average.Total.Payments) in New York?

# Import packages
library(ggplot2)
library(ggpmisc)

# Import files
payments <- read.csv('payments.csv')

# Create scatterplot showing the relationship
ggplot(payments, aes(x = Average.Covered.Charges, y = Average.Total.Payments)) +
  geom_point(alpha = 0.1) + # add transparency to help with overplotting
  scale_x_log10() + # plot on log scale so data doesn't look so scrunched
  scale_y_log10() +
  stat_smooth(method = 'lm') + # plot linear regression
  # show lin reg formula on plot
  stat_poly_eq(aes(label = ..eq.label..), formula = y~x, parse = TRUE) + 
  # label plot
  labs(x = 'Mean Covered Charges (Log($))', y = 'Mean Total Payments (Log($))',
       title = 'Positive correlation between logs of 
  covered charges and total payments') +
  theme(plot.title = element_text(size = 16))

# Save as PDF
ggsave('plot1.pdf', width = 5, height = 5)

# Make a plot that answers the question: how does the relationship between mean
# covered charges and mean total payments vary by medical condition 
# (DRG.Definition) and the state in which care was received (Provider.State)?

# Change medical condition names to be more readable
levels(payments$DRG.Definition) <- c('Pneumonia', 'Heart Failure', 'Gastroent', 
                                     'Misc Nutrition', 'Kidney/UI Tract', 'Sepsis')

# Create scatterplot showing the relationship
ggplot(payments, aes(x = Average.Covered.Charges, y = Average.Total.Payments)) +
  geom_point(alpha = 0.1, size = 0.5) + # add transparency to help with overplotting
  scale_x_log10() + # plot on log scale so data doesn't look so scrunched
  scale_y_log10() +
  stat_smooth(method = 'lm') + # plot linear regression
  # show lin reg formula on plot
  # stat_poly_eq(aes(label =..eq.label..), formula = y~x, parse = TRUE) + 
  facet_grid(DRG.Definition ~ Provider.State) +
  # label plot
  labs(x = 'Mean Covered Charges (Log($))', y = 'Mean Total Payments (Log($))',
       title = 'Positive correlation between logs of covered charges and total payments') +
  theme(plot.title = element_text(size = 16), 
        strip.text.y = element_text(size = 8))

# Save as PDF
ggsave('plot2.pdf', width = 10, height = 10)
