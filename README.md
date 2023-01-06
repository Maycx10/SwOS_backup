# Bash script for MikroTik SwOS backup configuration file
### Precondition:
1. Tested in CentOS 7
2. Curl already installed or use install command ```yum -y install curl```
3. Snmpget and mibs-libary already installed or use install command ```yum -y install net-snmp net-snmp-utils```
4. Create folder for script, logs, tmp and backup files ```mkdir /opt/swos_bkp```

### How script is works:
1. Uses directory ```/opt/swos_bkp/``` for all files
2. Create directory for today backup files, for example ```/opt/swos_bkp/bkp_files/30.12.2022```
3. Clears old tmp files '*.swb' in the ```/opt/swos_bkp/tmp/```
4. Read 'hostsw' file with IPs line by line
5. Makes a snmp-request to IP from 'hostsw' to find out the platform
6. Makes a snmp-request to find out the system name. **System name must be without backspaces**
7. Download config file by curl to ```/opt/swos_bkp/tmp``` directory
8. Checking the downloaded configuration for errors (too small weight, less than 100b and 401 errors in the downloaded file)
9. Move checked the configuration file from ```*/tmp``` to ```/opt/swos_bkp/bkp_files/$date/$filename```, for example ```/opt/swos_bkp/bkp_files/30.12.2022/MikroTik-1.swb```
10. Logs writes in the file ```/opt/swos_bkp/log/swos_bkp.log```
11. Deletes the old backup directory if found

### How to install:
