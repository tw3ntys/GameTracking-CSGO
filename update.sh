#!/bin/bash

cd "${0%/*}"
. ../common.sh

echo "Processing CS:GO..."

ProcessDepot ".so"
ProcessVPK

unzip -lv ./csgo/panorama/code.pbin > ./csgo/panorama/code_pbin.txt

while IFS= read -r -d '' file
do
	/home/steamdb/EntityLumpDumper/EntityLumpDumper/bin/Release/EntityLumpDumper "$file"
done <   <(find "csgo/maps/" -type f -name "*.bsp" -print0)

FixUCS2

CreateCommit "$(grep "ClientVersion=" csgo/steam.inf | grep -o '[0-9\.]*') | $(grep "PatchVersion=" csgo/steam.inf | grep -o '[0-9\.]*')" "$1"

bash ~/csgo_panorama/update.sh
