require(data.table)

getPrevValuesByGroup <- function(data, group) {
  temp <- data.table(data = data, group = group)
  temp[, data_prev := c(temp[head(.I, 1)]$data, temp[head(.I,.N-1),]$data), by = "group"]
  temp[!duplicated(temp$group), ]$data_prev = NA
  return(temp$data_prev)
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
}