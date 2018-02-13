Collection of useful R codes
========

This repository contains some handy R codes I have written.  These are organised into individual R scripts based on functionalities:

- **plotUtils.R** Functions related to plotting graphs (Using native *graphics* package for plotting).

### Examples
Plotting a 2D path
![Plot path](assets/plotPath.png?raw=true)

Plotting a 2D path with arrows to indicate headings
![Plot path with headings](assets/plotPathWithHeadings.png?raw=true)

Plot bubbles with size scaled according to provided values
![Plot bubbles](assets/plotBubbles.png?raw=true)


- **fileUtils.R** Relating to File IO

- **dataUtils.R** For transforming and displaying data
### Examples
```
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
  
  lagPadded(person.data$value, 2)
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
  ```

### Style
All the R scripts in this repository follow the [Google R styling guide](http://google.github.io/styleguide/Rguide.xml).

### How to Use
- Clone this project
- This project includes a R project file.  In R Studio, choose 'Open Project' and select this folder
- In Console, use **source()** function to load utils you want to use:
```
source('./src/plotUtils.R')
```

### License
This project is licensed under the terms of the Apache license 2.0
