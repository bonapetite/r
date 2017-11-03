plotGrid <- function(nrow, ncol) {
  # Calling graphics::par function to display plots in a grid format
  # Args:
  #   nrow: Number of rows in grid
  #   ncol: Number of columns in grid
  par(mfrow = c(nrow, ncol))
}

rangePadded <- function(data, padding.fixed=NULL, padding.ratio = 0.1) {
  # Returns a range extended by the specified padding 
  # Args:
  #   data: Vector of values
  #   padding.fixed: Amount of padding expressed as a fixed value
  #   padding.ratio: Amount of padding expressed as a ratio, ignore if padding.fixed is not null
  data = data[!is.na(data)]
  if (is.null(padding.fixed)) {
    padding.fixed = (max(data) - min(data)) * padding.ratio
  }
  return (range(data) + c(-1 * padding.fixed, padding.fixed))
}

plotPath <- function(x, y, size = 1, col = 'gray', pch = 1, main = '', new.plot = T, xlim = NULL, ylim = NULL, arrows=T, lwd=1) {
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
  #   ylim: Y range of plot.  Default is NULL, ignore if newPlot is FALSE.
  #   arrows: Show arrows in path to indicate direction.  Default is TRUE
  #   lwd: Line width.  Default is 1.
  isNA <- !is.na(x) & !is.na(y)
  x <- x[isNA]
  y <- y[isNA]
  if (is.null(xlim)) {
    xlim = rangePadded(x)
  }
  if (is.null(ylim)) {
    ylim = rangePadded(y)
  }
  if (new.plot) {
    plot(c(), c(), xlab='x', ylab = 'y', xlim = xlim, ylim = ylim, main = main)
  }
  points(x, y, col = col, pch = pch, cex = size)
  lines(x, y, col = col, lwd=lwd)
  if (arrows) {
    x0 <- c(NA, x[1:length(x)-1])
    y0 <- c(NA, y[1:length(y)-1])
    arrows(x0, y0, x, y, col = col, cex = size, code = 2, length = size/10, lwd=lwd)
  }
}

bubbleSize <- function(x, min.size, max.size, max.size.x = NULL) {
  # Return a value scaled based on the value range.  This is useful to plot bubbles where the size
  # of a bubble depends on the value of the point
  # Args:
  #   x: a vector of values
  #   min.size: minimum size.  Should be greater than 0
  #   max.size: Size of points.  Default is 1.
  #   max.size.x: This value allows to set your own range for scaling.  
  #   Instead of scaling x by the range c(min(x), max(x)), use the range c(min(x), max.size.x). 
  #   Hence, for all the points with value > max.size.x, the size will be max.size. 
  x.range = range(x)
  size.range = range(min.size, max.size)
  if (!is.null(max.size.x)) {
    x.range[2] = max.size.x
  }
  size = ((x - x.range[1])/(diff(x.range)))*diff(size.range) + size.range[1]
  size[size > max.size] = max.size
  return (size)
}

plotArrow <- function(origin.x, origin.y, angle, unit='radian', angle.north=0, arrow.length=1, colour='black', lwd=1) {
  # Plot arrows given angles of the arrow vectors.
  # Args:
  #   origin.x: A vector containing x coordinates of arrow origins
  #   origin.y: A vector containing y coordinates of arrow origins
  #   angle: Angles of arrow vectors
  #   unit: Angle unit, can be 'degree' or 'radian'.  Default is 'radian'
  #   angle.north: Angle for north direction.  Default is 0
  #   arrow.length: Length of arrow.  Default is 1 
  #   colour: Colour of arrow.  Default is 'black' 
  #   lwd: Line width of arrow.  Default is 1
  angle = angle - angle.north + 6.28/4
  if (unit == 'degree') {
    angle = angle*180/3.14
  } else if (unit != 'radian') {
    stop('Only support degree and radian.')
  }
  arrows(x=origin.x, y=origin.y, x1=origin.x+arrow.length*cos(angle), y1=origin.y+arrow.length*sin(angle), length=0.1, col=colour, lwd=lwd)
}

plotLightPath <- function(x, y, col = 'gray', main = '', new.plot = T, xlim = NULL, ylim = NULL) {
  # Visualise the input 2D points using the built-in graphics::plot function, connect the points with a translucent path
  # Args:
  #   x: a vector containing X coordinate of points
  #   y: a vector containing Y coordinate of points
  #   col: Colour of points. Default is 'gray'.
  #   main: Title of plot. Default is ''.
  #   new.plot: Create a new plot of TRUE.  Default is TRUE.
  #   xlim: X range of plot.  Default is NULL, ignore if newPlot is FALSE.
  #   ylim: Y range of plot.  Default is NULL, ignore if newPlot is FALSE.
  plotPath(x, y, col=col, size=0, main = main, new.plot=new.plot, xlim=xlim, ylim=ylim, arrows=F, lwd=0.3)
}

