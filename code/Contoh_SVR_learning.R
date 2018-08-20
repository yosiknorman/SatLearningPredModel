# Contoh Pakai data timeseries

data(AirPassengers) 
monthly_data <- unclass(AirPassengers)
months <- 1:144
DF <- data.frame(months,monthly_data)
colnames(DF)<-c("x","y")

# train an svm model, consider further tuning parameters for lower MSE

gamm = 10:30
svmodel = list()
prognoza = list()
hasil = c()
for(i in 1:length(gamm)){
  svmodel[[i]] <- ?svm(y ~ x,data=DF, type="eps-regression",kernel="radial",cost=10000, gamma=gamm[i])
  prognoza[[i]] <- predict(svmodel[[i]], newdata=data.frame(x=nd))
  hasil[i] = cor(prognoza[[i]][DF$x], DF$y)
}
gamm[which(hasil == max(hasil))]
# svmodel <- svm(y ~ x,data=DF, type="eps-regression",kernel="radial",cost=100, gamma=20)
#specify timesteps for forecast, eg for all series + 12 months ahead
nd <- 1:156
length(DF)

#compute forecast for all the 156 months 
prognoza <- predict(svmodel, newdata=data.frame(x=nd))
length(prognoza)
length(nd)

#plot the results
ylim <- c(min(DF$y), max(DF$y))
xlim <- c(min(nd),max(nd))
plot(DF$y, col="blue", ylim=ylim, xlim=xlim, type="l")
lines(prognoza[[21]], col="red")
prognoza

cor(prognoza[DF$x], DF$y)
# par(new=TRUE)
# plot(prognoza, col="red", ylim=ylim, xlim=xlim)