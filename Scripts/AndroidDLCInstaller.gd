extends WindowDialog
export var DLC_foxes_download_link:String  = 'https://github.com/SonadowDEV/SonadowRPG/releases/dlc_foxes/dlc_foxes.pck'
export var dlc_temp_download_dir:String = "user://temp/"
export var dlc_install_dir:String = "user://dlcs/"
var dir = Directory.new()
func _ready():
	$dlc_foxes.set_download_file(dlc_temp_download_dir + "dlc_foxes.pck")

func _on_dlcfoxes_pressed():
	$dlc_foxes.request(DLC_foxes_download_link)
	set_installation_step_text("downloading", "reciving")

func set_installation_step_text(step:String, progress:String):
	$VBoxContainer2/Label.set_text("STEP: " + step + "  PROGRESS: " + progress)


func _on_dlc_foxes_request_completed(result, response_code, headers, body):
	set_installation_step_text('installing', 'copying')
	dir.copy(dlc_temp_download_dir + "dlc_foxes.pck", dlc_install_dir + "dlc_foxes.pck")
	set_installation_step_text('installing', 'done copying')
	set_installation_step_text('installing', 'clearing cache game data')
	dir.remove(dlc_temp_download_dir + "dlc_foxes.pck")
	set_installation_step_text('installing', 'done clearing game cache data. Your DLC was successfully installed')
