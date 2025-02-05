// fix resolution
display_set_gui_maximize();

#region visuals

	draw_set_font(fnt_regular14);
	draw_set_color(c_white);
	draw_set_halign(fa_left);
	if (array_length(files) > 0) {
	    for (var i = 0; i < array_length(self.files); i++) {
	        draw_text(64, 64 + 48 * i, self.files[i]);
	    }
	} else {
	    draw_text(64, 64, "Drag some files into the window from Explorer!");
	}


	draw_set_halign(fa_center);
	draw_text(window_get_width()/2, 0, working_directory);
	if (clipboard_string == "image detected") draw_set_color(LT_BLUE);
	draw_text(900, 64, clipboard_string);
	draw_set_halign(fa_left);
	draw_text(window_get_width()/2-100, 128, animated_string);
	draw_set_color(c_lime);
	draw_set_halign(fa_right);
	draw_text(window_get_width(), 0, string(fps));

#endregion


// actual clipboard image

if (image_id != undefined and no_image_id_error) no_image_id_error = draw_stored_image(image_id, 0, 192);


