
# Index:
# 1. Information & Description:
# 2. Setup & Instructions:
# 3. Parameters:
# 4. Functions:
# 5. Main:
# 6. Footer:

# -------------------------------------------------------------------------------
# Information & Description:

# Clean-up log file for:
# /home/pi/DynDNS/DynDNS-NameSilo-RottenEggs.py
# e.g.
# /home/pi/DynDNS/DynDNS-NameSilo-RottenEggs.log

# /Information & Description
# -------------------------------------------------------------------------------
# Setup & Instructions:

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# To copy this script to Raspberry Pi via PuTTY:
#pscp "%UserProfile%\Documents\Flash Drive updates\Pi-Hole DNS server\DynDNS-NameSilo-RottenEggs-LogCleanup.sh" pi@my.pi:/home/pi/DynDNS/DynDNS-NameSilo-RottenEggs-LogCleanup.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Make script executable:
# Note that to make a file executable, you must set the eXecutable bit, and for a shell script, the Readable bit must also be set:
#cd /home/pi/DynDNS/
#ls -l
#chmod a+rx DynDNS-NameSilo-RottenEggs-LogCleanup.sh
#ls -l

# Permissions breakdown:
# drwxrwxrwx
# | |  |  |
# | |  |  others
# | |  group
# | user
# is directory?

# u  =  owner of the file (user)
# g  =  groups owner  (group)
# o  =  anyone else on the system (other)
# a  =  all

# + =  add permission
# - =  remove permission

# r  = read permission
# w  = write permission
# x  = execute permission

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# To run this script: 
#/home/pi/DynDNS/DynDNS-NameSilo-RottenEggs-LogCleanup.sh
#cd /home/pi/DynDNS/
#./DynDNS-NameSilo-RottenEggs-LogCleanup.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Schedule script to run automatically once every 2 weeks:
#crontab -l
#crontab -e
#0 0 */14 * * /home/pi/DynDNS/DynDNS-NameSilo-RottenEggs-LogCleanup.sh
#crontab -l

# Schedule script to run automatically once every month:
#crontab -l
#crontab -e
#0 0 1 */1 * /home/pi/DynDNS/DynDNS-NameSilo-RottenEggs-LogCleanup.sh
#crontab -l

# m h  dom mon dow   command

# * * * * *  command to execute
# - - - - -
# ¦ ¦ ¦ ¦ ¦
# ¦ ¦ ¦ ¦ ¦
# ¦ ¦ ¦ ¦ +----- day of week (0 - 7) (0 to 6 are Sunday to Saturday, or use names; 7 is Sunday, the same as 0)
# ¦ ¦ ¦ +---------- month (1 - 12)
# ¦ ¦ +--------------- day of month (1 - 31)
# ¦ +-------------------- hour (0 - 23)
# +------------------------- min (0 - 59)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# /Setup & Instructions
# -------------------------------------------------------------------------------
# Parameters:

CURRENT_LOGFILE_PATH="/home/pi/DynDNS/DynDNS-NameSilo-RottenEggs.log"

#ARCHIVE_LOGFILE_PATH="/home/pi/DynDNS/DynDNS-NameSilo-RottenEggs-LastTwoWeeks.log"
ARCHIVE_LOGFILE_PATH="/home/pi/DynDNS/DynDNS-NameSilo-RottenEggs-LastMonth.log"


# /Parameters
# -------------------------------------------------------------------------------
# Functions:

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

