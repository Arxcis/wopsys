#!/bin/sh

BASE=$(dirname "$0")

mkdir local_stuff;	# Create local gitignored temp folder

echo $BASE > localtemp/path;	
touch localtemp/bglog.log;

git clone https://github.com/Arxcis/wopsys $BASE

chmod 755 $BASE/wopsys.h
chmod 755 $BASE/wupdate.h

echo "source $BASE/wopsys.h" >> ~/.bash_profile