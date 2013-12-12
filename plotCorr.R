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

### get roi location (for distances) and roi label
roi.labels<-read.table('txt/labels_bb264_coords',sep="\t",header=F)
names(roi.labels) <- c('n','x','y','z','atlas','dist','label','a','b')
roi.labels <- roi.labels[,c('n','x','y','z','label','dist'),]


# if we were trying to do it programticly
# ... load in everyone, remove those with too few volumes, get cors, and drop subj
subjinfo <- read.table('txt/SubjectTimeAgeSexFD.txt', header=T) # file from restPreproc
goodtp1  <- subset(subjinfo,tpoint=='t1'&as.numeric(as.character(remaingvols))>=num.goodvols)

# but instead we've cleaned it by hand
# goodtp1 <- read.table('txt/clean_motion_20_subs_11_13.csv', header=T,sep=',') # file from restPreproc
# goodtp1 <- subset(goodtp1,X=='',c('sid','age','sex'))

tp1cor   <- ddply(goodtp1,.(sid),function(x){
       sid  <- as.character(x$sid)
       print(sid)
       try({
           f   <- sprintf('/data/Luna1/Reward/Rest/%s/afni_restproc/power_nogsr/%s_264roistats.txt',sid,sid)
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
write.csv(file="txt/tp1_264cordf.csv",tp1cor)

# deal with roi drop out
# the try statement above means ROIs of all 0s do not appear in the data.frame 
roisubj    <- ddply(tp1cor, .(sid), function(x) { data.frame(roi=unique(c(unique(x$roi1),unique(x$roi2)))) })
roisubjcnt <- ddply(roisubj,.(roi),nrow)
subjroicnt <- ddply(roisubj,.(sid),nrow)
ggsave(file="imgs/preanalysis/256_ROICntPerSubj.png",ggplot(subjroicnt,aes(y=V1,x=sid)) + geom_point() + theme_bw() )
ggsave(file="imgs/preanalysis/256_SubjCntPerROI.png",ggplot(roisubjcnt,aes(y=V1,x=roi)) + geom_point() + theme_bw() )
# particularly bad subjects
print(head(subjroicnt[sort(subjroicnt$V1,index.return=T)$ix,]))
print(head(roisubjcnt[sort(roisubjcnt$V1,index.return=T)$ix,]))


#### DROP ROIS with less than 95% of subjects coverage
### WHY? lets keep all the data we can!
##drop.rois <- roisubjcnt[roisubjcnt$V1<max(roisubjcnt$V1)*.95,'roi']
####   ... drop anything without total coverage
#drop.rois <- roisubjcnt[roisubjcnt$V1<max(roisubjcnt$V1),'roi']
#print(drop.rois)
#tp1cor.roiDrp <- subset(tp1cor,!(roi1 %in% drop.rois) & !(roi2 %in% drop.rois ) ) 
#tp1cor <- tp1cor.roiDrp
### maybe we want to see what we've done
##roisubj.drp    <- ddply(tp1cor.roiDrp, .(sid), function(x) { data.frame(roi=unique(c(unique(x$roi1),unique(x$roi2)))) })
##roisubjcnt.drp <- ddply(roisubj.drp,.(roi),nrow)
##subjroicnt.drp <- ddply(roisubj.drp,.(sid),nrow)
##allrois <- unique(c(tp1cor.roiDrp$roi1,tp1cor.roiDrp$roi2))
##roisubj.missing  <- ddply(tp1cor.roiDrp, .(sid), function(x) { data.frame(roi=setdiff(allrois,unique(c(unique(x$roi1),unique(x$roi2)))  )) })

### TODO - sliding window ?

## break into age groups
tp1cor$agegroup <- cut(tp1cor$age,breaks=c(-Inf,12, 15, 18, 21,Inf))
levels(tp1cor$agegroup ) <-c('babys','kids','youngteens','oldteens','youngadults','theelderly')
# TODO: better names


## t test roi-roi pairs
tp1cor.pval <- ddply(tp1cor, .(roi1, roi2),.progress = "text", function(x){
   #grp1<-x$z[x$agegroup=='kids'];
   #grp2<-x$z[x$agegroup=='youngadults'];
   grp1<-x$z[x$age<15];
   grp2<-x$z[x$age>18];
   p<-tryCatch( t.test(grp1,grp2)$p.value, 
                error=function(e){print(e);print(c(length(grp1),length(grp2)));1}   # t.test doesnt work => say p is one
     )
})
names(tp1cor.pval)[3] <- 'p'

## add roi-roi distance
tp1cor.pval <- ddply(tp1cor.pval, .(roi1, roi2), function(x) {
  x$d <- dist( rbind(
        roi.labels[roi.labels$n==x$roi1,c('x','y','z')],
        roi.labels[roi.labels$n==x$roi2,c('x','y','z')]
      ))
  x
})
tp1cor.pval$dgrp <- cut(tp1cor.pval$d,breaks=c(-Inf,20,40,70,100,Inf))

## adjust pvalues for multiple comparisons
tp1cor.pval <- ddply(tp1cor.pval, .(dgrp), function(x) {
  x$adj.grp <- p.adjust(x$p,n=nrow(x),method="fdr")
  x
})
# and adj if all were used
tp1cor.pval$adj.all <- p.adjust(tp1cor.pval$p,n=nrow(tp1cor.pval),method="fdr")

write.csv(tp1cor.pval,file='txt/tp1cor_pvals.csv')
# show the top pvals
print(head(tp1cor.pval[sort(tp1cor.pval$adj,index.return=T)$ix,]))




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
