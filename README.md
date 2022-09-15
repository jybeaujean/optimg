# Optimg
*require ImageMagick*

Compress and optimize your image files.
This script can optimize entire directories and use ImageMagick to reduce the size and optimize file. 


## Installation and requirements
The only thing to install is ImageMagick


## Parameters
- path        : path to optimize.
- max_width   : maximal width for you images.
- quality     : [optional] allows to to specify the ouput quality of your images. Example: 90 means a quality of 90%, so a loss of 10% 



## Examples
Optimize the directory my_image_folder and resize images bigger than 1000px:
```bash
optimg.sh /my_image_folder 1000
```

Optimize the directory my_image_folder and resize images bigger than 1000px and keep a quality of 85%
```bash
optimg.sh /my_image_folder 1000 85
```

## TODO
-[X] : Detect ImageMagick and abort it not found
-[] : Add output parameter
-[] : 