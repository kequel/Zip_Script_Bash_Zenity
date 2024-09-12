#!/bin/bash

# Author : Karolina Glaza (https://github.com/kequel)
# Created On : May 2024
# Last Modified On : 20/05/2024
# Version : 1.0.2
#
# Description :
# Script made to zip or unzip files or folders using Zenity.
#
# opensource

function show_v(){
  echo "zipscript.sh version 1.0.2"
  echo "author: Karolina Glaza"
}

function show_h(){
  echo "Help:"
  echo "-v : information about the version and author"
  echo "-h : help"
  echo "Script that allows zipping and unzipping files"
  echo "1. The script only unzips non-password-protected zip files"
  echo "2. File names for zipping should not contain spaces"
  echo "3. Possible to zip/unzip both folders and individual files"
  echo "4. Options related to zipping files:"
  echo "4.1 add a password"
  echo "4.2 create a new folder for the zip file"
  echo "4.3 set the archive name"
  echo "4.4 choose the location"
  echo "5. Options related to unzipping files:"
  echo "5.1 set the folder name"
  echo "5.2 choose the location"
  echo "---opensource---"
}

function pack_files() {
  # file selection
  local files=$(zenity --file-selection --multiple --title="Select files to zip" --separator=" ")
  [[ -z "$files" ]] && zenity --error --text="No files selected." && exit 1
  
  local files2=""
  for file in $files; do
  local filename=$(basename "$file")
  files2="$files2$filename "
  done
  files2="${files2% }"

  # location selection
  local destination=$(zenity --file-selection --directory --title="Select destination location.")
  [[ -z "$destination" ]] && zenity --error --text="No destination selected." && exit 1

  # add: new folder
  new_dir_name=$(zenity --entry --title="New folder name" --cancel-label="Don't want a new folder" --text="Enter the name of the new folder:")

if [[ -n "$new_dir_name" ]]; then
    destination="$destination/$new_dir_name"
    mkdir -p "$destination"
fi

  # add: password, zip name
  local password=$(zenity --password --title="Set password (optional)" --cancel-label="Don't want a password")
  local zipname=$(zenity --entry --title="ZIP file name" --text="Enter the name:")

  zipname="$zipname.zip"
  local current=$(pwd)
  
  cd "$(dirname "${files%% *}")"

  # zipping
    if [[ -n "$password" ]]; then
    zip -P "$password" "$current/$zipname" $files2 | zenity --progress --pulsate --text="Zipping files..." --title="Zipping files"
  else
    zip "$current/$zipname" $files2 | zenity --progress --pulsate --text="Zipping files..." --title="Zipping files"
  fi

  mv "$current/$zipname" "$destination"
  
  cd "$current"

   if [[ $? -eq 0 ]]; then
    zenity --info --text="Zipping completed successfully."
  else
    zenity --error --text="Error during zipping."
  fi
}

function unpack_files() {
  # zip file selection
  local zipfile=$(zenity --file-selection --title="Select file to unzip")
  [[ -z "$zipfile" ]] && zenity --error --text="No file selected." && exit 1

  # location selection
  local destination=$(zenity --file-selection --directory --title="Select destination location")
  [[ -z "$destination" ]] && zenity --error --text="No destination selected." && exit 1

  # unzipping
    unzip -d "$destination" "$zipfile" | zenity --progress --pulsate --text="Unzipping files..." --title="Unzipping files"

  if [[ $? -eq 0 ]]; then
    zenity --info --text="Unzipping completed successfully."
  else
    zenity --error --text="Error during unzipping."
  fi
}

# MAIN
if [[ "$1" == "-h" ]]; then
  show_h
  exit 0
elif [[ "$1" == "-v" ]]; then
  show_v
  exit 0
else
  if zenity --question --title="Zip or Unzip?" --text="Do you want to zip or unzip files?" --ok-label="Zip" --cancel-label="Unzip"; then
    pack_files
  else
    unpack_files
  fi
fi
