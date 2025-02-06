/// @description load dump wait time
// You can write your code in this editor

if (!file_exists("test_dump.png")) {
	new debug_text("test_dump.png doesn't exist", c_red);
	return;
}
//clipboard_img = sprite_add("test_dump.png", 1, false, false, 0, 0);

draw_image_id = load_and_store_image("test_dump.png");
no_image_id_error = true;