# Zip Script

Zip Script is my first simple Bash script designed for zipping and unzipping files or folders via graphical interface using Zenity eveloped as part of the Operating Systems course in my second semester at Gdańsk University of Technology. It offers both basic functionality for compressing and decompressing files, as well as password protection and creating custom directories for the archived files.

## Author
- Karolina Glaza [GitHub](https://github.com/kequel)

### Version
- Current version: **1.0.2**

## Features
  1. The script only unzips non-password-protected zip files
  2. File names for zipping should not contain spaces
  3. Possible to zip/unzip both folders and individual files
  4. Options related to zipping files:
     -  add a password
     - create a new folder for the zip file
     - set the archive name
     - choose the location
  6. Options related to unzipping files:
     - set the folder name
     - choose the location
  7. Graphical Interface: Zenity.
  8. Error Handling.

## How to use

**Zipping Files**
1. Select the files to zip (ensure the filenames do not contain spaces).
2. Choose the destination directory.
3. Optionally, provide a new directory name where the ZIP archive will be stored.
4. Optionally, set a password for the ZIP file.
5. Provide a name for the ZIP file.

**Unzipping Files**
1. Select the ZIP file to unzip.
2. Choose the destination directory where the files will be extracted.

## Options
`-v` display version information and the author of the script.

`-h` display help with a description of available options and usage.
