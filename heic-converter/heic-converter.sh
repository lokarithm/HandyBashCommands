#!/bin/bash
if ! command -v heif-convert &> /dev/null
then
    echo "heif-convert COMMAND could not be found."
    echo "Please install 'libheif-examples' first."
    echo "To install 'libheif-examples', run the following command:"
    echo "  sudo apt install libheif-examples"
    exit
else
    fileExtension="jpg"

    while getopts :p flag; do
        case ${flag} in
            # -p flag: convert heic files to png format instead
            p) fileExtension="png"
            ;;
        esac
    done

    start_time=$(date +%s.%3N)

    # look for files in current path that contains ".heic" in a case-insensitive manner
    for file in $( ls | grep -iF ".heic")
    do
        echo "Converting file: $file"

        # file extension of current file
        currFileExtension=`echo $file | grep -iFo "heic"`
        sedCommand="s/${currFileExtension}/${fileExtension}/g;s/HEIC/${fileExtension}/g"

        #replace original file name by changing the extension from heic to jpg
        outputFileName=`echo $file | sed -e $sedCommand`
        heif-convert $file $outputFileName
    done

    end_time=$(date +%s.%3N)

    elapsed=$(echo "scale=3; $end_time - $start_time" | bc)
    echo -e "\nElapsed time: \e[32m$elapsed \e[39mmilliseconds."

fi
