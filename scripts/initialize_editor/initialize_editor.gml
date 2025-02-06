// script goes brrrrrr

function initialize_editor() {



//show_debug_overlay(true, true);

// set fps
game_set_speed(FRAMERATE, gamespeed_fps);

// create init objects
for (var i=0;i<array_length(INIT_OBJ_ARRAY); i++) {
	instance_create_layer(0, 0, "Instances", INIT_OBJ_ARRAY[i]);
}



#region loading and storing images

global.image_map = ds_map_create();
#macro IMAGE_MAP global.image_map
global.image_id_counter = 0;

// load images from a file if game started by opening one
// load image counter and ds map to match the file

// save images as pngs to save space, buffers aren't compressed


#endregion



// dra and drop features
global.window_handle = window_handle();
// Register the drag-drop handler
external_call(global.drop_handler_register, global.window_handle);
global.dragging_file = false;






}


// game end code
function deinitialize_editor() {
	
ds_map_destroy(IMAGE_MAP);
external_call(global.drop_handler_unregister);
	
}