extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_account_info():
#	print(Globals.user_data['displayname'])
#	print(Globals.user_data['profilepicture'])
#	print(Globals.user_data['registered'])
#	print(Globals.user_data['email'])
#	print(Globals.user_data)
	$HBoxContainer/CenterContainer/Profile.textureUrl = Globals.user_data['profilepicture']
	$HBoxContainer/VBoxContainer/EmailStatus.text = "Email Verified: " + str(Globals.user_data['registered'])
	$HBoxContainer/VBoxContainer/Email.text = "Email: " + Globals.user_data['email']
	$HBoxContainer/VBoxContainer/Nickname.text = "Nickname: " + Globals.user_data['displayname']


func _on_Close_pressed():
	hide()
