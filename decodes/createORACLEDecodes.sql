-- $Id: createORACLEDecodes.sql,v 1.4 2006/05/23 18:04:32 hdba Exp $
--
-- $Source: /projects/hdb/hdb2/builds.cvs/decodes/createORACLEDecodes.sql,v $
--
-- $State: Exp $
--
-- $Log: createORACLEDecodes.sql,v $
-- Revision 1.4  2006/05/23 18:04:32  hdba
-- mods for decodes phase 0 re-development effort
--
-- Revision 1.3  2006/03/17 18:58:25  hdba
-- change for ilex code for databaseversion table name change
--
-- Revision 1.2  2006/03/01 22:46:00  hdba
-- mod for tables creation due to decode changes
--
-- Revision 1.1  2006/01/04 16:58:18  hdba
-- new files and documentation to add phase 0 to cvs
--
-- Revision 1.7  2004/04/27 17:46:49  mjmaloney
-- For DECODES 6.1, added time zone to transport medium.
--
-- Revision 1.6  2004/02/05 21:50:25  mjmaloney
-- final release prep for 6.0
--
-- Revision 1.5  2003/11/17 14:55:27  mjmaloney
-- Table definitions modified for DECODES Version 6.
-- Sequences moved to separate SQL script file.
--
-- Revision 1.4  2002/10/30 18:47:09  mjmaloney
-- Added comments for release.
--
-- Revision 1.3  2002/10/17 18:39:32  mjmaloney
-- Changed TEXT to VARCHAR in all cases for SQL standard.
--
-- Revision 1.2  2002/10/11 19:52:32  mjmaloney
-- cleanup
--
-- Revision 1.1  2002/10/10 13:07:41  mjmaloney
-- Added createDecodesDb
--
-- Revision 1.20  2002/10/06 14:23:58  mjmaloney
-- SQL Development.
--
-- Revision 1.19  2002/10/04 13:32:12  mjmaloney
-- SQL dev.
--
-- Revision 1.18  2002/10/01 01:09:22  mjmaloney
-- SQL dev.
--
-- Revision 1.17  2002/09/24 13:20:34  mjmaloney
-- SQL dev
--
-- Revision 1.16  2002/09/22 18:39:55  mjmaloney
-- SQL Dev.
--
-- Revision 1.14  2002/09/20 12:59:07  mjmaloney
-- SQL Dev.
--
-- Revision 1.12  2002/09/17 11:37:30  mjmaloney
-- SQL dev.
--
-- Revision 1.11  2002/09/13 14:16:48  mjmaloney
-- Bug fixes.
--
-- Revision 1.10  2001/06/24 02:29:38  mike
-- dev
--
-- Revision 1.9  2001/03/17 01:00:39  mike
-- *** empty log message ***
--
-- Revision 1.8  2001/01/20 02:54:46  mike
-- dev
--
-- Revision 1.7  2001/01/04 01:33:32  mike
-- dev
--
-- Revision 1.6  2000/12/11 15:36:24  mike
-- dev
--
-- Revision 1.5  2000/12/09 22:13:08  mike
-- dev
--
-- Revision 1.4  2000/12/07 00:03:53  mike
-- dev
--
-- Revision 1.3  2000/12/06 13:24:15  mike
-- dev
--
-- Revision 1.2  2000/11/26 20:01:05  mike
-- *** empty log message ***
--
-- Revision 1.1  2000/11/24 19:34:26  mike
-- Initial implementation
--
--

-----------------------------------------------------------------------
-- Single record DecodesDatabaseVersion table.
-- If this table doesn't exist, it means the database < 6.0
-- Some SQL code acts differently depending on the database version.
-----------------------------------------------------------------------
CREATE TABLE DECODESDatabaseVersion
(
	version INTEGER NOT NULL,
	options  VARCHAR(400)
) tablespace HDB_data;

INSERT into DECODESDatabaseVersion VALUES(7, NULL) ;

