extends KinematicBody2D
const GRAVITY_VEC = Vector2(0, 750)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 500
const speed_run = 0.9
const SIDING_CHANGE_SPEED = 10
const BULLET_VELOCITY = 1000
const SHOOT_TIME_SHOW_WEAPON = 0.2
var TIMER_LIMIT = 2.5
var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var shoot_time=99999 #time since last shot
var anim=""
var speed = 0.5
var scene
var timer = 0
onready var sprite = $Sprite
func _physics_process(delta):
#	if Input.is_action_just_pressed("console"):
#		if $console/console.visible == false:
#			$console/console.show()
#		if $console/console.visible == true:
	onair_time += delta
	shoot_time += delta

	### uiMENT ###

	# Apply Gravity
	linear_vel += delta * GRAVITY_VEC
	# ui and Slide
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect Floor
	if is_on_floor():
		onair_time = 0

	on_floor = onair_time < MIN_ONAIR_TIME

	### CONTROL ###

	# Horizontal uiment
	#speeding
	var target_speed = 0
#	print($AnimationPlayer.playback_speed)
#	real-time speeding
	if timer > TIMER_LIMIT:
		if speed <= 1.1:
			timer = 0.0
			speed += 0.2
			TIMER_LIMIT -= 0.2
			$AnimationPlayer.playback_speed = 0.5 + speed
			
		if speed == 1.1 or speed > 1.1:
			pass
	#moving left
	if Input.is_action_pressed("ui_left"):
		timer += delta
		target_speed -= 1
		#braking if movig left
		if Input.is_action_pressed("ui_right"):
			speed = 0.5
			target_speed += 1.1
	#moving right
	if Input.is_action_pressed("ui_right"):
		timer += delta
		target_speed += 1
		#braking if moving right
		if Input.is_action_pressed("ui_left"):
			speed = 0.5
			target_speed -= 1.1
	#setting 'speed' to 0 so that the character can accelerate again
	if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		speed = 0.5
		TIMER_LIMIT = 2.5
#	if Input.is_action_pressed("speed") and Input.is_action_pressed("ui_left"):
#		target_speed += -1.1
#	if Input.is_action_pressed("speed") and Input.is_action_pressed("ui_right"):
#		target_speed += 1.1
	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	# Jumping
	if on_floor and Input.is_action_just_pressed("jump"):
		linear_vel.y = -JUMP_SPEED
		$sound_jump.play()

	### ANIMATION ###

	var new_anim = "idle"

	if on_floor:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = -1
			if speed >= speed_run:
				new_anim = "run"
				$AnimationPlayer.playback_speed = 0.8
			else:
				new_anim = "walk"
				

		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = 1
			if speed >= speed_run:
				new_anim = "run"
				$AnimationPlayer.playback_speed = 0.8
			else:
				new_anim = "walk"
	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			sprite.scale.x = -1
		if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			sprite.scale.x = 1
#		if new_anim == "run":
#			$AnimationPlayer.playback_speed = $AnimationPlayer.playback_speed/2
		if linear_vel.y < 0:
			new_anim = "jump"
		else:
			new_anim = "idle"

	if shoot_time < SHOOT_TIME_SHOW_WEAPON:
		new_anim += "_weapon"

	if new_anim != anim:
		anim = new_anim
		$AnimationPlayer.play(anim)
		

