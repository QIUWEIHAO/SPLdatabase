#Database of Seattle Pulbic Library
### An Automatic Simple Version By weihao Qiu

___

## Files Descriptions (Please read thoroughly and patiently)
1. <b> createTablesToLoad.sql </b>

	<i><u>Create all tables for the database. Usually applied to an empty database.</u></i> 
	
	An example of usage:
	
	<code>mysql --local-infile -u weihao -p spl_weihao < /home/weihao/spldb/scripts/createTablesToLoad.sql</code>
	
	*Syntax:
	<code>mysql --local-infile -u username -p password databasename < file.sql</code>
	
	
2. <b>loadTables.sql </b>

	<i><u>Load data into the tables. Data are originally stored as XML files. They are converted into CSV files by the converter program introduced later and imported into database by this program.
	
	Same usage as the program before.</u></i>
	
	
	<B><i>Make sure the import directory is consistant with the output directory of the converter program, <code>xmlToCsv.pl</code>.</i></b>
	

3. <b>xmlToCsv.pl</b>


	<i><u>Data are originally stored as XML files in the folder below. They are converted into CSV files by the converter program.</u></i>
	
	<code>/aux/spl/data</code>
	
	
	Usage of this file:
	
	
	<code>perl xmlToCsv.pl data\_directory YYYY MM DD</code>
	
	Example:
	
	<code>perl xmlToCsv.pl /aux/spl/data 2017 01 01</code>
	
	This command line convert the XML files fetched on 2017/01/01 into CSV files in the output directory. The default output directory is 
	
	<code>/home/weihao/csv</code>
	
	Which is consistant with the import directory in <code>loadTables.sql</code>.

	
4. <b>xmlToCsv\_all_years.pl</b>

	<i><u>Similar function as the program before. The difference is that this file will convert XML files of all days since 2005 until today into CSV files automatically, where as the previous one only converts the XML files from a selected day.</u></i>
	
	Usage:
	
	<code>perl xmlToCsv.pl data\_directory</code>
	
	
	Example:
	
	<code>perl xmlToCsv.pl /aux/spl/data</code>




5. <b>updateDatabaseDaily.pl</b>

	<i><u> This is the program packing everything up. Ideally, if the directory is set rightly, using Cron tools to run this Perl script will make the database update daily.</i></u>
	
	Usage:
	
	<code>perl updateDatabaseDaily.pl</code>
	
	Please contact Larry Zins for deploying this program using Cron tools.


6. <b>database_validater.sql</b>

	<i><u>A program to validate if the database is correctly updated.</u></i>
	
	<code>mysql --local-infile -u username -p password databasename < database\_validater.sql </code>
	
	What shows up during the running of this program would be redundant records, and should be deleted. If nothing show up, which is in the most cases, the database is ready to go.
	
	*It usually take 20 minutes to run the validation program. The frequency to run it should not be more than weekly.
	
___

##Instructions for situations
1. If you are **rebuilding** a **new database**:

	<code>perl xmlToCsv.pl directory\_to_data</code>

	<code>mysql --local-infile -u username -p password databasename < createTablesToLoad.sql </code>
	
	<code>mysql --local-infile -u username -p password databasename < loadTables.sql </code>
	
	<code>mysql --local-infile -u username -p password databasename < database\_validater.sql </code>
	

2. If you are **updating** the **current database**:
	
	* Update the database with today's data:
	
		<code>perl updateDatabaseDaily.pl</code>
 
	* Update the database with data of some day:
	
		<code>perl xmlToCsv.pl directory\_to_data YYYY MM DD</code>

		<code>mysql --local-infile -u username -p password databasename < loadTables.sql </code>
		
3. Find **redundant records** / **Error** checking.

	<code>mysql --local-infile -u username -p password databasename < database\_validater.sql </code>
	
	


	
	
