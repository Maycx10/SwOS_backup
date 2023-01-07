# Bash script for backup MikroTik SwOS configuration file
### Precondition:
1. Tested in CentOS 7
2. Curl already installed or use install command ```yum -y install curl```
3. Snmpget and mibs-libary already installed or use install command ```yum -y install net-snmp net-snmp-utils```
4. Create folder for script, logs, tmp and backup files ```mkdir /opt/swos_bkp```

### How script is works:
1. Uses directory ```/opt/swos_bkp/``` for all files
2. Create directory for today backup files, for example ```/opt/swos_bkp/bkp_files/16:00-30.12.2022```
3. Clears old tmp files '*.swb' in the ```/opt/swos_bkp/tmp/```
4. Read 'hostsw' file with IPs line by line
5. Makes a snmp-request to IP from 'hostsw' to find out the platform
6. Makes a snmp-request to find out the system name. **System name must be without backspaces**
7. Download config file by curl to ```/opt/swos_bkp/tmp``` directory
8. Checking the downloaded configuration for errors (too small weight, less than 100b and 401 errors in the downloaded file)
9. Move checked the configuration file from ```*/tmp``` to ```/opt/swos_bkp/bkp_files/$date/$filename```, for example ```/opt/swos_bkp/bkp_files/16:00-30.12.2022/MikroTik-1.swb```
10. Logs writes in the file ```/opt/swos_bkp/log/swos_bkp.log```
11. Deletes the old backup directory if found. Var ```days_to_keep``` in begining of the script

### How to install step by step:
1. ```yum -y install curl```
2. ```yum -y install net-snmp net-snmp-utils```
3. ```mkdir /opt/swos_bkp```
4. Copy or unzip this repository in the directory ```/opt/swos_bkp/```
5. Write **your** SwOS IPs in the ```/opt/swos_bkp/hostsw```
5. Edit the vars ```snmp_commname```, ```user```, ```pass``` in the script file ```swos_backup.sh```
6. ```chmod +x /opt/swos_bkp/swos_backup.sh```
6. Use cron for run the script would you like. For example:
   - ```crontab -e```
   - Write this command and save ```00 16 * * * root /opt/swos_bkp/swos_backup.sh >> /var/log/messages 2>&1```
   - For more information google how to crontab works :) or [click here](https://www.generateit.net/cron-job/).
7. Rotate logs file would you like. For example rotateing once day a week:
   - ```touch /etc/logrotate.d/swos_bkp```
   - ```vi /etc/logrotate.d/swos_bkp```
   - Write this and save in the file 
   ``` 
   /opt/swos_bkp/log/*.log {
        rotate 3
        weekly
        compress
        missingok
        notifempty 
        } 
9. Enjoy
