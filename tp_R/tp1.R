#### Set the default directory to the folder that contains all ARFF files 

temp = list.files(pattern="*.arff")
library(foreign)

for (i in 1:length(temp)) assign(temp[i], read.arff(temp[i]))

for(i in 1:length(temp))
{
  mydata=read.arff(temp[i])
  t=temp[i]
  x=paste(t,".csv")
  write.csv(mydata,x,row.names=FALSE)
  mydata=0
}