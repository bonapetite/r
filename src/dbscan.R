dbscan <- function(points.x, points.y, points.time, location.eps, time.eps, min.pts, noise.cluster=-1, debug=F) {
  
  # Spatial Temporal DBScan clustering implementation.  
  # The neighbour search logic is based on the optimised DB-Scan algorithm provided in [1].
  # This is a variation of the DBScan method that considers temporal distance as well as spatial distance.
  # The spatial distance is scaled by a term based on the temporal distance and time eps prior to the 
  # reachbility check by comparing to location eps.  Refer to the GitHub page for more details.
  #
  # Args:
  #   x: a vector containing X coordinate of points
  #   y: a vector containing Y coordinate of points
  #   points.time: a vector containing the time as integer values (e.g. epoc)
  #   location.eps: eps for location proximity
  #   time.eps: eps for temporal proximity
  #   min.pts: minimum number of points to form a neighbourhood
  #   noise.cluster: assign this cluster number to noises
  #   debug: display debug information if TRUE. Default value is FALSE
  #
  # [1] Kryszkiewicz M., Skonieczny Ł. (2005) Faster Clustering with DBSCAN. In: Kłopotek M.A., Wierzchoń S.T., Trojanowski K. (eds) 
  # Intelligent Information Processing and Web Mining. Advances in Soft Computing, vol 31. Springer, Berlin, Heidelber
  
  points = data.frame(x=points.x, y=points.y, time=points.time)
  N = nrow(points)
  points$id = seq(1, N)
  points$cluster = 0
  cluster = 1
 
  if (debug) {
    print(paste('Processing', N, 'points', sep=' '))
  }
  for (n in 1:N) {
    p = points[n, ]
    if (p$cluster != 0) {
      next
    }
    neighbour = neighbourhood(points, p, location.eps, time.eps, min.pts)
    if (length(which(neighbour)) < min.pts) {
      points[n, ]$cluster = -1;
    } else {
      points[neighbour, ]$cluster = cluster
      neighbour[n] = FALSE
      while (length(which(neighbour) > 0)) {
        ppi = which(neighbour)[1]
        pp = points[ppi, ]
        pp.neighbours = neighbourhood(points, pp, location.eps, time.eps, min.pts)
        if (length(pp.neighbours) >= min.pts) {
          neighbour[pp.neighbours & points$cluster == 0] = TRUE
          points$cluster[pp.neighbours & (points$cluster == 0 | points$cluster == -1)] = cluster
        }
        neighbour[ppi] = FALSE
      }
      cluster = cluster + 1
    }
  }
  
  # Print results
  in.cluster = points$cluster != -1
  if (debug) {
    if (length(which(in.cluster)) == 0) {
      print("No clusters found")
    } else {
      cluster.percent = round(length(which(in.cluster))/nrow(points)*100, 2)
      print(paste('Clustering results (', cluster.percent, '%):', sep=''))
      print(table(points[in.cluster, ]$cluster))
    }
  }
  points$clusters[!in.cluster] = noise.cluster
  return (points$cluster)
}

neighbourhood <- function(points, p, location.eps, time.eps, min.pts) {
   scale = exp(abs(points$time - p$time)/time.eps)
   points$dist = sqrt((p$x - points$x)^2 + (p$y - points$y)^2) * scale
   return (points$dist <= location.eps)
 }