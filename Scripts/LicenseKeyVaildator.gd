extends Control


# Declare member variables here. Examples:
# var a = 2
var base_install_path = "user://dlcs/"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

func activate_license_key_in_game(key:String, product_name:String):
	var result
	var cfg = ConfigFile.new()
	cfg.load_encrypted_pass("user://lk_data.cfg", "wefbgfrfgb")
	cfg.set_value("keys", key, product_name)
	cfg.save_encrypted_pass("user://lk_data.cfg", "wefbgfrfgb")

var _validation_result_d
func validate_license_key(key:String):
	$VBoxContainer/result.text = tr("KEY_LICENSES_VALIDATION_STARTED")
	$VBoxContainer/result.text = tr("KEY_LICENSES_PARSING_DATA")
	var data = {'license_key': key}
	_tmp_dlc_license_key = key
	var query = JSON.print(data)
	var url = "https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/api/validate_license_key/"
	$VBoxContainer/result.text = tr("KEY_LICENSES_SENDING_DATA")
	$Vaildator.request(url, ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, query)
	$VBoxContainer/result.text = tr("KEY_LICENSES_AWAITING_FOR_SERVER_RESPONSE")

func get_activated_products_in_game():
	var cfg = ConfigFile.new()
	cfg.load_encrypted_pass("user://lk_data.cfg", "wefbgfrfgb")
	return cfg.get_section_keys("keys")

func _on_Vaildator_request_completed(result, response_code, headers, body):
	$VBoxContainer/result.text = tr("KEY_LICENSES_RECIVING_DATA")
	$VBoxContainer/result.text = tr("KEY_LICENSES_PARSING_DATA")
	var vaildation_result = JSON.parse(body.get_string_from_utf8()).result
	_tmp_dlc_name = vaildation_result['product']
	print(vaildation_result['exists'])
	if vaildation_result['exists'] == "True":
		#exists
#		$VBoxContainer/result.text = Globals.user_data)
		if vaildation_result['assigned_to_user'] == Globals.user_data['localid']:
			download_content(vaildation_result['product'])
			$VBoxContainer/result.text = tr("KEY_LICENSES_VALIDATION_SUCCESSFUL")
		else:
			$VBoxContainer/result.text = tr("KEY_LICENSES_WRONG_LICENSE_KEY")
	else:
		$VBoxContainer/result.text = tr("KEY_LICENSES_WRONG_LICENSE_KEY")


func download_content(content_name:String):
	$VBoxContainer/result.text = tr("KEY_LICENSES_DOWNLOADING_STARTED")
	$VBoxContainer/result.text = tr("KEY_LICENSES_PARSING_DATA")
	var data = {'content_name': content_name}
	var query = JSON.print(data)
	var url = "https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/api/get_content_download_data/"
	$VBoxContainer/result.text = tr("KEY_LICENSES_SENDING_DATA")
	$ContentDataDownloader.request(url, ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, query)
	$VBoxContainer/result.text = tr("KEY_LICENSES_AWAITING_FOR_SERVER_RESPONSE")

var _tmp_download_files = 0
var _tmp_downloaded_files = 0
var _tmp_dlc_name = ""
var _tmp_dlc_full_name = ""
var _tmp_dlc_license_key = ""
func _on_ContentDataDownloader_request_completed(result, response_code, headers, body):
	$VBoxContainer/result.text = tr("KEY_LICENSES_RECIVING_DATA")
	$VBoxContainer/result.text = tr("KEY_LICENSES_PARSING_DATA")
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
		$VBoxContainer/result.text = tr("KEY_LICENSES_DOWNLOADING_DLC")
		$ContentFileDownloader.download_file = base_install_path + _tmp_dlc_name + "/" + download_name
		$ContentFileDownloader.request(download_url)
		yield($ContentFileDownloader, "request_completed")
		if _result[i].get_extension() == "cfg":
			_tmp_dlc_full_name = get_dlc_full_name(_tmp_dlc_name)
	activate_license_key_in_game(_tmp_dlc_license_key, _tmp_dlc_full_name)

func _on_ContentFileDownloader_request_completed(result, response_code, headers, body):
	_tmp_downloaded_files += 1
	$VBoxContainer/AllFilesDownloadProgress.value = _tmp_downloaded_files
	set_process(false)


func _on_ContentCFGDownloader_request_completed(result, response_code, headers, body):
	pass # Replace with function body.

func _process(delta):
	$VBoxContainer/FileDownloadProgress.value = (($ContentFileDownloader.get_downloaded_bytes())*100/$ContentFileDownloader.get_body_size())

func get_dlc_full_name(product):
	print(product)
	var dir = Directory.new()
	var file = File.new()
	var cfg = ConfigFile.new()
	var av_dirs = ['.', '..']
	if dir.open("user://dlcs/" + product + '/') == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and not av_dirs.has(file_name):
				pass
			if not dir.current_is_dir() and not av_dirs.has(file_name):
				print("Found file: " + file_name.get_file())
				if file_name.get_extension() == "cfg":
					cfg.load("user://dlcs/" + product + '/' + file_name.get_file())
					return cfg.get_value("mod_info", "name")
			file_name = dir.get_next()

func _on_AddKeyButton_pressed():
	if $VBoxContainer/LineEdit.text == "":
		$VBoxContainer/result.text = tr("KEY_LICENSES_MISSING_LICENSE_KEY")
	else:
		validate_license_key($VBoxContainer/LineEdit.text)
