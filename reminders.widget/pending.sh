#!/bin/bash
# Original cribbed from http://www.macosxtips.co.uk/geeklets/productivity/ical-reminders/
# Updated for Catalina

# Constants for reuse.
REMINDERS_STORES="$HOME/Library/Reminders/Container_v1/Stores";
SQL_GET_Z_ENT="SELECT Z_ENT FROM Z_PRIMARYKEY WHERE Z_NAME = 'REMCDList'";

# http://stackoverflow.com/questions/1527049/bash-join-elements-of-an-array
function join {
    local IFS="$1"; shift; echo "$*";
}

# Test to see if it's the correct Reminders datastore.
# The simplest test seems to be to count the number of rows
# of REMCDList entities that also have ZCKIDENTIFIER
function test_db {
  sqlite3 "$1" \
    "SELECT COUNT(*) FROM ZREMCDOBJECT WHERE Z_ENT = ($SQL_GET_Z_ENT) AND ZCKIDENTIFIER IS NOT NULL;";
}

# Get a list of datastore files and test each one for Reminder lists.
function find_db {
  # Exclude "Data-local.sqlite"
  for DBFILE in "$REMINDERS_STORES"/Data-*-*.sqlite;
  do
    DB="file:$DBFILE?mode=ro";
    COUNT=$(test_db "$DB")
    if [ "$COUNT" -gt 0 ];
    then
      echo "$DB";
      break;
    fi
  done;
}

# Get the Reminders datastore.
# Consider caching the name of the file to avoid hitting these each time.
REMINDERS_DB="$(find_db)"

# Catalina - get Z_ENT for Lists
Z_ENT_LISTS=$(sqlite3 "$REMINDERS_DB" "$SQL_GET_Z_ENT;");

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
    WHERE Z_ENT=$Z_ENT_LISTS
    AND ZMARKEDFORDELETION = 0;
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
    WHERE LIST.Z_ENT = $Z_ENT_LISTS
        AND TASK.ZCOMPLETED = 0
        AND LIST.ZMARKEDFORDELETION = 0
        AND TASK.ZMARKEDFORDELETION = 0
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

