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
	$Control.process_to_bbcode(data['body'])
	print(str(data['body']).c_escape())
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
	var _platform_names = {
		"Windows": "windows-x64",
		"OSX": "osx",
		"X11": "linux-x64"
	}
	var _platform_suffixes = {
		"Windows": 'exe',
		'X11': 'run',
		'OSX': 'app'
	}
	var platform = _platform_names[OS.get_name()]
	var platform_suffix = _platform_suffixes[OS.get_name()]
	var url = Globals.install_base_path + 'autoupdate/autoupdate-%s.%s' % [platform, platform_suffix]
	OS.shell_open(url)



func _on_Node_extraction_finished(target):
	$Main2.set_text("Updating...")
	print("Exportet to: " + target)


func _on_Control_meta_clicked(meta):
	OS.shell_open(meta)
