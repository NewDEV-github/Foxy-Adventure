extends Control
var request_commits_url = "https://api.github.com/repos/NewDEV-github/Foxy-Adventure/commits"
var request_releases_url = "https://api.github.com/repos/NewDEV-github/Foxy-Adventure/releases/tags/%s"
var request_notes_releases_url = "https://api.github.com/repos/NewDEV-github/Foxy-Adventure/releases/generate-notes"
var latest_release_url = ""
var base_patch_url = "https://github.com/NewDEV-github/Foxy-Adventure/releases/download/%s/%s"
var platforms = {
	"Windows": "build-win-64-3.4.zip",
	"OSX": "build-osx-3.4.zip",
	"X11": "build-x11-64-3.4.zip"
}
var tag_limit = 4
var _tmp_tag_download_info_result_notes = ""
var _tmp_tag_download_info:String = ""
var _tmp_tag_download_info_result={}
func _ready():
#	var test_dict =  {
#		"server_response": "Validation Failed",
#		"errors": "none",
#		"lol": {"lol": "glhf"},
#		"Array": ["Array", "array 1", "Array number Two_lol"]
#	}
#	$TagData.parse_text_from_dictionary(test_dict)
	$HTTPRequest.request(request_commits_url, ["Accept: application/vnd.github.v3+json"], true, HTTPClient.METHOD_GET)
var updates_data = {}
var releases_data = {}
var release_notes_data = {}
var commits_data = []
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var commits = json.result
	var latest_tag = commits[0]['sha'].left(7)
	commits_data = commits
	print(latest_tag)
	print("Latest release URL: " + (base_patch_url % [latest_tag, platforms[OS.get_name()]]))
	var _processed_tags = 0
	for i in commits:
		if not _processed_tags == tag_limit or not _processed_tags >= tag_limit:
			_processed_tags += 1
			print(i['sha'].left(6))
			add_tag_to_list(i['sha'].left(7))
			yield($release_data_downloader, "request_completed")
			yield($release_notes_downloader, "request_completed")
		else:
			print("Processed maximum (%s) tags" % tag_limit)

func download_update_by_tag(tag:String):
	Directory.new().make_dir_recursive("user://updates/" + tag)
	$patch_downloader.download_file = "user://updates/" + tag +"/" + platforms[OS.get_name()]
	$patch_downloader.request(base_patch_url % [tag, platforms[OS.get_name()]])
	yield($patch_downloader, "request_completed")
	##unzip and replace game files there and restart the game
func add_tag_to_list(tag:String):
	$TagList.add_item("Update " + tag)
	updates_data["Update " + tag] = tag
	print("Requesting data for: " + tag)
	print("Requesting release notes for: " + tag)
	download_update_info(tag)
	yield($release_notes_downloader, "request_completed")
	releases_data[tag]=_tmp_tag_download_info_result
	release_notes_data[tag]=_tmp_tag_download_info_result_notes

func download_update_info(tag:String):
	$release_data_downloader.request(request_releases_url % tag, ["Accept: application/vnd.github.v3+json"], true, HTTPClient.METHOD_GET)
	yield($release_data_downloader, "request_completed")
	var tag_js = JSON.print({'tag_name': tag})
	$release_notes_downloader.request(request_notes_releases_url, ["Accept: application/vnd.github.v3+json"], true, HTTPClient.METHOD_POST, tag_js)
	_tmp_tag_download_info = tag


func _on_release_data_downloader_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var js_result = json.result
	_tmp_tag_download_info_result = js_result
	print("Result for tag %s: %s" % [_tmp_tag_download_info, js_result])
	
func get_tag_info(id):
	return releases_data[updates_data[$TagList.get_item_text(id)]]
func get_notes_info(id):
	return release_notes_data[updates_data[$TagList.get_item_text(id)]]
func _on_TagList_item_selected(index):
	$TagData.parse_text_from_dictionary(get_tag_info(index), true, ["author", "url", "assets_url", "upload_url", "id", "html_url", "node_id"])
#	$ReleaseNotes.parse_text_from_dictionary(get_tag_info(index), true, ["author", "url", "assets_url", "upload_url", "id", "html_url", "node_id"])


func _on_release_notes_downloader_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var js_result = json.result
	_tmp_tag_download_info_result_notes = js_result
	print("Result (release notes) for tag %s: %s" % [_tmp_tag_download_info, js_result])