/*  remove from HDB creation due to existing hdb tables
-----------------------------------------------------------------------
-- Sites & Site Names
-----------------------------------------------------------------------

CREATE TABLE Site
(
	id INTEGER NOT NULL,
	latitude VARCHAR(24),
	longitude VARCHAR(24),
	nearestCity VARCHAR(64),
	state VARCHAR(24),
	region VARCHAR(64),
	timezone VARCHAR(64),
	country VARCHAR(64),
	elevation FLOAT,
	elevUnitAbbr VARCHAR(24),
	description VARCHAR(800)
) tablespace HDB_data;

-- Guarantees no two sites have the same ID:
CREATE UNIQUE INDEX Site_IdIdx on Site (id)  tablespace HDB_idx;

CREATE TABLE SiteName
(
	siteid INTEGER NOT NULL,
	nameType VARCHAR(24) NOT NULL,
	siteName VARCHAR(24) NOT NULL
) tablespace HDB_data;

-- Guarantees at most one site name of a given time per site.
CREATE UNIQUE INDEX SiteName_IdTypeIdx on SiteName (siteid, nameType)  tablespace HDB_idx;

end of removing comment  */

-----------------------------------------------------------------------
-- EquipmentModel & its properties.
-----------------------------------------------------------------------

CREATE TABLE EquipmentModel
(
	id INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	company VARCHAR(64),
	model VARCHAR(64),
	description VARCHAR(400),
	equipmentType VARCHAR(24)
) tablespace HDB_data;

-- Guarantees no two EquipmentModels have the same ID:
CREATE UNIQUE INDEX EquipmentModel_IdIdx on EquipmentModel (id)  tablespace HDB_idx;

-- Guarantees no two EquipmentModels have the same name:
CREATE UNIQUE INDEX EquipmentModel_NmIdx on EquipmentModel (name)  tablespace HDB_idx;

CREATE TABLE EquipmentProperty
(
	equipmentId INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	value VARCHAR(240) NOT NULL
) tablespace HDB_data;

-- Guarantees property names are unique within an EquipmentModel:
CREATE UNIQUE INDEX EquipmentProperty_IdNameIdx 
	on EquipmentProperty (equipmentId, name)  tablespace HDB_idx;


-----------------------------------------------------------------------
-- Enumeration & its values
-----------------------------------------------------------------------

CREATE TABLE Enum
(
	id INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	defaultValue VARCHAR(24)
) tablespace HDB_data;

-- Guarantees no two Enums have the same ID:
CREATE UNIQUE INDEX EnumIdIdx on Enum(id)  tablespace HDB_idx;

CREATE TABLE EnumValue
(
	enumId INTEGER NOT NULL,
	enumValue VARCHAR(24) NOT NULL,
	description VARCHAR(400),
	execClass VARCHAR(160),
	editClass VARCHAR(160),
	sortNumber INTEGER
) tablespace HDB_data;

-- Guarantees each EnumValue is unique within an Enum.
CREATE UNIQUE INDEX EnumValueIdx on EnumValue(enumId, enumValue);

-----------------------------------------------------------------------
-- Data Types & Equivalences
-----------------------------------------------------------------------

CREATE TABLE DataType 
(
	id INTEGER NOT NULL,
	standard VARCHAR(24) NOT NULL,
	code VARCHAR(24) NOT NULL
) tablespace HDB_data;

-- Guarantees no two DataTypes have the same ID:
CREATE UNIQUE INDEX DataType_IdIdx on DataType (id)  tablespace HDB_idx;

-- Guarantees no two DataTypes have the same standard & code:
CREATE UNIQUE INDEX DataTypeCode_IdIdx on DataType (standard, code)  tablespace HDB_idx;


-- An entry in the DataTypeEquivalence table says that the two 
-- data types represent the same type of data, but in different standards.
-- For example EPA 00063 is equivalent to SHEF HG
CREATE TABLE DataTypeEquivalence
(
	id0 INTEGER NOT NULL,
	id1 INTEGER NOT NULL
) tablespace HDB_data;

