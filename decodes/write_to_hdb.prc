create or replace PROCEDURE WRITE_TO_HDB (
			      SAMPLE_SDI            NUMBER,
			      SAMPLE_DATE_TIME      DATE,
			      SAMPLE_VALUE          FLOAT,
                              SAMPLE_INTERVAL       VARCHAR2,
                              LOADING_APP_ID        NUMBER,
                              COMPUTE_ID            NUMBER,
                              MODELRUN_ID           NUMBER
)  IS

/*  This procedure was written to be the generic interface to 
    HDB from the DECODES and the COMPUTATION application                       
    this procedure written by Mark Bogner   June 2005          */

    /*  first declare all internal variables need for call to modify_r_base_raw 
        and to modify m_tables_raw                                               */
    SITE_DATATYPE_ID       R_BASE.SITE_DATATYPE_ID%TYPE;
    INTERVAL               R_BASE.INTERVAL%TYPE;
    START_DATE_TIME        R_BASE.START_DATE_TIME%TYPE;
    END_DATE_TIME          R_BASE.END_DATE_TIME%TYPE;
    VALUE                  R_BASE.VALUE%TYPE;  
    AGEN_ID                R_BASE.AGEN_ID%TYPE;
    OVERWRITE_FLAG         R_BASE.OVERWRITE_FLAG%TYPE;
    VALIDATION             R_BASE.VALIDATION%TYPE;
    COLLECTION_SYSTEM_ID   R_BASE.COLLECTION_SYSTEM_ID%TYPE;
    METHOD_ID              R_BASE.METHOD_ID%TYPE;
    COMPUTATION_ID         R_BASE.COMPUTATION_ID%TYPE;
    LOADING_APPLICATION_ID R_BASE.LOADING_APPLICATION_ID%TYPE;
    MODEL_RUN_ID           M_DAY.MODEL_RUN_ID%TYPE;

    /* some temp variables for use in this procedures  for internal 
       processing and queries  */

    TEMP_NUMBER     NUMBER;
    DEF_COMP_ID     NUMBER;
    DEF_METHOD_ID   NUMBER;
    DEF_COLLECTION_ID   NUMBER;
    DEF_AGEN_ID     NUMBER;
    DECODES_ID      NUMBER;

