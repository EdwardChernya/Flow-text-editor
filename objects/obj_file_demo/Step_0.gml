var array = file_dropper_get_files();
file_dropper_flush();

if (array_length(array) > 0) {
    self.files = array;
	
}

if (array_length(files) > 0 and keyboard_check_pressed(vk_enter)) {
	open_file(files[0]);
}

clipboard_string = "no image data";
if (ex_clipboard_has_img() != 0) clipboard_string = "image detected";

if (keyboard_check(vk_control) and keyboard_check_pressed(ord("V"))) {
	if (clipboard_img != undefined) {
		sprite_delete(clipboard_img);
	}
	clipboard_img = try_get_clipboard_sprite();
}


if (keyboard_check_pressed(vk_escape)) game_end();

timer += 1;
if (timer > 1) {
	animated_string += ".";
	timer = 0;
}

if (string_length(animated_string) > 20) animated_string = "";