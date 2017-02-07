# !/bin/bash

# $1 = should be $root 
# $2 = should be $logfile file

cd $1
		# Jump to git repo
echo "Jumped to ->" $PWD;

git pull origin master;

		# Commit if changes happen
git add $2;
git commit -m "Updating $2";
git push origin master;	

		# Back to working directory
