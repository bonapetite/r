plotPath <- function(x, y, size = 1, col = 'gray', pch = 1, main = '', new.plot = T, xlim = NULL, ylim = NULL) {
  # Visualise the input 2D points using the built-in graphics::plot function, connect the points using arrows
  # Args:
  #   x: a vector containing X coordinate of points
  #   y: a vector containing Y coordinate of points
  #   size: Size of points.  Default is 1.
  #   col: Colour of points. Default is 'gray'.
  #   pch: pch of points. Default is 1.
  #   main: Title of plot. Default is ''.
  #   new.plot: Create a new plot of TRUE.  Default is TRUE.
  #   xlim: X range of plot.  Default is NULL, ignore if newPlot is FALSE.
  #   ylim: Y range of plot.  Default is NULL, ignore if newPlot is FALES.
  isNA <- !is.na(x) & !is.na(y)
  x <- x[isNA]
  y <- y[isNA]
  if (new.plot) {
    plot(x, y, col = col, xlim = xlim, ylim = ylim, cex = size, pch = pch, main = main)
  } else {
    points(x, y, col = col, pch = pch, cex = size)
  }
  lines(x, y, col = col)
  x0 <- c(NA, x[1:length(x)-1])
  y0 <- c(NA, y[1:length(y)-1])
  arrows(x0, y0, x, y, col = col, cex = size, code = 2, length = size/10)
}

plotGrid <- function(nrow, ncol) {
  # Calling graphics::par function to display plots in a grid format
  # Args:
  #   nrow: Number of rows in grid
  #   ncol: Number of columns in grid
  par(mfrow = c(nrow, ncol))
}

rangePadded <- function(data, padding.ratio = 0.1) {
  # Returns a range extended by the specified padding ratio (i.e. padding = (max(data) - min(data)) * padding.ratio)
  # Args:
  #   data: Vector of values
  #   padding.ratio: Amount of padding expressed as a ratio
  padding = (max(data) - min(data)) * padding.ratio
  return (range(data) + c(-1 * padding, padding))
}

examples <- function() {
    p <- data.frame(x = c(1,2,3), y = c(1,2,1))

    # plotPath & rangePadded example
    plotPath(p$x, p$y, size = 3, main = "Some path", xlim = rangePadded(p$x), ylim = rangePadded(p$y))
    
    # plotGrid example
    plotGrid(1,2)
    plotPath(p$x, p$y, size = 3, main = "Some path")
    plotPath(p$x, p$y, size = 3, main = "Some path again in red", col = 'red')
}