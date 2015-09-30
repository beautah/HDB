
create or replace trigger decodes_unit_delete
instead of delete on unit_to_decodes_unit_view 
for each row
declare
 TEMP_COUNT number;

begin


/* right now just delete if the abbreviation is there  */
/* actually don't do any deletes cause the use of rledit would destroy the database  */
/* so effectively shut off delete capabilities */
/*  delete from hdb_unit where unit_common_name = :old.unitabbr;   */
temp_count := 0;

END;
.
/

create or replace trigger decodes_unit_update
instead of update on unit_to_decodes_unit_view 
for each row
declare
 TEMP_DIM_ID number;
begin

/* go get the dimension_id for the measures column  */
select dimension_id into temp_dim_id from hdb_dimension where dimension_name = :new.measures;

/* now update the values and the foreign key into the hdb_ubit table  */	
update hdb_unit set 
unit_name=:new.name,
unit_common_name=:new.unitabbr,
dimension_id=temp_dim_id,
family=:new.family
where unit_common_name = :old.unitabbr;

END;
.
/


create or replace trigger decodes_unit_insert
instead of insert on unit_to_decodes_unit_view 
declare
 TEMP_DIM_ID number;
 TEMP_UNIT_ID number;
begin

/* go get the dimension_id for the measures column  */
select dimension_id into temp_dim_id from hdb_dimension where dimension_name = :new.measures;
select unit_id into temP_unit_id from hdb_unit where unit_common_name = :new.unitabbr;
 exception when others then null;

/* now insert or update the values and the foreign key into the hdb_unit table  */	

if (temp_unit_id > -1 ) THEN
  update hdb_unit set
   unit_name=:new.name,
   unit_common_name=:new.unitabbr,
   dimension_id=temp_dim_id,
   family=:new.family
  where unit_common_name = :new.unitabbr; 
ELSE
  insert into hdb_unit (unit_name,unit_common_name,dimension_id,stored_unit_id,is_factor,mult_factor,family)
  values (:new.name,:new.unitabbr,temp_dim_id,1,1,1,:new.family);
END IF;

END;
.
/
