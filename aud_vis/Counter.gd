extends Label

# Add this to the Counter

func _ready():
	countdown(5)
	yield(get_tree().create_timer(1.0), "timeout")
	countdown(4)
	yield(get_tree().create_timer(1.0), "timeout")
	countdown(3)
	yield(get_tree().create_timer(1.0), "timeout")
	countdown(2)
	yield(get_tree().create_timer(1.0), "timeout")
	countdown(1)
	yield(get_tree().create_timer(1.0), "timeout")
	hide()

func countdown(num):
	text = str(num) 
