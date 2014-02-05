Open_Data_Paris_import_into_PostGIS
===================================

This project allow to load [Open Data Paris](http://opendata.paris.fr/opendata/) into a PostGIS database, and do some cleaning of the data


===================================
# What does it do?#

The proposed script will take as input zip files containing data from Open Data Paris,
this data will be
* imported :
   * uncompressed, 
   * analysed to find the correct encoding (encoding are silently mixed in open data paris datas..)
   * wrote to the choosen schema in the database.
* cleaned :
   * table name changed, 
   *  Delete useless table 
   *  2. Rename tables 	
   *  3. Editing of complexe table 
   *  4. Dealing with null and 'Objet sans identification particulière pour ce niveau' values 
   *  5. Changing the data type of 'libelle' and 'info' 
   *  6. Fusinning tables with close contents 
   *  7. Changing info nomenclatura to add the table name as a prefixe except to info already prefixed (like BOR_UNK or DDB_UNK)
   *  8. Creating Binary Tree indexes on the info columns 
   *  9. Creating Rectangle Tree indexes on the geom info 
   *  10. Clustering physically the tables based on the index on info. 
* reconstructed relationnaly
   * create a table nomenclature and hold inside all the different values for info and libelle column
   * use foreign key constraint to enforce the respect of nomenclature
   * 
   
 


# How to Use : #

## required ##

### Data Import###
 * bash
 * postgres
 * postgis
 * shp2pgsql in you path
 * zip files from [Open Data Paris](http://opendata.paris.fr/opendata/) (shapefile =  4 files per layer) 
 * a postgres user to connect to database via socket (no password, database need to be configured)

 * the french IGN SRID into postgis, see [how to import it here](https://github.com/Remi-C/IGN_spatial_ref_for_PostGIS)
 
###data cleaning###

 * Functions need to be imported from script of the sql script folder, in perticular (import function in reverse order)
    * rc_random_string(INTEGER )
    * rc_change_all_libelle_info_length_in_a_schema(schema_name text)
    * rc_add_prefix_to_info_column(text,text[],text[])
    * rc_table_exists();
    * rc_create_index_on_all_info_column_in_schema
    * rc_filtering_raw_odparis

 * another function rc_create_index_on_all_geom_column_in_schema, found in [this repo with utilities for Postgres Postgis, Postgis Topology and PointCloud](https://github.com/Remi-C/PPPP_utilities/tree/master/postgis)
 
 * data required : (see [here](https://github.com/Remi-C/Open_Data_Paris_import_into_PostGIS/wiki/list-of-Open-Data-Paris-zip-files-required) for the list of required data to be cleaned)
 * 
###relation reconstruction###

 * the script is 

## steps ##

###data import ###
 
 * import the french SRID in your PostGIS data base [how to import it here](https://github.com/Remi-C/IGN_spatial_ref_for_PostGIS)
 * create the postgres schema which will receive the open data paris table (optionnal)
 * set the variable at the begginning of the .sh script to reference you data folder, you preference ...
 * get into the postgres user (su postgres)
 * launch the .sh script 
 * exit the postgres user (exit)

### data cleaning###

You should have a postgres schema filled with open data paris tables.

 * create the rc_filtering_raw_odparis function, for this you need to  create first the function (and dependencies)
    * rc_random_string(INTEGER )
    * rc_change_all_libelle_info_length_in_a_schema(schema_name text)
    * rc_add_prefix_to_info_column(text,text[],text[])
    * rc_table_exists();
    * rc_create_index_on_all_info_column_in_schema
 *  * another function rc_create_index_on_all_geom_column_in_schema, found in [this repo with utilities for Postgres Postgis, Postgis Topology and PointCloud](https://github.com/Remi-C/PPPP_utilities/tree/master/postgis)
 * Load the rc_filtering_raw_odparis_CONTROL.sql script and execute one by one the sql command, possibly skipping the last 2.

###relation reconstruction###
  
  * It is the function  rc_create_foreign_keys_constraint_on_all_info_columns('odparis_corrected','odparis_corrected.nomenclature');
  *  which has for dependecy rc_gather_all_info_libelle_columns('odparis_corrected');

## Details## 
###data import###
the encoding is guessed based on the .dbf file : indeed, some of the file are encoded in ansi, some in Latin1, some in IBM850!
the table names are the shapefile name put to lower character.

### data cleaning###

###relation reconstruction###

