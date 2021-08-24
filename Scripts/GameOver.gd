extends Control



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_quitgame_pressed():
	get_tree().quit()


func _on_gotomenu_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")
