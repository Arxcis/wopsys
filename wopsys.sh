#!/bin/bash

# File        : .wopsys
# Date        : 07.02.17
# Author      : Jonas J. Solsvik
# Email       : jonasjso@stud.ntnu.no 
# Description : A system for downloading files from any teacher's website
#                in any subject on NTNU Gjøvik specifically.

BASE=~/wopsys

    # CONFIG - NO TOUCHY
logfile=${BASE}/wopsys.log                  # Logfile - relative path
bglog=${BASE}/localtemp/bglog.log

    # CONFIG
# url=http://www.ansatt.hig.no/erikh/opsys/ # Main repository
url=http://folk.ntnu.no/frh/ooprog/eksempel/
editor=subl                                 # Default editor


function wops () {

        # TempSTRINGS
    filename=               
    searchstring=


        # STANDARD UNIX COMMAND INTERPRETING SWITCH
    while [ $# -gt 0 ]
    do 
        case "$1" in 
            -f) filename=$2;
                curl ${url}${filename} > ${filename} 
                shift;;

            -p) filename=$2;  # Shift because consume two arguments
                curl ${url}${filename};
                shift;; 

            -l) echo -e "\nKnown files:";
                grep "" ${logfile} -n;
                break;;

            -s) searchstring=$2;

                echo -e "\nSearching DB...";
                grep ${searchstring} ${logfile} -n
                break;;

            -h) 
                whelp
                break;;


                     # BIIIG UPDATE-PROCEDURE
            -update) 
                echo -e "\nUpdating file DB";
                wupdate # Start foreground updating
                break;;

            -*) echo -e "\nCommand not handled"; break;;

            *.*)                    
                filename=$1;
                curl ${url}${filename} > ${filename};
                ${editor} ${filename};
                break;;              # Terminate while loop
                
            *) echo "Printing BASE ${BASE}";
               break;;
        esac
        shift
    done

        # DUMP FILENAME TO HISTORY

        # echo "Filename is:" ${filename}  # debug
    if [ ! -z ${filename} ]                     # If user input filename
    then
        if grep ${filename} ${logfile}  # If filname not exist in history
        then
            echo -e "\n" ${filename} " already exists in cache....";
        else
            echo -e "\nAdding " ${filename} " to cache...";
            echo ${filename} >> ${logfile};
            nohup ~/wopsys/wupdate.sh ${BASE} ${logfile} > ${bglog} & # Start background updating
        fi 
    fi

}

function wupdate() {
    currentdir=$PWD; 
    cd ${BASE}/;

        # Jump to git repo
    echo "Jumped to ->" $PWD;

    git pull origin master;

        # Commit if changes happen
    git add ${logfile};
    git commit -m "Updating ${logbase}";
    git push origin master; 

        # Back to working directory
    cd $currentdir;
    echo $PWD "<- Back to";
}

function whelp() {
    echo -e \
    "\nValid commands:\n" \
     "-------------------\n" \
     "       [filename]               - open file in default editor\n" \
     "        -f [filename] ([path])  - just save file\n" \
     "        -p [filename]           - print file\n" \
     "        -h                      - help\n" \
     "        -s [word]               - search for a file in log\n"\
     "        -l                      - list all files in log\n" \
     "        -update                 - update repository\n"\

}