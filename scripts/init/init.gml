// script goes brrrrrr

#macro LT_BLUE #0099ff
#macro FORCE_NOTEPAD false
//show_debug_overlay(true, true);




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

function try_get_clipboard_sprite() {
	if (ex_clipboard_has_img() == 0) return undefined;
	
	ex_clipboard_dump_png("test_dump.png");
	
	return sprite_add("test_dump.png", 1, false, false, 0, 0);
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