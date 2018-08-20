#!/usr/bin/Rscript

library(ncdf4)
library(EBImage)
library(raster)
library("dynlm")
library("starma")
library(maps)
library(viridis)
library(e1071)




rm(list = ls())


nc_list = list.files("../data/", pattern = ".nc")

nc = nc_open(filename = paste0("../data/", nc_list[1]) )
lat = nc$dim$latitude$vals
lon = nc$dim$longitude$vals
# IR = ncvar_get(nc, "IR")
# index = 1

ST = function(index){
  rnc = raster(paste0("../data/", nc_list[index]))
  potong = raster()
  extent(potong) = c(xmn = 117, xmx = 150, ymn = -13, ymx = 7)
  rncN = crop(rnc, potong)
  crs(rncN) = crs(rnc)
  return(rncN)
}


ST_nc = list()
# Spat = array(0, dim = c(dim(ST_nc[[1]])[1:2], length(nc_list)))

for(i in 1:length(nc_list)){
  ST_nc[[i]] = ST(i)
}
Spat = array(0, dim = c(dim(ST_nc[[1]])[1:2], length(nc_list)))
for(i in 1:length(nc_list)){
  Spat[,,i] =as.matrix(ST_nc[[i]])
}


# Please Skip This Part
load("~/Data_riset/kec2.Rda")
sulsel = which(kec$Provinsi == "SULAWESI SELATAN")
sulsel = kec[sulsel,]
# SubMask = list()
# for(i in  1:length(sulsel)){
#   SubMask[[i]] = mask(ST_nc[[1]], sulsel[i,])
# }
# SubMask
# for(i in  1:length(sulsel)){
#   SubMask[[i]][!is.na(SubMask[[i]])] = 1
#   SubMask[[i]][is.na(SubMask[[i]])] = 0
# }

load(file = "~/Data_riset/nc_AHI13.bin")

# dim(Spat[,,1])
# dim(as.matrix(SubMask[[1]]))
Spat_satu = Spat

fastmasking = function(filter_array, data_spat){
  satu = as.matrix(SubMask[[filter_array]])
  data_spat[satu != 1] = 0
  return(data_spat)
}

hasil = array(0, dim = dim(Spat))

for(i in 1:dim(Spat)[3]){
  hasil[,,i] = fastmasking(filter_array = 204, data_spat = Spat_satu[,,i])
}
which(sulsel$Kecamatan == "PANAKUKANG")

Mean_1 = c()
for(i in 1:dim(hasil)[3]){
  Mean_1[i] = mean(hasil[,,i][hasil[,,i] != 0])
}


Spat_satu
# satu = as.matrix(SubMask[[1]])
# Spat_satu = Spat
# Spat_satu[,,1][satu != 1] = 0




dt = substr(nc_list,19, nchar(nc_list)-3 )
st = paste0(substr(dt, 1, 4),"-",   substr(dt, 5, 6), "-", substr(dt, 7, 8), " ", substr(dt, 9, 10),":",substr(dt, 11, 12) , ":",substr(dt, 13, 14),":00" )
time = as.POSIXct(st)
# all = data.frame(time = time, x = 1:length(time), y = Spat[1,1,])
# df = data.frame(time = time, x = 1:length(time), y = Spat[1,1,])

all = data.frame(time = time, x = 1:length(time), y = Mean_1)
df = data.frame(time = time, x = 1:length(time), y = Mean_1)
df = df[1:15, ]


nd = 1:1000
svmodel <- svm(y ~ x,data=df, type="eps-regression",kernel="radial",cost=1000, gamma=2)
prognoza <- predict(svmodel, newdata=data.frame(x=nd))

plot(df$y, type = "l" , xlim = c(1, 30))
lines(prognoza, col = "red")
lines(all$y, col = "green")
points(x = 15, y = prognoza[15])
# legend()
cor(prognoza[all[,2]], all$y)





# image(ST_nc[[1]])
# plot(raster(Spat[,,1]))
# par(mfrow = c(3, 3))
# for(i in 1:8){
#   plot(ST_nc[[i]], col = rev(c("black", viridis(4), "red")), main = paste0("Data ", dt[i]))
#   map("world", add = T, col = "white")
#   
# }






# col = viridis(10)
# plot(rncN, col = rev(col))
# map("world", add = T)


