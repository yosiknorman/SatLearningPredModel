#!/usr/bin/Rscript

library(RCurl)


url1="ftp://hmwr829gr.cr.chiba-u.ac.jp/gridded/FD/V20151105/201712/TIR/"
url2="ftp://hmwr829gr.cr.chiba-u.ac.jp/gridded/FD/V20151105/201801/TIR/"
url3="ftp://hmwr829gr.cr.chiba-u.ac.jp/gridded/FD/V20151105/201802/TIR/"
jan = read.table("available01.txt", header = F)
jan = as.character(jan$V9)


# URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
for(i in 1:length(jan)){
  setwd("../hmw_compiler")
  download.file(url = paste0(url2, jan[i]), destfile = paste0(jan[i] ))
  system(paste0("./hmw_compiler.sh ", jan[i]))
}
setwd("../code")

1*6*24


