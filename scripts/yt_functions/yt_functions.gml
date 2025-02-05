// script goes brrrrrr


// yt api key
global.ytapikey = "AIzaSyB343C-4Xx2j3srbAX2ZqlUiG524r5zak8";
#macro YT_API global.ytapikey
global.ytapikey2 = "AIzaSyCmIrBNnfOn1oagtKwJKhM2_1Ug1M0IiTc";
#macro YT_API2 global.ytapikey2



function file_get_size(_file) {
	var _buff = buffer_load(_file);
	if (_buff <= 0) return 0;
	var _size = buffer_get_size(_buff);
	buffer_delete(_buff);
	return _size;
}


/// Extract Video ID from YouTube URL
function extract_id(_url) {
    var _video_id = "";
    
    if (string_pos("watch?v=", _url) > 0) {
        // Extract from standard URL
        _video_id = string_copy(_url, string_pos("watch?v=", _url) + 8, 11);
    } else if (string_pos("youtu.be/", _url) > 0) {
        // Extract from shortened URL
        _video_id = string_copy(_url, string_pos("youtu.be/", _url) + 9, 11);
    }
    
    return _video_id;
}


function request_video_info(_url) {
	
	if (yt_request_id != undefined or yt_thumbnail_download_request != undefined) {
		new debug_text("request already sent");
		return;
	}
	
	var video_id = extract_id(_url);
	
	// Define the YouTube API URL and your API key
	var url = "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=" + video_id + "&key=" + YT_API2;

	// Send the HTTP GET request asynchronously
	yt_request_id = http_get(url);
	
}


