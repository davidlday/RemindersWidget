CREATE TABLE ZREMCDOBJECT ( Z_PK INTEGER PRIMARY KEY,
	Z_ENT INTEGER,
	Z_OPT INTEGER,
	ZCKDIRTYFLAGS INTEGER,
	ZCKNEEDSINITIALFETCHFROMCLOUD INTEGER,
	ZCKNEEDSTOBEFETCHEDFROMCLOUD INTEGER,
	ZMARKEDFORDELETION INTEGER,
	ZMINIMUMSUPPORTEDAPPVERSION INTEGER,
	ZACCOUNT INTEGER,
	ZCKCLOUDSTATE INTEGER,
	ZDAALLOWSCALENDARADDDELETEMODIFY INTEGER,
	ZDASUPPORTSSHAREDCALENDARS INTEGER,
	ZDAWASMIGRATED INTEGER,
	ZDIDCHOOSETOMIGRATE INTEGER,
	ZDIDCHOOSETOMIGRATELOCALLY INTEGER,
	ZDIDFINISHMIGRATION INTEGER,
	ZINACTIVE INTEGER,
	ZTYPE INTEGER,
	ZREMINDER INTEGER,
	ZTRIGGER INTEGER,
	Z6_TRIGGER INTEGER,
	ZALARM INTEGER,
	ZPROXIMITY INTEGER,
	ZEVENT INTEGER,
	ZREMINDER1 INTEGER,
	ZFILESIZE INTEGER,
	ZHEIGHT INTEGER,
	ZWIDTH INTEGER,
	ZREMINDER2 INTEGER,
	ZOWNER INTEGER,
	ZDADISPLAYORDER INTEGER,
	ZDAISEVENTONLYCONTAINER INTEGER,
	ZDAISIMMUTABLE INTEGER,
	ZDAISNOTIFICATIONSCOLLECTION INTEGER,
	ZDAISREADONLY INTEGER,
	ZISGROUP INTEGER,
	ZSHARINGSTATUS INTEGER,
	ZSHOWINGLARGEATTACHMENTS INTEGER,
	ZPARENTACCOUNT INTEGER,
	ZPARENTLIST INTEGER,
	ZSHAREDOWNER INTEGER,
	ZFIRSTDAYOFTHEWEEK INTEGER,
	ZFREQUENCY INTEGER,
	ZINTERVAL INTEGER,
	ZOCCURRENCECOUNT INTEGER,
	ZREMINDER3 INTEGER,
	ZALLDAY INTEGER,
	ZCOMPLETED INTEGER,
	ZDISPLAYDATEISALLDAY INTEGER,
	ZDISPLAYDATEUPDATEDFORSECONDSFROMGMT INTEGER,
	ZFLAGGED INTEGER,
	ZICSDISPLAYORDER INTEGER,
	ZPRIORITY INTEGER,
	ZLIST INTEGER,
	ZPARENTREMINDER INTEGER,
	ZACCESSLEVEL INTEGER,
	ZSTATUS INTEGER,
	ZLIST1 INTEGER,
	Z4REMINDERS INTEGER,
	Z_FOK_REMINDER INTEGER,
	Z_FOK_REMINDER1 INTEGER,
	Z_FOK_PARENTLIST INTEGER,
	Z_FOK_PARENTACCOUNT INTEGER,
	Z_FOK_REMINDER2 INTEGER,
	Z_FOK_LIST INTEGER,
	ZACKNOWLEDGEDDATE TIMESTAMP,
	ZLATITUDE FLOAT,
	ZLONGITUDE FLOAT,
	ZRADIUS FLOAT,
	ZTIMEINTERVAL FLOAT,
	ZLENGTH FLOAT,
	ZLASTUSERACCESSDATE TIMESTAMP,
	ZENDDATE TIMESTAMP,
	ZCOMPLETIONDATE TIMESTAMP,
	ZCREATIONDATE TIMESTAMP,
	ZDISPLAYDATEDATE TIMESTAMP,
	ZDUEDATE TIMESTAMP,
	ZLASTBANNERPRESENTATIONDATE TIMESTAMP,
	ZLASTMODIFIEDDATE TIMESTAMP,
	ZSTARTDATE TIMESTAMP,
	ZCKIDENTIFIER VARCHAR,
	ZCKZONEOWNERNAME VARCHAR,
	ZDAPUSHKEY VARCHAR,
	ZDASYNCTOKEN VARCHAR,
	ZEXTERNALIDENTIFIER VARCHAR,
	ZEXTERNALMODIFICATIONTAG VARCHAR,
	ZCKUSERRECORDNAME VARCHAR,
	ZDACONSTRAINTSDESCRIPTIONPATH VARCHAR,
	ZNAME VARCHAR,
	ZALARMUID VARCHAR,
	ZORIGINALALARMUID VARCHAR,
	ZADDRESS VARCHAR,
	ZCONTACTLABEL VARCHAR,
	ZLOCATIONUID VARCHAR,
	ZREFERENCEFRAMESTRING VARCHAR,
	ZROUTING VARCHAR,
	ZTITLE VARCHAR,
	ZUTI VARCHAR,
	ZFILENAME VARCHAR,
	ZTRANSCRIBEDTEXT VARCHAR,
	ZREMINDERIDENTIFIER VARCHAR,
	ZOLDEXTERNALIDENTIFIER VARCHAR,
	ZOLDLISTIDENTIFIER VARCHAR,
	ZOLDEXTERNALIDENTIFIER1 VARCHAR,
	ZOLDLISTIDENTIFIER1 VARCHAR,
	ZUUIDSTRING VARCHAR,
	ZBADGEEMBLEM VARCHAR,
	ZDAEXTERNALIDENTIFICATIONTAG VARCHAR,
	ZNAME1 VARCHAR,
	ZSHAREDOWNERADDRESS VARCHAR,
	ZSHAREDOWNERNAME VARCHAR,
	ZCKPARENTREMINDERIDENTIFIER VARCHAR,
	ZDACALENDARITEMUNIQUEIDENTIFIER VARCHAR,
	ZDISPLAYDATETIMEZONE VARCHAR,
	ZNOTES VARCHAR,
	ZTIMEZONE VARCHAR,
	ZTITLE1 VARCHAR,
	ZADDRESS1 VARCHAR,
	ZDISPLAYNAME VARCHAR,
	ZFIRSTNAME VARCHAR,
	ZLASTNAME VARCHAR,
	ZMIDDLENAME VARCHAR,
	ZNAMEPREFIX VARCHAR,
	ZNAMESUFFIX VARCHAR,
	ZNICKNAME VARCHAR,
	ZIDENTIFIER BLOB,
	ZURL VARCHAR,
	ZHOSTURL VARCHAR,
	ZICSURL VARCHAR,
	ZOWNINGLISTIDENTIFIER BLOB,
	ZRESOLUTIONTOKENMAP BLOB,
	ZRESOLUTIONTOKENMAP_V2_JSON BLOB,
	ZCOLOR BLOB,
	ZCKSERVERRECORDDATA BLOB,
	ZCKSERVERSHAREDATA BLOB,
	ZLISTIDSMERGEABLEORDERING BLOB,
	ZLISTIDSMERGEABLEORDERING_V2 BLOB,
	ZDATECOMPONENTSDATA BLOB,
	ZMAPKITHANDLE BLOB,
	ZMETADATA BLOB,
	ZDABULKREQUESTS BLOB,
	ZREMINDERIDSMERGEABLEORDERING BLOB,
	ZREMINDERIDSMERGEABLEORDERING_V2_JSON BLOB,
	ZDAYSOFTHEMONTH BLOB,
	ZDAYSOFTHEWEEK BLOB,
	ZDAYSOFTHEYEAR BLOB,
	ZMONTHSOFTHEYEAR BLOB,
	ZSETPOSITIONS BLOB,
	ZWEEKSOFTHEYEAR BLOB,
	ZCONTACTHANDLES BLOB,
	ZIMPORTEDICSDATA BLOB,
	ZNOTESDOCUMENT BLOB,
	ZSIRIFOUNDINAPPSDATA BLOB,
	ZTITLEDOCUMENT BLOB,
	ZUSERACTIVITY BLOB );
