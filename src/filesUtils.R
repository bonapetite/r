read.all.csv <- function(files.dir, pattern=".*\\.csv$") {
  all.files = list.files(path=files.dir, pattern=pattern)
  df = data.frame()
  for (f in all.files) {
    df = rbind(df, read.csv(file.path(files.dir, f)))
  }
  return(df)
}