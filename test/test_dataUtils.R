# TODO Test other methods

test_that('Test scaleToRange', {
  expect_equal(scaleToRange(person.data$value, 100, 600), c(100, 200, 300, 400, 500, 600))
  expect_equal(scaleToRange(c(NA_real_, NA_real_, 1, 2, 3, 4, 5, 6), 100, 600), c(NA_real_, NA_real_, 100, 200, 300, 400, 500, 600))
  expect_error(scaleToRange(c(NA_real_)))
  expect_error(scaleToRange(c(1)))
  expect_error(scaleToRange(c(1, 1)))
})

test_that('Test percent.string',  {
  expect_equal(percent.string(1, 100), "1/100 (1%)")
  expect_equal(percent.string(1, 1000), "1/1000 (0.1%)")
})

test_that('Test showProgress',  {
  expect_equal(showProgress(1, 100), "Processed 1/100 (1%)")
  expect_equal(showProgress(1, 1000), "Processed 1/1000 (0.1%)")
})

test_that('Test group.by.count.as.percent.string',  {
  expect_equal(group.by.count.as.percent.string(values = c('A', 'A', 'B')), "66.67% A,33.33% B")
  expect_equal(group.by.count.as.percent.string(values = c('A', 'A', 'B'), all.values = c('A', 'B', 'C')), "66.67% A,33.33% B,0% C")
  expect_equal(group.by.count.as.percent.string(values = c('A', 'A', 'B', 'D'), all.values = c('A', 'B', 'C')), "66.67% A,33.33% B,0% C")
})