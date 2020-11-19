extends Control
onready var storage = $FirebaseStorage

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	storage.set_download_file("user://profilepic")
	Firebase.Auth.connect("login_succeeded", self, "on_login_succeeded")
	Firebase.Auth.connect("login_failed", self, "on_login_failed")

func _on_login_pressed():
	var email = $email.text
	var password = $pass.text
	Firebase.Auth.login_with_email_and_password(email, password)

func on_login_succeeded(auth):
	print("Succeeded!")
	var email = $email.text.replace("@", "%40")
	storage.request("https://firebasestorage.googleapis.com/v0/b/api-9176249411662404922-339889.appspot.com/o/pics%2F"+ email +"%2Fprofilepic?alt=media")
func on_login_failed(error_code, message):
	print("Failed!\nError code: %s\nMessage: %s" % [error_code, message])
