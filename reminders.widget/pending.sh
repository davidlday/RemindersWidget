#!/bin/bash
# Cribbed from http://www.macosxtips.co.uk/geeklets/productivity/ical-reminders/

# Changes from original
# * Used a little SQL-fu to figure out tables and codes instead of hard coding
# * Select list names independent of tasks so empty lists can be shown as well

# TODO
# * Find recurrence indicator
# * Add Notes

# http://stackoverflow.com/questions/1527049/bash-join-elements-of-an-array
function join {
    local IFS="$1"; shift; echo "$*";
}

# Catalina
# File is in $HOME/Library/Reminders/Container_v1/Stores/
# Mine is: Data-DB8E17A5-EEC6-44DF-8A5C-96B66F3E1E32.sqlite


# Calendar Cache DB
CAL_CACHE_DB="file:$HOME/Library/Calendars/Calendar Cache?mode=ro"

# Figure out calendar table
CALTABLE=$(sqlite3 "$CAL_CACHE_DB" \
    "SELECT name FROM sqlite_master WHERE name IN ('ZICSELEMENT','ZCALENDARITEM')");
# ZCALENDARITEM

# Get REMCODE for Tasks

# Catalina
# SELECT *
# FROM Z_PRIMARYKEY
# WHERE Z_NAME = 'REMCDReminder';
# returns 21 on my machine

REMCODE=$(sqlite3 "$CAL_CACHE_DB" \
    "SELECT z_ent FROM z_primarykey WHERE z_name = 'Task'");
# 6

# Get CALDAVCALENDAR
# CALDAVCALENDAR=$(sqlite3 "$CAL_CACHE_DB" \
#     "SELECT z_ent FROM z_primarykey WHERE z_name = 'CalDAVCalendar'");

# Now. Duh.
NOW=$(date +%s);

# Time Zone Offset (i.e. +0500)
ZONERESET=$(date +%z | awk \
    '{if (substr($1,1,1)!="+") {printf "+"} else {printf "-"} print substr($1,2,4)}');

# Reminders year zero in seconds since epoch (I think). (i.e. 978289200)
# Adding timezone caused issues b/c JavaScript Date() uses the system to adjust.
#YEARZERO=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "2001-01-01 0:0:0 $ZONERESET" "+%s");
YEARZERO=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "2001-01-01 0:0:0 +0000" "+%s");

# Used to figure out which ones are overdue
NOW=$(date "+%s")

# Due date in seconds since epoch (I think).
DUEDATE="($YEARZERO + zduedate)";

# Get all list names

# Catalina
# SELECT Z_PK, ZNAME1
# FROM ZREMCDOBJECT
# WHERE Z_ENT = '21';

IFS=$'\n';
lists=( $(sqlite3 "$CAL_CACHE_DB"<<EOF
.echo off
.headers off
.nullvalue " "
.separator "\t"
    SELECT '"' || ztitle || '"'
    FROM znode
    WHERE zistaskcontainer=1;
EOF
) );

# Get reminders that aren't completed.
#    SELECT strftime('%Y-%m-%d %H:%M:%S',$DUEDATE,'unixepoch') as dueDate,

# Catalina
# SELECT Z_PK, Z_ENT, ZTITLE1, ZCOMPLETED, ZDUEDATE
# FROM ZREMCDOBJECT
# WHERE ZLIST = 1404
# AND ZCOMPLETED = 0;

IFS=$'\n';
reminders=( $(sqlite3 "$CAL_CACHE_DB"<<EOF
.echo off
.headers on
.nullvalue " "
.separator "\t"
    SELECT strftime('%Y-%m-%dT%H:%M:%S',$DUEDATE,'unixepoch') as dueDate,
        zpriority AS priority,
        rem.ztitle AS title,
        cal.ztitle AS list,
        rem.znotes AS notes,
        $DUEDATE - $NOW AS secondsLeft
    FROM $CALTABLE rem LEFT JOIN znode cal ON rem.zcalendar=cal.z_pk
    WHERE rem.z_ent=$REMCODE
        AND zcompleteddate IS NULL
    ORDER BY CASE WHEN zduedate IS NULL THEN 1 ELSE 0 END, zduedate, zpriority;
EOF
) );

# Get field names
IFS=$'\t';
fields=( "${reminders[0]}" );

# Construct JSON
json=""
row_json=()
for (( i=1; i<${#reminders[@]}; i++ ))
do
    values=( "${reminders[$i]}" );
    value_json=()
    for (( j=0; j<${#fields[@]}; j++ ))
    do
        esc_value=$( echo ${values[$j]} | sed -e 's/"/\\"/g' )
        value_json[$j]=" \"${fields[$j]}\":  \"$esc_value\"";
    done;
    tmp=$( join "," "${value_json[@]}" );
    # $i-1 because original reminders array includes a header row.
    row_json[$i-1]="{$tmp }";
done;
listnames=$( join "," "${lists[@]}" )
tmp=$( join "," "${row_json[@]}" );
json="{ \"tasks\": [ $tmp ], \"lists\": [$listnames] }";
echo $json

