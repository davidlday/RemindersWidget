-- A set of queries used to explore the Reminders Datastores

SELECT * FROM Z_PRIMARYKEY WHERE Z_NAME = 'REMCDList';

SELECT Z_ENT, ZNAME, ZNAME1 FROM ZREMCDOBJECT;

SELECT COUNT(*) FROM ZREMCDOBJECT WHERE Z_ENT = 21 AND ZCKIDENTIFIER IS NOT NULL AND Z_OPT > 1;

SELECT COUNT(*) FROM ZREMCDOBJECT WHERE Z_ENT = 21;

-- Seems to be a good enough test for whether the datastore has Reminders lists.
SELECT COUNT(*) FROM ZREMCDOBJECT WHERE Z_ENT = (SELECT Z_ENT FROM Z_PRIMARYKEY WHERE Z_NAME = 'REMCDList');

SELECT * FROM ZREMCDOBJECT WHERE Z_ENT = 21;

SELECT Z_ENT, ZCKIDENTIFIER, ZNAME, ZNAME1, Z_OPT FROM ZREMCDOBJECT WHERE Z_ENT = 21;

SELECT * from Z_METADATA;

SELECT * FROM Z_PRIMARYKEY;
