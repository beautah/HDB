set echo on
spool decodes_tbl_changes.out

/* inital hdb_unit mods not necessary due to incorporation with datatype rework project  */
/*  just saving the original unit table in case something goes wrong  */
/* create table hdb_unit_save as select * from hdb_unit;  */

/*  now the changes to the unit table to accommodate DECODE's stuff  */
/*  update hdb_unit set UNIT_COMMON_NAME = substr(UNIT_COMMON_NAME,1,24);  */

/*  alter table hdb_unit add (family varchar2(24));  */
/*  alter table hdb_unit  modify (unit_common_name varchar2(24));  */

/*  still create an index for the common name since decodes will use it as an abbreviation that must be unique  */
create unique index unit_abbr on hdb_unit (UNIT_COMMON_NAME) tablespace hdb_idx;  

/* The view against HDB_UNIT table is still needed to interface correctly with DECODES   */
/* now  create the view to make it look like a decodes table for the engineering unit table  */
/* and give the right permissions to this view  */
create or replace view unit_to_decodes_unit_view as
select a.unit_common_name "UNITABBR", a.unit_name "NAME",
a.family, b.dimension_name "MEASURES"
from hdb_unit a, hdb_dimension b
where a.dimension_id = b.dimension_id;

grant select on unit_to_decodes_unit_view to public;
grant insert,update,delete on unit_to_decodes_unit_view to decodes_role; 
create public synonym engineeringunit for unit_to_decodes_unit_view;


/*  modify the existing site table to accommodate DECODE's data element sizes */
alter table hdb_site  modify (lat   varchar2(24));
alter table hdb_site  modify (longi varchar2(24));
alter table hdb_site  modify (description varchar2(560));

/*  now for the DECODES's site table  */

/*  here's an extension table for decodes site information  */
CREATE TABLE DECODES_Site_ext
(
        site_id INTEGER NOT NULL,
        nearestCity VARCHAR(64),
        state VARCHAR(24),
        region VARCHAR(64),
        timezone VARCHAR(64),
        country VARCHAR(64),
        elevUnitAbbr VARCHAR(24)
) tablespace HDB_data;

ALTER TABLE DECODES_Site_ext
 ADD CONSTRAINT DECODES_Site_ext_PK PRIMARY KEY
  (SITE_ID)
using index tablespace hdb_idx;

ALTER TABLE DECODES_Site_ext ADD CONSTRAINT
 DECODES_Site_ext_FK1 FOREIGN KEY
  (SITE_ID) REFERENCES HDB_SITE
  (SITE_ID)
  ON DELETE CASCADE;

/* for now we will create an extension record for every site record currently
   out there.  Don't know if that's entirely necessary but its somewhere to start from  */
insert into DECODES_Site_ext (site_id) select site_id from hdb_site; 

/* now the view for the decodes site table  */
/* create the sites view for the decode site table  */
/* this view modified 12/13/06 by M.Bogner  to eliminate record redundancies  */

create or replace view SITE_TO_DECODES_SITE_VIEW as
select a.site_id "ID", a.lat "LATITUDE", a.longi "LONGITUDE",
b.nearestcity,b.state,b.region, b.timezone,b.country,a.elevation,b.elevunitabbr,
substr(a.site_name||chr(10)||a.description,1,801) "DESCRIPTION"
from hdb_site a, decodes_site_ext b, ref_db_list d
where a.site_id = b.site_id(+)
and d.db_site_code = a.db_site_code
and d.session_no = 1;


grant select on site_to_decodes_site_view to public;
grant insert,update,delete on site_to_decodes_site_view to decodes_role;
create public synonym site for site_to_decodes_site_view;

/* now the view for the DECODES sitename table  */

create or replace view site_to_decodes_name_view as
select siteid, nametype, sitename, dbnum, agency_cd from (
select a.hdb_site_id "SITEID",b.ext_site_code_sys_name "NAMETYPE", a.primary_site_code "SITENAME",
substr(substr(secondary_site_code,1,instr(secondary_site_code,'|')-1),1,2) "DBNUM",
substr(secondary_site_code,instr(secondary_site_code,'|')+1,5) "AGENCY_CD", f.sortnumber sortnum
from hdb_ext_site_code a, hdb_ext_site_code_sys b, hdb_site c, ref_db_list d, decodes.enum e, decodes.enumvalue f
where a.ext_site_code_sys_id = b.ext_site_code_sys_id and 
a.hdb_site_id = c.site_id and
c.db_site_code = d.db_site_code and
d.session_no = 1 and
e.name = 'SiteNameType' and
e.id = f.enumid and
f.enumvalue = b.ext_site_code_sys_name and 
b.ext_site_code_sys_name <> 'hdb'
union
select c.site_id,f.enumvalue,to_char(c.site_id),null,null,
f.sortnumber sortnum from
hdb_site c, decodes.enum e, decodes.enumvalue f, ref_db_list d where
e.name = 'SiteNameType' and
e.id = f.enumid and
f.enumvalue = 'hdb' and
c.db_site_code = d.db_site_code and
d.session_no = 1
order by sortnum);





