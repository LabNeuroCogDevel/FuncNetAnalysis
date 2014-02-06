 # install.packages(c('ggplot2','R.matlab'))
 library(R.matlab)
 library(ggplot2)
 roiidx<-213
 roiXsubj<-readMat('mat/PCs_per_ind.mat')
 age <- readMat('age.mat')
 df <- data.frame(roi=roiXsubj$P[roiidx,],age)
 p <- ggplot(df,aes(x=age,y=roi))+geom_smooth()+theme_bw()
 print(p)
