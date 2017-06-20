require(data.table)

getPrevValuesByGroup <- function(data, group) {
  # Get a vector that contains the value of the previous row of the same group
  # Args:
  #   data: Vector of values
  #   group: Group of the values
  temp <- data.table(data = data, group = group)
  temp[, data_prev := c(temp[head(.I, 1)]$data, temp[head(.I,.N-1),]$data), by = "group"]
  temp[!duplicated(temp$group), ]$data_prev = NA
  return(temp$data_prev)
}

# Return a vector with values shifted (lagged) by k position.  
# The resultant vector will be of the same length as data.  Values from position 1 to k will be set to NA.
# Args:
#   data: Vector of values
#   k: Number of positions to shift
lagPadded <- function(data, k=1) {
  return (c(rep(NA, k), head(data, length(data)-k)))
}

examples <- function() {
  
  # getPrevValuesByGroup example
  person.data = data.frame(name = c('amy', 'amy', 'john', 'john', 'amy', 'john'), value = c(10,20,30,40,50,60))
  person.data$prev = getPrevValuesByGroup(person.data$value, person.data$name)
  print(person.data)
  #     name  value prev
  # 1    amy    10   NA
  # 2    amy    20   10
  # 3   john    30   NA
  # 4   john    40   30
  # 5    amy    50   20
  # 6   john    60   40
  
  print(lagPadded(person.data$value, 2))
  # NA NA 10 20 30 40
}

