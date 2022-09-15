#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGS="$@"


usage() {
	cat <<- EOF
	usage: $PROGNAME <dir> <max_width> <quality OPTIONAL>
 
    Ce script optimise toutes les images contenu dans le répertoire passé en argument 1 le répertoire à optimiser et en second argument la taille maximale autorisée ( largeur )
	Une largeur maximale doit être passée en argument 2. Les images plus grandes que cette taille seront redimensionnée. 

	Ce script requiert ImageMagick
 
	OPTIONS:
	    dir         : nom du répertoire à optimiser
	    max_width   : largeur maximale autorisée pour les images
	    quality     : paramètre optionnel, permet de spécifier la qualité de sortie. Defaut : 90
 
	Exemples:
		Optimiser le répertoire my_image_folder et redimensionner les images qui font plus de 500px de large:
		$PROGNAME /my_image_folder  500

		Optimiser le répertoire my_image_folder et redimensionner les images qui font plus de 500px de large avec une qualité de 60%
		$PROGNAME /my_image_folder  500 60

	EOF
}



if [ -z "$1" ] || [ -z "$2" ]  ; then
	echo "ERREUR : Paramètre manquants";
	usage
	exit;
fi




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

# Linux et Macos diffère
# Linux


# Macos 


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



