extends Node2D
signal finished_loading_dlc_list
signal finished_loading_dlcs_cfg
signal finished_downloading_dlc
var cfg_number = 1
var pck_number = 1
var list_downloaded
var dlc_script_path = "res://dlcs/"
var dlc_path = "user://dlcs/"
var dir = Directory.new()
var avaliavble_dlcs
func _ready():
	if not dir.dir_exists("user://dlcs/"):
		dir.open("user://")
		dir.make_dir("dlcs")
		download_dlc_list()


func download_pck_files_from_cfg(cfg_name:String):
	dir.open("user://dlcs/")
	var file_name = ""
	var info_file = load("user://dlcs/" + cfg_name + ".gd").new()
	dir.make_dir(str(info_file.dlc_name))
	var files_array = info_file.dlc_files
	print(str(files_array))
	for dlcname in info_file.dlc_name:
		Globals.add_dlc(str(dlcname))
	for f_name in info_file.dlc_file_names:
		file_name = str(f_name)
		for file in files_array:
			print(str(file))
			$download_dlc_files.set_download_file("user://dlcs/" + str(info_file.dlc_name) + "/" + str(file_name) + ".pck")
			$download_dlc_files.request(file)
			yield($download_dlc_files, "request_completed")
			pck_number += 1
	emit_signal("finished_downloading_dlc", cfg_name)

func download_dlc_list():
	print('downloading dlc list')
	$download_dlc_list.set_download_file("user://dlcs/dlc_list.gd")
	$download_dlc_list.request("https://dl.new-dev.tk/data/games/dlcs/foxy-adventure/dlc_list.gd")
	emit_signal("finished_loading_dlc_list")
func download_dlc_cfg_files():
	dir.open("user://dlcs/")
	var script = load("user://dlcs/dlc_list.gd").new()
	print(str(script.dlc_list))
	for cfg in script.dlc_list:
		print(str(cfg))
		var str_cfg = str(cfg)
		$download_dlc_cfg.set_download_file("user://dlcs/" + str(cfg_number) + '.gd')
		$download_dlc_cfg.request(cfg)
		yield($download_dlc_cfg, "request_completed")
		var new_filename = load("user://dlcs/" + str(cfg_number) + '.gd').new().dlc_name
		dir.rename(str(cfg_number) + ".gd", str(new_filename) + ".gd")
		new_filename = null
		cfg_number += 1
	list_downloaded = true
	emit_signal("finished_loading_dlcs_cfg")

func _on_download_dlc_list_request_completed(result, response_code, headers, body):
	download_dlc_cfg_files()
#	pass

func uninstall_dlc(dlc_name:String):
	var dlc_cfg_file = load("user://dlcs/" + dlc_name + ".gd").new()
	dir.open("user://dlcs/")
	dir.remove(str(dlc_cfg_file.dlc_name))
