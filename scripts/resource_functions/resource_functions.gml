// script goes brrrrrr


function resource() constructor { // id of the file they are attached to and id of the resource itself
	
	fid = CURRENT_FILE;
	rid = CURRENT_RESOURCE_ID++;
	
	rname = undefined;
	rextension = undefined;
	
	static init_res = function(_name, _extension) {
		rname = _name;
		rextension = _extension;
		new debug_text("inheritance works", c_red);
	}
	
}


function text_resource() : resource() constructor {
	
}


function song_resource() : resource() constructor {
	
}


function image_resource() : resource() constructor {
	
}

var s1 = new image_resource();
s1.init_res();

var s2 = new song_resource();
s2.init_res();