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
	global.downloads = working_directory + "Downloads\\";
	#macro DOWNLOADS global.downloads
	new debug_text(DOWNLOADS);
	
#endregion
