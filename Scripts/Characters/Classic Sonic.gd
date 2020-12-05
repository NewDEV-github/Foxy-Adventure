extends KinematicBody2D
var speed = 80
signal house_dialog_accept
signal house_dialog_accept_2
var move
var f_rotation = -180
var vel = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("minimap", self, "set_minimap")
	vel = Vector2()
	if str(OS.get_name()) == "Android":
		$CanvasLayer/HouseDialog.set_scale(Vector2(1.75, 1.75))
		$CanvasLayer/HouseDialog2.set_scale(Vector2(1.75, 1.75))
		$Camera2D.zoom = Vector2(0.7, 0.7)
	else:
		$Camera2D.zoom = Vector2(1, 1)
		$CanvasLayer/HouseDialog.set_scale(Vector2(1, 1))
		$CanvasLayer/HouseDialog2.set_scale(Vector2(1, 1))


func _physics_process(delta):
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_down2"):
		vel.y += 1
		$AnimationPlayer.play("down")
		f_rotation = -180
	elif Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_up2"):
		vel.y -= 1
		$AnimationPlayer.play("up")
		f_rotation = 0
	elif Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_right2"):
		vel.x += 1
		$AnimationPlayer.play("right")
		f_rotation = 90
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_left2"):
		vel.x -= 1
		$AnimationPlayer.play("left")
		f_rotation = -90
	if Input.is_action_just_released('ui_left') or Input.is_action_just_released('ui_left2'):
		vel = Vector2()
		$AnimationPlayer.stop()
		$Sprite.frame = 11
	elif Input.is_action_just_released('ui_right') or Input.is_action_just_released('ui_right2'):
		vel = Vector2()
		$AnimationPlayer.stop()
		$Sprite.frame = 14
	elif Input.is_action_just_released('ui_up') or Input.is_action_just_released('ui_up2'):
		vel = Vector2()
		$AnimationPlayer.stop()
		$Sprite.frame = 4
	elif Input.is_action_just_released('ui_down') or Input.is_action_just_released('ui_down2'):
		vel = Vector2()
		$AnimationPlayer.stop()
		$Sprite.frame = 0
	vel = vel.normalized() * speed
	move = move_and_collide(vel * delta)
	vel = Vector2()
func show_enter_house_dialog():
	$CanvasLayer/HouseDialog.popup_centered()

func set_minimap(minimap_visible):
	$CanvasLayer/MiniMap.visible = minimap_visible

func _on_HouseDialog_confirmed():
	get_tree().paused = false
	emit_signal("house_dialog_accept", true)


func _on_HouseDialog_popup_hide():
	get_tree().paused = false
	emit_signal("house_dialog_accept", false)


func _on_HouseDialog2_confirmed():
	get_tree().paused = false
	emit_signal("house_dialog_accept_2", true)

func _on_HouseDialog2_popup_hide():
	get_tree().paused = false
	emit_signal("house_dialog_accept_2", false)

func show_exit_house_dialog():
	$CanvasLayer/HouseDialog2.popup_centered()

func save_last_world_position():
	Globals.last_world_position = position


func _on_Shadow_tree_entered():
	$AnimationPlayer.stop()