update_all_software()
{
  yum check-update
  sudo yum update
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# https://www.shellscript.sh/functions.html

add_a_user()
{
  USER=$1
  PASSWORD=$2
  shift; shift;
  # Having shifted twice, the rest is now comments ...
  COMMENTS=$@
  echo "Adding user $USER ..."
  echo useradd -c "$COMMENTS" $USER
  echo passwd $USER $PASSWORD
  echo "Added user $USER ($COMMENTS) with pass $PASSWORD"
}

adduser()
{
  USER=$1
  PASSWORD=$2
  shift; shift;
  # Having shifted twice, the rest is now comments ...
  COMMENTS=$@
  useradd -c "${COMMENTS}" $USER
  if [ "$?" -ne "0" ]; then
    echo "Useradd failed"
    return 1
  fi
  passwd $USER $PASSWORD
  if [ "$?" -ne "0" ]; then
    echo "Setting password failed"
    return 2
  fi
  echo "Added user $USER ($COMMENTS) with pass $PASSWORD"
}

#adduser bob letmein Bob Holness from Blockbusters
#ADDUSER_RETURN_CODE=$?
#if [ "$ADDUSER_RETURN_CODE" -eq "1" ]; then
#  echo "Something went wrong with useradd"
#elif [ "$ADDUSER_RETURN_CODE" -eq "2" ]; then 
#  echo "Something went wrong with passwd"
#else
#  echo "Bob Holness added to the system."
#fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# https://www.shellscript.sh/functions.html

factorial()
{
  if [ "$1" -gt "1" ]; then
    i=`expr $1 - 1`
    j=`factorial $i`
    k=`expr $1 \* $j`
    echo $k
  else
    echo 1
  fi
}

#while :
#do
#  echo "Enter a number:"
#  read x
#  factorial $x
#done    

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# /Functions
# -------------------------------------------------------------------------------
# Main:

# -------------------------------------------------------------------------------
# ===============================================================================
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Index of Main:
#===============================================================================
# 1: Get physical drives on system and partiotions
# 2: Get total size and % used for each physical drive
# 3: Edit partitions
# 4: Format disks
# 5: Mount/Un-mount drives to filesystem
#===============================================================================

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# https://www.shellscript.sh/

# -------------------------------------------------------------------------------

#https://serverfault.com/questions/120431/how-to-backup-a-full-centos-server

rsync -aAXv --delete-after --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / user@server:backup-folder

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#https://www.centos.org/forums/viewtopic.php?t=61787

rsync --dry-run -avzhe ssh /dir-to-be-copied/* root@<target_server>:/backupdir/

# Worked fine. Then tried it as the real deal:

rsync -avzhe ssh /dir-to-be-copied/* root@<target_server>:/backupdir/

# Also worked fine.

# Then used crontab -e to set up the following, for a nightly transfer:

1 2 * * * rsync -auvzhe ssh /dir-to-be-copied/* root@<target_server>:/backupdir/



# -------------------------------------------------------------------------------


#https://serverfault.com/questions/120431/how-to-backup-a-full-centos-server

# The best tool to use for this is probably dump, which is a standard linux tool and will give you the whole filesystem. I would do something like this:

/sbin/dump -0uan -f - / | gzip -2 | ssh -c blowfish user@backupserver.example.com dd of=/backup/server-full-backup-`date '+%d-%B-%Y'`.dump.gz

# This will do a file system dump of / (make sure you don't need to dump any other mounts!), compress it with gzip and ssh it to a remote server (backupserver.example.com), storing it in /backup/. If you later need to browse the backup you use restore:

restore -i

# Another option, if you don't have access to dump is to use tar and do something like

tar -zcvpf /backup/full-backup-`date '+%d-%B-%Y'`.tar.gz --directory / --exclude=mnt --exclude=proc --exclude=tmp .

# But tar does not handle changes in the file system as well.



# -------------------------------------------------------------------------------


#https://www.eandbsoftware.org/how-to-do-a-full-backup-using-the-tar-command-in-linux-centosredhatdebianubuntu/

# Get today's date & time in YYYYmmdd-HHMM e.g. 20190804-2343
TODAY=`/bin/date +%Y%m%d-%H%M`

FILENAME="FULLBACKUP-${TODAY}"

tar -cvpf /backups/${FILENAME}.tar --directory=/ --exclude=proc --exclude=sys --exclude=dev/pts --exclude=backups .

exit 0


#    The c option creates the backup file.
#    The v option gives a more verbose output while the command is running. This option can also be safely eliminated.
#    The p option preserves the file and directory permissions.
#    The f option needs to go last because it allows you to specify the name and location of the backup file which follows next in the command (in our case this is the /backups/fullbackup.tar file).
#    The --directory option tells tar to switch to the root of the file system before starting the backup.
#    We --exclude certain directories from the backup because the contents of the directories are dynamically created by the OS. We also want to exclude the directory that contains are backup file.
#    Many tar references on the Web will give an exclude example as:
#    --exclude=/proc





# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ===============================================================================
# -------------------------------------------------------------------------------

# /Main
# -------------------------------------------------------------------------------
# Footer:

echo "End of script."
echo $'\n'
exit 0

# /Footer
# -------------------------------------------------------------------------------

