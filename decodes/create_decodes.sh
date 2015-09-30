
echo "Have you installed the DECODES Application in your environment? (y/n)"
read answer

if test $answer != y
    then exit
fi


echo "Have you set ORACLE_SID in your environment? (y/n)"
read answer

if test $answer != y
    then exit
fi

echo Enter DBA user name:
read dba_name
echo Enter DBA user password:
read passwd

# remove any previous out files that may exist
/usr/bin/rm *.out 

# The following calls create the users, and  database objects
# needed to implement new HDB DECODES schema.
# this implementation assumes a fully functional HDB database
# including the generic mapping tables already installed

sqlplus $dba_name/$passwd   @./decodes_prelims.sql;
sqlplus $dba_name/$passwd   @./decodes_tbl_changes.sql;
sqlplus decodes/decodes @./createORACLEDecodes.sql;
sqlplus decodes/decodes @./createORACLEDecodesSequences.sql;
sqlplus decodes/decodes @./set_decodes_privs.sql;
sqlplus $dba_name/$passwd   @./write_to_hdb.prc;

sqlplus $dba_name/$passwd   @./disable_site_views.sql;
grep ERROR *.out

echo "Importing Enumerations from edit-db ..."
dbimport edit-db/enum/EnumList.xml
echo "Importing Standard Engineering Units and Conversions from edit-db ..."
dbimport edit-db/eu/EngineeringUnitList.xml
echo "Importing Standard Data Types from edit-db ..."
dbimport edit-db/datatype/DataTypeEquivalenceList.xml
echo "Importing SHEF English Presentation Group ..."
dbimport edit-db/presentation/SHEF-English.xml

sqlplus $dba_name/$passwd   @./enable_site_views.sql;

bin/copyHdbDataTypes

