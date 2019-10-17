#!/bin/bash
# Original cribbed from http://www.macosxtips.co.uk/geeklets/productivity/ical-reminders/
# Updated for Catalina

# http://stackoverflow.com/questions/1527049/bash-join-elements-of-an-array
function join {
    local IFS="$1"; shift; echo "$*";
}

# Catalina
# File is in $HOME/Library/Reminders/Container_v1/Stores/
# Find the last updated *.sqlite file:
# https://stackoverflow.com/a/9052878/204032
REMINDERS_SQLITE=$(find "$HOME/Library/Reminders/Container_v1/Stores" -name "*.sqlite" -type f -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f2- -d" ")

# Reminders Database
REMINDERS_DB="file:$REMINDERS_SQLITE?mode=ro"

# Catalina - get Z_ENT for Lists
Z_ENT_LISTS=$(sqlite3 "$REMINDERS_DB" \
    "SELECT Z_ENT FROM Z_PRIMARYKEY WHERE Z_NAME = 'REMCDList';");

# Now. Duh.
NOW=$(date +%s);

# Time Zone Offset (i.e. +0500)
# ZONERESET=$(date +%z | awk \
#     '{if (substr($1,1,1)!="+") {printf "+"} else {printf "-"} print substr($1,2,4)}');

# Reminders year zero in seconds since epoch (I think). (i.e. 978289200)
# Adding timezone caused issues b/c JavaScript Date() uses the system to adjust.
YEARZERO=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "2001-01-01 0:0:0 +0000" "+%s");

# Used to figure out which ones are overdue
NOW=$(date "+%s")

# Get all list names
lists=()
while IFS='' read -r line; do lists+=("$line"); done < <(sqlite3 "$REMINDERS_DB"<<EOF
.echo off
.headers off
.nullvalue " "
.separator "\t"
    SELECT '"' || ZNAME1 || '"'
    FROM ZREMCDOBJECT
    WHERE Z_ENT=$Z_ENT_LISTS;
EOF
)

# Get all Reminders
reminders=()
while IFS='' read -r line; do reminders+=("$line"); done < <(sqlite3 "$REMINDERS_DB"<<EOF
.echo off
.headers on
.nullvalue " "
.separator "\t"
    SELECT strftime('%Y-%m-%dT%H:%M:%S',($YEARZERO + TASK.ZDUEDATE),'unixepoch') as dueDate,
        TASK.ZPRIORITY AS priority,
        TASK.ZTITLE1 AS title,
        LIST.ZNAME1 AS list,
        TASK.ZNOTES AS notes,
        ($YEARZERO + TASK.ZDUEDATE) - $NOW AS secondsLeft
    FROM ZREMCDOBJECT TASK LEFT JOIN ZREMCDOBJECT LIST on TASK.ZLIST = LIST.Z_PK
    WHERE LIST.Z_ENT=21
        AND TASK.ZCOMPLETED = 0
    ORDER BY CASE WHEN TASK.ZDUEDATE IS NULL THEN 1 ELSE 0 END, TASK.ZDUEDATE, TASK.ZPRIORITY;
EOF
)

# Get field names
IFS=$'\t' read -r -a fields <<< "${reminders[0]}"

# Construct JSON
json=""
row_json=()
for (( i=1; i<${#reminders[@]}; i++ ))
do
    # values=( "${reminders[$i]}" );
    IFS=$'\t' read -r -a values <<< "${reminders[$i]}"
    value_json=()
    for (( j=0; j<${#fields[@]}; j++ ))
    do
        # esc_value=$( echo ${values[$j]} | sed -e 's/"/\\"/g' )
        esc_value=${values[$j]//\"/\\\"/}
        value_json[$j]=" \"${fields[$j]}\":  \"$esc_value\"";
    done;
    tmp=$( join "," "${value_json[@]}" );
    # $i-1 because original reminders array includes a header row.
    row_json[$i-1]="{$tmp }";
done;
listnames=$( join "," "${lists[@]}" )
tmp=$( join "," "${row_json[@]}" );
json="{ \"tasks\": [ $tmp ], \"lists\": [$listnames] }";
echo "$json"