-- Guarantees that each equivalence assertion is unique.
CREATE UNIQUE INDEX DataTypeEquivalence_Id1Idx 
	on DataTypeEquivalence (id0, id1)  tablespace HDB_idx;


-----------------------------------------------------------------------
-- Platforms & Platform Sensors
-----------------------------------------------------------------------

CREATE TABLE Platform
(
	id INTEGER NOT NULL,
	agency VARCHAR(64),
	isProduction VARCHAR(5) DEFAULT 'FALSE',
	siteId INTEGER,
	configId INTEGER,
	description VARCHAR(400),
	lastModifyTime TIMESTAMP WITH TIME ZONE,
	expiration TIMESTAMP WITH TIME ZONE,
        platformDesignator VARCHAR(24)
) tablespace HDB_data;

CREATE TABLE PlatformProperty
(
	platformId INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	value VARCHAR(240) NOT NULL
) tablespace HDB_data;

-- Guarantees no two Platforms have the same ID:
CREATE UNIQUE INDEX Platform_IdIdx on Platform (id)  tablespace HDB_idx;

CREATE TABLE PlatformSensor
(
	platformId INTEGER NOT NULL,
	sensorNumber INTEGER NOT NULL,
	siteId INTEGER,
        dd_nu INTEGER
) tablespace HDB_data;

CREATE TABLE PlatformSensorProperty
(
	platformId INTEGER NOT NULL,
	sensorNumber INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	value VARCHAR(240) NOT NULL
) tablespace HDB_data;

CREATE TABLE TransportMedium
(
	platformId INTEGER NOT NULL,
	mediumType VARCHAR(24) NOT NULL,
	mediumId VARCHAR(64),   -- Holds DCP address or other identifier
	scriptName VARCHAR(24), -- soft link to script in this platform's config.
	channelNum INTEGER,
	assignedTime INTEGER,
	transmitWindow INTEGER,
	transmitInterval INTEGER,
	equipmentId INTEGER,
	timeAdjustment INTEGER,
	preamble CHAR,
	timeZone VARCHAR(64)
) tablespace HDB_data;

-- Guarantees no two TransportMedia have same type and ID.
CREATE UNIQUE INDEX TransportMediumIdx on TransportMedium(mediumType,mediumId) tablespace HDB_idx;

-----------------------------------------------------------------------
-- Platform Configurations & Subordinate Entities
-----------------------------------------------------------------------

CREATE TABLE PlatformConfig
(
	id INTEGER NOT NULL,
	name VARCHAR(64) NOT NULL,
	description VARCHAR(400),
	equipmentId INTEGER
) tablespace HDB_data;

-- Guarantees no two PlatformConfigs have the same ID:
CREATE UNIQUE INDEX PlatformConfigIdIdx on PlatformConfig(id) tablespace HDB_idx;

-- Guarantees no two PlatformConfigs have the same name:
CREATE UNIQUE INDEX PlatformConfigNameIdx on PlatformConfig(name) tablespace HDB_idx;

CREATE TABLE ConfigSensor
(
	configId INTEGER NOT NULL,
	sensorNumber INTEGER NOT NULL,
	sensorName VARCHAR(64),
	recordingMode CHAR,
	recordingInterval INTEGER,     -- # seconds
	timeOfFirstSample INTEGER,     -- second of day
	equipmentId INTEGER,
	absoluteMin FLOAT,
	absoluteMax FLOAT,
        stat_cd VARCHAR(5)
) tablespace HDB_data;

-- This relation associates a data type with a sensor.
-- A sensor may have mulptiple data types, but only one for each standard.
CREATE TABLE ConfigSensorDataType
(
	configId INTEGER NOT NULL,
	sensorNumber INTEGER NOT NULL,
	dataTypeId INTEGER NOT NULL
) tablespace HDB_data;