BEGIN

    /*  set these default assignments according to the primary key values in your database  */
    DEF_COMP_ID  := 2;    /*  N/A    */
    DEF_AGEN_ID  := 33;   /* see loading application  */
    DEF_METHOD_ID  := 18;   /* unknown  */
    DEF_COLLECTION_ID  := 13;   /* see loading application  */
    DECODES_ID    :=  41;   /*  loading application_id for DECODES  */

    /*  First check for any required fields that where passed in as NULL  */
    IF SAMPLE_SDI IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_SDI' );
	ELSIF SAMPLE_DATE_TIME IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_DATE_TIME' );
	ELSIF SAMPLE_VALUE IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_VALUE' );
	ELSIF SAMPLE_INTERVAL IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_INTERVAL' );
	ELSIF LOADING_APP_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> LOADING_APP_ID' );
	ELSIF MODELRUN_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> MODELRUN_ID' );
    END IF;

    /*  now set the variables for the data input parameters     */
    SITE_DATATYPE_ID := SAMPLE_SDI;
    START_DATE_TIME := SAMPLE_DATE_TIME;
    VALUE := SAMPLE_VALUE;
    COMPUTATION_ID := COMPUTE_ID;
    LOADING_APPLICATION_ID := LOADING_APP_ID;
    MODEL_RUN_ID := MODELRUN_ID;

    /* the next two queries should be done only if the data is comming from the DECODES application
       we will use the loading_application_id for this since its the only indicator we have where the data
       is comming from                                                                                      */

    if LOADING_APPLICATION_ID = DECODES_ID THEN
      BEGIN
      /*  go get the interval and  method if the users decided to define 
          them and use the generic mapping table for these data      */
      select a.hdb_interval_name,a.hdb_method_id
            into INTERVAL,METHOD_ID
      	  from ref_ext_site_data_map a, hdb_ext_data_source b
          where a.hdb_site_datatype_id = site_datatype_id
            and a.ext_data_source_id = b.ext_data_source_id
            and upper(b.ext_data_source_name) = 'DECODES';
 
      EXCEPTION
        WHEN NO_DATA_FOUND THEN  /* don't care, will use defaults.. so do nothing  */  
        TEMP_NUMBER := 0;
      END;

      BEGIN
         temp_number := site_datatype_id;
      /*  go get the agen_id from the generic mapping tables  since decodes must use these 
          tables data to get the site data anyway  But it may be null so its set later as a
          default if  that is the case                                                        */
      select min(agen_id) into agen_id from  hdb_ext_site_code a , hdb_ext_site_code_sys  b, hdb_site_datatype c 
        where a.hdb_site_id = c.site_id and a.ext_site_code_sys_id = b.ext_site_code_sys_id
              and c.site_datatype_id = temp_number;
 
      EXCEPTION
        WHEN NO_DATA_FOUND THEN    /* don't care, will use defaults.. so do nothing  */
        TEMP_NUMBER := 0;
      END;

    END IF;  /* the end of queries to do specific to the DECODES Application   */

    /*  set all the default system and agency ids for this application 
        since they will be known.  IT was decided to hardcode these to be site 
        specific to reduce the number of queries necessary to put in a R_base record  
        These default settings may need to be changed based on the values at each 
        specific HDB installation  */

    /*  Interval query above gives the installation the chance to define a different 
        interval for a particular site if they want it, otherwise default the interval 
        to  to the passed in variable                */                                          

    if INTERVAL is null THEN
       INTERVAL :=  SAMPLE_INTERVAL;
    END IF;

    IF AGEN_ID is NULL THEN  /*  see query above if there is a problem here  */
       AGEN_ID := DEF_AGEN_ID;         /* see loading application  */
    END IF;

    IF COLLECTION_SYSTEM_ID is NULL THEN
      COLLECTION_SYSTEM_ID := DEF_COLLECTION_ID;    /*  see loading application  */
    END IF;
    
    IF METHOD_ID is NULL THEN    /*  possibly already set if user defined method for this SDI  */
       METHOD_ID := DEF_METHOD_ID;               /* unknown  */
    END IF;

    IF COMPUTATION_ID is NULL THEN    /*  possibly already set if user defined computation_id for this SDI  */
       COMPUTATION_ID := DEF_COMP_ID;           /*  N/A  */
    END IF;


    /*  now we should have passed all the logic and validity checks so
    just call the normal procedure to put data into r_base or an M_ table
    if model_run_id = 0 then insert record into R_BASE otherwise send it to the model_ tables  */

    IF MODEL_RUN_ID = 0 THEN
      modify_r_base_raw ( SITE_DATATYPE_ID,
                          INTERVAL,
      			  START_DATE_TIME,
  			  END_DATE_TIME,
			  VALUE,
                          AGEN_ID,
			  OVERWRITE_FLAG,
			  VALIDATION,
                          COLLECTION_SYSTEM_ID,
                          LOADING_APPLICATION_ID,
                          METHOD_ID,
                          COMPUTATION_ID,
                          'Y');
     END IF;

    IF MODEL_RUN_ID > 0 THEN
      modify_m_table_raw ( MODEL_RUN_ID,
                          SITE_DATATYPE_ID,
      			  START_DATE_TIME,
  			  END_DATE_TIME,
			  VALUE,
                          INTERVAL,
                          'Y');
     END IF;

END;  /* end of the procedure  */
.
/

show errors;

create public synonym WRITE_TO_HDB for WRITE_TO_HDB;
grant execute on WRITE_TO_HDB to app_role;
grant execute on WRITE_TO_HDB to savoir_faire;

exit;
