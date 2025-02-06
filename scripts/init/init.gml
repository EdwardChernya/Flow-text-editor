// script goes brrrrrr

#region macros

	global.framerate = 60;
	#macro FRAMERATE global.framerate

	global.init_objects_array = [
		o_debug
	];
	#macro INIT_OBJ_ARRAY global.init_objects_array

	global.debug_array = array_create(0);
	#macro DEBUG_ARRAY global.debug_array
	
	#macro LT_BLUE #0099ff
	#macro FORCE_NOTEPAD false
	
	// use run_command_SHOW or hide the consoles
	#macro SHOW_COMMAND_CONSOLE true

	
	if (!directory_exists("Downloads")) {
		new debug_text("creating Downloads folder");
		directory_create("Downloads");
	}
	global.downloads_folder = working_directory + "Downloads\\";
	#macro DOWNLOADS global.downloads_folder
	
	if (!directory_exists("Files")) {
		new debug_text("creating Files folder");
		directory_create("Files");
	}
	global.files_folder = working_directory + "Files\\";
	#macro FILES global.files_folder
	
	if (!directory_exists("Temp")) {
		new debug_text("creating Temp folder");
		directory_create("Temp");
	}
	global.temp_folder = working_directory + "Temp\\";
	#macro TEMP global.temp_folder
	
	if (!directory_exists(TEMP + "Dump")) {
		new debug_text("creating Dump folder");
		directory_create(TEMP + "Temp");
	}
	global.dump_folder = TEMP + "Dump\\";
	#macro DUMP global.dump_folder
	
	
	global.current_file = "Default";
	#macro CURRENT_FILE global.current_file
	new debug_text("current file " + CURRENT_FILE);
	global.current_resource_id = 0;
	#macro CURRENT_RESOURCE_ID global.current_resource_id
	
#endregion
