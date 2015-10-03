  CREATE OR REPLACE TRIGGER HDB_DAMTYPE_PK_TRIG
  BEFORE INSERT OR UPDATE ON HDB_DAMTYPE
  REFERENCING FOR EACH ROW
  BEGIN IF inserting THEN IF populate_pk.pkval_pre_populated = FALSE THEN :new.DAMTYPE_ID := populate_pk.get_pk_val( 'HDB_DAMTYPE', FALSE );  END IF; ELSIF updating THEN :new.DAMTYPE_ID := :old.DAMTYPE_ID; END IF; END;
/
show errors trigger HDB_DAMTYPE_PK_TRIG;