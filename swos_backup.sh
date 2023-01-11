#!/bin/sh
#set -x
cd /opt/swos_bkp/

snmp_commname='YOUR_COMMUNITY_SNMP_NAME'
user='user'
pass='password'
log=log/swos_bkp.log
date=$(date '+%H:%M-%d.%m.%Y')
days_to_keep=5

# Create new today folder for backup
echo $(date) "Info: create folder for today backup bkp_files/$date" >> $log
mkdir bkp_files/$date

# Clear tmp folder
echo $(date) "Info: delete tmp files 'tmp/*.swb'" >> $log
rm -f tmp/*.swb 2> /dev/null

# Read IPs from 'hostsw' file
while read -r ip_addr
do
	# Making a snmp-request to find out the platform
	snmp_sysdescr=$(snmpget -v2c -c $snmp_commname -r 1 $ip_addr sysDescr.0 2>&1)

	# If the platform contains SwOS continue
	if [[ "$snmp_sysdescr" =~ .*SwOS.* ]]; then

		# Making a snmp-request to find out the system name. !!!Switch system name must not contain spaces!!!
		sysname=$(snmpget -v2c -c $snmp_commname -r 1 $ip_addr sysName.0 | cut -d':' -f 4 | cut -d ' ' -f 2)
		filename=$sysname".swb"

		# Downloading the backup-file
		echo $(date) "Info: download $filename to tmp/$filename" >> $log
		curl --silent --anyauth --digest -u $user:$pass "http://$ip_addr/backup.swb" -o tmp/$filename

        minimumsize=100
        actualsize=$(wc -c < "tmp/$filename" | awk '{print $1}')

        # If in the backup-file found "401" this is an authorization error
        if grep -q 401 tmp/$filename; then
			echo $(date) "Error: Check authorization log/pass $ip_addr" >> $log

		# If the downloaded file is less than minimumsize (100b), then it is too small (something wrong)
		elif [[ $actualsize -lt $minimumsize ]]; then
			echo $(date) "Error: $filename size is less than 100 byte!" >> $log

        # Move the downloaded backups from tmp to the main folder
        else
        	echo $(date) "Info: move tmp/$filename to bkp_files/$date/$filename" >> $log
        	mv "tmp/$filename" "bkp_files/$date/$filename"
        fi

    # If the SNMP request fell off by timeout, then an error. SNMP is not configured or the host is unreachable
    elif [[ $snmp_sysdescr =~ .*Timeout.* ]]; then
    	echo $(date) "Error snmpget: $snmp_sysdescr" >> $log

	# Otherwise, if the SNMP platform is not SwOS, then the error
	else
		echo $(date) "Error: Can't find 'SwOS' in the snmp_responce sysDescr host $ip_addr" >> $log
	fi

# Read IPs from 'hostsw' file
done < hostsw

# Remove backup folders older than $date minus $days_to_keep
echo $(date) "Info: remove folders older than $date - $days_to_keep days" >> $log
find bkp_files/ -daystart -mtime +$days_to_keep -delete
