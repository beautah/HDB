echo Enter name of local database:
read db_name

echo Enter dba name at local installation:
read dba_name

echo Enter dba Oracle password:
read psswd

echo Running create_syn_syns_master.sql
sqlplus $dba_name/$psswd @../create_syn_syns_master.sql $db_name $dba_name > create_syn_syns_master.out

echo "**********************"
echo "Check output in create_syn_syns_master.out; ok to continue? (y or n)"
read answer
if test $answer != y; then
  echo Fix problems as necessary, then re-run.
  echo Exiting...
  exit
fi

echo Running pop_pk.sps
sqlplus $dba_name/$psswd @../../pop_pk.sps $dba_name $dba_name $db_name > pop_pk.sps.out

echo "**********************"
echo "Check output in pop_pk.sps.out; ok to continue? (y or n)"
read answer
if test $answer != y; then
  echo Fix problems as necessary, then re-run.
  echo Exiting...
  exit
fi

echo Running pop_pk.spb
sqlplus $dba_name/$psswd < ../../pop_pk.spb > pop_pk.spb.out

echo "**********************"
echo "Check output in pop_pk.spb.out; ok to continue? (y or n)"
read answer
if test $answer != y; then
  echo Fix problems as necessary, then re-run.
  echo Exiting...
  exit
fi

echo Ready to run ../gen_trigs.sql
echo Take a quick look and make sure the WHERE clause includes all tables
echo whose primary key is a single integer that should be
echo automatically generated on insert of a new row.
echo When you have verified that the script is correct, press any key.
read answer

echo Running ../gen_trigs.sql
sqlplus $dba_name/$psswd @../gen_trigs.sql > gen_trigs.out

echo "**********************"
echo "Check output in gen_trigs.out; ok to continue? (y or n)"
read answer
if test $answer != y; then
  echo Fix problems as necessary, then re-run.
  echo Exiting...
  exit
fi

echo Running get_pk_val_wrap.sql
sqlplus $dba_name/$psswd < ../../get_pk_val_wrap.sql > get_pk_val_wrap.out

echo "**********************"
echo "Check output in get_pk_val_wrap.out; ok to continue? (y or n)"
read answer
if test $answer != y; then
  echo Fix problems as necessary, then re-run.
  echo Exiting...
  exit
fi

echo Running cg_ref_codes.ddl
sqlplus $dba_name/$psswd < ../../cg_ref_codes.ddl > cg_ref_codes.out

echo "**********************"
echo "Check output in cg_ref_codes.out; ok to continue? (y or n)"
read answer
if test $answer != y; then
  echo Fix problems as necessary, then re-run.
  echo Exiting...
  exit
fi

echo Running V_DT_UT.sql
sqlplus $dba_name/$psswd < ../../V_DT_UT.sql > V_DT_UT.out

echo "**********************"
echo "Check output in V_DT_UT.out; ok to continue? (y or n)"
read answer
if test $answer != y; then
  echo Fix problems as necessary, then re-run.
  echo Exiting...
  exit
fi

echo Running V_SITEDT.sql
sqlplus $dba_name/$psswd < ../../V_SITEDT.sql > V_SITEDT.out

echo "**********************"
echo "Check output in V_SITEDT.out; ok to continue? (y or n)"
read answer
if test $answer != y; then
  echo Fix problems as necessary, then re-run.
  echo Exiting...
  exit
fi

echo Running V_DBA_ROLES.sql
sqlplus '$dba_name/$passwd as sysdba' < ../../V_DBA_ROLES.sql > V_DBA_ROLES.out

echo "**********************"
echo "Check output in V_DBA_ROLES.out; ok to continue? (y or n)"
read answer
if test $answer != y; then
  echo Fix problems as necessary, then re-run.
  echo Exiting...
  exit
fi

echo Running ../../ref_installation.ddl
sqlplus $dba_name/$psswd  @../../ref_installation.ddl island > ref_installation.out

echo "**********************"
echo "Check output in ref_installation.out; ok to continue? (y or n)"
read answer
if test $answer != y; then
  echo Fix problems as necessary, then re-run.
  echo Exiting...
  exit
fi

echo "** Island installation created. **"
exit


