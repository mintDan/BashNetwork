#!/bin/bash

#print all files
#echo All files
#ls -lh

function CheckConnection(){
ping -c4 -q $1
echo Result
echo $?
#hvis result == 0, er der connection, hvis >0, ping failed
if [ $? == 0 ]
then
	echo Connection established to HTTP server
else
	echo Couldnt establish connection to HTTP server
fi 
}

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
#test connection to server
#ping -c4 -q $IPcut
#echo Result
#echo $?
#hvis result == 0, er der connection, hvis >0, ping failed
#if [ $? == 0 ]
#then
#	echo Connection established to HTTP server
#else
#	echo Couldnt establish connection to HTTP server
#fi 

CheckConnection $IPcut

#==============================================
#BaseIPpath=$IPcut":8000/"
#BaseIPpath="10.166.6.199:8000/" #Stationær
BaseIPpath="10.166.6.198:8000/"	#laptop
echo
echo cURL base path to HTTP server
curl -I $BaseIPpath
#Now we download the files
echo ---------------------------
echo Downloading index.html

wget $BaseIPpath




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

#==============================================
#Now we download the files
echo ---------------------------
echo Downloading files from HTTP server
#BaseIPpath=$IPcut":8000/"
#BaseIPpath="10.166.6.199:8000/" #Stationær
BaseIPpath="10.166.6.198:8000/"	#laptop

Size=0
for file in $s
do
	#gdy dodac string do inny, nie wkladam +.
	#bezposrednio $string1$string2, a nie $string1+$string2
	#dlatego $BaseIPpath$file
	echo Size of $file in bytes
	#-i for case insentitive i grep, -I i curl for header only
	
	SizeFile=$( curl -sI $BaseIPpath$file | grep -i Content-Length | awk '/Content-Length/ {print $2}' )
	#xargs echo -n	
	
	#echo $SizeFile | tr -d '\r'
	SizeFile=$( echo $SizeFile | tr -d '\r' )
	
	
	Size=$(($SizeFile+$Size))
	echo $SizeFile
	echo Download $file
	#-q for quiet, no output to terminal
	wget -q $BaseIPpath$file
done

echo "Total Size of files downloaded in bytes" 
echo $Size
echo Available space
DiskSpace=$( df -h | grep "/dev/sda1" | awk '{print $4}' )
echo $DiskSpace

#=============================================
#We must now convert files
#And then we must setup http server here
