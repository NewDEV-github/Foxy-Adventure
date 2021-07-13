extends KinematicBody2D
export (String) var character_name
const GRAVITY_VEC = Vector2(0, 850)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 500
const SIDING_CHANGE_SPEED = 10
const BULLET_VELOCITY = 1000
const SHOOT_TIME_SHOW_WEAPON = 0.2
var TIMER_LIMIT = 2.5
var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var shoot_time=99999 #time since last shot
var anim=""
var can_jump = true
var speed = 0.5
var scene
var controls_blocked = false
onready var sprite = $Anim/Sprite
func _ready() -> void:
	DiscordSDK.run_rpc(false, true, character_name)
#func restart_position():
#	set_position(Vector2(144, 90))
#func _ready():
#	$ui/Control/GameUI.connect("FPSHide", self, "_on_fps_hide")
#	$ui/Control/GameUI.connect("FPSShow", self, "_on_fps_show")
#	pass
func _physics_process(delta):
	
	
#	if Input.is_action_just_pressed("console"):
#		if $console/console.visible == false:
#			$console/console.show()
#		if $console/console.visible == true:
#			$console/console.hide()
#	if $ui/Control/ProgressBar.value == 0:
#		scene = get_tree().change_scene("scenes/GameOver.tscn")
	onair_time += delta
	shoot_time += delta
		### MOVEMENT ###
		# Apply Gravity
	linear_vel += delta * GRAVITY_VEC
	# Move and Slide
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect Floor
	if is_on_floor():
		onair_time = 0
		on_floor = onair_time < MIN_ONAIR_TIME
		### CONTROL ###
		# Horizontal Movement
	
	var target_speed = 0
		
	if controls_blocked == false:
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_left2"):
			target_speed -= 1
			#braking if movig left
			if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_right2"):
				speed = 0 
				target_speed += 0.5
		#moving right
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_right2"):
			target_speed += 1
			#braking if moving right
			if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_left2"):
				speed = 0 
				target_speed -= 0.5
		#setting 'speed' to 0 so that the character can accelerate again
		if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_left2") or Input.is_action_just_released("ui_right2") or Input.is_action_just_released("ui_right"):
			speed = 0.5
			TIMER_LIMIT = 2.5
	#	if Input.is_action_pressed("speed") and Input.is_action_pressed("move_left"):
	#		target_speed += -1.1
	#	if Input.is_action_pressed("speed") and Input.is_action_pressed("move_right"):
	#		target_speed += 1.1
		target_speed *= WALK_SPEED
		linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

		# Jumping
		if can_jump:
			if on_floor and Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("jump2"):
				can_jump = false
				linear_vel.y = -JUMP_SPEED
				
		can_jump = is_on_floor()
#		$AudioPlayer/jump.play()
	# Shooting
#	if Input.is_action_just_pressed("shoot"):
#		var weapon_current = preload("res://scenes/bullet.tscn").instance()
#		weapon_current.position = $sprite/bullet_shoot.global_position #use node for shoot position
#		weapon_current.linear_velocity = Vector2(sprite.scale.x * BULLET_VELOCITY, 0)
#		weapon_current.add_collision_exception_with(self) # don't want player to collide with bullet
#		get_parent().add_child(weapon_current) #don't want bullet to move with me, so add it as child of parent
#		$sound_shoot.play()
#		shoot_time = 0

	### ANIMATION ###

	var new_anim = "idle1"

	if is_on_floor():
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = -1
			new_anim = "run"

		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = 1
			new_anim = "run"
	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if Input.is_action_pressed("ui_left"):
			sprite.scale.x = -1
		if Input.is_action_pressed("ui_right"):
			sprite.scale.x = 1
		if linear_vel.y < 0:
			new_anim = "jump_" + str(sprite.scale.x)
#	print(str(Globals.lives))
#	if shoot_time < SHOOT_TIME_SHOW_WEAPON:
#		new_anim += "_weapon"

	if new_anim != anim:
		anim = new_anim
		$Anim/Sprite/AnimationPlayer.play(anim)
	


func _on_Tails_tree_exiting():
	DiscordSDK.kill_rpc()


func _on_Area2D_body_entered(body):
	if body.name == "Enemy":
		body.hit_by_bullet()
var queued_messages = []
signal msg_done
func show_message_box(block_controls:bool=false):
	controls_blocked = block_controls
	$CanvasLayer/MessageDisplay.show()
func hide_message_box():
	controls_blocked = false
	$CanvasLayer/MessageDisplay.hide()
func render_message(message):
	$CanvasLayer/MessageDisplay.display_message(message)
	emit_signal("msg_done")
func clear_message():
	$CanvasLayer/MessageDisplay.clear()
func set_render_messages_delay(delay):
	$CanvasLayer/MessageDisplay/delay.wait_time = delay
func render_messages(messages:Array):
	for i in messages:
		$CanvasLayer/MessageDisplay.display_message(i)
		yield($CanvasLayer/MessageDisplay/MessageBox, "message_done")
		$CanvasLayer/MessageDisplay/delay.start()
		yield($CanvasLayer/MessageDisplay/delay, "timeout")
	emit_signal("msg_done")
