tool
extends Node2D

# Gonkee's audio visualiser for Godot 3.2 - full tutorial https://youtu.be/AwgSICbGxJM
# If you use this, I would prefer if you gave credit to me and my channel

var spectrum = AudioServer.get_bus_effect_instance(0, 0)

export(String, "Circular", "Linear") var shape = "Linear" setget new_shape
export var total_w := 400 setget new_width
export var total_h := 200 setget new_height
export var radius := 50 setget new_radius
export var editor_color := Color.white setget new_color_e
export var visualizer_color := Color.red setget new_color_v

export var line_width := 4.0
export var definition := 20
export var min_freq := 20.0
export var max_freq := 20000.0
export var max_db = 0
export var min_db = -40

var accel = 20
var histogram = []

func new_color_e(_new_value):
	editor_color = _new_value
	refresh()

func new_color_v(_new_value):
	visualizer_color = _new_value
	refresh()

func new_shape(_new_value):
	shape = _new_value
	refresh()

func new_radius(_new_value):
	radius = _new_value
	refresh()

func new_width(_new_value):
	total_w = _new_value
	refresh()

func new_height(_new_value):
	total_h = _new_value
	refresh()

func _enter_tree():
	#max_db += get_parent().volume_db
	#min_db += get_parent().volume_db
	
	for i in range(definition):
		histogram.append(0)
	

func _process(delta):
	var freq = min_freq
	var interval = (max_freq - min_freq) / definition
	
	for i in range(definition):
		
		var freqrange_low = float(freq - min_freq) / float(max_freq - min_freq)
		freqrange_low = freqrange_low * freqrange_low * freqrange_low * freqrange_low
		freqrange_low = lerp(min_freq, max_freq, freqrange_low)
		
		freq += interval
		
		var freqrange_high = float(freq - min_freq) / float(max_freq - min_freq)
		freqrange_high = freqrange_high * freqrange_high * freqrange_high * freqrange_high
		freqrange_high = lerp(min_freq, max_freq, freqrange_high)
		
		var mag = spectrum.get_magnitude_for_frequency_range(freqrange_low, freqrange_high)
		mag = linear2db(mag.length())
		mag = (mag - min_db) / (max_db - min_db)
		
		mag += 0.3 * (freq - min_freq) / (max_freq - min_freq)
		mag = clamp(mag, 0.05, 1)
		
		if not Engine.editor_hint:
			histogram[i] = lerp(histogram[i], mag, accel * delta)
	
	update()

func _draw():
	var draw_pos = Vector2(12, 0)
	var w_interval = total_w / definition
	
	if Engine.editor_hint:
		if shape == "Circular":
			draw_circle(Vector2(0, 0), radius, editor_color)
		else:
			draw_rect(Rect2(0, 0, total_w / 10, -total_h / 10), editor_color)
			draw_line(Vector2(0, 0), Vector2(total_w, 0), editor_color, line_width, true)
			draw_line(Vector2(0, 0), Vector2(0, -total_h), editor_color, line_width, true)
	else:
		if shape == "Circular":
			var angle = PI
			var angle_interval = 2 * PI / definition
			var length = 50
			
			
			for i in range(definition):
				var normal = Vector2(0, -1).rotated(angle)
				var start_pos = normal * radius
				var end_pos = normal * (radius + histogram[i] * length)
				draw_line(start_pos, end_pos, visualizer_color, line_width, true)
				angle += angle_interval
		else:
			for i in range(definition):
				draw_line(draw_pos, draw_pos + Vector2(0, -histogram[i] * total_h), visualizer_color, line_width, true)
				draw_pos.x += w_interval
		

func refresh():
	hide()
	show()
