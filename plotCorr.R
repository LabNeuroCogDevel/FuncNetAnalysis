library(plyr)
library(reshape)
library(foreach)

# roistats <- Sys.glob('../RewardRestSubjs/*/afni_restproc/power_nogsr/*_roistats.txt')
# ages     <- Sys.glob('../RewardRestSubjs/*/*.age.txt')
# sexs     <- Sys.glob('../RewardRestSubjs/*/*.sex.txt')
# 
# agedf <- ldply(ages,function(x){ c(
#                        subj=unlist(lapply(strsplit(x,'/'),function(y){y[3]})),
#                        age=as.numeric(try(read.table(file=x)$V1)) )} ) 
# 
# sexdf <- ldply(sexs,function(x){ c(
#                        subj=unlist(lapply(strsplit(x,'/'),function(y){y[3]})),
#                        sex=as.numeric(try(read.table(file=x)$V1)) )} )
# 
# #infodf <- merge(sexdf,agedf,by='subj')
# 
# corelation <- ldply(roistats, function(x) { 
#           try({
#           m    <- as.matrix(read.table(x,comment.char="",header=T))
#           subj <- unlist(lapply(strsplit(x,'/'),function(y){y[3]}))
#           m[upper.tri(m)] <- NA
#           df <- as.data.frame( cbind(which(!is.na(m),arr.ind = TRUE),na.omit(as.vector(m))) )
#           df$subj <- subj
#           df$sex  <- sexdf$sex[sexdf$subj==subj]
#           df$age  <- agedf$age[agedf$subj==subj]
#           return(df)}
#           )
#           
#  })

num.goodvols <- .8*200; # 80% retained, 160 vols
subjinfo <- read.table('txt/SubjectTimeAgeSexFD.txt', header=T) # file from restPreproc
goodtp1  <- subset(subjinfo,tpoint=='t1'&as.numeric(as.character(remaingvols))>=num.goodvols)
tp1cor   <- ddply(goodtp1,.(sid),function(x){
       sid  <- as.character(x$sid)
       print(sid)
       try({
           f   <- sprintf('../RewardRestSubjs/%s/afni_restproc/power_nogsr/%s_roistats.txt',sid,sid)
           # read in as a matrix, discard file name and subbrick number
           raw <- as.matrix(read.table(f,comment.char="",header=T)[,c(-1,-2)])
           #m   <- cor(raw,use='na.or.complete')
           m   <- cor(raw)
           m[lower.tri(m,diag=T)] <- NA

           df <- melt(m)
           names(df) <- c('roi1','roi2','c')
           df <- subset(df,!is.na(c))
           df$roi1   <- as.numeric(gsub('Mean_','',as.character(df$roi1)))
           df$roi2   <- as.numeric(gsub('Mean_','',as.character(df$roi2))) 
            
           df$z    <- scale(df$c)
           df$sid  <- sid
           df$sex  <- x$sex
           df$age  <- x$age
           #print(head(df))
           return(df)}
         )
     })
write.csv(file="txt/tp1cordf.csv",tp1cor)

### TODO - sliding window ?

## break into age groups
tp1cor$agegroup <- cut(tp1cor$age,breaks=c(-Inf,12, 15, 18, 21,Inf))
levels(tp1cor$agegroup ) <-c('babys','kids','youngteens','oldteens','youngadults','theelderly')
# TODO: better names


# t test roi-roi pairs
#t.test( subset(tp1cor,roi1==3&roi2==6&agegroup=='babys',z),   subset(tp1cor,roi1==3&roi2==6&agegroup=='youngadults',z) )
# see p.adjust
rois<-head(unique(tp1cor$roi1),n=24)
groups <- unique(tp1cor$agegroup)
a<-foreach(roi.i=1:length(rois), .combine='rbind') %do% {
 b<-foreach(roi.j=roi.i:length(rois), .combine='rbind') %do% {
   roi1<-rois[roi.i];roi2<-rois[roi.j]

   grp1<-subset(tp1cor,roi1==roi1&roi2==roi2&agegroup=='babys',z)$z;
   grp2<-subset(tp1cor,roi1==roi1&roi2==roi2&agegroup=='youngadults',z)$z;

   cat(sprintf('%d,%d -> %d,%d (%d,%d)\n',roi.i,roi.j,roi1,roi2,length(grp1),length(grp2)))

   i<-tryCatch( t.test(grp1,grp2)$p.value, 
                error=function(e){print(e);print(c(length(grp1),length(grp2)));1}   # t.test doesnt work => say p is one
     )
   print(i)
   i
  }
}

# get group stats
groupcor <- ddply(tp1cor, .(roi1, roi2, agegroup), function(x){
    c(mu.c=mean(x$c,na.rm=T),
      mu.z=mean(x$z,na.rm=T),
      sd.z=sd(x$z),
      mu.age=mean(x$age),
      #n.nan=nrow(subset(x,is.nan(c)|is.na(c)|c==0)), # nan's not included
      n.fem=nrow(subset(x,sex=="F")),
      n=nrow(x))
})
write.csv(file="txt/tp1roibyagegroup.csv",groupcor)

# plot cor mats
ggplot(groupcor,aes(x=roi1,y=roi2,color=mu.z))+geom_tile()+facet <- wrap(~agegroup)+theme_bw() + scale_color_gradient2(low="blue",mid="white",high="red") 

# plot to see dropout
# by age,z score 
#ggplot(groupcor,aes(x=mu.age,y=mu.z))+geom_point()+facet_wrap(~agegroup) 
# by roi, age
ggplot(groupcor,aes(x=roi1,y=mu.age,size=n,color=agegroup))+geom_point()+ theme_bw() # +facet_wrap(~agegroup) 



# 
