package dataloader;

import java.io.*;
import java.lang.Integer;
import java.util.*;
import dbutils.*;
import java.sql.*;

/*

	Java class USACEfileReader

	THis program was created by M. Bogner Sutron Corporation

	initial coded: 06-April-2011
	modified code to report skipped data records 18-MAY-2011
	modified code to parse a different formatted csv file from Central Utah 09-FEB-2012
        modified code 07-NOV-2012 to read in a csv file from Hoover Dam

	This program reads the file identified in the instantiation of this class
	It reads each line
	Skips the comment lines
	Parses each line for it's repective fields
	then inputs the data into the database

*/

public class USACEfileReader {

  private Hashtable hash = null;
  private String file_name = null;
  private Logger log = null;
  private int errors = 0;
  private DBAccess db = null;
  private boolean debug = false;
  private Connection cnn = null;
  private String comma = ",";
  private String apos = "'";
  private String pipe = "|";
  DataObject dobj_orig = null;


  public USACEfileReader( String _file_name)
  {
    file_name = _file_name; 
    log = Logger.getInstance();
    db = new DBAccess(cnn);
    dobj_orig = new DataObject();

    try 
    {

      dobj_orig.addPropertyFile(System.getProperty("start.property"));
      cnn = db.getConnection(dobj_orig);
      RBASEUtils rbu = new RBASEUtils(dobj_orig,cnn);
      rbu.get_all_ids();
 
    }
    catch (Exception e) {System.out.println(e.toString());}

  }

// this instantiation constructor is for a file that only lists the site and it's values
// so the interval and the parameter code is implied by the file itself... like with USGS files
// this constructor currently programmed for the USGS files only!!!
  public USACEfileReader( String _file_name, String _parameter_code, String _sample_interval )
  {
    file_name = _file_name; 
    log = Logger.getInstance();
    db = new DBAccess(cnn);
    dobj_orig = new DataObject();

    try 
    {

      dobj_orig.addPropertyFile(System.getProperty("start.property"));
      // now add the class parameters to the data object
      dobj_orig.put("SAMPLE_INTERVAL",_sample_interval);
      dobj_orig.put("PARAMETER_CODE",_parameter_code);
      // default the sample_date format to the instant format change appropriately if the interval is day
      dobj_orig.put("SAMPLE_DATE_FORMAT","yyyy-mm-dd HH24:MI");
      if (_sample_interval.equalsIgnoreCase("day")) dobj_orig.put("SAMPLE_DATE_FORMAT","yyyy-mm-dd");
      cnn = db.getConnection(dobj_orig);
      RBASEUtils rbu = new RBASEUtils(dobj_orig,cnn);
      rbu.get_all_ids();
 
    }
    catch (Exception e) {System.out.println(e.toString());}

  }


// this instantiation constructor is for a file that only lists the date and it's values
// so the interval and the parameter code is implied by the file itself... like with USBR Hydromet files
// this constructor currently programmed for the USBR Hydromet files only!!!
  public USACEfileReader( String _file_name, String _site_code, String _parameter_code, String _sample_interval )
  {
    file_name = _file_name; 
    log = Logger.getInstance();
    db = new DBAccess(cnn);
    dobj_orig = new DataObject();

    try 
    {

      dobj_orig.addPropertyFile(System.getProperty("start.property"));
      // now add the class parameters to the data object
      dobj_orig.put("SITE_CODE",_site_code);
      dobj_orig.put("SAMPLE_INTERVAL",_sample_interval);
      dobj_orig.put("PARAMETER_CODE",_parameter_code);
      // default the sample_date format to the instant format change appropriately if the interval is day
      dobj_orig.put("SAMPLE_DATE_FORMAT","yyyy-mm-dd HH24:MI");
      if (_sample_interval.equalsIgnoreCase("day")) dobj_orig.put("SAMPLE_DATE_FORMAT","mm/dd/yyyy");
      cnn = db.getConnection(dobj_orig);
      RBASEUtils rbu = new RBASEUtils(dobj_orig,cnn);
      rbu.get_all_ids();
 
    }
    catch (Exception e) {System.out.println(e.toString());}

  }


public void process()

