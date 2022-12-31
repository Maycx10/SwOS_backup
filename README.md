# Bash script for MikroTik SwOS backup configuration file once a day
### Precondition:
1. Tested in CentOS 7
2. curl already installed or use install command ```yum -y install curl```
3. snmpget and mibs-libary already installed or use install command ```yum -y install net-snmp net-snmp-utils```
4. Create folder for script, logs, tmp and backup files ```mkdir /opt/swos_bkp```

### How script is works:
1. Uses directory ```/opt/swos_bkp/``` for all files
2. Create directory for today backup files, for example ```/opt/swos_bkp/bkp_files/30.12.2022```
3. Clears old tmp files *.swb in the ```/opt/swos_bkp/tmp/```
4. Read 'hostsw' file with IPs line by line
5. Makes a snmp-request to IP from 'hostsw' to find out the platform
6. 


### How to install:
