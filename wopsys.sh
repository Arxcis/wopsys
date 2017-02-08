#!/bin/bash

# File        : wopsys.sh
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
url=http://www.ansatt.hig.no/erikh/opsys/ # Main repository
# url=http://folk.ntnu.no/frh/ooprog/eksempel/
editor=subl                                 # Default editor


function wops () {

        # TempSTRINGS
    filename=               
    searchstring=
    path=


        # STANDARD UNIX COMMAND INTERPRETING SWITCH
    while [ $# -gt 0 ]
    do 
        case "$1" in 
            -o) filename=$2;
                curl ${url}${filename} > ${filename};
                ${editor} ${filename};
                break;;

            -p) filename=$2;  # Shift because consume two arguments
                curl ${url}${filename};
                shift;; 

            -l) echo -e "Known files:";
                grep "" ${logfile} -n;
                break;;

            -s) searchstring=$2;

                echo -e "Searching DB...";
                grep ${searchstring} ${logfile} -n;
                break;;

            -h) 
                whelp
                break;;

                     # BIIIG UPDATE-PROCEDURE
            -update) 
                echo -e "Updating file DB";
                wupdate # Start foreground updating
                break;;


            -active)  echo -e  $url;               break;;
            -*)       echo -e "Command not handled"; break;;

            *.*)                   
                filename=$1;
                curl ${url}${filename} > ${filename};
                shift;;
                    # Terminate while loop
                
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
            echo -e "" ${filename} " already exists in cache....";
        else
            echo -e "Adding " ${filename} " to cache...";
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
     "       [filepath]        - save file to given path\n" \
     "        -o [filepath]    - open file in default editor\n" \
     "        -p [filename]    - print file\n" \
     "        -h               - help\n" \
     "        -s [word]        - search for a file in log\n"\
     "        -l               - list all files in log\n" \
     "        -update          - update repository\n"\
     "        -active          - print active repository"\

}