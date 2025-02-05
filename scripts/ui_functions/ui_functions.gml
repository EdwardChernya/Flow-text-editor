// script goes brrrrrr


function debug_text(_string, _color=c_lime) constructor {
	
	x = window_get_width();
	y = window_get_height();
	y_initial = y;
	y_target = 0;
	
	text = _string;
	line_size = 22;
	draw_halign = fa_right;
	draw_valign = fa_bottom;
	color = _color;
	floating = true;
	
	timer = FRAMERATE*3;
	
	array_insert(DEBUG_ARRAY, 0, self);
	
	static UpdateDraw = function() {
		timer -= 1;
		if (timer <= 0) {
			Clear();
			return;
		}
		
		var _find_function = function (_element, _index) {
			return (_element == self);
		}
		y_target = y_initial - array_find_index(DEBUG_ARRAY, _find_function)*line_size;
		y += (y_target-y)*(1-exp(-5/FRAMERATE));
		
		// draw the text
		draw_set_color(color);
		draw_set_halign(draw_halign);
		draw_set_valign(draw_valign);
		draw_set_alpha(timer/FRAMERATE);
		draw_set_font(fnt_regular14);
		draw_text(x, y, text);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_alpha(1);
	}
	
	static Clear = function() {
		var _array_index, _find_function;
		
		_find_function = function (_element, _index) {
			return (_element == self);
		}
		
		_array_index = array_find_index(DEBUG_ARRAY, _find_function);
		if (_array_index != -1) array_delete(DEBUG_ARRAY, _array_index, 1);
	
	}
	
}


