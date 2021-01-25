extends KinematicBody2D
const Gravity_Vec = Vector2(0,900)
const Floor_Normal = Vector2(0,-1)
const State_Walking = 0
const State_Killed = 1
const Walk_Speed = 70
var linear_v = Vector2()
var direction = -1
var anim = ""
var state = State_Walking
onready var detectfloorleft = $DetectFloorLeft
onready var detectfloorright = $DetectFloorRight
onready var detectwallleft = $DetectWallLeft
onready var detectwallright = $DetectWallRight
onready var sprite = $Sprite

func _physics_process(delta):
	var new_anim = "idle"
	if state == State_Walking:
		linear_v += Gravity_Vec*delta
		linear_v.x = direction*Walk_Speed
		linear_v = move_and_slide(linear_v,Floor_Normal)
		if not detectfloorleft.is_colliding() or detectwallleft.is_colliding():
			direction = 1.0
		if not detectfloorright.is_colliding() or detectwallright.is_colliding():
			direction = -1.0
		sprite.scale = Vector2(direction, 1.0)
		new_anim = "walk"
	else:
		new_anim = "explode"

	if anim != new_anim:
		anim = new_anim
		($Anim as AnimationPlayer).play(anim)


func hit_by_bullet():
	state = State_Killed


