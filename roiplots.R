# install.packages(c('ggplot2','R.matlab'))
library(R.matlab)
library(ggplot2)

# so plots look like latex
library(Cairo)
mainfont <- "Garamond"
CairoFonts(regular = paste(mainfont,"style=Regular",sep=":"),
        bold = paste(mainfont,"style=Bold",sep=":"),
        italic = paste(mainfont,"style=Italic",sep=":"),
        bolditalic = paste(mainfont,"style=Bold Italic,BoldItalic",sep=":"))

###################  READ IN MAT
roiXsubj<- readMat('mat/PCs_per_ind.mat')
age     <- readMat('mat/age.mat')$age
sigrois <- readMat('mat/sigPCidx.mat')$sigPCidx

###################  READ IN TXT
# read in roi labels
roilabel <- read.table('txt/labels_bb264_coords',header=F,sep="\t")
names(roilabel) <- c('i','x','y','z','atlas','dist','label')

# read in from restPreproc list
subjscaninfo <- read.table('txt/SubjectTimeAgeSexFD.txt',sep="\t",header=T)

## extract people we care about
# we know we only want visit1's that have enough volumes
ssi.t1 <- subset(subjscaninfo, tpoint=="t1"&remaingvols>160)
# grab the people who have NA remaing vols, but not really
ssi.t1 <- rbind(ssi.t1, subset(subjscaninfo,sid %in% c(
                 "10849_20101115",
                 "10677_20110604",
                 "10173_20100313",
                 "10852_20101213"
                 ) ) )
# sort by age
ssi.t1 <- ssi.t1[sort(ssi.t1$age,index.return=T)$ix,]
# sanity check: all ages from the txt and mat should match
if(any(ssi.t1$age!=age)){
 warning('mat and txt do not agree!!')
}

# split luna_date into 2 fileds
ssi.t1$lunaid <- as.numeric(substr(as.character(ssi.t1$sid),1,5))
ssi.t1$date   <- as.numeric(substr(as.character(ssi.t1$sid),7,14))

# only take the bits we like
ssi.t1<-subset(ssi.t1,select=c(lunaid,date,age,sex))


###############################
### put matrix and age into one "long" format data frame
df <- data.frame(roi=t(roiXsubj$P[sigrois,]))
df<-cbind(df,ssi.t1)
# move all the rois from columns into rows
df.reshape <- reshape(df,varying=1:nrow(sigrois),direction='long')
# rename columns so they make sense
names(df.reshape) <- c('lunaid','date','age','sex','roi','value','subjn')

# rename ROI to again be the name/idx from washu
df.reshape$roi <- sigrois[df.reshape$roi]
# and grab annotated names
df.reshape$roiname <- roilabel$label[df.reshape$roi]

##############################
# plot

# plot all sig rois in a grid
p.all<-ggplot(df.reshape,aes(x=age,y=value,color=sex))+geom_smooth()+theme_bw()+facet_wrap(~roiname)+geom_point()
print(p.all + ggtitle('ROIs with sig PC change'))

# just plot roi 
p.248<-ggplot(subset(df.reshape,roi=="248"), aes(x=age,y=value))+geom_smooth() + theme_bw() + ggtitle("roi 248")
print(p.248)
