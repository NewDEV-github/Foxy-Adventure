extends KinematicBody2D
class_name Player

var speed = 200
var rotation_speed = PI/2

var rotation_dir = 0
var velocity = Vector2.ZERO


func get_input():
	rotation_dir = 0
	velocity = Vector2.ZERO
	if Input.is_action_pressed("right"):
		rotation_dir += 1
	if Input.is_action_pressed("left"):
		rotation_dir -= 1
	if Input.is_action_pressed("forward"):
		velocity += transform.x * speed
	if Input.is_action_pressed("back"):
		velocity -= transform.x * speed


func _physics_process(delta):
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)

