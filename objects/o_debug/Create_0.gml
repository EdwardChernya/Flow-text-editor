self.files = [];

clipboard_string = "no image data";
image_id = undefined;
no_image_id_error = true;

open_folder(DOWNLOADS);

animated_string = "";
timer = 0;

test_value = 0;


// yt
yt_request_id = undefined;
yt_request_url = undefined;
yt_thumbnail_download_request = undefined;




//// Create the buffer to store the pixel data (width * height * 4 for RGBA)
//surface_width = 800; // Adjust width as needed
//surface_height = 600; // Adjust height as needed
//pixel_buffer_size = surface_width * surface_height * 4; // 4 bytes per pixel (RGBA)
//buffer_id = buffer_create(pixel_buffer_size, buffer_fixed, 1); // Create buffer

//// Get the address of the buffer to pass to the DLL
//buffer_address = buffer_get_address(buffer_id);

//// pass adress to dll and have dll write pixel data to the buffer
//external_call(global.send_buffer_to_chromium, buffer_address, surface_width, surface_height, surface_width * 4);

//// init chromium
//external_call(global.start_chromium);