create or replace package riverware_connection as
/*  PACKAGE riverware_connection is the package designed to contain all
    the procedures and functions necessary to incorporate the 
    requirements for the Riverware - hdb direct connection capability
 
    Created by M. Bogner  March 2007   
    Modified 4/09/2007  to take out status and error messaging
    Modified by M. Bogner January 2014to add Riverware ensemble procedures
*/
	/* declare the associative array table types for this package   */
	TYPE numberTable is TABLE of NUMBER INDEX BY BINARY_INTEGER;
	TYPE stringTable is TABLE of VARCHAR2(32) INDEX BY BINARY_INTEGER;
	TYPE stringTableLrg is TABLE of VARCHAR2(256) INDEX BY BINARY_INTEGER;
	
	/*  CURR_START_OF_TIME is a date that Riverware uses to indicate it's start
    of time.  THis package will be written in a way that if this date changes 
    in Riverware then this date will change dynamically since the start of time
    date is passed into the various procedures as a modifiable parameter
    */
	
	CURR_START_OF_TIME DATE := NULL; 
	
	/* declare all the keys that will be used when calling the HDB stored Procedures  */
	CURR_DATA_SOURCE_ID HDB_EXT_DATA_SOURCE.EXT_DATA_SOURCE_ID%TYPE;
	CURR_AGENCY_ID		HDB_AGEN.AGEN_ID%TYPE;
	CURR_COLLECTION_ID	HDB_COLLECTION_SYSTEM.COLLECTION_SYSTEM_ID%TYPE;
	CURR_OVERWRITE_FLAG R_BASE.OVERWRITE_FLAG%TYPE;
	CURR_MODEL_RUN_ID	REF_MODEL_RUN.MODEL_RUN_ID%TYPE;
	CURR_DATA_TABLES    VARCHAR2(30);
	CURR_DATA_TYPE      VARCHAR2(30);
	
	/* now all the default values used for this Stored Procedure  */
	/*  first declare all internal variables need for call to modify_r_base_raw 
        and to modify m_tables_raw
        NOTE!!!!! THe DBA who installs this package must assure that these defaults
        agree with their tables version of the default values
                                                       */
    DEF_VALIDATION             R_BASE.VALIDATION%TYPE := NULL;
    DEF_METHOD_ID              R_BASE.METHOD_ID%TYPE := 18;  /* unknown  */
    DEF_COMPUTATION_ID         R_BASE.COMPUTATION_ID%TYPE := 1;  /* unknown  */
    DEF_LOADING_APPLICATION_ID R_BASE.LOADING_APPLICATION_ID%TYPE:= 7;  /* RIVERWARE DMI */
	
	/* SECONDS_PER_DAY is a constant for the # of seconds in a day */
	SECONDS_PER_DAY CONSTANT NUMBER := 86400;

/*	procedure init_riverware_dmi passes in all needed HDB parameters  
    for this DMI event                                                ` */
	procedure init_riverware_dmi(  
	  parameter_names IN stringTable,
	  parameter_values IN stringTable);

/*	procedure init_riverware_dataset passes in all needed HDB parameters  
    for this DMI  DATASET event                                                ` */
	procedure init_riverware_dataset(  
	  parameter_names IN stringTable,
	  parameter_values IN stringTable);
	  
/*  procedure get_info_for_riverware_slot  looks up the unit and the SDI for a object and slot name  */
	procedure get_info_for_riverware_slot(  
	  riverware_object_name	REF_EXT_SITE_DATA_MAP.PRIMARY_SITE_CODE%TYPE,
	  riverware_slot_name	REF_EXT_SITE_DATA_MAP.PRIMARY_DATA_CODE%TYPE,
	  parameter_names    stringTable,
	  parameter_values   stringTable,
	  output_parameter_names  OUT stringTable,
	  output_parameter_values OUT stringTable);

/*	procedure write_riverware_data_to_db writes data to database from Riverware    */  
	procedure write_riverware_data_to_db(  
	  riverware_object_name	REF_EXT_SITE_DATA_MAP.PRIMARY_SITE_CODE%TYPE,
	  riverware_slot_name	REF_EXT_SITE_DATA_MAP.PRIMARY_DATA_CODE%TYPE,
	  interval_number       NUMBER,
	  interval_name         VARCHAR2,
	  date_array            numberTable,
	  value_array           numberTable,
	  parameter_names       stringTable,
	  parameter_values      stringTable);

