library(plyr)
library(reshape)

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

subjinfo <- read.table('../restPreproc/txt/SubjectTimeAgeSexFD.txt', header=T)
goodtp1  <- subset(subjinfo,tpoint=='t1'&as.numeric(as.character(remaingvols))>100)
tp1cor   <- ddply(goodtp1,.(sid),function(x){
       sid  <- as.character(x$sid)
       print(sid)
       try({
           f   <- sprintf('../RewardRestSubjs/%s/afni_restproc/power_nogsr/%s_roistats.txt',sid,sid)
           # read in as a matrix, discard file name and subbrick number
           raw <- as.matrix(read.table(f,comment.char="",header=T)[,c(-1,-2)])
           m   <- cor(raw,use='na.or.complete')
           m[lower.tri(m,diag=T)] <- NA

           # ugly melt
           #df <- as.data.frame( cbind(which(!is.na(m),arr.ind = TRUE),na.omit(as.vector(m))) )

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
### 

#now we need a sliding window

