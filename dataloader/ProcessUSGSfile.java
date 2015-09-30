package dataloader;

import java.io.*;
import dbutils.Logger;
	
/*  PROGRAM  ProcessUSGSfile
	Initial coding BY M. Bogner Sutron Corporation
	initial code:  22-FEBRUARY_2012

	This program is the java driver to process the file supplied by USGS  
	The file is a TAB separated file that contains observed and user
	modified data

	THis program accepts the following parameters:

	-V : Provides the current version of the code that is being executed
        file_name :  The first parameter always if not a -v and is the file this
		program will process

	log_file : the log file that the program will output results to.  This
		file name is always the second parameter if used. Otherwise the 
		log name of the run will be the .log of the processd file name

*/

public class ProcessUSGSfile {

    private static String version = "1.00.0";

    public static void main(String[] args) throws IOException 

    {

     // check and report if the paramter indicates the request is for the version of this 
     // program; exit with a zero result
     if (args.length == 1 && args[0].equalsIgnoreCase ("-V"))
     {
      System.out.println("ProcessUSGSfile Executeable: " + version);
      System.exit(0);
     }

      String log_file = null;

      // check to see if a log file was identified; if not, create the log file name from
      // the name of the file to be processed
      //if (args.length == 1) log_file = args[0].substring(0,args[0].lastIndexOf(".")) + ".log";
      if (args.length < 4) log_file = args[0] + ".log";
      else log_file = args[3];
 
      // create the logging file
      Logger log = Logger.createInstance(log_file);

      // now instantiate the USACE file reader and execute the process method for the USGS 
      USACEfileReader afp = new USACEfileReader(args[0], args[1], args[2]);
      afp.process();

      // exit with a zero status if all went well
      System.exit(0);

    }
}
