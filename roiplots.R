# install.packages(c('ggplot2','R.matlab'))
library(R.matlab)
library(ggplot2)

# read in from matlab
age     <- readMat('mat/age.mat')$age
sigrois <- readMat('mat/sigPCidx.mat')$sigPCidx

### put matrix and age into one "long" format data frame
df <- data.frame(roi=t(roiXsubj$P[sigrois,]))
df$age <- age
# move all the rois from columns into rows
df.reshape <- reshape(df,varying=1:nrow(sigrois),direction='long')
# rename columns so they make sense
names(df.reshape) <- c('age','roi','value','sid')
# rename ROI to again be the name/idx from washu
df.reshape$roi <- sigrois[df.reshape$roi]


# plot all sig rois in a grid
p.all<-ggplot(df.reshape,aes(x=age,y=value))+geom_smooth()+theme_bw()+facet_wrap(~roi)
print(p.all)

# just plot roi 
p.248<-ggplot(subset(df.reshape,roi=="248"), aes(x=age,y=value))+geom_smooth() + theme_bw() + ggtitle("roi 248")
print(p.248)
