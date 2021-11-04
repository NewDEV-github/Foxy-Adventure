extends Control


# Declare member variables here. Examples:
# var a = 2
var base_install_path = "user://dlcs/"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

func activate_license_key_in_game(key:String, product:String):
	var result
	var cfg = ConfigFile.new()
	cfg.load_encrypted_pass("user://lk_data.cfg", "wefbgfrfgb")
	cfg.set_value("keys", product, key)
	cfg.save_encrypted_pass("user://lk_data.cfg", "wefbgfrfgb")

var _validation_result_d
func validate_license_key(key:String):
	print('VAILDATION STARTED...')
	print('PARSING DATA...')
	var data = {'license_key': key}
	var query = JSON.print(data)
	var url = "https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/api/validate_license_key/"
	print('SENDING DATA...')
	$Vaildator.request(url, ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, query)
	print('AWAITING FOR SERVER RESPONSE...')

func get_activated_products_in_game():
	var cfg = ConfigFile.new()
	cfg.load_encrypted_pass("user://lk_data.cfg", "wefbgfrfgb")
	return cfg.get_section_keys("keys")

func _on_Vaildator_request_completed(result, response_code, headers, body):
	print('RECIVING DATA...')
	print('PARSING DATA...')
	var vaildation_result = JSON.parse(body.get_string_from_utf8()).result
	_tmp_dlc_name = vaildation_result['product']
	print(vaildation_result['exists'])
	if vaildation_result['exists'] == "True":
		#exists
#		print(Globals.user_data)
		if vaildation_result['assigned_to_user'] == Globals.user_data['localid']:
			download_content(vaildation_result['product'])
			$VBoxContainer/result.text = "Vaildation successfull, downloading now..."
		else:
			$VBoxContainer/result.text = "Sorry, this is wrong license key"
	else:
		$VBoxContainer/result.text = "Sorry, this is wrong license key"


func download_content(content_name:String):
	print('DOWNLOADING STARTED...')
	print('PARSING DATA...')
	var data = {'content_name': content_name}
	var query = JSON.print(data)
	var url = "https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/api/get_content_download_data/"
	print('SENDING DATA...')
	$ContentDataDownloader.request(url, ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, query)
	print('AWAITING FOR SERVER RESPONSE...')

var _tmp_download_files = 0
var _tmp_downloaded_files = 0
var _tmp_dlc_name = ""
func _on_ContentDataDownloader_request_completed(result, response_code, headers, body):
	print('RECIVING DATA...')
	print('PARSING DATA...')
	#LINKs for all files will be placed in database and they will be returned there
#	{"cfg": download link, "pck1": download link} etc.
	var _result = JSON.parse(body.get_string_from_utf8()).result
	for i in _result:
		_tmp_download_files += 1
	$VBoxContainer/AllFilesDownloadProgress.max_value = _tmp_download_files
	var dir = Directory.new()
	if not dir.dir_exists(base_install_path + _tmp_dlc_name + "/"):
		dir.make_dir_recursive(base_install_path + _tmp_dlc_name + "/")
	for i in _result:
		$VBoxContainer/FileDownloadProgress.value = 0
		set_process(true)
		var download_name = _result[i].get_file()
		var download_url = _result[i]
		print("DOWNLOADING FILE: " + download_name + "...")
		$ContentFileDownloader.download_file = base_install_path + _tmp_dlc_name + "/" + download_name
		$ContentFileDownloader.request(download_url)
		yield($ContentFileDownloader, "request_completed")

func _on_ContentFileDownloader_request_completed(result, response_code, headers, body):
	_tmp_downloaded_files += 1
	$VBoxContainer/AllFilesDownloadProgress.value = _tmp_downloaded_files
	set_process(false)


func _on_ContentCFGDownloader_request_completed(result, response_code, headers, body):
	pass # Replace with function body.

func _process(delta):
	$VBoxContainer/FileDownloadProgress.value = (($ContentFileDownloader.get_downloaded_bytes())*100/$ContentFileDownloader.get_body_size())


func _on_AddKeyButton_pressed():
	if $VBoxContainer/LineEdit.text == "":
		$VBoxContainer/result.text = "Please, enter license key"
	else:
		validate_license_key($VBoxContainer/LineEdit.text)
