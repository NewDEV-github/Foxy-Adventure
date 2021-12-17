extends Tabs
onready var tpl = $TagProcessedLabel
func _on_NIN_Button_pressed():
	tpl.update_text("Pro Controller")


func _on_PS_Button_pressed():
	tpl.update_text("PS4 Controller")


func _on_XBOX_Button_pressed():
	tpl.update_text("XInput Gamepad")


func _on_PC_Button_pressed():
	tpl.update_text("")
