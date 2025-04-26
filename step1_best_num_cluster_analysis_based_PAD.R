library(NbClust)
setwd("/Users/hyx/Downloads/hyx/Network-based_Brain_Ageing_XUANWU/")

#  NbClust: https://cran.r-project.org/web/packages/NbClust/vignettes/NbClust.pdf
# selected_diag = "NC"
selected_diag = "SCD"

data_source = "XUANWU"

path = paste0("./XUANWU_BA/baseline/", selected_diag, "_ba_pad_b.csv")
data = read.csv(path)
selected_data <- data[data$diagnosis == selected_diag,]

if(data_source=="XUANWU")
{
  selected_data <- selected_data[, grep("^(Net[1-7]_Corrected_PAD)", 
                                        colnames(selected_data))]
}else{
  selected_data <- selected_data[, grep("^(Net[1-7]_Corrected_PAD)", 
                                        colnames(selected_data))]
}

selected_data <- na.omit(selected_data)
selected_data <- scale(selected_data)


# https://stackoverflow.com/questions/46067602/the-tss-matrix-is-indefinite-there-must-be-too-many-missing-values-the-index

indices <- c("kl", "ch", "hartigan", "ccc", "scott", "marriot", "trcovw", 
             "tracew", "friedman", "rubin", "cindex", "db", "silhouette", 
             "duda", "pseudot2", "beale", "ratkowsky", "ball", "ptbiserial", 
             "gap", "frey", "mcclain",  "dunn", "gamma", "gplus", "tau",
             "hubert", "sdindex", "dindex", "sdbw") # "sdbw"
results <- list()
array_best_num_cluster <- array(0, dim = 10)
for (i in 1:length(indices)) {
  print(paste0("Trying ", indices[i], " index..."))
  # results[[i]] <- try(NbClust(data=selected_data, min.nc=2, max.nc=10, 
  #                             index=indices[i], method="kmeans"))
  results[[i]] <- try(NbClust(data=selected_data, min.nc=2, max.nc=10, 
                              index=indices[i], method="centroid", distance="binary"))
  best_num <- try(results[[i]]$Best.nc[1])
  if(is.numeric(best_num)){
    if (best_num > 0){
    array_best_num_cluster[best_num]  = array_best_num_cluster[best_num]+1
  }}
}
print(paste("Source: ", data_source, ", Diagnosis: ", selected_diag))
print(paste("Total", as.character(sum(array_best_num_cluster))))
print(paste("Support Best Count", as.character(max(array_best_num_cluster), arr.ind = TRUE)))
print(paste("Best", as.character(which(
  array_best_num_cluster == max(array_best_num_cluster), arr.ind = TRUE))))
print(array_best_num_cluster)

# res<-NbClust(selected_data, distance = "euclidean", min.nc=2, max.nc=8, 
#              method = "kmeans", index = "all")
# res$Best.nc
# 
# res<-NbClust(selected_data, distance = "euclidean", min.nc=2, max.nc=8,
#              method = "kmeans", index = "alllong")
# res$Best.nc