CREATE INDEX ZREMCDOBJECT_ZACCOUNT_INDEX ON ZREMCDOBJECT (ZACCOUNT);
CREATE INDEX ZREMCDOBJECT_ZCKCLOUDSTATE_INDEX ON ZREMCDOBJECT (ZCKCLOUDSTATE);
CREATE INDEX ZREMCDOBJECT_ZREMINDER_INDEX ON ZREMCDOBJECT (ZREMINDER);
CREATE INDEX ZREMCDOBJECT_ZTRIGGER_INDEX ON ZREMCDOBJECT (ZTRIGGER);
CREATE INDEX ZREMCDOBJECT_ZALARM_INDEX ON ZREMCDOBJECT (ZALARM);
CREATE INDEX ZREMCDOBJECT_ZREMINDER1_INDEX ON ZREMCDOBJECT (ZREMINDER1);
CREATE INDEX ZREMCDOBJECT_ZREMINDER2_INDEX ON ZREMCDOBJECT (ZREMINDER2);
CREATE INDEX ZREMCDOBJECT_ZOWNER_INDEX ON ZREMCDOBJECT (ZOWNER);
CREATE INDEX ZREMCDOBJECT_ZPARENTACCOUNT_INDEX ON ZREMCDOBJECT (ZPARENTACCOUNT);
CREATE INDEX ZREMCDOBJECT_ZPARENTLIST_INDEX ON ZREMCDOBJECT (ZPARENTLIST);
CREATE INDEX ZREMCDOBJECT_ZSHAREDOWNER_INDEX ON ZREMCDOBJECT (ZSHAREDOWNER);
CREATE INDEX ZREMCDOBJECT_ZREMINDER3_INDEX ON ZREMCDOBJECT (ZREMINDER3);
CREATE INDEX ZREMCDOBJECT_ZLIST_INDEX ON ZREMCDOBJECT (ZLIST);
CREATE INDEX ZREMCDOBJECT_ZPARENTREMINDER_INDEX ON ZREMCDOBJECT (ZPARENTREMINDER);
CREATE INDEX ZREMCDOBJECT_ZLIST1_INDEX ON ZREMCDOBJECT (ZLIST1);
CREATE INDEX ZREMCDOBJECT_Z4REMINDERS_INDEX ON ZREMCDOBJECT (Z4REMINDERS);
CREATE INDEX ZREMCDOBJECT_Z_ENT_INDEX ON ZREMCDOBJECT (Z_ENT);
CREATE INDEX Z_REMCDObject_ckIdentifier ON ZREMCDOBJECT (ZCKIDENTIFIER COLLATE BINARY ASC);
CREATE INDEX Z_REMCDObject_ckDirtyFlags ON ZREMCDOBJECT (ZCKDIRTYFLAGS COLLATE BINARY ASC);
CREATE UNIQUE INDEX Z_REMCDObject_UNIQUE_identifier ON ZREMCDOBJECT (ZIDENTIFIER COLLATE BINARY ASC);
CREATE UNIQUE INDEX Z_REMCDObject_UNIQUE_externalIdentifier ON ZREMCDOBJECT (ZEXTERNALIDENTIFIER COLLATE BINARY ASC);
CREATE INDEX Z_REMCDList_byParentAccount ON ZREMCDOBJECT (Z_ENT COLLATE BINARY ASC,
	ZMARKEDFORDELETION COLLATE BINARY ASC,
	ZPARENTACCOUNT COLLATE BINARY ASC);
CREATE INDEX Z_REMCDReminder_byScheduledIndex ON ZREMCDOBJECT (ZCOMPLETED COLLATE BINARY ASC,
	ZMARKEDFORDELETION COLLATE BINARY ASC);
CREATE INDEX Z_REMCDReminder_byFlaggedIndex ON ZREMCDOBJECT (Z_ENT COLLATE BINARY ASC,
	ZFLAGGED COLLATE BINARY ASC);