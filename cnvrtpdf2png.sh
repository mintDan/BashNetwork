#!/bin/bash

#Lad os lige print all files
#echo All files
#ls -lh

Nfiles=$( ls | wc -l )
echo number of files $Nfiles

Allfiles=$( ls )
echo All files here
echo $Allfiles


for file in $Allfiles
do
	if [[ $file == *.pdf ]]
	then
		echo $file
		filename=$( basename -s .pdf $file )
		#hmm, skal fkatisk måske have basename eller noget...
		convert -density 300 $file -quality 90 filename.png
	fi
done


