# source("http://bioconductor.org/biocLite.R")
# biocLite("Rgraphviz")
# library(Rgraphviz)
library(R.matlab)
# save PC table from matlab: has a matrix for each table 
mat <- readMat('mat/PC_tables.mat')

# combine them all
allcmps <- as.data.frame(do.call(rbind,mat))



# name the columns
names(allcmps) <- c("ROI","YoungCommunity","OldCommunity","Degree(young)","Degree(old)","changeDegree","DM","SM","V","CO","FP","DM","SM","V","CO","FP","ΔDM","ΔSM","ΔV","ΔCO","ΔFP")

# id whcih comparison each comes from
allcmps$grpcmp <- do.call(c,sapply(names(mat),function(n){rep(substr(n,5,6),dim(mat[[n]])[1])}))

allcmps$OldCommunity <- factor(allcmps$OldCommunity,label=c('DM','SM','V','CO','FP','O','O','O'),levels=1:8)

#allcmps[allcmps$grpcmp=="EC",grep('^ROI$|^OldCommunity|Δ',names(allcmps))]

print(head(allcmps))

write.table( sep="\t", row.names=F, file="txt/sigPC_graph_long.txt", quote=F,
   allcmps[grep('^ROI$|^OldCommunity|Δ|grpcmp',names(allcmps))]
)



