extends Node


const ERROR_MISSING_WRITE_READ_PERMISSIONS = "0x0000"
const ERROR_MISSING_DATA_FILES = "0x0001"
const ERROR_SAVING_DATA = "0x0002"
const ERROR_LOADING_DATA = "0x0003"
const ERROR_DOWNLOADING_DATA = "0x0004"
const ERROR_INITIALIZING_GAME = "0x0005"
const ERROR_GAME_DATA = "0x0006"
const CONFIG_FILE_ERROR_MISSING_SECTION = "0x1000"
const CONFIG_FILE_ERROR_MISSING_SECTION_KEY = "0x1001"
const CONFIG_FILE_ERROR_MISSING_SECTION_VALUE = "0x1002"
const FILE_ERR = "0x2000"
const FILE_ERR_ALREADY_IN_USE = "0x2001"
const FILE_ERR_LOCKED = "0x2002"
const FILE_ERR_CORRUPTED = "0x2003"
const ERR_PC_ON_FIRE = "You'r PC is being burned now"
const ERR_WTF = "This game is just too hard for Your PC"
# Called when the node enters the scene tree for the first time.
func treat_error(error_code):
	print("Error happened!\n\nError code: " + str(error_code))
	OS.alert("Error occured :c\n\nError code: " + str(error_code), "Oops!")
