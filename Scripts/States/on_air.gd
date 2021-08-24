extends '../state.gd'

var has_jumped : bool
var has_rolled : bool
var roll_jump : bool
var can_attack : bool
var is_in_air : bool
var is_flying : bool
var is_tired_of_flying
var override_anim : String

func enter(host):
	if host.name == "Tails" or host.name == "NewTheFox":
		host.tails.hide()
		is_tired_of_flying = host.is_tired_of_flying
	is_flying = host.is_flying
	is_in_air = host.is_in_air
	has_jumped = host.has_jumped
	has_rolled = host.is_rolling
	can_attack = has_jumped
	host.has_jumped = false
	host.is_rolling = false
	roll_jump = has_jumped and has_rolled

func step(host, delta):
	if host.is_tired_of_flying:
#		host.FALL = 150
#		host.GRV = 13.125
		host.velocity.y += 0.2
	if host.is_grounded:
		host.is_tired_of_flying = false
		host.is_flying = false
#		host.is_in_air = false
		host.FALL = 150
		host.GRV = 13.125
		host.ground_reacquisition()
		return 'OnGround'
	
	var can_move = true if !host.control_locked and !roll_jump else false
	var no_rotation = has_jumped or has_rolled
	host.rotation_degrees = int(lerp(host.rotation_degrees, 0, .2)) if !no_rotation else 0
	
	if Input.is_action_pressed("ui_left") and can_move:
		if host.velocity.x > -host.TOP:
			host.velocity.x -= host.AIR
	elif Input.is_action_pressed("ui_right") and can_move:
		if host.velocity.x < host.TOP:
			host.velocity.x += host.AIR
	
	if Input.is_action_just_pressed("ui_accept") and can_attack:
		if not host.name == "Tails" or not host.name == "NewTheFox":
			host.player_vfx.play('InstaShield', true)
			host.audio_player.play('insta_shield')
			can_attack = false
			roll_jump = false
	
	if host.velocity.y < 0 and host.velocity.y > -240:
		host.velocity.x -= int(host.velocity.x / 7.5) / 15360.0
	
	host.velocity.y += host.GRV
	
	if Input.is_action_just_released("ui_accept"): # has jumped
		if host.name == "Tails" or host.name == "NewTheFox":
			host.is_in_air = true
			can_attack = false
			host.tails.play('jump_roll')
		if host.velocity.y < -240.0: # set min jump height
			host.velocity.y = -240.0
	if Input.is_action_just_released("ui_accept") and is_in_air == true: # has jumped
		if host.name == "Tails" or host.name == "NewTheFox":
			host.is_in_air = false
			host.is_flying = true
			#if not host.velocity.y == 1000:
			host.velocity.y +=100
			host.GRV = 0.01
			host.FALL = 0.01
			host.start_fly_timer()
	if Input.is_action_pressed("ui_down") and host.is_flying:
		host.velocity.y += 2
	if Input.is_action_pressed("ui_up") and host.is_flying:
		host.velocity.y -= 2
	host.velocity.x = 0 if host.is_wall_left and host.velocity.x < 0 else host.velocity.x
	host.velocity.x = 0 if host.is_wall_right and host.velocity.x > 0 else host.velocity.x
func exit(host):
	pass

func animation_step(host, animator):
	var anim_name = animator.current_animation
	var anim_speed = animator.get_playing_speed()
	
	if anim_name == 'Braking':
		anim_name = 'Walking'
	
	if has_jumped or has_rolled:
		anim_name = 'Rolling'
		anim_speed = max(-((5.0 / 60.0) - (abs(host.gsp) / 120.0)), 1.0)
	if host.is_flying and host.name == "Tails" or host.name == "NewTheFox":
		anim_name = "Flying"
	if host.is_tired_of_flying and host.name == "Tails" or host.name == "NewTheFox":
		anim_name = "TiredOfFlying"
	if host.is_flying and Input.is_action_pressed("ui_up") and host.name == "Tails" or host.name == "NewTheFox":
		anim_name = "FlyingUP"
	if host.is_flying and Input.is_action_pressed("ui_down") and host.name == "Tails" or host.name == "NewTheFox":
		anim_name = "FlyingDOWN"
	if Input.is_action_pressed("ui_right"):
		host.character.scale.x = 1
	elif Input.is_action_pressed("ui_left"):
		host.character.scale.x = -1
	
	animator.animate(anim_name, anim_speed, true)
