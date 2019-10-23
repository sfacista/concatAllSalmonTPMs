#!/bin/bash
#By Sal Facista
##Here we will be taking all the .sf files found in this directory, extracting the TPM column, then pasting with a file name as a header (sample name).
##It would be nice to use a search parameter variable without shell expansion
columnDepth=4
#searchParameter="*.sf"

echo "This script is a drag and drop script. It should be in the working directory unless you specify otherwise. It also assumes that all columns are the same for each file."
echo ""
echo $PWD
echo "This is your working directory. Is this the directory you want to get all the Salmon (.sf) files from? If you press no, you will be given the option to work from only the current directory (find -maxdepth 1)."
read -p "(y/n)?" in2  
echo    # just a blank line

if [ $in2 = "y" ] || [ $in2 = "Y" ];
	then		
		#find the files in the dir - NO maxdepth
		find . -name "*.sf" > TEMPstorageFILEdeleteME
		#Create a file with the template colmun names
		for ((i = 1; i < 2; i++))
		do 
			bloopBorp=$(head -n 1 TEMPstorageFILEdeleteME)
			cut -f1 ${bloopBorp} > allTPMs
			unset bloopBorp
		done
		
		while read line1
		do 
			cut -f${columnDepth} ${line1} > $(echo ${line1} | sed 's/.*\///' -)_tmp
			paste allTPMs $(echo ${line1} | sed 's/.*\///' -)_tmp > allTPMs_tmp
			mv allTPMs_tmp allTPMs
			rm $(echo ${line1} | sed 's/.*\///' -)_tmp
		done < TEMPstorageFILEdeleteME
		unset line1
		echo Removing temp files...
		
		#for column labels
		tr -d '\n' < TEMPstorageFILEdeleteME | sed 's/\.\//BEEPBOBBORPBLEEP/g' - | sed 's/^BEEPBOBBORPBLEEP//g' - | sed 's/BEEPBOBBORPBLEEP/\t/g' - > labelsList
		cat labelsList allTPMs > allTPMs_tmp2
		mv allTPMs_tmp2 allTPMs
		
		rm TEMPstorageFILEdeleteME
		rm labelsList
		echo "You need to edit the first line (column labels because I am lazy right now)".
	else 
		echo "Did you want to work from this directory only?"
		read -p "Was the entry correct (y/n)?" in1  
		echo    # just a blank line
		if [ $in1 = "y" ] || [ $in1 = "Y" ];
			then
				find . -maxdepth 1 -name "*.sf" >TEMPstorageFILEdeleteME
				#paste from above - needs to be made to work with full directory names - assume POSIX compliant file names!
			
			else 
				echo "Nothing else was done."
			exit 0
		fi

fi

exit 0