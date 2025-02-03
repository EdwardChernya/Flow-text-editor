/// @description Insert description here
// You can write your code in this editor

// update and draw debug array
gpu_set_blendmode(bm_add);
for (var i=0; i<array_length(DEBUG_ARRAY); i++) {
	DEBUG_ARRAY[i].UpdateDraw();
}
gpu_set_blendmode(bm_normal);