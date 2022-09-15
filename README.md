# Optimg
*require ImageMagick*

Compress and optimize your image files.
This script can optimize entire directories and use ImageMagick to reduce the size and optimize file. 


## Installation 
The only thing to install is ImageMagick


## Parameters
- path:  directory or file to optimize
- max_width:  define the maximum size of the images
- quality: between 0 and 100, definies the quality to keep. Exampel: 85 means 15% of loss.


## Examples
Optimize /path, image max size 1000 pixels and quality 85.
```bash
optimg.sh /path 1000 85
```

## TODO
-[] : Detect ImageMagick and abort it not found
-[] : Increase parameter
-[] : 