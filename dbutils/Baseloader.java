package dbutils;

import java.sql.*;
import java.util.*;
import dbutils.*;

/*

        Java class Baseloader

        THis program was created by M. Bogner Sutron Corporation

        initial coded: 08-April-2011

        This class take a data object created by the calling class and
	puts the data into the database by calling the modify_r_base_raw
	stored procedure.  This program expects all the necessary data 
	items to already be in the data object and with the expected 
	tags names of:

	site_datatype_id:  The sdi od the data row
	sample_interval:   The interval of the sample data
	sample_date The date and time of the data
	sample_date_format The format of the samples date time in ORACLE format
	sample_value:  the actual value of the data row
	agen_id: the id for the agency this data is from
	overwrite_flag: the over write flag for this row
	validation: the validation flag for this row of data
	collection_system_id: the default collection system id to put in the database
	loading_application_id: the default id for the loading application that read this data
	method_id: The default method id to put into the database
	computation_id: The computation id for this data row
	sample_data_flags: the data flags that may be with the sample data
	sample_tz:  The time zone the sample_date was collected

*/

public class Baseloader	 
{
    private String error_message;
    private Logger log = null;
    private DataObject do2 = null;
    private Connection conn = null;
    private boolean debug = false;
    private boolean log_all = true;
    private boolean fatal_error = true;
    private DBAccess db = null;

    public Baseloader(DataObject _do, Connection _conn)  
    {
      log = Logger.getInstance();
      do2 = _do;
      conn = _conn;
      db = new DBAccess(conn);
      if ((String)do2.get("debug") != null && ((String)do2.get("debug")).equals("YES")) debug = true;
    }

    public void process()
    {

      fatal_error = true;
      try 
      {

       String result = null;
       String query = null;
       String db_oper = " ";

       if (debug) log.debug( this,"Passed in Database Object to Follow:");
       if (debug) log.debug( this,do2.toString());

	//  Set up the call to the stored procedure
       String proc = "{ call modify_r_base_raw(?,?,to_date(?,'" + do2.get("sample_date_format") 
	  +"'),?,to_number(?),?,?,?,?,?,?,?,?,?,?)}";
          CallableStatement stmt = db.getConnection(do2).prepareCall(proc);
          // set all the called procedures input variables from the DataObject
          stmt.setLong(1,Long.parseLong(do2.get("site_datatype_id").toString()));
          stmt.setString(2,(String) do2.get("sample_interval"));
          stmt.setString(3,(String) do2.get("sample_date"));
          //stmt.setString(4,(String) do2.get("end_date_time"));  let procedure determine end_date_time
          //stmt.setFloat(5,Float.parseFloat(do2.get("sample_value").toString()));
          //stmt.setDouble(5,new Double(do2.get("sample_value").toString()));
          stmt.setString(5,(String) do2.get("sample_value"));
          stmt.setLong(6,Long.parseLong(do2.get("agen_id").toString()));
          stmt.setString(7,(String) do2.get("overwrite_flag"));
          stmt.setString(8,(String) do2.get("validation"));
          stmt.setLong(9,Long.parseLong(do2.get("collection_system_id").toString()));
          stmt.setLong(10,Long.parseLong(do2.get("loading_application_id").toString()));
          stmt.setLong(11,Long.parseLong(do2.get("method_id").toString()));
          stmt.setLong(12,Long.parseLong(do2.get("computation_id").toString()));
          stmt.setString(13,"Y");
          stmt.setString(14,(String) do2.get("sample_data_flags"));
          stmt.setString(15,(String) do2.get("sample_tz"));

          stmt.registerOutParameter(4, java.sql.Types.DATE);

          // execute the stored procedure call
          stmt.execute();

          // we are done with the procedure call so close the statement
          stmt.close();
          fatal_error = false;

      }  // end of try

       catch (Exception e) {if (log_all) log.debug(this, e.getMessage());}

    }  // end of method process

}  // end of class Baseloader
