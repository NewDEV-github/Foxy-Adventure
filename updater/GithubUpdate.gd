extends WindowDialog
var latest_release_data_url= "https://api.github.com/repos/NewDEV-github/Foxy-Adventure/releases/latest"
var latest_tag = ""
var platforms = {
	"Windows": "build-win-64-3.4.zip",
	"OSX": "build-osx-3.4.zip",
	"X11": "build-x11-64-3.4.zip"
}

func _ready():
	$HTTPRequest.request(latest_release_data_url, ["Accept: application/vnd.github.v3+json"], true, HTTPClient.METHOD_GET)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var data = json.result
	$Main.text = "Checking for updates"
	for i in data.keys():
		print(str(i) + " = " + str(data[i]))
	$TagData.bbcode_text = data['body']
	latest_tag = data['tag_name']
	if compare_versions(data['tag_name']):
		$Main.text = "You have the newest version"
	else:
		$Main.text = "Update " + data['name'] + " is avaliable"

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

func _on_Download_pressed():
	var url = "https://github.com/NewDEV-github/Foxy-Adventure/releases/download/%s/%s" % [latest_tag, platforms[OS.get_name()]]
	Directory.new().make_dir_recursive("user://updates/%s" % [latest_tag])
	Directory.new().make_dir_recursive("user://updates/_tmp/%s" % [latest_tag])
	if not File.new().file_exists("user://updates/%s/%s" % [latest_tag, platforms[OS.get_name()]]):
		$patch_downloader.download_file = "user://updates/%s/%s" % [latest_tag, platforms[OS.get_name()]]
		$patch_downloader.request(url)
	Unzip.unzip("user://updates/%s/%s" % [latest_tag, platforms[OS.get_name()]],"user://updates/_tmp/%s" % [latest_tag])