colourGradient <- function(values, colours=c("red","yellow","green"), minV=NULL, maxV=NULL, colours.num=100, use.quartiles=F) {
  # Return the colours representing the given values using the specified colour palette
  # Args:
  #   values: Vector of values
  #   colours: Vector containing Y coordinate of points
  #   minV: Minimum value in the scale
  #   maxV: Maximum value in the scale
  #   colours.num: Number of unique colours in the final palette
  #   use.quartiles: Use quartiles as extremes of scale
  if (use.quartiles) {
    my.stats = summary(values)
    this.min = my.stats[[2]] # 1st Qu.
    this.max = my.stats[[5]] # 3rd Qu.
  } else {
    this.min = min(values, na.rm=T)
    this.max = max(values, na.rm=T)
  }
  if (!is.null(minV)) {
    if (this.min < minV) {
      this.min = minV
    }
  }
  if (!is.null(maxV)) {
    if (this.max > maxV){
      this.max = maxV
    }
  }
  print(this.min)
  print(this.max)
  return(colorRampPalette(colours) (colours.num) [ findInterval(values, seq(this.min,this.max, length.out=colours.num)) ] )
}

library(ggplot2)
library(Rmisc)

histPlotCategoricalMultilclass <- function(df, var.column, class.column) {
  return (ggplot(df, aes_string(x=var.column, group=class.column)) + geom_bar(aes(y=..prop.., fill=(..x..)), stat='count') + 
    facet_grid(as.formula(paste('~',class.column))) + scale_y_continuous(labels = scales::percent))
}

plotDensityMutlivariate <- function(df, columns, class.column) {
  this.plots = list()
  col.n = 5
  row.n = round(length(columns) / col.n)
  left.col.first.i = (col.n-1)*row.n + 1
  i = 1
  for (c in columns) {
      print(c)
    if (sapply(df, is.factor)[c]) {
      # Percentage bar
      this.plots[[i]] = histPlotCategoricalMultilclass(df, c, class.column) + theme(legend.position="none")
    } else {
      this.plots[[i]] = ggplot(df, aes_string(x=c, fill=class.column)) + geom_density(alpha=1/3)
      # if (i < left.col.first.i) {
      #   this.plots[[i]] = this.plots[[i]] + theme(legend.position="none")
      # }
    }
    i = i + 1
  }
  multiplot(plotlist = this.plots, cols=col.n)
}

examples <- function() {
    p <- data.frame(x = c(1,2,3), y = c(1,2,1), direction=c(0, 3.14, 4.71), value=c(1, 5, 1000))

    # plotPath & rangePadded example
    plotPath(p$x, p$y, size = 3, main = "Some path", xlim = rangePadded(p$x), ylim = rangePadded(p$y, 1))
    
    #plotLightPath example
    plotLightPath(p$x + 0.2, p$y, new.plot=F)
    
    #bubbleSize example
    plot(p$x, p$y, xlim=c(0, 4), ylim=c(0, 3), cex=bubbleSize(p$value, min.size = 1, max.size = 4, max.size.x = 10))
    text(p$x, p$y+0.2, p$value)
    
    # plotGrid example
    plotGrid(1,2)
    plotPath(p$x, p$y, size = 3, main = "Some path")
    plotPath(p$x, p$y, size = 3, main = "Some path again in red", col = 'red')
    
    #plotArrow example
    plot(c(), c(), xlim=c(0, 4), ylim=c(0, 3))
    plotArrow(p$x, p$y, p$direction, arrow.length = 0.2)    
    
    plot(c(), c(), xlim=c(0, 40), ylim=c(-5, 30))
    plotArrow(p$x, p$y, p$direction, arrow.length = 5)
    
    #colourGradient
    values = c(1, 1, 2, 3, 5, 7, 100)
    plot(p$x, p$y, col=colourGradient(values), xlim = rangePadded(p$x), ylim = rangePadded(p$y), cex=5)
    plot(p$x, p$y, col=colourGradient(values, use.quartiles = T), xlim = rangePadded(p$x), ylim = rangePadded(p$y), cex=5)
    
}