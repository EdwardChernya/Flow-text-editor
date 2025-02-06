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
global.runas_file_program = external_define("external_library.dll", "OpenFileProgram", dll_cdecl, ty_real, 2, ty_string, ty_string); // path, program (if no program its open with the default program, if program then it uses program to open the path)
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
	external_call(global.runas_file_program, path, program);
}
#endregion

#region images

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

global.save_png = external_define("external_library.dll", "save_png", dll_cdecl, ty_real, 4, ty_string, ty_string, ty_real, ty_real); // path, buffer data, width, height


// change these to work with image_resource struct, the iamge map already stores arrays with pixe ldata, width and height

function load_and_store_image(_file) {
	
	if (!file_exists(_file)) {
		new debug_text("image not found", c_red);
		return undefined;
	}
	
	// Create a buffer for width & height (2 integers)
	var info_buffer = buffer_create(12, buffer_fixed, 1); // 8 bytes (3 * 4-byte integers)

	if (external_call(global.image_info, _file, buffer_get_address(info_buffer)) == 0) {
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
	if (external_call(global.load_image, _file, buffer_get_address(img_buffer)) == 0) {
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

function save_stored_image_to_png(_image_id, _path, _fname) { // this is kind of unneeded as the images are either dumped to png or from local source or downloaded from youtube
	if (!ds_map_exists(IMAGE_MAP, _image_id)) {
		new debug_text("image not found");
		return;
	}
	var data = ds_map_find_value(IMAGE_MAP, _image_id); // IMAGE_MAP containts arrays with buffer, width and height
	var buffer = buffer_get_address(data[0]);
	var fname_append = 1;
	var temp_fname = _fname;
	if (file_exists(_path+_fname+".png")) {
		do {
			temp_fname = _fname + string(fname_append++);
		} until (!file_exists(_path+temp_fname+".png"));
	}
	_fname = temp_fname;
	if (external_call(global.save_png, _path + _fname + ".png", buffer, data[1], data[2]) == 0) {
		new debug_text("image save failed");
	}
}


#endregion

#region others

// Load the functions from the DLL
global.drop_handler_register = external_define("external_library.dll", "RegisterDragDropHandler", dll_cdecl, ty_real, 1, ty_string);
global.drop_handler_unregister = external_define("external_library.dll", "UnregisterDragDropHandler", dll_cdecl, ty_real, 1, ty_string);
global.check_dragging = external_define("external_library.dll", "IsDraggingFile", dll_cdecl, ty_real, 0);

global.drop_handler_get_file_count = external_define("external_library.dll", "GetDroppedFileCount", dll_cdecl, ty_real, 0);
global.drop_handler_get_drop_file = external_define("external_library.dll", "GetDroppedFile", dll_cdecl, ty_string, 1, ty_real);
global.drop_handler_clear_files = external_define("external_library.dll", "ClearDroppedFiles", dll_cdecl, ty_real, 0);


global.drop_handler_file_ext_filter = [ ".mp3", ".txt", ".png", ".jpg" ];
function get_drop_handler_files() {
	var ext = global.drop_handler_file_ext_filter;
	var n = external_call(global.drop_handler_get_file_count);
	var array = array_create(0);
	
	for (var i=0; i<n; i++) {
		var filename = external_call(global.drop_handler_get_drop_file, i);
		for (var j=0; j<array_length(ext); j++) {
			if (filename_ext(filename) != ext[j]) continue;
			array_push(array, filename);
			break;
		}
	}
	// clear the files
	external_call(global.drop_handler_clear_files);
	return array;
}


#endregion


// test
global.pointer_test = external_define("external_library.dll", "pointer_test", dll_cdecl, ty_real, 1, ty_string);



