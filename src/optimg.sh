#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGS="$@"


###############
#  Functions  #
###############

# Displays the usage
usage() {
	cat <<- EOF
	usage: $PROGNAME <path> <max_width> <quality OPTIONAL>
 
	OPTIONS:
	    path        : path to optimize.
	    max_width   : maximal width for you images.
	    quality     : [optional] allows to to specify the ouput quality of your images. Example: 90 means a quality of 90%, so a loss of 10% 
 
	Example:
		Optimize the directory my_image_folder and resize images bigger than 500px:
		$PROGNAME /my_image_folder  500

		Optimize the directory my_image_folder and resize images bigger than 500px and keep a quality of 60%
		$PROGNAME /my_image_folder  500 60

	EOF
}

# 
check_dependecies() {
  command -v mogrify >/dev/null 2>&1 || { echo >&2 "\033[0;31mERROR\033[0m: ImageMagick is required but it seems that is not installed or not present in your PATH. Visit: https://imagemagick.org."; exit 1; }
}



if [ -z "$1" ] || [ -z "$2" ]  ; then
	echo "\033[0;31mERROR\033[0m: Missing parameter(s): path or max width.";
	usage
	exit;
fi


check_dependecies



# Variables
DIR=$1
export RESIZE_MAX_WIDTH=$2
# Quality : third parameter or 90 as default value
export RESIZE_QUALITY="${3:-90}";
export RESISZE_GAIN_TOTAL=0;


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export STAT_ARGS="--format %s";
  export SHELL_TO_USE=bash
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  export STAT_ARGS="-f %z";
  export SHELL_TO_USE=sh
fi

read -r -p "Optimize [$1] (max image width: $2px)? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then

    echo "      ";
    # Optimize
    find $DIR -type f \( -iname "*.jpg" -or -iname "*.jpeg" -or -iname "*.png" \) -exec $SHELL_TO_USE -c '
      for image do 

      FILESIZE=$(stat $STAT_ARGS "$image");
      echo "OPTIMIZE ["${image}"]: $FILESIZE bytes.";
      mogrify -strip -resize $RESIZE_MAX_WIDTH\> -density 72 -quality $RESIZE_QUALITY -type optimize "${image}";
      OPTFILESIZE=$(stat $STAT_ARGS "$image");
      GAIN=$(($FILESIZE-$OPTFILESIZE));

      export RESISZE_GAIN_TOTAL=$(($RESISZE_GAIN_TOTAL+$GAIN));
      printf "\t\t\tdone. New size: $OPTFILESIZE  bytes.  \e[1m\e[32m$GAIN\e[39m bytes saved \e[0m\n";
      done

      b=$RESISZE_GAIN_TOTAL; d=''; s=0; S=(Bytes {K,M,G,T,P,E,Y,Z}iB);
      while ((b > 1024)); do
        d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
        b=$((b / 1024))
        let s++
      done

      printf "\e[1mTOTAL SAVED: \e[32m $b$d ${S[$s]} \e[0m\n"
      

    ' $SHELL_TO_USE {} +  



else
  echo "Abort."
fi

exit;



