extends Node
var request_url = "https://api.github.com/repos/NewDEV-github/Foxy-Adventure/commits"

var latest_release_url = ""
var base_patch_url = "https://github.com/NewDEV-github/Foxy-Adventure/releases/download/%s/%s"
var platforms = {
	"Windows": "build-win-64-3.4.zip",
	"OSX": "build-osx-3.4.zip",
	"X11": "build-x11-64-3.4.zip"
}
func _ready():
	$HTTPRequest.request(request_url, [], true, HTTPClient.METHOD_GET)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var commits = json.result
	var latest_tag = commits[0]['sha'].left(6)
	print(latest_tag)
	print("Latest release URL: " + (base_patch_url % [latest_tag, platforms[OS.get_name()]]))
		
func download():
	pass
