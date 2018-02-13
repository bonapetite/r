library(testthat)
source('src/dataUtils.R')
test_results = test_dir("test", reporter="summary")
print(test_results)
