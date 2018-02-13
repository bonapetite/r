read.all.csv <- function(files.dir, time.field=NULL, pattern=".*\\.csv$", verbose=F) {
  # Import data from all the matching csv files into a directory and stores in a single dataframe.
  # There is also the option to convert a time field for time series data.
  # All the csv files must have the same columns
  #
  # Args:
  #   files.dir: Directory of csv files
  #   time.field: Field to convert to a POSTXct field, the new time column will be called 'time'.  This is optional
  #   pattern: Only import csv that matches this file name pattern.  Default to all csv files
  #   verbose: Verbose logging if true.  Default to false
  all.files = list.files(path=files.dir, pattern=pattern)
  if (verbose) {
    print(paste('Found', length(all.files), 'matching files.'))
  }
  df = data.frame()
  for (f in all.files) {
    df1 = read.csv(file.path(files.dir, f))
    if (!is.null(time.field)) {
      df1$time = as.POSIXct(df1[, c(time.field)], origin='1970-01-01')
    }
    if (verbose) {
      s = paste(f, ':', nrow(df1), 'records.')
      if (!is.null(time.field)) {
        s = paste(s, min(df1$time, na.rm = T), '-', max(df1$time, na.rm = T))
      }
      print(s)

    }
    df = rbind(df, df1)
  }
  return(df)
}
