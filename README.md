# Static Map
MoveApps

Github repository: *github.com/movestore/simple-map*

## Description
Simple shiny map with points and lines in the ID colours. Background are coastlines only. 

## Documentation
This App gives a simple coastline map with movement tracks. For each animal the locations are added as points that are connected with straight lines. Data of each animal are marked by different colours.

### Input data
moveStack in Movebank format

### Output data
moveStack in Movebank format
Shiny user interface (UI)

### Artefacts
none

### Settings 
`Choose edge size`: The amount of longitude and latitude units that shall be added at the edges of the data's bounding box for better visibility. Default 0.

### Null or error handling:
**Setting `Choose edge size`:** The default value is `0`, which leads to no extra margin of the map around the locations' bounding box.

**Data:** The data are not manipulated, but empty input with no locations (NULL) leads to an error. For calculations in further Apps the input data set is returned.
