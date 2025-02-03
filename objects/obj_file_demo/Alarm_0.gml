/// @description load dump wait time
// You can write your code in this editor

if (!file_exists("test_dump.png")) {
	new debug_text("test_dump.png doesn't exist", c_red);
	return;
}
//clipboard_img = sprite_add("test_dump.png", 1, false, false, 0, 0);

// Create a buffer for width & height (2 integers)
var info_buffer = buffer_create(12, buffer_fixed, 1); // 8 bytes (3 * 4-byte integers)

if (external_call(global.image_info, "test_dump.png", buffer_get_address(info_buffer)) == 0) {
	new debug_text("image info failed", c_red);
	exit;
}

// Read width & height from buffer
buffer_seek(info_buffer, buffer_seek_start, 0);
var width = buffer_read(info_buffer, buffer_u32);
var height = buffer_read(info_buffer, buffer_u32);
var size = buffer_read(info_buffer, buffer_u32);

buffer_delete(info_buffer); // Delete width/height buffer


// Create a buffer to store the image data
var img_buffer = buffer_create(size, buffer_fixed, 1);

// Call DLL function to load the image into the buffer
if (external_call(global.load_image, "test_dump.png", buffer_get_address(img_buffer)) == 0) {
	new debug_text("image load failed", c_red);
	exit;
}

// Create a surface and draw the buffer onto it
if (surface_exists(clipboard_surface)) {
	surface_resize(clipboard_surface, width, height);
} else {
	clipboard_surface = surface_create(width, height);
}
surface_set_target(clipboard_surface);
draw_clear_alpha(c_black, 0);
buffer_set_surface(img_buffer, clipboard_surface, 0);
surface_reset_target();


// Cleanup
buffer_delete(img_buffer);
