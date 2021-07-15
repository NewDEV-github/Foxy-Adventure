extends Node
var treat_on_android = false


const ERROR_MISSING_WRITE_READ_PERMISSIONS = "0x0000"
const ERROR_MISSING_DATA_FILES = "0x0001"
const ERROR_SAVING_DATA = "0x0002"
const ERROR_LOADING_DATA = "0x0003"
const ERROR_DOWNLOADING_DATA = "0x0004"
const ERROR_INITIALIZING_GAME = "0x0005"
const ERROR_GAME_DATA = "0x0006"
const ERROR_HTTPREQ_CANT_CONNECT = "0x0007"
const ERROR_HTTPREQ_NO_RESPONSE = "0x0008"
const ERROR_HTTPREQ_CANT_WRITE = "0x0009"
const ERROR_HTTPREQ_CANT_OPEN = "0x0010"
const ERROR_HTTPREQ_CANT_RESOLVE = "0x0011"
const ERROR_HTTPREQ_CONNECTION_ERR = "0x0012"
const CONFIG_FILE_ERROR_MISSING_SECTION = "0x1000"
const CONFIG_FILE_ERROR_MISSING_SECTION_KEY = "0x1001"
const CONFIG_FILE_ERROR_MISSING_SECTION_VALUE = "0x1002"
const FILE_ERR = "0x2000"
const FILE_ERR_ALREADY_IN_USE = "0x2001"
const FILE_ERR_LOCKED = "0x2002"
const FILE_ERR_CORRUPTED = "0x2003"
const ERR_PC_ON_FIRE = "Your PC is being burned now"
const ERR_WTF = "WTF?!"
# Called when the node enters the scene tree for the first time.
func treat_error(error_code, treat_alert=true):
	printerr("Error happened!\n\nError code: " + str(error_code))
	if treat_alert:
		OS.alert("Error occured :c\n\nError code: " + str(error_code), "Oops!")
	if str(OS.get_name()) == "Android" and treat_on_android and treat_alert:
		OS.alert("Error occured :c\n\nError code: " + str(error_code), "Oops!")
