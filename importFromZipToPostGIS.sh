#!/bin/bash

#Script by Rémi C
#loading open data paris in postgis

#This script load all the open data paris data in a folder (one zip per data) into a postgis database


#	Copyright 2013 Rémi C, IGN THALES 
#                                                                        
#	This program is free software: yo u can redistribute it and/or modify
#	it under the terms of the GNU Lesser General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU Lesser General Public License for more details.
#	You should have received a copy of the GNU Lesser General Public License
#	along with this program.  If not, see <http://www.gnu.org/licenses/>.



########################
#Variables : NEED TO BE TWEAKED

	#zip_data_folder ; the folder where the downloaded zip files from odparis are stored
		declare zip_data_folder="../../DATA/Donnees_ODP/20120720_brutes";
		
	#connection_options : the variable holding the details about ocnnecting to the database
		declare connection_options="psql -d odparis -p 5433";	
	
	
	#the shp2pgsql option, EXCLUDING the srid and the encoding which are automatically extracted
		declare shp2pgsql_command="shp2pgsql -d -g geom -D -I -N insert";
		
	#the postgres schema name for where to write table in database, it should exists !
		declare postgres_schema="odparis";
########################
		
		
		
		
		
		
	#srid of opendataparis : you should have imported it, it is IGNF:LAMB1, it will be retrieved from databse if it exists
		declare -i srid=0;	
	#getting the srid for open data paris :
	srid=`$connection_options -t --command "SELECT srid FROM spatial_ref_sys WHERE proj4text ILIKE '%IGNF:LAMB1'"`;	                                                                                                    	
	
	echo "here is the retrieved srid : $srid";

	
	declare encoding="null"; # variable to store the found encoding of the file
	declare working_folder="null";
	shopt -s nullglob;  #Safeguard to do nothing if the data folder is empty
	
	#going into the data folder
	cd $zip_data_folder; 
	for f in *.zip --loop on all zip files
	do
		echo "here is f : $f";
		var=$(pwd)
		echo "The current working directory $var" 
		
		echo "	extracting $f into folder";
		unzip -u "$f" #-d "${f%.*}" ;

		echo "		Converting dbf to texte extract";
		cd ${f%.*};
		
		echo "			name of extracted folder by unzip : ${f%.*} ";
		dbfdump -h *.dbf | head -c 1000000 > tmp_extract ;
		
		
		echo "	getting the charset of dbf extract";
		encoding=`file --mime-encoding tmp_extract`;
		
		
		#the encoding means :
		# iso-8859-1 = LATIN1
		# unknown-8bit = IBM850
		# us-ascii = there is no accentued character, can use LATIN1
		
			case "$encoding" in
			*iso-8859-1|*us-ascii )
			encoding="LATIN1";
			echo "encoding : $encoding";
			;;
			
			*unknown-8bit)
			echo "oops, encoding not known, must be IBM850";
			encoding="IBM850";
			;;
			
			*)
			echo "encoding is nothing expected ($encoding), stopping"
			exit 1;
			;;
			esac
		
		
		
		declare current_shp_name="null"
		for g in *.shp; do
			current_shp_name="$g";
			break;
		done
		echo "getting the name of the .shp file : $current_shp_name";
		
		echo "loading into PostGIS with proper encoding option, table name are converted to lower casse to enforce postgres good practice.
			$shp2pgsql_command -s $srid -W $encoding $current_shp_name $postgres_schema."$(echo ${current_shp_name%.*} | tr '[A-Z]' '[a-z]')" | $connection_options;
			";
		
		$shp2pgsql_command -s $srid -W $encoding $current_shp_name $postgres_schema."$(echo ${current_shp_name%.*} | tr '[A-Z]' '[a-z]')" | $connection_options;
		
		
		
		#| psql --set ON_ERROR_STOP=on dbname  
		#	$7 -c "$commande_sql";
		
		echo "cleaning temporary dbf extract";
		rm tmp_extract;
		cd ..;
		
		
	done
exit 0
		

