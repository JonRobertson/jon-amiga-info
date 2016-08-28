#!/bin/bash

# Script to check out and build AROS source.
# This script was assembled using various script snippets
# found in the AROS Developer wikis at 
# http://aros.sourceforge.net/documentation/developers/compiling.php
# and
# https://en.wikibooks.org/wiki/Aros/Developer/Docs
#
# Set varHome to the parent folder where you want the AROS source and local builds.
varHome=/home/jonr/PRJ
#
# Set varAROSFolder to whatever you prefer the AROS folder to be named.
varAROSFolder=AROS
#
# Child folders under $varAROSFolder:
#
# varDownloadFolder is a common folder that configure/make uses to store downloaded
# libraries.  This is helpful when building for multiple targets from the same source.
varDownloadFolder=BuildDownloads
#
# Set varTarget to the platform and variant to build (native or hosted).
varTarget=linux-i386

echo ""
echo "Warning!!!"  
echo "This script will completely remove the AROS source folder and all builds."
echo "The script may be used to start development on a new machine"
echo "or start fresh on an existing machine."
echo ""

read -t 10 -n 1 -p "Do you wish to continue? (y/n) " answer
[ -z "$answer" ] && answer="No"  # if 'no' have to be default choice

if echo "$answer" | grep -iq "^n" ;then
    echo ""
    echo "Bye then!"
    exit
fi

echo ""
echo ""
echo "Checking out and building AROS in folder $varHome/$varAROSFoler"

# The output, both stdout and stderr, of the configure and make
# scripts is redirected to a log file.  The name of the log file
# includes the date/time of the build.
today=`date '+%Y_%m_%d__%H_%M_%S'`;
filename="$varHome/$varAROSFolder_$varTarget_$today.txt"

echo "Build started at $(date)" >> $filename

cd "$varHome"

# Remove current AROS folder and create new folder
sudo rm -r -f "$varAROSFolder/"
mkdir "$varAROSFolder/"
cd "$varAROSFolder/"

mkdir "$varDownloadFolder"

echo "Checking out AROS source from subversion..."
svn co -q --username=guest --password=guest https://svn.aros.org/svn/aros/trunk src

# Set up folder for the desired build.
mkdir $varTarget
cd $varTarget

# Call AROS configure script to prepare everything needed to build AROS.
# Note that this script is only creating a linux i386 hosted build.
../src/AROS/configure --target=$varTarget
# ../src/AROS/configure --target=$varTarget --with-portssources="../$varDownloadFolder"

make >>$filename 2>&1

echo "Build finished at $(date)" >> $filename
echo "The results of the build are in the file $filename"

