
#region update

// drop handler
global.dragging_file = external_call(global.check_dragging);
if (global.dragging_file) {
	file_drop_trigger = false;
	image_drop_trigger = false;
	files = [];
} else {
	if (!file_drop_trigger) {
		file_drop_trigger = true;
		// drop handler
		var array = get_drop_handler_files();
		if (array_length(array) > 0) files = array;	
	}
}





#endregion 


#region hotkeys

if (array_length(files) > 0 and keyboard_check_pressed(vk_enter)) {
	open_file(files[0]);
}

if (array_length(files) > 0 and filename_ext(files[0]) == ".png" and !image_drop_trigger) {
	image_drop_trigger = true;
	draw_image_id = load_and_store_image(files[0]);
	no_image_id_error = true;
	save_stored_image_to_png(draw_image_id, FILES, "test");
}

if (keyboard_check(vk_control) and keyboard_check_pressed(ord("V"))) try_get_clipboard_sprite();

if (keyboard_check_pressed(ord("Q"))) { // example of passing pointer to a buffer to dll
	var value_buffer = buffer_create(4, buffer_fixed, 1); // one 4 byte integer
	buffer_write(value_buffer, buffer_u32, test_value);
	
	external_call(global.pointer_test, buffer_get_address(value_buffer));
	
	buffer_seek(value_buffer, buffer_seek_start, 0);
	test_value = buffer_read(value_buffer, buffer_u32);
	new debug_text(string(test_value));
	
	buffer_delete(value_buffer);
}

if (keyboard_check(vk_control) and keyboard_check(vk_alt) and keyboard_check_pressed(ord("D"))) {
	var keys = ds_map_keys_to_array(IMAGE_MAP);
	new debug_text("free " + string(array_length(keys)) + " images");
	for (var i=0; i<array_length(keys); i++) {
		var image_id = keys[i];
		var data = ds_map_find_value(IMAGE_MAP, image_id);
		buffer_delete(data[0]);
	}
	
	ds_map_clear(IMAGE_MAP);
}

if (keyboard_check_pressed(vk_escape)) game_end();



// youtube stuff
if (keyboard_check_pressed(ord("Y"))) {

yt_request_url = "https://youtu.be/7rKs-pMGSQ8?si=5DQax0McEdLIiwMG";
//request_video_info(yt_request_url);

// download audio ?
var path = format_path(DOWNLOADS);

var url = "https://youtu.be/7rKs-pMGSQ8?si=tc2x4cUZ-XKQeEJX";
var fname = "test file 1";
var arguments = "\"" + url + "\" \"" + fname + "\" " + path;
external_call(global.run_cmd_SHOW, "run_download.bat", arguments, working_directory);
url_open(url);

}






#endregion


#region visuals


clipboard_string = "no image data";
if (ex_clipboard_has_img() != 0) clipboard_string = "image detected";

timer += 1;
if (timer > 1) {
	animated_string += ".";
	timer = 0;
}

if (string_length(animated_string) > 20) animated_string = "";

#endregion