 {
   BufferedReader input = null;

   try 
   {
     input = new BufferedReader(new FileReader(file_name));
   } 
   catch (FileNotFoundException e) {
     log.debug(this,e.getMessage()); 
     System.exit(-1);
   }


   boolean process;

   try 
   {

   // set the debug mode based
   if (dobj_orig.get("debug") != null && dobj_orig.get("debug").toString().equalsIgnoreCase("YES")) debug =true; 
   // read the file line by line
   String inputLine = null;	
   int reads = 0; 
   int skips = 0; 
   DataObject dobj = null;


      inputLine = input.readLine();
      while (inputLine != null)  // read the file until and End of File EOF is returned
      {
          process = true;

         //System.out.println("RECORD: " + reads);

          if (inputLine != null)
          {
             reads ++; 
             //System.out.println("RECORD: " + reads + " " + inputLine);
             if (debug) log.debug( this,inputLine);
 
             if (!inputLine.substring(0,1).equals("#"))
             {
	       // this is not a comment line so process it
	       // add the default properties to this data object while you're at it
               dobj = new DataObject(dobj_orig.getTable());
	       // first initialize some data columns that are needed for the loader but the specific file type 
	       // may not have within its data  The parse method for each file type may over-ride these values
 	       // the Baseloader class
               dobj.put("overwrite_flag","");
               dobj.put("validation","");
               dobj.put("sample_data_flags","");
	       // now decide what file type it is so that that proper parsing method is called
   	       // the following file types are currently supported
               // CUWCD_PSV  -- A pipe separated value file from the Cebtral Utah Water Conservatory District
 	       // HOOVER_CSV -- A comma separated file from the Hoover SCADA system
 	       // USGS_TSV   -- A tab delimited value file from the USGS web site
	       // DEFAULT    -- A Comma Sepated File from the USCAE (which was the original development) 
               if (dobj.get("data_source") != null && dobj.get("file_type").toString().equals("CUWCD_PSV")) 
               {
                 parseCentral(dobj,inputLine);
               }
               // if the file type is the Hoover SCADA comma delimited file then call this method
               else if (dobj.get("data_source") != null && dobj.get("file_type").toString().equals("HOOVER_CSV")) 
               {
                 parseHooverSCADA(dobj,inputLine);
               }
               // if the file type is the USGS tab delimited file then call this method
               else if (dobj.get("data_source") != null && dobj.get("file_type").toString().equals("USGS_TSV")) 
               {
                 parseUSGSTSV(dobj,inputLine);
               }
               // if the file type is the USBR Hydromet TAB delimited file then call this method
               else if (dobj.get("data_source") != null && dobj.get("file_type").toString().equals("USBRHM_TSV")) 
               {
                 parseUSBRHMTSV(dobj,inputLine);
               }
               else
               // parse it like all other csv file types
               {
                 parse(dobj,inputLine);
               }
      	       RBASEUtils rbu = new RBASEUtils(dobj,cnn);
               // if the file type is the Hoover SCADA comma delimited file then call this method to get the interval
               if (dobj.get("data_source") != null && dobj.get("file_type").toString().equals("HOOVER_CSV")) 
               {
      	          Integer temp_int = rbu.get_external_data_interval();
                  String l_query = "";

                 // the date time doesn't need to be parsed in any way, the date format from the
                 // property files will define the date time format
                 // the default time zone for Hoover data will always be MST
                 // The date field is end time for the hour interval so convert that time to an 
                 // hour earlier utilizing ORACLE data math
                  l_query = "select to_char(to_date('" 
                  + dobj.get("SAMPLE_DATE")
                  + "','" 
                  + dobj.get("SAMPLE_DATE_FORMAT")
                  + "')-1/24,'" 
                  + dobj.get("SAMPLE_DATE_FORMAT")
                  + "') SAMPLE_DATE from dual";
                  // but if the interval is instant just truncate it to the hour level
                  if (dobj.get("sample_interval") != null && dobj.get("sample_interval").toString().equals("instant")) 
                  {
                    l_query = "select to_char(TRUNC(to_date('" 
                    + dobj.get("SAMPLE_DATE")
                    + "','" 
                    + dobj.get("SAMPLE_DATE_FORMAT")
                    + "'),'HH24'),'" 
                    + dobj.get("SAMPLE_DATE_FORMAT")
                    + "') SAMPLE_DATE from dual";
                  }

                if (debug) log.debug( this,l_query);

                 // now perform the query to get the right hourly value 
                 db.performQuery(l_query,dobj);
               }
      	       Integer sdi = rbu.get_external_data_sdi();
	       if (sdi > 0)
	       {
	       // this line of data has a good SDI so it should be attempted to put into database
                 if (debug) log.debug(this,dobj.toString());
		 Baseloader bl = new Baseloader (dobj,cnn);
	         bl.process();
               }
	       else
	       {
                  // a data record was read but no sdi was defined for this data record
                  log.debug("No mapping record found for site: " + dobj.get("site_code") + 
		  "  Parameter Code: " + dobj.get("parameter_code") + "  Source: " + dobj.get("data_source"));
		  skips ++;
               }
             //System.out.println("RECORD: " + reads + " " + inputLine);
             }
             else 
             {
	       // this is a comment line so skip it
               skips ++;
             }
          }

          inputLine = input.readLine();


      }  /// end of big loop to read the whole file	

        // close the input file
        // close the data base object
        input.close();
        cnn.close();
        log.debug(this,"RECORDS Processed: " + reads);
        log.debug(this, "SKIPS: " + skips );

     } // end of big try
    
     catch( SQLException se) 
     {
       log.debug(this,se.getMessage()); 
       System.exit(-1);
     }
     catch (IOException e) 
     {
       log.debug(this,e.getMessage()); 
       System.exit(-1);
     }

    }  // end of process method

