library(dplyr)

gbm.var.importance <- function(gbm.trained, all.vars) {
  vi = varImp(gbm.trained, scale=T)
  variable.importance = data.frame(var=rownames(vi$importance), score=(vi$importance$Overall))
  variable.importance$var.name = sapply(
    as.character(variable.importance$var),
    function(x) {
        if (x %in% all.vars) {
          return(x)
        } else {
          nc = 9
          if (grepl('_calc_', x)) {
            nc = nc + 1
          }
          if (grepl('_bin', x) | grepl('_cat', x)) {
            nc = nc + 4
          }
          return (substr(x, 1, nc))
        }
      }
  )
  vi.transformed = summarise(group_by(variable.importance, var.name), med=median(score), mean=mean(score))
  return(vi.transformed[order(vi.transformed$med, decreasing = T), ])
}