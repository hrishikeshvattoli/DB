#!/bin/bash 
# 
# Name: monitor.sh
# 
# Summary: Script to monitor the server stats and feeding the SRE monitoring dashboard.
# 
# Usage example: 
# 
# ./monitor.sh 
# 
# Date                  Modified By     Description 
# 26-Nov-2019           Hrishikesh              Original version
#
#########################################################################################
#
rm -f /var/www/html/stats/index.json
rm -f /tmp/output.txt

# Install the required packages

apt-get -y install sysstat
apt-get -y install jq

#Gather some basic server info

# Check Hostname

HOST=$(hostname)
echo "Hostname:" $HOST >> /tmp/output.txt

# Gather server date andtime

DT=$(date)
echo "Date:" $DT >> /tmp/output.txt

# Check the IP address

IP=$(hostname -I)
echo -e "Host IP address:" $IP >> /tmp/output.txt

# Kernel version

KERNEL=$(uname -r)
echo -e "Kernel Version:" $KERNEL >> /tmp/output.txt

# Server Hardware
ARCH=$(uname -m)
echo -e "Server arch:" $ARCH >> /tmp/output.txt

# Uptime
UPTIME=$(uptime | awk '{print $3,$4}' |cut -d , -f1)
echo -e "Server uptime:" $UPTIME >> /tmp/output.txt

# Check the system load

LOAD=$(top -n 1 -b | grep "load average:" |awk '{print $11 " " $12 $13 $14 $15}')
echo -e "Server Load:" $LOAD >> /tmp/output.txt

# Check CPU usage status

CPU=$(top -n 1 -b | grep "Cpu")
echo -e "CPU usage status:" $CPU >> /tmp/output.txt

# Processes running

# IO statistics
IO=$(iostat)
echo -e "IOstats:" $IO >> /tmp/output.txt

# Package updates available

echo "Pending Package updates:" >> /tmp/output.txt
apt list --upgradable >> /tmp/output.txt

#File system usage

DF=$(df -h |egrep '(Filesystem|xvd*)')
echo -e "Disk usage:" $DF >> /tmp/output.txt

# Memory usage

free -h > /tmp/mem.txt
MEM=$(grep -v Mem /tmp/mem.txt)
SWAP=$(grep -v Swap /tmp/mem.txt)

echo -e "Memory usage:" $MEM >> /tmp/output.txt
echo -e "Swap usage:" $SWAP >> /tmp/output.txt

jq  -R -s  'split("\n")' < /tmp/output.txt  >> /var/www/html/stats/index.json

#END                                                                                                                         
