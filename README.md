Collection of useful R codes
========

This repository contains some handy R codes I have written.  These are organised into individual R scripts based on functionalities:

- **plotUtils.R** Functions related to plotting graphs that use the built-in graphics package for plotting.  
Plotting a 2D path
<img src="https://user-images.githubusercontent.com/13400791/28256450-fd981870-6b05-11e7-96f7-79c581fd2e4f.png" width="600px"/>

Plotting a 2D path with arrows to indicate headings
<img src="https://user-images.githubusercontent.com/13400791/28256446-f533fa50-6b05-11e7-8bde-8169efaa1614.png" width="600px"/>

Plot bubbles with size scaled to provided values
<img src="https://user-images.githubusercontent.com/13400791/28256508-80268d3a-6b06-11e7-9cc8-16a50dbd8221.png" width="600px"/>


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
