#!/bin/bash

while getopts "M:" OPTION;
do
        case $OPTION in
                "M") # Assign MAC_ADDRESS
                        MAC_ADDRESS="$OPTARG"
                ;;
        esac
done

if [ -z $MAC_ADDRESS ]; then
        # we need this parameter to continue
        EXIT_STRING="CRITICAL: MAC_ADDRESS variable has not been set!\n"
        EXIT_CODE=2
else
        IP_ADDRESS=$(arp -a | grep -i $MAC_ADDRESS | awk '{print $2}' | tr -d "()")
        if [ -z $IP_ADDRESS ]; then
                EXIT_STRING="WARNING: MAC Address not found\n"
                EXIT_CODE=1
        else
                EXIT_STRING=$(/usr/local/nagios/libexec/check_ping -H $IP_ADDRESS -w 3000.0,80% -c 5000.0,100% -p 5)
                EXIT_STRING=$(echo $EXIT_STRING | tr '[:lower:]' '[:upper:]')
                if [ $(echo $EXIT_STRING | grep "PING OK" | wc -l) -eq 1 ]; then
                        EXIT_CODE=0
                elif [ $(echo $EXIT_STRING | grep "WARNING" | wc -l) -eq 1 ]; then
                        EXIT_CODE=1
                else
                        EXIT_CODE=2
                fi
        fi
fi

echo "$EXIT_STRING\n"
echo "$EXIT_CODE\n"
exit $EXIT_CODE
