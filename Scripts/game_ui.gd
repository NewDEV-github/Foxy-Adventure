extends CanvasLayer

var ms = 0
var s = 0
var m = 0
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.



func _process(delta: float) -> void:
	if DiscordSDK.discord_user_img:
		$Icon.texture = DiscordSDK.discord_user_img
	$stats_label.set_text("COINS: " + str(Globals.coins) + "\nLIVES: " + str(Globals.lives))
	$fps.visible = Globals.fps_visible
	if Globals.fps_visible:
		$fps.set_text("FPS: " + str(Engine.get_frames_per_second()))
	$timer.visible = Globals.timer_visible
	if Globals.timer_visible:
		if ms > 9:
			s += 1
			ms = 0
		if s > 59:
			m += 1
			s = 0
		$timer.set_text(str(m)+":"+str(s)+":"+str(ms))



func _on_ms_timeout() -> void:
	if Globals.timer_visible:
		ms += 1