    // method parse is to parse all normal csv files in the USACE agreed format
    private void parse(DataObject dobj, String input)
    {


/* the lines coming from the data source are the following csv format:
   and any comment line starts with a #
Field 1: data_source
Field 2: date timestamp with Timezone
Field 3: site id
Field 4: data parameter
Field 5: interval (hour, day, etc...)
Field 6: observation's value
Field 7: observation's unit
*/

         int tcount = 0;

         dobj.put("INPUTLINE",input);
	 String [] fields = input.split(comma);
	 for (String field : fields)
	 {
            //System.out.println("field=  " + field + "  token= " + tcount); 
            switch (tcount) 
            {

              case 0:   // first column of the line

                 dobj.put("DATA_SOURCE",field);
                 break;
    
              case 1:   // third column of the line

                 field = field.replace("24:00","00:00");
	         String [] fields2 = field.split(":");
                 dobj.put("SAMPLE_DATE",fields2[0] + ":" + fields2[1]);
                 dobj.put("SAMPLE_TZ",fields2[2]);
                 break;
    
              case 2:  // fourth column of the line

                 dobj.put("SITE_CODE",field);
                 break;
    
              case 3:  // fifth column of the line

                 dobj.put("PARAMETER_CODE",field);
                 break;
    
              case 4:  // sixth column of the line

                 dobj.put("SAMPLE_INTERVAL",field);
                 break;
    
              case 5:  // seventh column of the line

                 dobj.put("SAMPLE_VALUE",field);
                 break;
    
              case 6:  // eighth column of the line

                 dobj.put("SAMPLE_UNIT",field);
                 break;

            }  /// end of switch

            tcount ++;
         }  // end of fields  for loop


    } // end of method parse

//  This parse method is for the Central Utah data format
    private void parseCentral(DataObject dobj, String input)
    {

/* the lines coming from the Central Utah data source are the following csv format:
   and any comment line starts with a #
Field 1: data_source
Field 2: date timestamp no Timezone
Field 3: observation's value
*/

         int tcount = 0;

         dobj.put("INPUTLINE",input);
         // there are only three fields in the file so split it into three fields
         // the file currently uses a pipe to separate fields
         // notice the special handling of pipe in split due to meaning of | in regular expressions
	 String [] fields = input.split("[|]");
	 for (String field : fields)
	 {
            //System.out.println("field=  " + field + "  token= " + tcount); 
            switch (tcount) 
            {

              case 0:   // first column of the line
                 // will be the data source  and there will be no datatype so we will make a default
                 dobj.put("SITE_CODE",field);
                 dobj.put("PARAMETER_CODE","NO ENTRY");
                 dobj.put("SAMPLE_INTERVAL","hour");
                 break;
    
              case 1:   // second column of the line

                 // the date time doesn't need to be parsed in any way, the date format from the
                 // property files will define the date time format
                 // the default time zone for Central data will always be MST
                 dobj.put("SAMPLE_DATE",field);
                 dobj.put("SAMPLE_TZ","MST");
                 break;
    
              case 2:  //Third column of the line
                 // the value may have commas in it so get rid of them
                 dobj.put("SAMPLE_VALUE",field.replaceAll(comma,""));
                 break;
    
            }  /// end of switch

            tcount ++;
         }  // end of fields  for loop

         //System.out.println(dobj.toString());

    } // end of method parseCentral


//  This parse method is for the USGS Tab delimited file format
    private void parseUSGSTSV (DataObject dobj, String input)
    {

/* the lines coming from the USGS data source are the following csv format:
   and any comment line starts with a #
Field 1: data_source in this case it just says USGS
Field 2: The USGS site code;  this value will be the value found in the primary site_code in the mapping table
Field 3: date timestamp no Timezone
Field 4: The time zone for the data observation
Field 5: observation's value
Field 6: The validation flag for the records value
*/

         int tcount = 0;

         dobj.put("INPUTLINE",input);
         // there are only three fields in the file so split it into three fields
         // the file currently uses a TAB to separate fields
	 String [] fields = input.split("\t");
	 for (String field : fields)
	 {
            //System.out.println("field=  " + field + "  token= " + tcount); 
            switch (tcount) 
            {

              case 0:   // first column of the line
                 // will be the data source of USGS   
                 dobj.put("EXTERNAL_SOURCE_CODE",field);
                 break;

              case 1:   // second column of the line
                 // will be the site code source of USGS   
                 dobj.put("SITE_CODE",field);
                 break;
    
              case 2:   // Third column of the line

                 // the date time doesn't need to be parsed in any way, the date format from the
                 // property files will define the date time format
                 dobj.put("SAMPLE_DATE",field);
                 dobj.put("SAMPLE_TZ","MST");
                 break;
    
              case 3:   // Fourth column of the line

	         // the file formats of day or instant files varies after the date field
 	         // there is no time zone field in the day file
                 if (dobj.get("sample_interval") != null && dobj.get("sample_interval").toString().equals("instant")) 
                 {
	           dobj.put("SAMPLE_TZ",field);
                 }
                 else
                 {
                   dobj.put("SAMPLE_VALUE",field);
                 }
                 break;
    
              case 4:  // Fifth column of the line

                 if (dobj.get("sample_interval") != null && dobj.get("sample_interval").toString().equals("instant")) 
                 {
	           dobj.put("SAMPLE_VALUE",field);
                 }
                 else
                 {
                   dobj.put("validation",field);
	         }
                 break;
    
              case 5:  // Sixth column of the line
                 // This case will only work for the instant file type
	         // so no need for the if statement
                 dobj.put("validation",field);
                 break;
    
            }  /// end of switch

            tcount ++;
         }  // end of fields  for loop

         //System.out.println(dobj.toString());

    } // end of method parseUSGSTSV

//  This parse method is for the USBR HYDROMET tab delimited file format
    private void parseUSBRHMTSV (DataObject dobj, String input)
    {

/* the lines coming from the Hydromet web data source are the following tab format:
   and any comment line starts with a #
Field 1: date timestamp no Timezone format mm/dd/yyyy
Field 2: observation's value
*/

         int tcount = 0;

         dobj.put("INPUTLINE",input);
         // there are only two fields in the file so split it into two fields
         // the file currently uses a TAB to separate fields
	 String [] fields = input.split("\t");
	 for (String field : fields)
	 {
            //System.out.println("field=  " + field + "  token= " + tcount); 
            switch (tcount) 
            {

              case 0:   // first column of the line
                 // will be the date in day format of the observation
                 dobj.put("SAMPLE_DATE",field);
                 dobj.put("SAMPLE_TZ","MST");
                 break;

              case 1:   // second column of the line
                 // will be the site code source of USGS   
                 dobj.put("SAMPLE_VALUE",field);
                 break;
    
            }  /// end of switch

            tcount ++;
         }  // end of fields  for loop

         //System.out.println(dobj.toString());

    } // end of method parseUSBRHMTSV

//  This parse method is for the Hoover DAM SCADA data format
    private void parseHooverSCADA(DataObject dobj, String input)
    {

/* the lines coming from the Hoover Dam SCADA data source are the following csv format:
   and any comment line starts with a #
Field 1: SDI
Field 2: date timestamp no Timezone
Field 3: observation's value
*/

         int tcount = 0;

         dobj.put("INPUTLINE",input);
         // there are only three fields in the file so split it into three fields
         // the file currently uses a comma to separate fields
	 String [] fields = input.split(comma);
	 for (String field : fields)
	 {
            //System.out.println("field=  " + field + "  token= " + tcount); 
            switch (tcount) 
            {

              case 0:   // first column of the line
                 // will be the data source (SDI)  and there will be no datatype so we will make a default
                 // data type of "NO ENTRY"
                 dobj.put("SITE_CODE",field);
                 dobj.put("PARAMETER_CODE","NO ENTRY");
                 // the interval is independant so get that from the mapping table
                 // dobj.put("SAMPLE_INTERVAL","hour");
                 break;
    
              case 1:   // second column of the line
                 // further processing of the date is performed after the parsing
                 // code modified by M. Bogner  03-12-2013
                 dobj.put("SAMPLE_DATE",field);
                 dobj.put("SAMPLE_TZ","MST");
                 break;
    
              case 2:  //Third column of the line
                 // the value may have commas in it so get rid of them
                 dobj.put("SAMPLE_VALUE",field.replaceAll(comma,""));
                 break;
    
            }  /// end of switch

            tcount ++;
         }  // end of fields  for loop

         if (debug) log.debug( this,dobj.toString());

    } // end of method parseHooverSCADA



}
