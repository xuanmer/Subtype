library(ggplot2)
library(ggplot2)
library(pheatmap)

# data
selected_diag = "SCD"
data_source = "xuanwu"

path = paste0("~/", data_source, 
              "_subnetwork_Corrected_PAD.csv")
data = read.csv(path)

selected_data <- data[data$diagnosis == selected_diag,]

if(data_source=="adni")
{
  selected_data <- selected_data[, grep("^(subnetwork[1-9]_Corrected_PAD)", 
                                        colnames(selected_data))]
}else{
  selected_data <- selected_data[, grep("^(network[1-9]_Corrected_PAD)", 
                                        colnames(selected_data))]
}

selected_data <- na.omit(selected_data)

# euclidean
dist_matrix <- dist(selected_data, method = "euclidean")
# dist_matrix <- dist(selected_data, method = "binary")
dist_matrix <- as.matrix(dist_matrix)
k <- 2

# K-means clustering
kmeans_result <- kmeans(selected_data, centers = k)
print(kmeans_result)

clusters <- kmeans_result$cluster

ordered_indices <- order(clusters)
ordered_dist_matrix <- dist_matrix[ordered_indices, ordered_indices]
ordered_clusters <- clusters[ordered_indices]

final_order <- integer(0)

for (i in unique(ordered_clusters)) {
  cluster_indices <- which(ordered_clusters == i)
  cluster_dist_matrix <- ordered_dist_matrix[cluster_indices, cluster_indices]
  total_distance <- apply(cluster_dist_matrix, 1, sum)
  cluster_order <- order(total_distance)

  final_order <- c(final_order, cluster_indices[cluster_order])
}

# distance matrix
final_dist_matrix <- ordered_dist_matrix[final_order, final_order]

pheatmap(final_dist_matrix, 
         cluster_rows = FALSE, 
         cluster_cols = FALSE, 
         main = "Distance Matrix Heatmap Based on K-means Clustering")
