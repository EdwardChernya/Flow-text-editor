/// @description Insert description here
// You can write your code in this editor


// Video info
if (async_load[? "id"] == yt_request_id) {
	
	// Check if the request was successful
    if (async_load[? "status"] == 0) {
		// reset request
		yt_request_id = undefined;
        var json_response = json_parse(async_load[? "result"]);
		new debug_text("http status " + string(async_load[? "http_status"]));
		
        // Make sure the response contains video details
        if (json_response != undefined and json_response.items != undefined and array_length(json_response.items) > 0) {
		
            var video_info = json_response[$ "items"][0];
            var video_title = video_info[$ "snippet"].title;
			
			var thumbnail_url = string(video_info.snippet.thumbnails[$ "medium"].url);
			new debug_text("Downloading " + thumbnail_url);
			yt_thumbnail_download_request = http_get_file(thumbnail_url, DOWNLOADS + "1.jpg");
			
			// download audio here after getting the name
			
            new debug_text("Video Title " + video_title);
        } else {
            new debug_text("No video info found");
        }
    } else if (async_load[? "status"] == 1) {
        // ⏳ Request still in progress, receiving packets
	    var size_downloaded = async_load[? "sizeDownloaded"];
	    var total_size = async_load[? "contentLength"];

		new debug_text("Processing");
	    if (total_size > 0) {
	        var progress = round((size_downloaded / total_size) * 100);
	        new debug_text("⏳ Downloading " + string(progress) + "%");
	    }
    }
}


// thumbnail
if (async_load[? "id"] == yt_thumbnail_download_request) {
	
	// Check if the request was successful
    if (async_load[? "status"] == 0) {
		// reset request
		yt_thumbnail_download_request = undefined;
		yt_request_url = undefined;
		new debug_text("Thumbnail downloaded");
        
    } else if (async_load[? "status"] == 1) {
        // ⏳ Request still in progress, receiving packets
	    var size_downloaded = async_load[? "sizeDownloaded"];
	    var total_size = async_load[? "contentLength"];
		
		new debug_text("Downloading");
	    if (total_size > 0) {
	        var progress = round((size_downloaded / total_size) * 100);
	        new debug_text(string(progress) + "%");
	    }
    } else if (async_load[? "status"] == -1) {
		new debug_text("error downloading :/");
	}
	
}