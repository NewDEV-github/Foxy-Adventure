extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var errors = {
	"USER_NOT_FOUND": "The user corresponding to the refresh token was not found. It is likely the user was deleted.",
	"TOKEN_EXPIRED": "The user's credential is no longer valid. The user must sign in again.",
	"INVALID_CUSTOM_TOKEN": "The custom token format is incorrect or the token is invalid for some reason (e.g. expired, invalid signature etc.)",
	"CREDENTIAL_MISMATCH": "The custom token corresponds to a different Firebase project.",
	"INVALID_REFRESH_TOKEN": "An invalid refresh token is provided.",
	"INVALID_GRANT_TYPE": "The grant type specified is invalid.",
	"MISSING_REFRESH_TOKEN": "No refresh token provided.",
	"EMAIL_EXISTS": "The email address is already in use by another account.",
	"OPERATION_NOT_ALLOWED": "This feature is disabled for this project.",
	"TOO_MANY_ATTEMPTS_TRY_LATER": "We have blocked all requests from this device due to unusual activity. Try again later.",
	"EMAIL_NOT_FOUND": "There is no user record corresponding to this identifier. The user may have been deleted.",
	"INVALID_PASSWORD": "The password is invalid or the user does not have a password.",
	"USER_DISABLED": "The user account has been disabled by an administrator.",
	"INVALID_IDP_RESPONSE": "The supplied auth credential is malformed or has expired.",
	"INVALID_EMAIL": "The email address is badly formatted.",
	"EXPIRED_OOB_CODE": "The action code has expired.",
	"INVALID_OOB_CODE": "The action code is invalid. This can happen if the code is malformed, expired, or has already been used.",
	"INVALID_ID_TOKEN": "The user's credential is no longer valid. The user must sign in again.",
	"WEAK_PASSWORD": "The password must be 6 characters long or more.",
	"CREDENTIAL_TOO_OLD_LOGIN_AGAIN": "The user's credential is no longer valid. The user must sign in again.",
	"FEDERATED_USER_ID_ALREADY_LINKED": "This credential is already associated with a different user account.",
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.connect("login_failed", self, "on_login_failed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_login_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))
	if errors.has(message):
		$Error.dialog_text = "Error: " + errors[message] + "\n\nError code: " + str(error_code)
	else:
		$Error.dialog_text = "Oops!\nUnknown error happened!\n\nError code: " + str(error_code)
	$Error.popup_centered()

func _on_Login_pressed():
	Firebase.Auth.login_with_email_and_password($HBoxContainer/Login/Email.text, $HBoxContainer/Login/Password.text)
	hide()


func _on_Register_pressed():
	OS.shell_open("https://newdev.web.app/auth")


func _on_Error_confirmed():
	show()
	$HBoxContainer/Login/Email.text = ""
	$HBoxContainer/Register/Email.text = ""
	$HBoxContainer/Login/Password.text = ""
	$HBoxContainer/Register/Password.text = ""
