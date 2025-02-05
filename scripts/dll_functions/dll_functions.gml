// script goes brrrrrr

#region files and commands

function format_path(path) {
	path = string_replace_all(path, "\\", "\\\\");
	path = "\"" + path + "\""; // Add quotes around the path if it contains spaces
	return path;
}
function file_type(path, _type) {
	var len = string_length(path);
	if (len < 4) return false;
	var ext = string_copy(path, len-3, 4);
	if (ext == _type) return true;
	return false;
}

// voids have to be set as ty_real return type
global.get_file_association = external_define("external_library.dll", "GetFileAssociation", dll_cdecl, ty_string, 1, ty_string); // string with file ext for example ".txt"
global.open_path = external_define("external_library.dll", "OpenExplorer", dll_cdecl, ty_real, 1, ty_string); // path
global.open_file_program = external_define("external_library.dll", "OpenFileProgram", dll_cdecl, ty_real, 2, ty_string, ty_string); // path, program
global.run_cmd = external_define("external_library.dll", "Execute", dll_cdecl, ty_real, 3, ty_string, ty_string, ty_string); // program, arguments, dir
global.run_cmd_SHOW = external_define("external_library.dll", "ExecuteSHOW", dll_cdecl, ty_real, 3, ty_string, ty_string, ty_string); // program, arguments, dir


function open_folder(dname) { // formats path and runs c++ code
	var path = format_path(dname);
	external_call(global.open_path, path);
}

function open_file(dname) {
	var program = undefined;
	if (FORCE_NOTEPAD and file_type(dname, ".txt")) program = "notepad.exe";
	if (file_type(dname, ".mp3")) program = external_call(global.get_file_association, ".mp3");
	if (file_type(dname, ".txt")) program = external_call(global.get_file_association, ".txt");
	show_debug_message(program);
	// format path
	var path = format_path(dname);
	show_debug_message(path);
	// final check
	if (program == "") program = undefined;
	external_call(global.open_file_program, path, program);
}
#endregion

#region clipboard and images

function try_get_clipboard_sprite() { // needs alarm[0] to load the dump
	if (ex_clipboard_has_img() == 0) return undefined;
	
	if (ex_clipboard_dump_png("test_dump.png") == 0) {
		new debug_text("dump failed", c_red);
		return;
	}
	alarm[0] = 1;
	// optional return path to the image
	// return path code here
}

// Define external functions
global.load_image = external_define("external_library.dll", "load_image", dll_cdecl, ty_real, 2, ty_string, ty_string); // write image data to a buffer
global.image_info = external_define("external_library.dll", "get_image_info", dll_cdecl, ty_real, 2, ty_string, ty_string); // write image info to a buffer

function load_and_store_image(_file) {
	
	// Create a buffer for width & height (2 integers)
	var info_buffer = buffer_create(12, buffer_fixed, 1); // 8 bytes (3 * 4-byte integers)

	if (external_call(global.image_info, "test_dump.png", buffer_get_address(info_buffer)) == 0) {
		new debug_text("image info failed", c_red);
		return undefined;
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
		return undefined;
	}
	
	var image_id = global.image_id_counter++;
	ds_map_add(IMAGE_MAP, image_id, [img_buffer, width, height]);
	
	return image_id;

}

function draw_stored_image(_image_id, _x, _y) {
	
	if (!ds_map_exists(IMAGE_MAP, _image_id)) {
		new debug_text("image id " + string(_image_id) + " missing");
		return 0;
	}
	
	var data = ds_map_find_value(IMAGE_MAP, _image_id);
	var img_buffer = data[0];
	var width = data[1];
	var height = data[2];
	
	// Create a surface and draw the buffer onto it
	var surf = surface_create(width, height);
	
	surface_set_target(surf);
	draw_clear_alpha(c_black, 0);
	buffer_set_surface(img_buffer, surf, 0);
	surface_reset_target();
	
	draw_surface(surf, _x, _y);
	surface_free(surf);
	
	return 1;
}

function free_stored_image(_image_id) {
	if (!ds_map_exists(IMAGE_MAP, _image_id)) return;
	var data = ds_map_find_value(IMAGE_MAP, _image_id);
	buffer_delete(data[0]);
	ds_map_delete(IMAGE_MAP, _image_id);
}

#endregion


// test
global.pointer_test = external_define("external_library.dll", "pointer_test", dll_cdecl, ty_real, 1, ty_string);



