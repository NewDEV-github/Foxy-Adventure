extends KinematicBody2D
class_name Mob

signal removed

var speed = 50
var velocity = Vector2()

var minimap_icon = "mob"
	
	
func _ready():
	rotation = rand_range(0, 2*PI)
	
	
func _physics_process(delta):
	velocity = transform.x * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal).rotated(rand_range(-PI/4, PI/4))
	rotation = velocity.angle()
