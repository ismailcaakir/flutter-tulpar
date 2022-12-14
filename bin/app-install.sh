#!/usr/bin/env bash
tulparDir=$1
projectDir=$2
libFolder=$3


if test -f "$tulparDir/.installed"; then
    echo "Project already installed..."
    echo "$projectDir"
    exit;
fi

echo "Installing app..."

createStructer() {
    echo "Creating structure..."

    ## rm -rf  "$libFolder/assets"  "$libFolder/components"  "$libFolder/core" "$libFolder/routes"

    rm -rf "$libFolder/main.dart"

    while read folderName; do
        if test -d "$projectDir/$folderName"
        then
            echo "$projectDir/$folderName exists."
        else
            mkdir -p "$projectDir/$folderName"
        fi
    done < "$tulparDir/core/folder_structer.txt"

   
    while read fileData; do
        IFS="|" read -r fileName gistUrl <<< "${fileData}"

        if test -f "$projectDir/$fileName"
        then
            echo "$projectDir/$fileName exists."
        else
            echo "Copying $fileName from gist..."
            mkdir -p "$(dirname "$projectDir/$fileName")"
            touch "$projectDir/$fileName"
            curl -s -L "$gistUrl" > "$projectDir/$fileName"
        fi
        
    done < "$tulparDir/core/file_structer.txt"
   
    echo "Created structure."
}


installPubPackages() {

        if test -f "$libFolder/$fileName"
        then
            echo "$libFolder/$fileName exists."
        else
            mkdir "$libFolder/$folderName"
        fi

    echo "Starting pub packages installation..."

    packagesCommands=""
    while read package; do
        packagesCommands+=$(echo "flutter pub add $package && ")
    done < "$tulparDir/core/pub_packages.txt"
    packages=$(echo $packagesCommands | rev | cut -c 3- | rev)

    sh -c "$packages"

    echo "Finished pub packages installation..."
}

installPubPackages
createStructer

flutter packages pub run build_runner build

touch "$tulparDir/.installed"
echo "Installed app... " > "$tulparDir/.installed"
echo "$(date)" >> "$tulparDir/.installed"
echo "Created .installed file"
echo "Installed app! Done!"