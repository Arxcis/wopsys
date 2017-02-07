#!/bin/bash

# File        : wopsys.sh
# Date        : 07.02.17
# Author      : Jonas J. Solsvik
# Email       : jonasjso@stud.ntnu.no 

# Installation script of 'wopsys' - tool
# 

cd ~/
BASE=$PWD;
name=wopsys;

cd $BASE;
git clone https://github.com/Arxcis/$name;
cd $name;

BASE=$PWD;

mkdir localtemp;	# Create local gitignored temp folder

echo $BASE > localtemp/path;	
touch localtemp/bglog.log;

chmod 755 wopsys.sh
chmod 755 wupdate.sh


if [[ -z $(grep $BASE/wopsys.sh ~/.bash_profile) ]]
then 
	echo -e "Adding to bash_profile..\n";
	echo "\nsource $BASE/wopsys.sh  # Path to Wops command" >> ~/.bash_profile
else
	echo -e "Already in bash_profile...\n";
fi