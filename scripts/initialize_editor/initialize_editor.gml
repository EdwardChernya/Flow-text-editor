// script goes brrrrrr

function initialize_editor(){

// set fps
game_set_speed(FRAMERATE, gamespeed_fps);

// create objects
for (var i=0;i<array_length(INIT_OBJ_ARRAY); i++) {
	instance_create_layer(0, 0, "Instances", INIT_OBJ_ARRAY[i]);
}





}