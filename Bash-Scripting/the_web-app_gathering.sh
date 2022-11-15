#!/bin/bash

iprotocol=$1
ip=$2
seclist=$3
port=$4 #yes or no

#Check ip argument
if [ -z "$ip" ];then
    echo "Please assign IP as first argument for this bash script"
    exit 1
else

#Check port argument, than execute gathering
    if [ -z "$port" ];then
        echo "No port assigned..."
        echo "Running whatweb..."
        whatweb $ip -v > temp1
        
        echo "whatweb banner grabbing"
        whatweb -IL $ip > temp2
        
        echo "Running nmap...."
        nmap -sV -Pn $ip > temp3 
        
        # gather dirs
        # check for https
        echo "Runing Gobuster DIR"
        if [ "$iprotocol" == "https" ];then
            gobuster dir -u https://$ip  --wordlist /home/minervaeu/WebSec-Tools/wordlists/common.txt > temp4
        else
            gobuster dir -u http://$ip  --wordlist /home/minervaeu/WebSec-Tools/wordlists/common.txt > temp4
            echo "Running nmap ENUM"
            map -sV --script=http-enum $ip > temp5
        fi
    
        # Gobuster seclist
        if [ "$seclist" == "seclist" ];then
            echo "Running Gobuster Seclist"
            gobuster dns -d $ip -w /usr/share/seclists/Discovery/DNS/namelist.txt > temp 6
        fi
    else
        echo "IP & Port assigned..."

    fi
    
#Finish gathering 
fi

#Output gathered data
output=output_file.txt

if [ -e temp1 ]
then
        printf "\n----- 1. WHATWEB -----\n\n" >> results
        cat $temp1 >> results
        printf "\n----- 1. WHATWEB -----\n\n" >> $output
        printf temp1 >> $output
        rm temp1
fi

if [ -e temp2 ]
then
        printf "\n----- 2. WHATWEB BANNER GRABBING -----\n\n" >> results
        cat $temp2 >> results
        printf "\n----- 2. WHATWEB BANNER GRABBING -----\n\n" >> $output
        printf $temp2 >> $output
        rm $temp2
fi  

if [ -e temp3 ]
then
        printf "\n----- 3. NMAP -----\n\n" >> results
        cat $temp3 >> results
        printf "\n----- 3. NMAP -----\n\n" >> $output
        printf $temp3 >> $output
        rm $temp3
fi  

if [ -e temp4 ]
then
        printf "\n----- 4. GOBUSTER DIR -----\n\n" >> results
        cat temp4 >> results
        printf "\n----- 4. GOBUSTER DIR -----\n\n" >> $output
        printf temp4 >> results
        rm temp4
fi  

if [ -e temp5 ]
then
        printf "\n----- 5. NMP HTTP ENUM -----\n\n" >> results
        cat temp5 >> results
        printf "\n----- 5. NMP HTTP ENUM -----\n\n" >> $output
        printf  temp5 >> $output
        rm temp5
fi  

if [ -e temp6 ]
then
        printf "\n----- 6. GOBUSTER SECLIST -----\n\n" >> results
        cat temp6 >> results
        printf "\n----- 6. GOBUSTER SECLIST -----\n\n" >> $output
        printf temp6 >> $output
        rm temp6
fi  

cat results
