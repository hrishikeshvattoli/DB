#!/bin/bash 
# 
# Name: cron.sh
# 
# Summary: Script to add a cron entry.
# 
# Usage example: 
# 
# ./cron.sh 
# 
# Date                  Modified By     Description 
# 26-Nov-2019           Hrishikesh              Original version
#
#########################################################################################
echo "*/5 * * * * monitor.sh" >> /etc/crontab
