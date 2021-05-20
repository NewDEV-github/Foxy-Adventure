extends RichTextEffect

var owner: RichTextLabel = null
var bbcode: String = "t_fade"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	if owner == null:
		return true
	char_fx.color.a *= owner._get_delta(char_fx.absolute_index, char_fx.env.get("time", 2.0))
	return true
