extends Area2D
class_name Crate

signal removed

var minimap_icon = "alert"


func _on_Crate_body_entered(body):
	if body is Player:
		emit_signal("removed", self)
		queue_free()