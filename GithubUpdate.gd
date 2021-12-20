extends Control
var request_commits_url = "https://api.github.com/repos/NewDEV-github/Foxy-Adventure/commits"
var request_releases_url = "https://api.github.com/repos/NewDEV-github/Foxy-Adventure/releases/tags/%s"
var latest_release_url = ""
var base_patch_url = "https://github.com/NewDEV-github/Foxy-Adventure/releases/download/%s/%s"
var platforms = {
	"Windows": "build-win-64-3.4.zip",
	"OSX": "build-osx-3.4.zip",
	"X11": "build-x11-64-3.4.zip"
}
func _ready():
	$HTTPRequest.request(request_commits_url, [], true, HTTPClient.METHOD_GET)
var updates_data = {}
var releases_data = {}
var commits_data = []
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var commits = json.result
	var latest_tag = commits[0]['sha'].left(6)
	commits_data = commits
	print(latest_tag)
	print("Latest release URL: " + (base_patch_url % [latest_tag, platforms[OS.get_name()]]))
	for i in commits:
		print(i['sha'].left(6))

func download_update_by_tag(tag:String):
	Directory.new().make_dir("user://updates/")
	$patch_downloader.download_file = "user://" + tag +"/" + platforms[OS.get_name()]
	$patch_downloader.request(base_patch_url % [tag, platforms[OS.get_name()]])
	yield($patch_downloader, "request_completed")
	##unzip and replace game files there and restart the game
func add_tag_to_list(tag:String):
	$TagList.add_item("Update " + tag)
	updates_data["Update " + tag] = tag
#	releases_data[tag]=
func download_update_info(tag:String):
	$release_data_downloader.request(request_releases_url % tag, [], true, HTTPClient.METHOD_GET)
	


func _on_release_data_downloader_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var js_result = json.result
