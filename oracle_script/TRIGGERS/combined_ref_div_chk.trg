create or replace trigger combined_ref_div_chk
after             insert or update
on                ref_div
for   each row
begin
     check_valid_site_objtype ('div', :new.site_id);
     if not (DBMS_SESSION.Is_Role_Enabled ('SAVOIR_FAIRE')
             OR DBMS_SESSION.Is_Role_Enabled ('REF_META_ROLE')) then
	check_site_id_auth (:new.site_id);
     end if;
end;
/
show errors trigger combined_ref_div_chk;
/