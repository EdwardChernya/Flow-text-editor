
#region update

var array = file_dropper_get_files();
file_dropper_flush();

if (array_length(array) > 0) {
    self.files = array;
	
}

#endregion 


#region hotkeys

if (array_length(files) > 0 and keyboard_check_pressed(vk_enter)) {
	open_file(files[0]);
}


if (keyboard_check(vk_control) and keyboard_check_pressed(ord("V"))) {
	if (clipboard_img != undefined) {
		sprite_delete(clipboard_img);
	}
	clipboard_img = try_get_clipboard_sprite();
}

if (keyboard_check_pressed(ord("Q"))) {
	var value_buffer = buffer_create(4, buffer_fixed, 1); // one 4 byte integer
	buffer_write(value_buffer, buffer_u32, test_value);
	
	external_call(global.pointer_test, buffer_get_address(value_buffer));
	
	buffer_seek(value_buffer, buffer_seek_start, 0);
	test_value = buffer_read(value_buffer, buffer_u32);
	new debug_text(string(test_value));
	
	buffer_delete(value_buffer);
}

if (keyboard_check_pressed(vk_escape)) game_end();

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