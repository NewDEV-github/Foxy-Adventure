extends Control
var latest_release_data_url= "https://api.github.com/repos/NewDEV-github/Foxy-Adventure/releases/latest"
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
	$HTTPRequest.request(latest_release_data_url, ["Accept: application/vnd.github.v3+json"], true, HTTPClient.METHOD_GET)
var updates_data = {}
var releases_data = {}
var release_notes_data = {}
var commits_data = []
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var data = json.result
	$Main.text = "Update " + data['name'] + " is avaliable"
	for i in data.keys():
		print(str(i) + " = " + str(data[i]))
	$TagData.bbcode_text = data['body']
	compare_versions(data['tag_name'])

func compare_versions(version:String):
	var f= File.new()
	f.open('res://version.dat', File.READ)
	var d = f.get_line()
	print('Current version is %s' % d)
	print('Latest version is ' + version)
	if version == d:
		print('up to date')
		return true
	else:
		print('not up to date')
		return false

