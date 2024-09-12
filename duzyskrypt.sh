#!/bin/bash

# Author : Karolina Glaza (198193 )
# Created On : May 2024
# Last Modified On : 20/05/2024
# Version : 1.0.2
#
# Description :
# Script made to zip or unzip files or folders using Zenity.
#
# opensource

function show_v(){
  echo "duzyskrypt.sh wersja 1.0.2"
  echo "autor: 198193"
}

function show_h(){
  echo "Pomoc:"
  echo "-v : informacja o wersji i autorze"
  echo "-h : pomoc"
  echo "Skrypt umożliwiający pakowanie i rozpakowywanie plików"
  echo "1.Skrypt rozpakowuje zipy tylko niezabezpieczone hasłem"
  echo "2.Nazwy plików do zipowania nie powinny zawierać spacji"
  echo "3.Możliwe pakowanie/rozpakowywanie zarówno folderów jak i pojedyńczych plików"
  echo "4.Opcje dot. pakowania plików:"
  echo "4.1 dodanie hasła"
  echo "4.2 dodanie nowego folderu dla zipa"
  echo "4.3 ustawineie nazwy archiwum"
  echo "4.4 wybór lokalizacji"
  echo "5.Opcje dot. rozpakowywania plików:"
  echo "5.1 ustawienie nazwy folderu"
  echo "5.2 wybór lokalizacji"
  echo "---opensource---"
}

function pack_files() {
  #wybor plikow
  local files=$(zenity --file-selection --multiple --title="Wybierz pliki do spakowania" --separator=" ")
  [[ -z "$files" ]] && zenity --error --text="Nie wybrano plików." && exit 1
  
  local files2=""
  for file in $files; do
  local filename=$(basename "$file")
  files2="$files2$filename "
  done
  files2="${files2% }"

  #wybor lokalizacji
  local destination=$(zenity --file-selection --directory --title="Wybierz lokalizację docelowa.")
  [[ -z "$destination" ]] && zenity --error --text="Nie wybrano lokalizacji docelowej." && exit 1

  #dod: nowy katalog
  new_dir_name=$(zenity --entry --title="Nazwa nowego katalogu" --cancel-label="Nie chce nowego katalogu" --text="Podaj nazwę nowego katalogu:")

if [[ -n "$new_dir_name" ]]; then
    destination="$destination/$new_dir_name"
    mkdir -p "$destination"
fi


  #dod: haslo,nazwa zipa
  local password=$(zenity --password --title="Ustaw hasło (opcjonalnie)" --cancel-label="Nie chce hasła")
  local zipname=$(zenity --entry --title="Nazwa pliku ZIP" --text="Podaj nazwę:")

  zipname="$zipname.zip"
  local current=$(pwd)
  
  cd "$(dirname "${files%% *}")"

  #pakowanie
    if [[ -n "$password" ]]; then
    zip -P "$password" "$current/$zipname" $files2 | zenity --progress --pulsate --text="Pliki są pakowane..." --title="Pakowanie plików"
  else
    zip "$current/$zipname" $files2 | zenity --progress --pulsate --text="Pliki są pakowane..." --title="Pakowanie plików"
  fi

  mv "$current/$zipname" "$destination"
  
  cd "$current"

   if [[ $? -eq 0 ]]; then
    zenity --info --text="Pakowanie zakończone sukcesem."
  else
    zenity --error --text="Błąd podczas pakowania plików."
  fi
}

function unpack_files() {
  #wybor zipa
  local zipfile=$(zenity --file-selection --title="Wybierz plik do rozpakowania")
  [[ -z "$zipfile" ]] && zenity --error --text="Nie wybrano pliku." && exit 1

  #wybor lokalizacji
  local destination=$(zenity --file-selection --directory --title="Wybierz lokalizację docelowa")
  [[ -z "$destination" ]] && zenity --error --text="Nie wybrano lokalizacji docelowej." && exit 1

  #rozpakowywanie
    unzip -d "$destination" "$zipfile" | zenity --progress --pulsate --text="Pliki są rozpakowywane..." --title="Rozpakowywanie plików"

  if [[ $? -eq 0 ]]; then
    zenity --info --text="Rozpakowanie zakończone sukcesem."
  else
    zenity --error --text="Błąd podczas rozpakowywania plików."
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
  if zenity --question --title="Pakowanie czy rozpakowywanie?" --text="Czy chcesz spakować czy rozpakować pliki?" --ok-label="Pakować" --cancel-label="Rozpakować"; then
    pack_files
  else
    unpack_files
  fi
fi
