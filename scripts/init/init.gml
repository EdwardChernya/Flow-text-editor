// script goes brrrrrr

#region macros

	global.framerate = 60;
	#macro FRAMERATE global.framerate

	global.init_objects_array = [
		obj_file_demo
	];
	#macro INIT_OBJ_ARRAY global.init_objects_array

	global.debug_array = array_create(0);
	#macro DEBUG_ARRAY global.debug_array
	
	#macro LT_BLUE #0099ff
	#macro FORCE_NOTEPAD false
	//show_debug_overlay(true, true);
	
	#macro MAX_IMPORT_IMG_SIZE 2048 // 2k images max

#endregion
