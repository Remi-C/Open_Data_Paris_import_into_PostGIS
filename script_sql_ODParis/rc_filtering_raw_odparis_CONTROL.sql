/*
Rémi C
THALES-TELECOM  
29/08/2012

this script filters raw OpenData Paris data into more workable data :
Each operation is explained
See documentation before the function definition for more precisions

This is the control part (you need to create the function before! )

Step 9 and 10 are optionnal (9 optionnal if ther already is spatial indexes, 10 optionnal because clustering hasn't be clearly proven to increase data access performance anyway)

WARNING : depend on :

rc_random_string(INTEGER )
rc_change_all_libelle_info_length_in_a_schema(schema_name text)
 rc_add_prefix_to_info_column(text,text[],text[])
 rc_table_exists();
 rc_create_index_on_all_info_column_in_schema
rc_filtering_raw_odparis
 */


--1. Delete useless table 
	BEGIN;
		SELECT rc_filtering_raw_odparis('odparis_corrected',ARRAY[TRUE,FALSE, FALSE,FALSE, FALSE,FALSE, FALSE,FALSE, FALSE,FALSE]);
	COMMIT;
	END;

--2. Rename tables 	
	BEGIN;
		SELECT rc_filtering_raw_odparis('odparis_corrected'::Text,ARRAY[FALSE,TRUE, FALSE,FALSE, FALSE,FALSE, FALSE,FALSE, FALSE,FALSE]);
	COMMIT;
	END;

--3. Editing of complexe table 
	BEGIN;
		SELECT rc_filtering_raw_odparis('odparis_corrected'::Text,ARRAY[FALSE,FALSE, TRUE,FALSE, FALSE,FALSE, FALSE,FALSE, FALSE,FALSE]);
	COMMIT;
	END;
	
--4. Dealing with null and 'Objet sans identification particulière pour ce niveau' values 
	BEGIN;
		SELECT rc_filtering_raw_odparis('odparis_corrected'::Text,ARRAY[FALSE,FALSE, FALSE,TRUE, FALSE,FALSE, FALSE,FALSE, FALSE,FALSE]);
	COMMIT;END;
	
--5. Changing the data type of 'libelle' and 'info' 
	BEGIN;
		SELECT rc_filtering_raw_odparis('odparis_corrected'::Text,ARRAY[FALSE,FALSE, FALSE,FALSE, TRUE,FALSE, FALSE,FALSE, FALSE,FALSE]);
	COMMIT;END;
	
--6. Fusinning tables with close contents 
	BEGIN;
		SELECT rc_filtering_raw_odparis('odparis_corrected'::Text,ARRAY[FALSE,FALSE, FALSE,FALSE, FALSE,TRUE, FALSE,FALSE, FALSE,FALSE]);
	COMMIT;END;

--7. Changing info nomenclatura to add the table name as a prefixe except to info already prefixed (like BOR_UNK or DDB_UNK)
	BEGIN;
		SELECT rc_filtering_raw_odparis('odparis_corrected'::Text,ARRAY[FALSE,FALSE, FALSE,FALSE, FALSE,FALSE, TRUE,FALSE, FALSE,FALSE]);
	COMMIT;END;
	
--8. Creating Binary Tree indexes on the info columns 
	BEGIN;
		SELECT rc_filtering_raw_odparis('odparis_corrected'::Text,ARRAY[FALSE,FALSE, FALSE,FALSE, FALSE,FALSE, FALSE,TRUE, FALSE,FALSE]);
	COMMIT;END;

-------OPTIONAL---------
--9. Creating Rectangle Tree indexes on the geom info 
	BEGIN;
		SELECT rc_filtering_raw_odparis('odparis_corrected'::Text,ARRAY[FALSE,FALSE, FALSE,FALSE, FALSE,FALSE, FALSE,FALSE, TRUE,FALSE]);
	COMMIT;END;

-------OPTIONAL---------
--10. Clustering physically the tables based on the index on info. 
	BEGIN;
		SELECT rc_filtering_raw_odparis('odparis_corrected'::Text,ARRAY[FALSE,FALSE, FALSE,FALSE, FALSE,FALSE, FALSE,FALSE, FALSE,TRUE]);
	COMMIT;	END;