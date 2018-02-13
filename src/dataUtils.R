
getPrevValuesByGroup <- function(data, group) {
  # Get a vector that contains the value of the previous row of the same group
  # Args:
  #   data: Vector of values
  #   group: Group of the values
  require(data.table)
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

interpolate <- function(x, max.gap=NULL) {
  # Interpolate missing values. Leave as NA if gap between data is larger than max.gap
  # Args:
  #   x: Vector of values
  #   max.gap: Leave as NA if gap between data is larger than max.gap
  # Returns the array of value with missing values populated if applicable
  require(zoo)
  if (!is.null(max.gap)) {
    return (na.approx(x, maxgap=max.gap)) 
  } else {
    return (na.approx(x))
  }
}

range.filter <- function(x, x.min, x.max, padding=0) {
  # Return a vector containing the logical of whether each row is within the specified range c(x.min, x.max). 
  # If padding is specified, the range to check will be c(x.min-padding, x.max+padding)
  # Args:
  #   x: Vector of values
  #   x.min: Minimum value of the range
  #   x.max: Maximum value of the range
  #   padding: Padding to add to the range.  Default is 0.
  return (!is.na(x) & !is.null(x) & (x >= x.min-padding) & (x <= x.max+padding))
}

changeTimeZone <- function(time, original.timezone, target.timezone) {
  # Change the timezone of the provided time.  The provided time should be in string format that can be parsed by as.POSIXct()
  # Args:
  #   time: Time in string format
  #   original.timezone: Timezone of the provided time
  #   target.timezone: Target timezone
  # Returns the value in the target time zone
  return (as.POSIXct(format(as.POSIXct(time, tz=original.timezone), tz=target.timezone, usetz = T), tz=target.timezone))
}

percent.string <- function(count, total) {
  # Generate a string showing the current count, total and percentage rounded to 2d.p.
  # e.g. percent.string(1, 10) -> '1/10 (10%)'
  #      percent.string(1, 1000) -> '1/1000 (0.01%)'
  # Args:
  #   count: Current count
  #   total: Total 
  # Returns the generated string
  return (paste(count, '/', total, ' (', round(count/total*100, 2), '%)', sep=''))
}

showProgress <- function(total, current, n, progress.message='Processed %?%') {
  require(stringr)
  # Display a progress message for every nth item processed
  # Args:
  #   total: Total number of items
  #   current: Current item index
  #   n: Show message for every nth item processed
  #   progress.message: Message to display.  The message should include the expression %?% which will be 
  #   replaced by the number of items processed.  Default message is 'Processed %?%.'
  if (current%%n == 0) {
    print(str_replace(text, '%?%', percent.string(current, total)))
  }
}

scaleToRange <- function(values, min, max) {
  # Scale the values to the specified range 
  # Args:
  #   values: Vector of values
  #   min: Minimum of the targeted range
  #   max: Maximum of the targeted range
  # Returns a vector of the scaled value
  values.range = range(values, na.rm = T)
  if (diff(values.range) == 0) {
    stop(paste('Cannot scale if value is constant at ', min(values, na.rm = T), sep=''))
  }
  sf = (max-min)/(diff(values.range))
  return ((values-values.range[1])*sf+min)
}

group.by.count.as.percent.string <- function(values, all.values=NULL) {
  if (length(values) == 0) {
    return ('')
  }
  # Generate a string showing the frequency of values as a percentage rounded to 2d.p.
  # Examples are given in example()
  # Args:
  #   values: Vector of values
  #   all.values: Percent string should show percent of these values.  Default to NULL.  
  # Returns the generated string
  dd = data.frame(table(values))
  dd$values = as.character(dd$values)
  if (is.null(all.values)) {
    all.values = unique(dd$values)
    all.values = all.values[order(all.values)]
  }
  all.values = as.character(all.values)
  merged = merge(dd, data.frame(values=all.values), by='values', all.y=T)
  if (sum(is.na(merged$Freq)) > 0) {
    merged[is.na(merged$Freq), ]$Freq = 0
  }
  merged$percent = round(merged$Freq/sum(merged$Freq)*100, 2)
  percent.string = ""
  for (a in all.values) {
    percent.string = paste(percent.string, paste(merged[merged$values == a, ]$percent, "% ", a, ',', sep=''), sep='')
  }
  percent.string = substr(percent.string, 1, nchar(percent.string) - 1)
  return (percent.string)
}

examples <- function() {
  
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
  
  interpolate(c(1, 2, NA, NA, 5, 6))
  # 1 2 3 4 5 6
  interpolate(c(1, 2, NA, NA, 5, 6), max.gap=1)
  # 1 2 NA NA 5 6
  
  person.data[range.filter(person.data$value, 30, 40), ]
  # name value
  # john    30
  # john    40
  
  person.data[range.filter(person.data$value, 30, 40, padding=10), ]
  # name value
  # amy    20
  # john    30
  # john    40
  # amy    50
  
  scaleToRange(person.data$value, 100, 600)
  # 100 200 300 400 500 600
  scaleToRange(c(NA_real_, NA_real_, 1, 2, 3, 4, 5, 6), 100, 600)
  # NA  NA 100 200 300 400 500 600
  
  percent.string(1, 100)
  # "1/100 (1%)"
  percent.string(1, 1000)
  # "1/1000 (0.1
  
  showProgress(1, 100)
  # "Processed 1/100 (1%)"
  showProgress(1, 1000)
  #"Processed 1/1000 (0.1%)"
  
  group.by.count.as.percent.string(values = c('A', 'A', 'B'))
  # "66.67% A,33.33% B"
  group.by.count.as.percent.string(values = c('A', 'A', 'B'), all.values = c('A', 'B', 'C'))
  # "66.67% A,33.33% B,0% C"
}

