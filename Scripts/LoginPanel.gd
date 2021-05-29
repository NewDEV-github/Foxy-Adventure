extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Login_pressed():
	Firebase.Auth.login_with_email_and_password($HBoxContainer/Login/Email.text, $HBoxContainer/Login/Password.text)
	hide()


func _on_Register_pressed():
#	Firebase.Auth.connect("signup_succeeded", self, "send_email")
	Firebase.Auth.signup_with_email_and_password($HBoxContainer/Register/Email.text, $HBoxContainer/Register/Password.text)
#func send_email():
	Firebase.Auth.send_account_verification_email()
	hide()
