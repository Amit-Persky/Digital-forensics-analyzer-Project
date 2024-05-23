#!/bin/bash

echo -e "\e[33m"
echo "╔══════════════════════════════╗"
echo "║         Welcome!!!           ║"
echo "╚══════════════════════════════╝"
echo -e "\e[0m"
sleep 3


START_TIME=$(date +"%Y-%m-%d %H:%M:%S")
HOME=/home/kali/Desktop

#1. Automate HDD and Memory Analysis:
#1.1 Check the current user; exit if not 'root'

CHECK_IF_ROOT()
{
    if [ "$(id -u)" -eq 0 ]; then
        echo -e "\033[0;32m[+] You have root permissions.. let's start...\033[0m" && sleep 3
    else
        echo "[+]You do not have root permissions... going out.. sry!"
        sleep 3
        exit 
    fi
}

echo "[+] To work with the tool in front of us, you need root privileges. 
If you are not one, switch to one and run the tool. 
In any case, the tool will start by checking your user privileges."
sleep 10
CHECK_IF_ROOT

#1.2 Allow the user to specify the filename; check if the file exists

CHECK_FILE_EXISTS()
 {
   
    read -p "[>] Enter the filename you want to analyze: " FILENAME

    
    if [ -z "$FILENAME" ]; then
        echo "Error: No filename provided..going out"
        exit 1
    fi

   
    if [ ! -e "$FILENAME" ]; then
        echo "Error: File '$FILENAME' does not exist.. going out"
        exit 1
    else
        echo "File '$FILENAME' exists... moving on"
    fi
}

echo "[+] Put the file you want to work with into the folder from which you run the tool,
otherwise it will not work properly"
sleep 10

CHECK_FILE_EXISTS

#1.3 Create a function to install the forensics tools if missing.. If the applications are installed already , we dont installing them.

TOOLS=( "figlet" "bulk-extractor" "binwalk" "foremost" "exiftool" "binutils")

function INSTALL_TOOLS(){
    for package_name in "${TOOLS[@]}"; do
        dpkg -s "$package_name" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "[*] Installing $package_name..."
            sudo -S apt-get install "$package_name" -y >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "[#] $package_name installed on your machine."
            else
                echo "[-] Failed to install $package_name."
            fi
        else
            echo "[#] $package_name is already installed on your machine."
        fi
    done
}

echo "Installing tools required for the work. Existing tools will not be reinstalled."
sleep 5

INSTALL_TOOLS

echo "[+] Making a new directory called 'Output' on your Desktop"
mkdir $HOME/Output >/dev/null 2>&1

#1.4 Use different carvers to automatically extract data..

function CARVERS()
{
		echo "Now we are going to analyze the file you have provided"
		sleep 5
		echo -e  "Please choose the tool you would like to use with, you can choose a specific one or all: \n1)exiftool\n2)foremost\n3)binwalk\n4)bulk_extractor\n5)strings\n6)All" 
		read TOOLS
		
	case $TOOLS in 
		1)
			echo "exiftool"
			exiftool $FILENAME -o /$HOME/Output/exiftool >/dev/null 2>&1
			sleep 2 
			echo "[+] a file named exiftool is now in the Output directory"
		;;
		
		2)
			echo "foremost"
			foremost $FILENAME -o /$HOME/Output/foremost >/dev/null 2>&1
			sleep 2 
			echo "[+] a file named foremost is now in the Output directory"
		;;
		
		3)
			echo "binwalk"
			binwalk $FILENAME -C /$HOME/Output/binwalk >/dev/null 2>&1
			echo "binwalk takes a few moments, please wait "
			sleep 2 
			echo "[+] a file named binwalk is now in the Output directory"
		;;
		
		4)
			echo "bulk_extractor"
			bulk_extractor $FILENAME -o /$HOME/Output/bulk_extractor >/dev/null 2>&1
			sleep 2 
			echo "[+] a file named bulk_extractor is now in the Output directory"
		;;
		
		5)
			echo "strings"
			strings $FILENAME >> /$HOME/Output/strings.txt >/dev/null 2>&1
			sleep 2 
			echo "[+] a file named strings is now in the Output directory"
		;;
		
		6)
			echo "All"
			exiftool $FILENAME -o /$HOME/Output/exiftool >/dev/null 2>&1
			sleep 2 
			echo "[+] a file named exiftool is now in the Output directory"
			sleep 1
			foremost $FILENAME -o /$HOME/Output/foremost >/dev/null 2>&1
			sleep 2 
			echo "[+] a file named foremost is now in the Output directory"
			sleep 1
			binwalk $FILENAME -C /$HOME/Output/binwalk >/dev/null 2>&1
			sleep 2 
			echo "[+] a file named binwalk is now in the Output directory"
			sleep 1
			bulk_extractor $FILENAME -o /$HOME/Output/bulk_extractor >/dev/null 2>&1
			sleep 2 
			echo "[+] a file named bulk_extractor is now in the Output directory"
			sleep 1
			strings $FILENAME >> /$HOME/Output/strings.txt >/dev/null 2>&1
			sleep 2 
			echo "[+] a file named strings is now in the Output directory"
			echo "[!] we did it!!! ALL INFORMATION IS SAVED"
			
