#!/usr/bin/env bash
tulparDir=$1
projectDir=$2
libFolder=$3
featureName=$4

featureName=$(echo $featureName | sed 's/[[:upper:]]/_&/g;s/^_//' | tr '[:upper:]' '[:lower:]')
featureFolder="$libFolder/features/$featureName"

echo "Creating feature $featureName"

if test -d "$featureFolder"; then
    echo "Feature already created..."
    echo "$featureFolder"
    exit;
fi

echo "Creating feature folder... $featureFolder"



mkdir -p "$featureFolder"

while read folderName; do
    if test -d "$featureFolder/$folderName"
    then
        echo "$featureFolder/$folderName exists."
    else
        mkdir -p "$featureFolder/$folderName"
    fi
done < "$tulparDir/core/feature_folder_structer.txt"
