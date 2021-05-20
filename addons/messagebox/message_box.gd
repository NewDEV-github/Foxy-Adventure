tool
extends RichTextLabel
# Provides a character-by-character rich text box

signal message_done
signal paused
signal unpaused

export(float) var speed = 1 setget _set_speed
export(float) var acceleration = 2 setget _set_accel
export(String, MULTILINE) var message = "" setget _set_message
export(String) var skip_action = ""
export(String) var accelerate_action = ""
export(Array, AudioStream) var voice = []
export(NodePath) var player = "" setget _set_player
export(Array, RichTextEffect) var transitions = [] setget _set_transitions
export(bool) var autoscroll = true
export(bool) var use_alt_scroll = false
# whether or not to use the alternate autoscroll.
# alternate method is less accurate but smoother and always works.

# publics
var playing: bool = false setget _set_active

# privates
var _isready: bool = false
var _speed_mult: float = 1
var _last_speed: float = 1
var _done: bool = false
var _last_char: int = 0
var _accel: bool = false
var _cool: bool = true
var _player: Node = null
var _chars: int = 0
var _t_time: float = 0
# github 37720
var _line_size: int = 1
var _max_lines: int = 1
var _scroll_pos: float = 0.0 setget _scroll_to
# end hacks
onready var _tween: Tween = Tween.new()
onready var _old_theme: Theme = theme
onready var _cooldown: Timer = Timer.new()

# none of the functions here return anything,
# so I didn't bother with return typing

### main loop ###

func _init():
	scroll_active = false

func _ready():
	if Engine.editor_hint:
		return
	
	add_child(_tween)
	add_child(_cooldown)
	
	_tween.connect("tween_all_completed", self, "_on_done")
	_cooldown.connect("timeout", self, "_on_cool")
	connect("resized", self, "_resized")
	
	_cooldown.wait_time = .1
	bbcode_enabled = true
	scroll_active = false
	
	var sbb = speedbb.new()
	sbb.caller = self
	install_effect(sbb)
	
	_resized()
	_isready = true
	
	# this seems dumb but it's necessary
	# bc the setget fires before the node is ready
	self.player = player
	for t in transitions:
		install_transition(t)
	
	_start_msg()


func _unhandled_input(event):
	if _tween == null or event.is_echo():
		return
	
	if InputMap.has_action(skip_action) and event.is_action_pressed(skip_action):
		if !_done and _cool:
			stop()
			get_tree().set_input_as_handled()
	
	elif InputMap.has_action(accelerate_action) and event.is_action_pressed(accelerate_action):
		_accel = true
		_tween.playback_speed = speed * _speed_mult * acceleration
		get_tree().set_input_as_handled()
	
	elif InputMap.has_action(accelerate_action) and event.is_action_released(accelerate_action):
		_accel = false
		_tween.playback_speed = speed * _speed_mult
		get_tree().set_input_as_handled()


func _process(delta):
	if Engine.editor_hint:
		return
	
	# disables broken autoscroll
	scroll_following = false
	
	# recalculate sizing when theme is changed
	if theme != _old_theme:
		_old_theme = theme
		_resized()
	
	# scroll up or down to show current text
	if autoscroll:
		if use_alt_scroll:
			_scroll_to(percent_visible * (get_content_height() - get_rect().size.y))
		else:
			if get_visible_line_count() > _max_lines and visible_characters > 0 and speed > 0:
				_scroll(1)
			if get_visible_line_count() <= _max_lines and visible_characters > 0 and speed < 0:
				_scroll(-1)
	
	# inline speed multiplier change
	if _speed_mult != _last_speed:
		_last_speed = _speed_mult
		_tween.playback_speed = _speed_mult * speed
	
	# detects when a reversed type is finished
	if !_done and speed < 0 and _tween.tell() == 0:
		_on_done()
	
	# plays a voice sound when a new letter is typed
	if _last_char != visible_characters and voice.size() > 0 and _player != null:
		_last_char = visible_characters
		_player.stop()
		_player.stream = voice[round(rand_range(0, voice.size() - 1))]
		_player.play()
	
	if playing:
		# updates transition time
		_t_time += delta * _tween.playback_speed

### Other ###

func play():
	if !_isready:
		return
	_tween.set_active(true)
	playing = true
	emit_signal("unpaused", _tween.tell())

func pause():
	if !_isready:
		return
	_tween.set_active(false)
	playing = false
	emit_signal("paused", _tween.tell())

func stop():
	if !_isready:
		return
	playing = false
	if speed >= 0:
		_t_time = _tween.get_runtime() * _tween.playback_speed
		_tween.seek(_tween.get_runtime() * _tween.playback_speed)
	else:
		_t_time = 0
		_tween.seek(0)

