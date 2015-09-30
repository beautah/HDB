set echo on
spool decodes_prelims.out

drop role decodes_role;
create role decodes_role;

drop user decodes cascade;

create user decodes identified by decodes
default tablespace HDB_data quota unlimited on HDB_data
temporary tablespace HDB_temp;

grant decodes_role to decodes;
grant decodes_role to ref_meta_role;
grant app_role to decodes_role;

grant create session to decodes;
grant resource to decodes;
grant connect  to decodes;
grant dba  to decodes;
alter user decodes default role all;

spool off

exit;