CREATE TABLE ConfigSensorProperty
(
	configId INTEGER NOT NULL,
	sensorNumber INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	value VARCHAR(240) NOT NULL
) tablespace HDB_data;

-----------------------------------------------------------------------
-- Decoding Scripts & Subordinate Entities
-----------------------------------------------------------------------

CREATE TABLE DecodesScript
(
	id INTEGER NOT NULL,
	configId INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	type VARCHAR(24) NOT NULL,
	dataOrder CHAR         -- A=Ascending D=Descending
) tablespace HDB_data;

-- Guarantees no two DecodesScripts have the same ID:
CREATE UNIQUE INDEX DecodesScriptIdx on DecodesScript(id) tablespace HDB_idx;

-- Guarantees script names are unique within a PlatformConfig:
CREATE UNIQUE INDEX DecodesScriptNmIdx on DecodesScript(configId, name) tablespace HDB_idx;
 
CREATE TABLE FormatStatement
(
	decodesScriptId INTEGER NOT NULL,
	sequenceNum INTEGER NOT NULL,
	label VARCHAR(24) NOT NULL,
	format VARCHAR(400)
) tablespace HDB_data;

-- Guarantees each format statement has a unique sequence within a script:
CREATE UNIQUE INDEX FormatStatementIdx on 
	FormatStatement(decodesScriptId, sequenceNum) tablespace HDB_idx;

CREATE TABLE ScriptSensor
(
	decodesScriptId INTEGER NOT NULL,
	sensorNumber INTEGER NOT NULL,
	unitConverterId INTEGER
) tablespace HDB_data;

-- Guarantees each scriptsensor has unique number within a script:
CREATE UNIQUE INDEX ScriptSensorIdx on 
	ScriptSensor(decodesScriptId, sensorNumber);

-----------------------------------------------------------------------
-- Routing Specs 
-----------------------------------------------------------------------

CREATE TABLE RoutingSpec
(
	id INTEGER NOT NULL,
	name VARCHAR(64) NOT NULL,
	dataSourceId INTEGER,
	enableEquations VARCHAR(5) DEFAULT 'FALSE',
	usePerformanceMeasurements VARCHAR(5) DEFAULT 'FALSE',
	outputFormat VARCHAR(24),
	outputTimeZone VARCHAR(64),
	presentationGroupName VARCHAR(64),
	sinceTime VARCHAR(80),
	untilTime VARCHAR(80),
	consumerType VARCHAR(24),
	consumerArg VARCHAR(400),
	lastModifyTime TIMESTAMP WITH TIME ZONE,
	isProduction VARCHAR(5) DEFAULT 'FALSE'
) tablespace HDB_data;

-- Guarantees no two RoutingSpecs have the same ID:
CREATE UNIQUE INDEX RoutingSpecIdIdx on RoutingSpec(id) tablespace HDB_idx;

-- Guarantees no two RoutingSpecs have the same name:
CREATE UNIQUE INDEX RoutingSpecNmIdx on RoutingSpec(name) tablespace HDB_idx;

-- Associates a routing spec to a network list:
CREATE TABLE RoutingSpecNetworkList
(
	routingSpecId INTEGER NOT NULL,
	networkListName VARCHAR(64) NOT NULL
) tablespace HDB_data;

CREATE TABLE RoutingSpecProperty
(
	routingSpecId INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	value VARCHAR(240) NOT NULL
) tablespace HDB_data;


-----------------------------------------------------------------------
-- Data Sources
-----------------------------------------------------------------------

CREATE TABLE DataSource
(
	id INTEGER NOT NULL,
	name VARCHAR(64) NOT NULL,
	dataSourceType VARCHAR(24) NOT NULL,
	dataSourceArg VARCHAR(400)
) tablespace HDB_data;

-- Guarantees no two DataSources have the same ID:
CREATE UNIQUE INDEX DataSource_IdIdx on DataSource(id)  tablespace HDB_idx;

