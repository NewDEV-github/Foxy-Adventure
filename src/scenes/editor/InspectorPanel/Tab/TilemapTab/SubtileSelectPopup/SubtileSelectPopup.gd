# SubtileSelectPopup
# Written by: First

extends WindowDialog

#class_name optional

"""
	Enter desc here.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

signal subtile_selected(tile_id)

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready() -> void:
	#Connect all buttons
	for i in $MarginContainer/PreviewTextureRect.get_children():
		if i is TileTextureButton:
			i.connect("pressed_id", self, "_on_btn_pressed_id")

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func set_preview_texture(texture : Texture):
	$MarginContainer/PreviewTextureRect.texture = texture

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_btn_pressed_id(id : int, texture : Texture):
	emit_signal("subtile_selected", id)
	hide()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------
