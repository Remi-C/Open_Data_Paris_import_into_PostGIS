Open_Data_Paris_import_into_PostGIS
===================================

This project allow to load [Open Data Paris](http://opendata.paris.fr/opendata/) into a PostGIS database, and do some cleaning of the data


===================================
# What does it do?#

The proposed script will take as input zip files containing data from Open Data Paris,
this data will be

* uncompressed, 
* analysed to find the correct encoding (encoding are silently mixed in open data paris datas..)
* wrote to the choosen schema in the database.
 
The script can be configured by setting the variable at the begginning


# How to Use : #

## required ##
 * bash
 * postgres
 * postgis
 * zip files from [Open Data Paris](http://opendata.paris.fr/opendata/) (shapefile =  4 files per layer)
 * a postgres user to connect to database via socket (no password, database need to be configured)

 * the french IGN SRID into postgis, see [how to import it here](https://github.com/Remi-C/IGN_spatial_ref_for_PostGIS)
 

## steps ##
 
 * import the french SRID in your PostGIS data base [how to import it here](https://github.com/Remi-C/IGN_spatial_ref_for_PostGIS)
 * create the postgres schema which will receive the open data paris table (optionnal)
 * set the variable at the begginning of the .sh script to reference you data folder, you preference ...
 * get into the postgres user (su postgres)
 * launch the .sh script 
 * exit the postgres user (exit)

## Details## 
the encoding is guessed based on the .dbf file : indeed, some of the file are encoded in ansi, some in Latin1, some in IBM850!
the table names are the shapefile name put to lower character.

