

#########################################################################
#
# made by Marshaw
#
# excel的起始日期是1899-12-30
#
# 最新更新：26/12/2023
# binance爬虫：每日涨幅
#
#######################################################################

rm(list=ls())

library(readxl)
library(dplyr)
library(openxlsx)
library(tidyr)
library(rvest)

wb <- loadWorkbook("Downloads/binance lower than 100m.xlsx") #现存标签
rawdata1 <- read.xlsx(wb, colNames = F)  # 读取当前 sheet 的数据

data1 <- NULL
for (i in 1:(nrow(rawdata1)/5)) {
  cat(i,'/', nrow(rawdata1),'\n')
  m = i*5-4
  n = i*5
  tem <- rawdata1[m:n,]
  tem1 <- t(tem)
  data1 <- rbind(data1, tem1)
}
colnames(data1) <- c('名称','价格','涨跌','24交易量','市值')
data1 <- as.data.frame(data1)
fulldata <- data1
fulldata$涨跌 <- sprintf("%.4f%%", as.numeric(fulldata$涨跌)*100)
# 去除24交易量列中的非数字字符，并将其转换为数值
fulldata$`24交易量_百万` <- as.numeric(gsub("[^0-9.]", "", fulldata$`24交易量`))
# 去除市值列中的非数字字符，并将其转换为数值
fulldata$市值_百万 <- as.numeric(gsub("[^0-9.]", "", fulldata$市值))

column1 <- fulldata$`24交易量_百万`/fulldata$市值_百万 %>% as.data.frame()
colnames(column1) <- "交易量市值比率"
fulldata <- cbind(fulldata, column1)
fulldata <- fulldata[,c(1,2,3,6,7,8)]
fulldata$交易量市值比率 <- sprintf("%.2f", as.numeric(fulldata$交易量市值比率)) 
fulldata <- fulldata[order(fulldata$交易量市值比率, decreasing = T),]



