set heading off
set feedback off
set verify off
/*  this sql creates a sequence command based on the input parameters and then executes the generated
    command.  THis is to be dynamic so that a sequence can be generated at any site without previous
    knowledge of the rows in any table

    this procedure written by M.  Bogner  May 2005   */

spool set_up_sequence.sql
select 'create sequence ' || '&1' || '  start with '|| nvl(max(&2)+1,1) || '  nocache;' from &3;
spool off

set heading on
set feedback on
set verify on

@set_up_sequence