-- Guarantees no two DataSources have the same name:
CREATE UNIQUE INDEX DataSource_NmIdx on DataSource(name)  tablespace HDB_idx;

CREATE TABLE DataSourceGroupMember
(
	groupId INTEGER NOT NULL,
	sequenceNum INTEGER NOT NULL,
	memberId INTEGER NOT NULL
) tablespace HDB_data;

-----------------------------------------------------------------------
-- Network Lists
-----------------------------------------------------------------------

CREATE TABLE NetworkList
(
	id INTEGER NOT NULL,
	name VARCHAR(64) NOT NULL,
	transportMediumType VARCHAR(24),
	siteNameTypePreference VARCHAR(24),
	lastModifyTime TIMESTAMP WITH TIME ZONE NOT NULL
) tablespace HDB_data;

-- Guarantees no two NetworkLists have the same ID:
CREATE UNIQUE INDEX NetworkList_IdIdx on NetworkList(id)  tablespace HDB_idx;

-- Guarantees no two NetworkLists have the same name:
CREATE UNIQUE INDEX NetworkList_NmIdx on NetworkList(name)  tablespace HDB_idx;

CREATE TABLE NetworkListEntry
(
	networkListId INTEGER NOT NULL,
	transportId VARCHAR(64) NOT NULL
) tablespace HDB_data;


-----------------------------------------------------------------------
-- Presentation Groups
-----------------------------------------------------------------------

CREATE TABLE PresentationGroup
(
	id INTEGER NOT NULL,
	name VARCHAR(64) NOT NULL,
	inheritsFrom INTEGER,
	lastModifyTime TIMESTAMP WITH TIME ZONE,
	isProduction VARCHAR(5) DEFAULT 'false'
) tablespace HDB_data;

-- Guarantees no two PresentationGroups have the same ID:
CREATE UNIQUE INDEX PresGrp_IdIdx on PresentationGroup(id) tablespace HDB_idx;

-- Guarantees no two PresentationGroups have the same name:
CREATE UNIQUE INDEX PresGrp_NmIdx on PresentationGroup(name) tablespace HDB_idx;

CREATE TABLE DataPresentation
(
	id INTEGER NOT NULL,
	groupId INTEGER NOT NULL,
	dataTypeId INTEGER,
	unitAbbr VARCHAR(24),
	equipmentId INTEGER,
	maxDecimals INTEGER
) tablespace HDB_data;

CREATE TABLE RoundingRule
(
	dataPresentationId INTEGER NOT NULL,
	upperLimit FLOAT,
	sigDigits INTEGER NOT NULL
) tablespace HDB_data;

-----------------------------------------------------------------------
-- Engineering Units and Conversions
-----------------------------------------------------------------------
/*  remove due to HDB equivalency table

CREATE TABLE EngineeringUnit
(
	unitAbbr VARCHAR(24) NOT NULL,
	name VARCHAR(64) NOT NULL,
	family VARCHAR(24),
	measures VARCHAR(24)
) tablespace HDB_data;

-- Guarantees no two EngineeringUnits have the same abbreviation:
CREATE UNIQUE INDEX EUAbbrIdx on EngineeringUnit(unitAbbr) tablespace HDB_idx;

  end of remove comment   */


CREATE TABLE UnitConverter
(
	id INTEGER NOT NULL,
	fromUnitsAbbr VARCHAR(24),
	toUnitsAbbr VARCHAR(24),
	algorithm VARCHAR(24),
	-- Meaning of coeffients depends on the algorithm:
	a FLOAT,
	b FLOAT,
	c FLOAT,
	d FLOAT,
	e FLOAT,
	f FLOAT
) tablespace HDB_data;

-- Guarantees no two UnitConverters have the same ID:
CREATE UNIQUE INDEX UnitConverterIdIdx on UnitConverter(id) tablespace HDB_idx;

-- Note: We DON'T put a unique index on from/to abbreviations because
-- Raw converters all have "raw" as the from abbreviation. Many
-- different raw converters may have the same from/to values.

exit;
