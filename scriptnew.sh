#!/bin/bash


# Get the current hostname and IP addresses
hostname=$(hostname)
ip_addresses=$(hostname -I)


# Filter IP addresses that start with 10.200.
ip_address=$(echo $ip_addresses | awk '{print $1}' | grep -E "^10\.200\.")

#echo
#echo "Password expiration user list of $hostname ($ip_address):"
#echo

for user in $(cut -d: -f1 /etc/passwd); do
    exp_date=$(chage -l $user | grep "Password expires" | cut -d: -f2-)
    if [ ! -z "$exp_date" ]; then
        if [ "$exp_date" == "never" ]; then
            echo -e "\e[32m$user's password never expires\e[0m"
        else
            exp_epoch=$(date -d "$exp_date" +"%s" 2>/dev/null)
            if [ $? -eq 0 ]; then
                today_epoch=$(date +"%s")
                if [ $exp_epoch -lt $today_epoch ]; then
                    echo -n "$user, "
                fi
            fi
        fi
    fi
done
#Created by Dinuka Nanayakkara(denon1994)
