#!/usr/bin/env bash
tulparDir=$1
projectDir=$2
libFolder=$3


##if test -f "$tulparFolder/.installed"; then
    ##echo "Project already installed..."
    ##exit;
##fi
echo "Installing app..."

createStructer() {
    echo "Creating structure..."

    rm -rf  "$libFolder/assets"  "$libFolder/components"  "$libFolder/core" "$libFolder/routes"

    while read folderName; do
        if test -d "$libFolder/$folderName"
        then
            echo
            #echo "$libFolder/$folderName exists."
        else
            mkdir -p "$libFolder/$folderName"
        fi
    done < "$tulparDir/core/folder_structer.txt"

   
    while read fileData; do
        IFS="|" read -r fileName gistUrl <<< "${fileData}"

        if test -f "$libFolder/$fileName"
        then
            echo
            #echo "$libFolder/$folderName exists."
        else
            echo "Copying $fileName from gist..."
            mkdir -p "$(dirname "$libFolder/$fileName")"
            touch "$libFolder/$fileName"
            curl -s -L "$gistUrl" > "$libFolder/$fileName"
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

touch "$tulparFolder/.installed"
echo "Created .installed file"
echo "Installed app! Done!"