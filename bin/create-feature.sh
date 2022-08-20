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

mkdir -p "$featureFolder"