# This is a Backup Moving Script to work with Percona - the Percona backup is running via another script, which may contain a bug.

# Jobs of this script in it's entirety:
# Retain: 2 latest days, 2 latest weeks, 2 latest months, every semester
# Move any files to /backups/mysql/deletion that isn't to be retained, so they can be deleted when the backup is successfully completed

# Moving files to /weekly on monday mornings
### CURRENTLY USES ECHO FOR TEST PURPOSES
# (This could also have used a `date + "%u"` to make the weekday a number, 1 being monday)
set `date`
if [ "$1" = "Mon" ]
    then
    cd /backups/mysql/daily
    TBMTW=$(ls -t | tail -1)
    echo "mv $TBMTW /backups/mysql/weekly/$TBMTW"
fi

# Monthly Backup, moves oldest /weekly file to /monthly on the 1st of each month
# Also has the nested semester backup on 1st of August and January
if [ $3 -eq 1 ]
    then
    cd /backups/mysql/weekly
    TBMTM=$(ls -t | tail -1)
    echo "mv /backups/mysql/weekly/$TBMTM /backups/mysql/monthly/$TMBTM"
#Semester backups to /semesters
    if [ "$2" = "Aug" ] || [ "$2" = "Jan" ]
        then
        cd /backups/mysql/monthly
        TBMTS=$(ls -t | tail -1)
        echo "mv /backups/mysql/monthly/$TBMTS /backups/mysql/semesters/$TMBTS"
    fi
fi

# Then remove the out-dated files

#Move oldest /daily file to deletion folder, if Number Of Files is more than 2
#Break Value as a precaution
cd /backups/mysql/daily
NOF=$(ls -1 | wc -l)
BV=1
echo "$NOF"
while [ $NOF -ge 3 ]
do
    cd /backups/mysql/daily
    TBD=$(ls -t | tail -1)
    mv /backups/mysql/daily/$TBD /backups/mysql/deletion/$TBD
    cd /backups/mysql/daily
    NOF=$(ls -1 | wc -l)
    echo "$NOF"
 if [ $BV -ge 4 ]
        then
        break
        echo "Warning: Had to break, daily"
        else
        BV=$((BV + 1))
    fi
    echo "$BV"
done


#Move the oldest /weekly file to deletion folder, if NOF is more than 2
#Break Value as a precaution
cd /backups/mysql/weekly
NOF=$(ls -1 | wc -l)
BV=1
while [ $NOF -ge 3 ]
do
    cd /backups/mysql/weekly
    TBD=$(ls -t | tail -1)
    mv /backups/mysql/weekly/$TBD /backups/mysql/deletion/$TBD
    cd /backups/mysql/weekly
    NOF=$(ls -1 | wc -l)
    if [ $BV -ge 4 ]
        then
        break
        echo "Warning: Had to break, weekly"
        else
        BV=$((BV + 1))
    fi
done


#Move the oldest /monthly file to deletion folder, if NOF is more than 2
#Break Value as a precaution
cd /backups/mysql/monthly
NOF=$(ls -1 | wc -l)
BV=1
while [ $NOF -ge 3 ]
do
    cd /backups/mysql/monthly
    TBD=$(ls -t | tail -1)
    mv /backups/mysql/monthly/$TBD /backups/mysql/deletion/$TBD
cd /backups/mysql/monthly
    NOF=$(ls -1 | wc -l)
    if [ $BV -ge 4 ]
        then
        break
        echo "Warning: Had to break, monthly"
        else
        BV=$((BV + 1))
    fi
done

# End of script