func reset():
	if !_isready:
		return
	playing = true
	if speed < 0:
		_t_time = _tween.get_runtime() * _tween.playback_speed - .1
		_tween.seek(_tween.get_runtime() * _tween.playback_speed - .1)
	else:
		_t_time = 0
		_tween.seek(0)

# use this INSTEAD OF 'install_effect' to install transition effects
func install_transition(transition: RichTextEffect):
	if !_isready or transition == null:
		return
	if transition.owner != null:
		print("WARNING: Transition instances should not be shared between messageboxes! Unexpected behavior may occur!")
		return
	transition.owner = self
	install_effect(transition)

func remove_transition(transition: RichTextEffect):
	custom_effects.erase(transition)
	transitions.erase(transition)

### Setgets ###

func _set_active(val):
	if val:
		play()
	else:
		pause()

func _set_player(path: NodePath):
	player = path
	
	if !_isready:
		return
	
	_player = get_node(path)
	if _player != null:
		_player.autoplay = false

func _set_speed(val: float):
	speed = float(val)
	
	if _tween == null:
		return
	
	if val != 0:
		_tween.playback_speed = _speed_mult * speed
	else:
		stop()

func _set_accel(val: float):
	if val <= 0:
		return
	
	acceleration = float(val)
	if _accel and _tween != null:
		_tween.playback_speed = _speed_mult * speed * acceleration

func _set_message(val: String):
	bbcode_text = val
	message = val
	if _isready:
		_start_msg()


func _set_transitions(trans: Array):
	if !_isready:
		transitions = trans
		return
	# when existing removed
	for t in transitions:
		if trans.find(t) == -1:
			custom_effects.erase(t)
	# when new added
	for t in trans:
		if transitions.find(t) == -1:
			install_transition(t)
	transitions = trans

### signal callbacks ###

func _on_done():
	_done = true
	emit_signal("message_done")


func _on_cool():
	_cool = true


func _resized():
	_line_size = get_font("normal_font").get_height() + get_constant("line_separation")
	_max_lines = int(get_rect().size.y / _line_size) - 1

### other ###

func _scroll(v: float):
	_scroll_to(_scroll_pos + v)

func _scroll_to(val):
	_scroll_pos = min(val, get_v_scroll().max_value)
	get_v_scroll().value = val


func _block_speed(val: float):
	if val > 0:
		_speed_mult = val

# returns % completion of transition as float
func _get_delta(ind: int, length: float) -> float:
	if speed == 0:
		return 1.0
	elif speed > 0:
		var lentime = length * speed * acceleration if _accel else length * speed
		return smoothstep(_t_time, _t_time - lentime, ind)
	else:
		var lentime = length * speed * acceleration if _accel else length * speed
		return smoothstep(_t_time, _t_time + lentime, ind)

func _start_msg():
	_speed_mult = 1
	_last_speed = 1
	_cool = false
	_cooldown.start()
	_chars = text.length()
	playing = true
	if _tween.is_active():
		_tween.remove_all()
	
	if speed != 0:
		_tween.playback_speed = speed
		_done = false
		if speed < 0:
			_tween.interpolate_property(self, "visible_characters", 0, _chars + 1,_chars + 1)
			_tween.seek(_chars + .9)
			_scroll_to(get_v_scroll().max_value)
			_t_time = _chars + .9
		else:
			_tween.interpolate_property(self, "percent_visible", 0.0, 1.0, _chars)
			_scroll_to(0)
			_t_time = 0
		_tween.start()
	else:
		percent_visible = 1.0
		_t_time = 0
		_on_done()


class speedbb extends RichTextEffect:
	var bbcode: String = "spd"
	var caller: Node = null
	
	func _process_custom_fx(char_fx) -> bool:
		if Engine.editor_hint:
			return true
		
		# main loop
		if char_fx.visible and caller != null and char_fx.env.has(""):
			# first char of speed sequence
			if char_fx.relative_index == 0 and (
					(caller.speed >= 0 and caller.percent_visible < 1.0)
					 or caller.speed < 0):
				
				caller._block_speed(char_fx.env[""])
				
			# last char of speed sequence
			if char_fx.env.get("_ct", -1) == char_fx.relative_index:
				caller._block_speed(1)
		
		# reset for reverse mode
		if (caller != null 
				and caller.speed < 0 
				and char_fx.relative_index == 0 
				and caller.visible_characters == char_fx.absolute_index - 1):
			
			caller._block_speed(1)
			
		# character counting, so it knows where to start and stop the speed
		char_fx.env["_ct"] = max(char_fx.relative_index, char_fx.env.get("_ct", 0))
		
		return true
