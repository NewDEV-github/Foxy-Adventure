extends Node


const ERROR_MISSING_WRITE_READ_PERMISSIONS = "0x0000"
const ERROR_MISSING_DATA_FILES = "0x0001"
const ERROR_SAVING_DATA = "0x0002"
const ERROR_LOADING_DATA = "0x0003"
const ERROR_DOWNLOADING_DATA = "0x0004"
const ERROR_INITIALIZING_GAME = "0x0005"
const ERROR_GAME_DATA = "0x0006"

# Called when the node enters the scene tree for the first time.
func treat_error(error_code):
	print("Error happened!\n\nError code: " + str(error_code))
	OS.alert("Error occured :c\n\nError code: " + str(error_code), "Oops!")
