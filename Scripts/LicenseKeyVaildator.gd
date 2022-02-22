extends Control

var bytes = 128974848.0 # WIELKOSC pliku
var download = 0
var changes = 0

var size = 0
var file_size #wielkosc pliku w stringu

var mbs = ""
var bytespers = 0
var lastbytesper = 0

var mbs_v = 0

var timer = 0

var last_ten = []

var base_install_path = "user://dlcs/"
onready var qc = preload("res://Scenes/QuitConfirm.py").new()
# Called when the node enters the scene tree for the first time.
func _ready():
#	Globals.encrypt_cfg("user://decryptedKeys2.cfg", "wefbgfrfgb", "user://lk_data.cfg")
	set_process(false)
func activate_license_key_in_game(key:String, product_name:String, install_cfg_path:String, needs_restart:bool):
	var result
	var cfg = ConfigFile.new()
	cfg.load_encrypted_pass("user://lk_data.cfg", "wefbgfrfgb")
	cfg.set_value("keys", key + "_" + Globals.user_data['localid'], product_name)
	cfg.set_value("keys", key + "_cfg", install_cfg_path)
	cfg.save_encrypted_pass("user://lk_data.cfg", "wefbgfrfgb")
	if needs_restart:
		OS.alert("Foxy Adventure needs restart to load\n%s"%product_name, "Warning")
#		qc.dlcrestartask(product_name)
var _validation_result_d
func validate_license_key(key:String):
	$VBoxContainer/result.text = "Validation started..."
	$VBoxContainer/result.text = "Parsing data..."
	var data = {'license_key': key}
	_tmp_dlc_license_key = key
	var query = JSON.print(data)
	var url = "https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/api/validate_license_key/"
	$VBoxContainer/result.text = "Sending data..."
	$Vaildator.request(url, ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, query)
	$VBoxContainer/result.text = "Awaiting for server response..."

func get_activated_products_in_game():
	var cfg = ConfigFile.new()
	cfg.load_encrypted_pass("user://lk_data.cfg", "wefbgfrfgb")
	return cfg.get_section_keys("keys")

func _on_Vaildator_request_completed(result, response_code, headers, body):
	$VBoxContainer/result.text = "Reciving data..."
	$VBoxContainer/result.text = "Parsing data..."
	var vaildation_result = JSON.parse(body.get_string_from_utf8()).result
	_tmp_dlc_name = vaildation_result['product']
	print(vaildation_result['exists'])
	if vaildation_result['exists'] == "True":
		#exists
#		$VBoxContainer/result.text = Globals.user_data)
		if vaildation_result['assigned_to_user'] == Globals.user_data['localid']:
			download_content(vaildation_result['product'])
			$VBoxContainer/result.text = "Vaildation successfull"
		else:
			$VBoxContainer/result.text = "Wrong license key"
	else:
		$VBoxContainer/result.text = "Wrong license key"


func download_content(content_name:String):
	$VBoxContainer/result.text = "Downloading started..."
	$VBoxContainer/result.text = "Parsing data..."
	var data = {'content_name': content_name}
	var query = JSON.print(data)
	var url = "https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/api/get_content_download_data/"
	$VBoxContainer/result.text = "Sending data..."
	$ContentDataDownloader.request(url, ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, query)
	$VBoxContainer/result.text = "Awaiting for server response..."

var _tmp_download_files = 0
var _tmp_downloaded_files = 0
var _tmp_dlc_name = ""
var _tmp_dlc_full_name = ""
var _tmp_dlc_license_key = ""
var _tmp_cfg_path = ""
func _on_ContentDataDownloader_request_completed(result, response_code, headers, body):
	$VBoxContainer/result.text = "Reciving data..."
	$VBoxContainer/result.text = "Parsing data..."
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
		$VBoxContainer/result.text = "Downloading..."
		$ContentFileDownloader.download_file = base_install_path + _tmp_dlc_name + "/" + download_name
		$ContentFileDownloader.request(download_url)
		
		yield($ContentFileDownloader, "request_completed")
		$VBoxContainer/result.text = "Parsing data..."
		if _result[i].get_extension() == "cfg":
			_tmp_cfg_path = base_install_path + _tmp_dlc_name + "/" + download_name
			_tmp_dlc_full_name = get_dlc_full_name(_tmp_dlc_name)
	activate_license_key_in_game(_tmp_dlc_license_key, _tmp_dlc_full_name, _tmp_cfg_path, true)

func _on_ContentFileDownloader_request_completed(result, response_code, headers, body):
	_tmp_downloaded_files += 1
	$VBoxContainer/AllFilesDownloadProgress.value = _tmp_downloaded_files
	set_process(false)


func _on_ContentCFGDownloader_request_completed(result, response_code, headers, body):
	pass # Replace with function body.

func _process(delta):
	if $ContentFileDownloader.get_http_client_status() == 7:
		file_size = "%.2f" % ($ContentFileDownloader.get_body_size() / 1048576.0)
		timer += delta
		download = $ContentFileDownloader.get_downloaded_bytes()
		bytespers = download
		if timer>1:
			timer=0
			last_ten.append((bytespers-lastbytesper))
			if last_ten.size()>10:
				last_ten.remove(0)
			var bytepersumaverage = 0    
			for byprs in last_ten:
				bytepersumaverage+=byprs+0.1
			bytepersumaverage /= last_ten.size()
			var sum  = (($ContentFileDownloader.get_body_size()) - (changes)) / (bytepersumaverage)
			var mins = int(sum/60)
			var secs = int(int(sum)%60)    
			mbs = ("%.2f" % ((bytepersumaverage)/ 1048576.0))+"MB/s, Estimated download time: "+str(mins)+":"+("%02d" % secs)
			lastbytesper = bytespers
		if changes != download:
			changes = download
			var downloaded_size = (changes / 1048576.0)
			$VBoxContainer/REEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE.set_text("Downloaded: "+("%.2f" % downloaded_size)+"MB /"+file_size+"MB\n"+mbs)
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
		$VBoxContainer/result.text = "Missing license key!"
	else:
		validate_license_key($VBoxContainer/LineEdit.text)
