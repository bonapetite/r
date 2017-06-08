Collection of useful R codes
========

This repository contains some handy R codes I have written.  These are organised into individual R scripts based on functionalities:

- **plotUtils.R** Functions related to plotting graphs that use the built-in graphics package for plotting.  For example, a single function call for plotting a path:

<img src="https://user-images.githubusercontent.com/13400791/26926538-7d726d5e-4c91-11e7-8173-d2fddc3d081b.png" width="600px"/>

- **dataUtils.R** For manipulating data stored in data frames or data tables (e.g. For each event in the sorted dataset, retrieve the previous time value in the same group to work out the time difference since the last event)

All the R scripts in this repository follow the [Google R styling guide](http://google.github.io/styleguide/Rguide.xml).

### How to Use
- Checkout this project or click on the src folder link on this page and download the required R script file(s)
- Use **source()** function to load the script required R script file, e.g.
```
source('/path/to/script/dir/plotUtils.R')
```

### License
This project is licensed under the terms of the Apache license 2.0