#1.5 Data should be saved into a directory... > Saved to the Dir Output on your Desktop


	esac
}
	
CARVERS

#1.6 Attempt to extract network traffic; if found, display to the user the location and size

function NET_TRAFFIC()
{
	echo "Lets look for a network traffic file inside all of the information gathered before"
	sleep 2
	
	NET_FILE=$(find $HOME/Output -name "*.pcap" -print -quit)
	
	if [ -n "$NET_FILE" ];
	then 
		echo "[+] A network traffic file was found and it is located in:  $NET_FILE"
		if [ -s "$NET_FILE" ]; then
            size=$(du -h "$NET_FILE" | cut -f1)
            echo "File size is: $size"
        else
            echo "File size is 0 bytes"
        fi
	else
		echo "[-] No such file was found in the extracted information...sry"
	fi	
}

NET_TRAFFIC

#1.7 Check for human-readable (exe files, passwords, usernames, etc.).

function HUMAN() 
{
	
	echo '[!] please grovide me the full path to a file wich we will look for special strings in it ' 
	read STRING_FILE
	echo '[!] what strings would you like me to search for you?'
	read STRING
	echo '[!] do you have another string you would like to search today?'
	read STRING_TWO
	echo '[!] any more?' 
	read STRING_THREE
	
	TEXT_STRING=$(strings "$STRING_FILE" | grep "$STRING")
	TEXT_STRING_TWO=$(strings "$STRING_FILE" | grep "$STRING_TWO")
	TEXT_STRING_THREE=$(strings "$STRING_FILE" | grep "$STRING_THREE")

		if [ -z "$TEXT_STRING" ] && [ -z "$TEXT_STRING_TWO" ] && [ -z "$TEXT_STRING_THREE" ]; 
		then
			echo "No such strings were found."
		else
			echo "Strings were found in the file:"
			[ -n "$TEXT_STRING" ] && echo "$TEXT_STRING"
			[ -n "$TEXT_STRING_TWO" ] && echo "$TEXT_STRING_TWO"
			[ -n "$TEXT_STRING_THREE" ] && echo "$TEXT_STRING_THREE"
		fi
}

HUMAN

#2. Memory Analysis with Volatility:
#2.1 Check if the file can be analyzed in Volatility; if yes, run Volatility

function VOL()
{
	echo  "[+]Lets try to extract ferther informatiom from the file you have provided with volatility tool"
	./volatility -f $FILENAME imageinfo 2>/dev/null
	
	echo  "[+]we can use volatility, lets start"
	
	sleep 2
}

VOL

#2.2 Find the memory profile and save it into a variable

function MEM_PROFILE()
{
	
	profile=$(./volatility -f $FILENAME imageinfo 2>/dev/null | grep "Suggested" | awk '{print$4}' | sed 's/,//g')
	
	echo "[+]Looks like the operation system of the memory file is $profile"
	
	sleep 2
}

MEM_PROFILE

#2.3 Display the running processes

function PROC()
{
	echo "[+]The running processes are:"
	RUN_PRO=$(./volatility -f $FILENAME --profile=$profile pslist 2>/dev/null)
	echo "$RUN_PRO"
	sleep 2
}	

PROC

#2.4 Display network connections

function NET_CON()
{
	echo "[+]The network connections are:"
	TCP_CON=$(./volatility -f $FILENAME --profile=$profile connscan 2>/dev/null)
	echo "$TCP_CON"
}

NET_CON

#2.5 Attempt to extract registry information

function REG()
{
	echo "[+]The registry information is:"
	REG_INFO=$(./volatility -f memdump.mem --profile=WinXPSP2x86 printkey 2>/dev/null)
	echo "$REG_INFO"
	sleep 2
}

REG
END_TIME=$(date +"%Y-%m-%d %H:%M:%S")

#3. Results
#3.1 Display general statistics (time of analysis, number of found files, etc.)
#3.2 Save all the results into a report (name, files extracted, etc.).
function NUM()
{
	echo "[+] General statistics about the findings:"
NUM_FILES=$(find /home/kali/Desktop/Output -type f | wc -l)

echo "we have extracted $NUM_FILES files from the file we analyzed." | tee /home/kali/Desktop/Output/generalstatistics.txt

sleep 2

}

NUM

function TIME()
{
	DURATION=$(($(date -d "$END_TIME" +%s) - $(date -d "$START_TIME" +%s)))
	echo "[+]the analyze of the file $FILENAME took to you $DURATION seconds." | tee /home/kali/Desktop/Output/analyzetime.txt
	sleep 2
}

TIME

#3.3 Zip the extracted files and the report file

echo -e "\033[0;32m[+]Zipping all the results to zip archive named: 'Your_Results.zip' and his location is your Desktop. \033[0m"

zip -r /home/kali/Desktop/Your_Results.zip /home/kali/Desktop/Output >/dev/null 2>&1

chmod 777 /home/kali/Desktop/Output
chmod 777 /home/kali/Desktop/Your_Results.zip


echo -e "\e[33m"
echo "╔══════════════════════════════╗"
echo "║        BYE BYE!!!            ║"
echo "╚══════════════════════════════╝"
echo -e "\e[0m"
sleep 3
exit
