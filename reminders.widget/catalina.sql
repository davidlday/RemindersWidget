-- Get the Z_ENT for Lists
SELECT Z_ENT
FROM Z_PRIMARYKEY
WHERE Z_NAME = 'REMCDReminder';
-- Returns 21 on my machine

-- Get a list of Lists
SELECT Z_PK, ZNAME1
FROM ZREMCDOBJECT
WHERE Z_ENT = '21';
-- My 'Personal' list is 1382

-- Get all incompleted items for a list
SELECT Z_PK, Z_ENT, ZTITLE1, ZCOMPLETED, ZDUEDATE
FROM ZREMCDOBJECT
WHERE ZLIST = 1382
AND ZCOMPLETED = 0;