grant select on site_to_decodes_name_view to public;
grant insert,update,delete on site_to_decodes_name_view to decodes_role;
create public synonym sitename for site_to_decodes_name_view;

/* now the view for the DECODES datatype table   */
/* removed for phase0 incompatibilities 5/15/2006 */
/*
create or replace view datatype_to_decodes_dt_view as
select b.hdb_datatype_id "ID", a.ext_data_code_sys_name "STANDARD", b.primary_data_code "CODE"
from hdb_ext_data_code_sys a, hdb_ext_data_code b
where a.ext_data_code_sys_id = b.ext_data_code_sys_id;

grant select on datatype_to_decodes_dt_view to public;
grant insert,update,delete on datatype_to_decodes_dt_view to decodes_role;
create public synonym datatype for datatype_to_decodes_dt_view;

 end of removed piece       */

/*  now prepopulate the hdb_ext_site_code_sys table with the three types of sites that DECODES allows  */
/*  assuming a 7 for the agen_id for all three records        */
/*  modify the agen_id to suit your database  */
insert into hdb_ext_site_code_sys (ext_site_code_sys_id,ext_site_code_sys_name,agen_id,model_id) values (0,'local',7,null);
insert into hdb_ext_site_code_sys (ext_site_code_sys_id,ext_site_code_sys_name,agen_id,model_id) values (0,'usgs',7,null);
insert into hdb_ext_site_code_sys (ext_site_code_sys_id,ext_site_code_sys_name,agen_id,model_id) values (0,'nwshb5',7,null);

/*  due to the way decodes works,  foreign key issues have arisen and a constraint must be disabled for   */
/*  system deletes in DECODES to work properly  */

/* this is now believed fixed by modification of the DECODES java code so I will comment it out
alter table hdb_ext_site_code disable constraint hdb_ext_site_code_fk2;
*/

/* now prepopulate  the hdb_ext_data_code_sys table with the three types of data code systems  */
/*  modify the agen_id to suit your database  */
insert into hdb_ext_data_code_sys (ext_data_code_sys_id,ext_data_code_sys_name,agen_id,model_id) values (0,'epa-code',7,null);
insert into hdb_ext_data_code_sys (ext_data_code_sys_id,ext_data_code_sys_name,agen_id,model_id) values (0,'shef-pe',7,null);
insert into hdb_ext_data_code_sys (ext_data_code_sys_id,ext_data_code_sys_name,agen_id,model_id) values (0,'hydstra-code',7,null);

-- populate the enumvalue table with an hdb value so that the sitename view will work correctly
-- only do the insert if the value is not there already
insert into enumvalue (enumid,enumvalue)
select id,'hdb' from enum where name='SiteNameType'
minus
select enumid,enumvalue from enum, enumvalue where enum.name='SiteNameType'
and enum.id=enumvalue.enumid and enumvalue = 'hdb';
 
spool off

/*  now handle anything here that generates sql statements so that this is not a spooling issues  */

/* now we need a hdb_site sequence for DECODES to work  */
@create_sequences hdb_site_sequence site_id hdb_site


set echo on
set feedback on
spool decodes_tbl_changes2.out

/*  create the synonymns and priveleges for the sequences previously created  */
grant select on hdb_site_sequence to decodes_role;
create public synonym SiteIdSeq for hdb_site_sequence;

/*  now handle all the additional and modified triggers */
/*  the insert trigger for hdb_site must be changed to allow the use of sequences

/*  the triggers for the decodes_site_view   */
@decodes_site.trg

/*  the triggers for the decodes_sitename_view   */
@decodes_sitename.trg

/*  the triggers for the engineering units view  */
/*  the triggers for engineering unit view are now obsolete due to the CZAR strategy employed by
     the work done for the datatypes rework project    */
/*  @decodes_engineeringunit.trg  */
@decodes_engineeringunit_do_nothing.trg

/* now redo the hdb_site insert  or update trigger to utilize the newly created sequence  */
@decodes_hdb_site.trg
  
/* we must also change the package that gets creates the primary key for the HDB_SITE table
@pop_pk.spb

/* now create the procedure DECODES will call to get the data into R-base
@decodes_to_rbase.prc

spool off

/*  now we are done with everything so exit the  sql program  */
exit;
