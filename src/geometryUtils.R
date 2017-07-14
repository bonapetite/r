# Returns the euclidean distance for one or more pairs of points
# 
# Args:
#   x1: Vector of x coordinate of first point
#   x1: Vector of y coordinate of first point
#   x2: Vector of x coordinate of second point
#   y2: Vector of y coordinate of second point
distance <- function(x1, y1, x2, y2) {
  return (sqrt((x1-x2)^2 + (y1-y2)^2))
}

examples <- function() {
  distance(1, 1, 2, 2)
  distance(c(1,2), c(1,1), c(2,2), c(2, 3))
  distance(c(NA,2), c(1,1), c(2,2), c(2, 3))
}