/*	procedure delete_riverware_data_from_db deletes data in database from Riverware    */  
	procedure delete_riverware_data_from_db(  
	  riverware_object_name	REF_EXT_SITE_DATA_MAP.PRIMARY_SITE_CODE%TYPE,
	  riverware_slot_name	REF_EXT_SITE_DATA_MAP.PRIMARY_DATA_CODE%TYPE,
	  interval_number       NUMBER,
	  interval_name         VARCHAR2,
	  date_array            numberTable,
	  parameter_names       stringTable,
	  parameter_values      stringTable);	  

/*	procedure read_db_data_to_riverware reads data from database to pass to Riverware    */  
	procedure read_db_data_to_riverware(  
	  riverware_object_name	REF_EXT_SITE_DATA_MAP.PRIMARY_SITE_CODE%TYPE,
	  riverware_slot_name	REF_EXT_SITE_DATA_MAP.PRIMARY_DATA_CODE%TYPE,
	  interval_number       NUMBER,
	  interval_name         VARCHAR2,
	  start_time			NUMBER,
	  end_time				NUMBER,
	  parameter_names       stringTable,
	  parameter_values      stringTable,
	  date_array        OUT numberTable,
	  value_array       OUT numberTable);

/* the following procedures were create January 2014 for the Riverware ensemble project  */
/* the procedures and functions were written by M. Bogner, Sutron Corporation January 2014    */

    
/*  function get_ensemble_trace_mri returns the model run_id for the input ensemble_id, trace_id  */
	function get_ensemble_trace_mri( p_ensemble_id REF_ENSEMBLE.ENSEMBLE_ID%TYPE,
	                                 p_trace_id  REF_ENSEMBLE_TRACE.TRACE_ID%TYPE )
	                                 RETURN NUMBER;

/*	procedure init_ensemble passes in all needed HDB parameters  
    for this ensemble event                                                  */
	procedure init_ensemble( p_ensemble_id REF_ENSEMBLE.ENSEMBLE_ID%TYPE);

/*  procedure read_ensemble_metadata looks up the metadata for a given ensemble  */
	procedure read_ensemble_metadata(  
	  p_ensemble_id REF_ENSEMBLE.ENSEMBLE_ID%TYPE,
	  output_parameter_names  OUT stringTable,
	  output_parameter_values OUT stringTableLrg);

/*  procedure read_ensemble_trace_metadata looks up the metadata for a given ensemble trace */
	procedure read_ensemble_trace_metadata(  
	  p_ensemble_id REF_ENSEMBLE_TRACE.ENSEMBLE_ID%TYPE,
	  p_trace_id  REF_ENSEMBLE_TRACE.TRACE_ID%TYPE,
	  output_parameter_names  OUT stringTable,
	  output_parameter_values OUT stringTableLrg);

/*	procedure write_ensemble_metadata passes in all needed HDB Ensemble parameters  
    for this DMI Ensemble event                                                    */
	procedure write_ensemble_metadata(  
	  p_ensemble_id REF_ENSEMBLE.ENSEMBLE_ID%TYPE,
	  p_parameter_names IN stringTable,
	  p_parameter_values IN stringTableLrg);

/*	procedure write_ensemble_trace_metadata passes in all needed HDB 
    Ensemble Trace parameters  for this DMI Ensemble event                         */
	procedure write_ensemble_trace_metadata(  
	  p_ensemble_id REF_ENSEMBLE_TRACE.ENSEMBLE_ID%TYPE,
	  p_trace_id  REF_ENSEMBLE_TRACE.TRACE_ID%TYPE,
	  p_parameter_names IN stringTable,
	  p_parameter_values IN stringTableLrg);


/*  procedure testing is for testing any procedure in this package  */
/*
	procedure testing(
	test_number NUMBER,
	test_char   VARCHAR2);
*/

end riverware_connection;
.
/

--grant execute on riverware_connection to model_priv_role;
--create or replace public synonym riverware_connection for riverware_connection;
