library(tidyverse)
df <- read.csv("kc_house_data.csv")
df


ggplot(df, aes(x=sqft_living, y=price))+
  geom_point()+
  theme(plot.caption = element_text(hjust = 0.5, face = "bold"))+
  labs(x="sqft Living", y="Price", caption="Scatter Plot of the SQFT of Living Space Against Price")


df$floors <-as.character(df$floors)
ggplot(df, aes(x=price, fill=floors))+
  geom_boxplot()+
  theme(plot.caption = element_text(hjust = 0.5, face = "bold"))+
  labs(x="Price", y="Floors ", caption="Boxplot of Floors with Prices")


df_floor1 <- df %>% filter(floors=='1')
df_floor15 <- df %>% filter(floors=='1.5')
df_floor2 <- df %>% filter(floors=='2')
df_floor25 <- df %>% filter(floors=='2.5')
df_floor3 <- df %>% filter(floors=='3')
df_floor35 <- df %>% filter(floors=='3.5')

chart1<-ggplot(df_floor1, aes(x=price, color=floors))+
  geom_histogram()
chart15<-ggplot(df_floor15, aes(x=price, color=floors))+
  geom_histogram()
chart2<-ggplot(df_floor2, aes(x=price, color=floors))+
  geom_histogram()


chart25<-ggplot(df_floor25, aes(x=price, color=floors))+
  geom_histogram()
chart3<-ggplot(df_floor3, aes(x=price, color=floors))+
  geom_histogram()
chart35<-ggplot(df_floor35, aes(x=price, color=floors))+
  geom_histogram()

library(gridExtra)
gridExtra::grid.arrange(chart1, chart15, chart2, chart25, chart3, chart35, ncol = 3, nrow = 2)


ggplot(df, aes(x=price, color=floors))+
  geom_density()+
  theme(plot.caption = element_text(hjust = 0.5, face = "bold"))+
  labs(x="Price", y="Proprotion", caption="Boxplot of Floors with Prices")




ggplot(df, aes(x=price, color=floors))+
  geom_density()+
  theme(plot.caption = element_text(hjust = 0.5, face = "bold"))+
  labs(x="Price", y="Proprotion", caption="Boxplot of Floors with Prices")

library(dplyr)
floors <- dplyr::count(df, floors, sort = TRUE)
count(floors)

df %>% 
  filter(price==75000)

