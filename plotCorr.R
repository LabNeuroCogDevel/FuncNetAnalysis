library(plyr)
library(reshape)
library(foreach)
library(network)
library(linkcomm)
library(statnet)

# who do we keep?
num.goodvols <- .8*200; # 80% retained, 160 vols

### get roi location (for distances) and roi label
roi.labels<-read.table('txt/labels_bb264_coords',sep="\t",header=F)
names(roi.labels) <- c('n','x','y','z','atlas','dist','label','a','b')
roi.labels <- roi.labels[,c('n','x','y','z','label','dist'),]


# if we were trying to do it programticly
# ... load in everyone, remove those with too few volumes, get cors, and drop subj
subjinfo <- read.table('txt/SubjectTimeAgeSexFD.txt', header=T) # file from restPreproc
goodtp1  <- subset(subjinfo,tpoint=='t1'&as.numeric(as.character(remaingvols))>=num.goodvols)

# or we can use what's been cleaned by hand
# on second thought, lets just use all the data!
# goodtp1 <- read.table('txt/clean_motion_20_subs_11_13.csv', header=T,sep=',') # file from restPreproc
# goodtp1 <- subset(goodtp1,X=='',c('sid','age','sex')) # keep if X!='removed' (e.g. no note)
if(file.exists()) {
  tp1cor <- read.csv(file="txt/tp1_264cordf.csv")
} else {
  tp1cor   <- ddply(goodtp1,.(sid),.progress = "text",function(x){
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
  
   ## break into age groups
   tp1cor$agegroup <- cut(tp1cor$age,breaks=c(-Inf,12, 15, 18, 21,Inf))
   # TODO: better names
   #                            "(-Inf,12]" "(12,15]"   "(15,18]"  "(18,21]"  "(21, Inf]"
   levels(tp1cor$agegroup ) <- c('child','earlyteen','midteen','preadult','adult')

   write.csv(file="txt/tp1_264cordf.csv",tp1cor)
}  


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


## linear models
# center age for easy interpretation of intercept
tp1cor$agec <- tp1cor$age - mean(tp1cor$age)
tp1cor.lm <- dlply(tp1cor, .(roi1, roi2),.progress = "text", function(x){
 lm(x,formula=z~agec)
})
tp1cor.lmdf <- ldply(tp1cor.lm,function(x){do.call(cbind,as.list(summary(x)$coefficients))})
names(tp1cor.lmdf)[3:10] <- c('int.est','age.est','int.stder','age.stder','int.t','age.t','int.p','age.p')
# label rois
tp1cor.lmdf <- ddply(tp1cor.lmdf, .(roi1, roi2),.progress = "text", function(x) {
  x$d <- dist( rbind(
        roi.labels[roi.labels$n==x$roi1,c('x','y','z')],
        roi.labels[roi.labels$n==x$roi2,c('x','y','z')]
      ))
  x
})
# example cut
a<-subset(tp1cor.lmdf,d>40&d<70) 
i<-head(sort(p.adjust(tp1cor.lmdf$age.p,method="fdr",  n=nrow(tp1cor.lmdf)),decreasing=F, index.return=T)$ix,n=1)
a<-tp1cor.lm[[i]]



## t test roi-roi pairs
tp1cor.pval <- ddply(tp1cor, .(roi1, roi2),.progress = "text", function(x){

   #grp1<-x$z[x$age<15];
   #grp2<-x$z[x$age>18];

   grp1<-x$z[x$agegroup=='child'];
   grp2<-x$z[x$agegroup=='adult'];
   n1<-length(grp1) 
   n2<-length(grp2) 
   pval<-tryCatch( t.test(grp1,grp2,alternative="two.sided",var.equal=F)$p.value, 
                error=function(e){print(e);print(c(length(grp1),length(grp2)));1}   # t.test doesnt work => say p is one
     )
   c(p=pval,n.1=n1,n.2=n2)
})
#names(tp1cor.pval)[3] <- 'p'

## add roi-roi distance
tp1cor.pval <- ddply(tp1cor.pval, .(roi1, roi2),.progress = "text", function(x) {
  x$d <- dist( rbind(
        roi.labels[roi.labels$n==x$roi1,c('x','y','z')],
        roi.labels[roi.labels$n==x$roi2,c('x','y','z')]
      ))
  x
})
tp1cor.pval$dgrp <- cut(tp1cor.pval$d,breaks=c(-Inf,20,40,70,100,Inf))

## adjust pvalues for multiple comparisons
tp1cor.pval <- ddply(tp1cor.pval, .(dgrp),.progress = "text", function(x) {
  x$adj.grp <- p.adjust(x$p,n=nrow(x),method="fdr")
  x
})
# and adj if all were used
tp1cor.pval$adj.all <- p.adjust(tp1cor.pval$p,n=nrow(tp1cor.pval),method="fdr")

# show the top pvals
print(head(tp1cor.pval[sort(tp1cor.pval$adj.grp,index.return=T)$ix,],n=10))
print(head(tp1cor.pval[sort(tp1cor.pval$adj.all,index.return=T)$ix,]))

# write to a file
write.csv(tp1cor.pval,file='txt/tp1cor_pvals.csv')
### This is a bust!! .. nothing < .01




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
