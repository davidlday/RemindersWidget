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

# Figure out calendar table
CALTABLE=$(sqlite3 $HOME/Library/Calendars/Calendar\ Cache \
    "SELECT name FROM sqlite_master WHERE name IN ('ZICSELEMENT','ZCALENDARITEM')");

# Get REMCODE for Tasks
REMCODE=$(sqlite3 $HOME/Library/Calendars/Calendar\ Cache \
    "SELECT z_ent FROM z_primarykey WHERE z_name = 'Task'");

# Location Table (not sure why this is here)
LOCN=$(sqlite3 $HOME/Library/Calendars/Calendar\ Cache \
    ".tables ZLOCATION%");

# Now. Duh.
NOW=$(date +%s);

# Time Zone Offset
ZONERESET=$(date +%z | awk \
    '{if (substr($1,1,1)!="+") {printf "+"} else {printf "-"} print substr($1,2,4)}');

# Reminders year sero in seconds since epoch (I think).
YEARZERO=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "2001-01-01 0:0:0 $ZONERESET" "+%s");

# Due date in seconds since epoch (I think).
DUEDATE="($YEARZERO + zduedate)";

# Get all list names
IFS=$'\n';
lists=( $(sqlite3 $HOME/Library/Calendars/Calendar\ Cache<<EOF
.echo off
.headers off
.nullvalue " "
.separator "\t"
    SELECT '"' || ztitle || '"'
    FROM znode
    WHERE z_ent=42
        AND zistaskcontainer=1;
EOF
) );

# Get reminders that aren't completed.
IFS=$'\n';
reminders=( $(sqlite3 $HOME/Library/Calendars/Calendar\ Cache<<EOF
.echo off
.headers on
.nullvalue " "
.separator "\t"
    SELECT strftime('%Y-%m-%d %H:%M:%S',$DUEDATE,'unixepoch') as dueDate,
        zpriority AS priority,
        rem.ztitle AS title,
        cal.ztitle AS list
    FROM $CALTABLE rem LEFT JOIN znode cal ON rem.zcalendar=cal.z_pk
    WHERE rem.z_ent=$REMCODE
        AND zcompleteddate IS NULL
    ORDER BY zduedate, zpriority;
EOF
) );

# Get field names
IFS=$'\t';
fields=( ${reminders[0]} );

# Construct JSON
json=""
row_json=()
for (( i=1; i<${#reminders[@]}; i++ ))
do
    values=( ${reminders[$i]} );
    value_json=()
    for (( j=0; j<${#fields[@]}; j++ ))
    do
        esc_value=$( echo ${values[$j]} | sed -e 's/"/\\"/g' )
        value_json[$j]=" \"${fields[$j]}\":  \"$esc_value\"";
    done;
    tmp=$( join "," ${value_json[@]} );
    # $i-1 because original reminders array includes a header row.
    row_json[$i-1]="{$tmp }";
done;
listnames=$( join "," ${lists[@]} )
tmp=$( join "," ${row_json[@]} );
json="{ \"tasks\": [ $tmp ], \"lists\": [$listnames] }";
echo $json


# sqlite3 $HOME/Library/Calendars/Calendar\ Cache \
#     "SELECT  strftime('%w|%m|%d|%Y',$DUEDATE,'unixepoch'), zpriority, rem.ztitle, cal.ztitle \
# FROM $JOIN WHERE $DATEMATCHES ORDER BY zduedate, zpriority
# " | awk '
# function monthname(i) {
# return substr("JanFebMarAprMayJunJulAugSepOctNovDec",((i-1)*3)+1,3)
# }
# function dayname(i) {
# return substr("SunMonTueWedThuFriSat",(i*3)+1,3)
# }
# function priority(i) {
# 	p[0]="None"; p[1]="High"; p[5]="Medium"; p[9]="Low"; return p[i]
# }
# BEGIN {FS="\|"; nMonth=0; nDay=0}
# {
# if ((nMonth!=$2)||(nDay!=$3)) {nMonth=$2;nDay=$3;
# 	print dayname($1), monthname($2), $3, $4
# };
# printf "    • " $6
# if ($5!=0) {printf " [" priority($5) "]"}
# printf "\n"
# }'
