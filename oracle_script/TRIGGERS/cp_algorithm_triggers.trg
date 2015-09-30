
create or replace trigger cp_algorithm_update                                                                    
after update on cp_algorithm 
for each row 
begin 
/*  This trigger created by M.  Bogner  04/04/2006
    This trigger archives any updates to the table
    cp_algorithm.
*/
insert into cp_algorithm_archive (                     
ALGORITHM_ID,
ALGORITHM_NAME,
EXEC_CLASS,
CMMNT,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT
) 
values (                                           
:old.ALGORITHM_ID,
:old.ALGORITHM_NAME,
:old.EXEC_CLASS,
:old.CMMNT,
'UPDATE', 
sysdate, 
NULL); 
end;                                                                    
/                                                                                                                       
show errors trigger cp_algorithm_update;                                                                         

                                                                                                                        
create or replace trigger cp_algorithm_delete                                                                    
after delete on cp_algorithm 
for each row 
begin 
/*  This trigger created by M.  Bogner  04/04/2006
    This trigger archives any deletes to the table
    cp_algorithm.
*/
insert into cp_algorithm_archive (                     
ALGORITHM_ID,
ALGORITHM_NAME,
EXEC_CLASS,
CMMNT,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT
) 
values (                                           
:old.ALGORITHM_ID,
:old.ALGORITHM_NAME,
:old.EXEC_CLASS,
:old.CMMNT,
'DELETE', 
sysdate, 
NULL); 
end;                                                                    
/                                                                                                                       
show errors trigger cp_algorithm_delete;                                                                         

