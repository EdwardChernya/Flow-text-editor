// script goes brrrrrr

#region files

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

function open_folder(dname) {
	var path = format_path(dname);
	ex_open_explorer(path);
}

function open_file(dname) {
	var program = undefined;
	if (FORCE_NOTEPAD and file_type(dname, ".txt")) program = "notepad.exe";
	if (file_type(dname, ".mp3")) program = ex_get_default_app(".mp3");
	if (file_type(dname, ".txt")) program = ex_get_default_app(".txt");
	show_debug_message(program);
	// format path
	var path = format_path(dname);
	show_debug_message(path);
	// final check
	if (program == "") program = undefined;
	ex_open_file_permission(path, program);
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
global.load_image = external_define("external_library.dll", "load_image", dll_cdecl, ty_real, 2, ty_string, ty_string);
global.image_info = external_define("external_library.dll", "get_image_info", dll_cdecl, ty_real, 2, ty_string, ty_string);


#endregion


// test
global.pointer_test = external_define("external_library.dll", "pointer_test", dll_cdecl, ty_real, 1, ty_string);



