extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var errors = {
	"INVALID_EMAIL": "Invalid email address",
	"EMAIL_NOT_FOUND": "Email address not found",
	"INVALID_PASSWORD": "Invalid password",
	"USER_DISABLED": "That user is disabled/banned",
	"WEAK_PASSWORD": "Weak password. It must be at least 6 characters long"}

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.arguments.has("locale"):
		print("Setting locale to: " + Globals.arguments["locale"])
		TranslationServer.set_locale(Globals.arguments["locale"])
	Firebase.Auth.connect("login_failed", self, "on_login_failed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_login_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))
	$Error.dialog_text = "Error: " + errors[message]
	$Error.popup_centered()

func _on_Login_pressed():
	Firebase.Auth.login_with_email_and_password($HBoxContainer/Login/Email.text, $HBoxContainer/Login/Password.text)
	hide()


func _on_Register_pressed():
#	Firebase.Auth.connect("signup_succeeded", self, "send_email")
	Firebase.Auth.signup_with_email_and_password($HBoxContainer/Register/Email.text, $HBoxContainer/Register/Password.text)
#func send_email():
	Firebase.Auth.send_account_verification_email()
	hide()


func _on_Error_confirmed():
	show()
	$HBoxContainer/Login/Email.text = ""
	$HBoxContainer/Register/Email.text = ""
	$HBoxContainer/Login/Password.text = ""
	$HBoxContainer/Register/Password.text = ""
