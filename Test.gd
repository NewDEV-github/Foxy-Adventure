extends Spatial

var use_anaglyph := true

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.scancode == KEY_TAB and event.pressed:
		use_anaglyph = not use_anaglyph
		$MainCamera.current = not use_anaglyph
		$MainCamera/AnaglyphCamera.current = use_anaglyph
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_UP:
			$MainCamera/AnaglyphCamera.half_res += 0.1
		if event.button_index == BUTTON_WHEEL_DOWN:
			$MainCamera/AnaglyphCamera.half_res -= 0.1
