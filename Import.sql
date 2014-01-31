/*
*Rémi-C , 2014
*
*Script to load Open Data Paris Data into a PostGis data base, taking care of the encoding and the srid
*
*/


-- Getting the correct srid : you need to get the IGNF srid, see other repository
--https://github.com/Remi-C/IGN_spatial_ref_for_PostGIS/blob/master/Put_IGN_SRS_into_Postgis.sql

	--do you have the ODParis srid?
	SELECT *
	FROM spatial_ref_sys
	WHERE proj4text ILIKE '%IGNF:LAMB1%';

	--the srid is for "LAMB1" : 932001

--importing one file at a time
--here are the shell command, for memory : 

	--	arbres_alignement-2010\arbres.shp , LATIN1 
	--	arbres_remarquables_2011\Arbres_remarquables.shp , LATIN1
	--	

	SELECT DISTINCT libelle FROM public.barriere    LIMIT 100
	