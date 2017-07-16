#!/bin/bash

#Lad os lige print all files
#echo All files
#ls -lh

#musze/trzeba html scrape index.html
echo HTML content of index.html from http server
cat index.html

echo ----------------------
echo Links found in http server

#https://stackoverflow.com/questions/2250131/how-do-you-append-to-an-already-existing-string
#sposob dodac string do inny string
IgnoreFiles=".git/ httpserver.py"
s=""


Links=$( grep '<li><a href=' index.html )
for link in $Links
do
	SUBSTRING=$(echo $link | cut -d'"' -f 2)
	if [ $SUBSTRING != "<li><a" ] && [ $SUBSTRING != "httpserver.py" ] && [ $SUBSTRING != ".git/" ]
	then
		echo $SUBSTRING
		s+=" "
		s+=$SUBSTRING
	fi
done


echo Loop done, saved to variable
#echo $s

#================================================
#Get local ip of http server from my other pc
IPoutput=$( arp -a )
echo ----------------------------
echo LOCAL IP ADDRESSES:
#echo $IPoutput
#for str in $IPoutput
#do
#	echo $str
#done
echo FOR HTTPSERVER

IPcut=$( echo $IPoutput | cut -d'(' -f 2 | cut -d')' -f 1 )
echo $IPcut

#==============================================
#Now we download the files
echo ---------------------------
echo Downloading files from HTTP server
BaseIPpath=$IPcut":8000/"
for file in $s
do
	#gdy dodac string do inny, nie wkladam +.
	#bezposrednio $string1$string2, a nie $string1+$string2
	wget $BaseIPpath$file
done



#=============================================
#We must now convert files
#And then we must setup http server here
