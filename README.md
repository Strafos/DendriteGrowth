"# DendriteGrowth" 

## To use
There are two separate programs analyze data.
`GUI.m` is an interface that allows the user to manually tag dendrites and outputs a data set of those tags

`dendrite.m` takes a video input and selects 10 equally spaced frames. Then it applies several filters on the image and MATLAB's edge detection modules to locate and graph the edges and output the data.
`dendrite.m` will require tuning to fit different data videos. To do so, use `vidToImg.m` to turn selected video into image frames. Then use `sobelEdgeTuner.m` to change variables on an individual frame until you are satisfied with the resulting edge. Then, enter these variables into `sobelEdgeFinder.m` which is called by the main function, `dendrite.m`

## Results
Dendrite detection on a specific frame:
![Dendrite detection on one frame](http://www.imgur.com/a/bM4D9.png)

Dendrite growth over time:
![Dendrite growth over time](http://imgur.com/a/GomNt.png)
