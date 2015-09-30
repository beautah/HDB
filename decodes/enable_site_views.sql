

create or replace view site_to_decodes_site_view as
select a.site_id "ID", a.lat "LATITUDE", a.longi "LONGITUDE",
b.nearestcity,b.state,b.region, b.timezone,b.country,a.elevation,b.elevunitabbr,
substr(a.site_name||chr(10)||a.description,1,801) "DESCRIPTION"
from hdb_site a, decodes_site_ext b, ref_db_list d
where a.site_id = b.site_id
and d.db_site_code = a.db_site_code
and d.session_no = 1
and a.site_id in (select distinct hdb_site_id from hdb_ext_site_code);


/* now the view for the DECODES sitename table  */

create or replace view site_to_decodes_name_view as
select a.hdb_site_id "SITEID",b.ext_site_code_sys_name "NAMETYPE", a.primary_site_code "SITENAME",
substr(substr(secondary_site_code,1,instr(secondary_site_code,'|')-1),1,2) "DBNUM",
substr(secondary_site_code,instr(secondary_site_code,'|')+1,5) "AGENCY_CD"
from hdb_ext_site_code a, hdb_ext_site_code_sys b, hdb_site c, ref_db_list d
where a.ext_site_code_sys_id = b.ext_site_code_sys_id 
and a.hdb_site_id = c.site_id and c.db_site_code = d.db_site_code and d.session_no = 1;


exit;
