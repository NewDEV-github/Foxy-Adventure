extends Node

#enumeration of all possible inputs from an xbox-controller. This is for Reference.
enum {LEFT_STICK, RIGHT_STICK, A_BUTTON, B_BUTTON, X_BUTTON, Y_BUTTON, LB_BUTTON, LT_BUTTON, RB_BUTTON, RT_BUTTON, D_PAD, D_UP, D_DOWN, D_LEFT, D_RIGHT, START_BUTTON, SELECT_BUTTON, L3_BUTTON, R3_BUTTON}

#enumeration of supporteds devices
enum {XBOX, PS4, NINTENDO, PC}

#you can add or remove devices either here or in the inspector. 
#remember to assign icons to the specific inputs by adding them to the arrays inside input_tag_replacement{}
#if you want to add a new device but aren't sure, what the name of your controller is, you can find it out by using Input.get_joy_name()
export var device_names = {
	"XInput Gamepad": XBOX,
	"PS4 Controller": PS4,
	"Pro Controller": NINTENDO,
	"": PC
}

#this dict maps different inputs to their respective text-tags.
#you don't have to use curly brackets, but I recommend to keep things consistent.
export var input_tags = 	{
			LEFT_STICK: "{LEFTSTICK}", 
			RIGHT_STICK: "{RIGHTSTICK}", 
			A_BUTTON: "{CONFIRM}", 
			B_BUTTON: "{SKIP}", 
			X_BUTTON: "{DOUBT}", 
			Y_BUTTON: "{BUTWHYTHO?!}", 
			LB_BUTTON: "{LB}", 
			LT_BUTTON: "{LT}", 
			RB_BUTTON: "{RB}", 
			RT_BUTTON: "{RT}", 
			D_PAD: "{D_PAD}", 
			D_UP: "{D_UP}", 
			D_DOWN: "{D_DOWN}", 
			D_LEFT: "{D_LEFT}", 
			D_RIGHT: "{D_RIGHT}", 
			START_BUTTON: "{START}", 
			SELECT_BUTTON: "{SELECT}", 
			L3_BUTTON: "{L3}", 
			R3_BUTTON: "{R3}", 
			}

#this painful list of painful stuff only needs to be written ONCE an can be accessed from everywhere. 
#make sure to change the data, if you are remapping your inputs or adding new tags
var input_tag_replacement = {
					LEFT_STICK: 
						[
							"[img]res://assets/leftstick.png[/img]", 
							"[img]res://assets/leftstick.png[/img]", 
							"[img]res://assets/leftstick.png[/img]", 
							"[img]res://assets/pc_WASD.png[/img]", 
						], 
					RIGHT_STICK: 
						[
							"[img]res://assets/rightstick.png[/img]", 
							"[img]res://assets/rightstick.png[/img]", 
							"[img]res://assets/rightstick.png[/img]", 
							"[img]res://assets/pc_arrow_keys.png[/img]", 
						], 
					A_BUTTON: 
						[
							"[img]res://assets/xbox_a.png[/img]", 
							"[img]res://assets/ps_cross.png[/img]", 
							"[img]res://assets/nin_b.png[/img]", 
							"Space", 
						], 
					B_BUTTON:  
						[
							"[img]res://assets/xbox_b.png[/img]", 
							"[img]res://assets/ps_circle.png[/img]", 
							"[img]res://assets/nin_a.png[/img]", 
							"Esc", 
						], 
					X_BUTTON: 
						[
							"[img]res://assets/xbox_x.png[/img]", 
							"[img]res://assets/ps_square.png[/img]", 
							"[img]res://assets/nin_y.png[/img]", 
							"Space", 
						], 
					Y_BUTTON:  
						[
							"[img]res://assets/xbox_y.png[/img]", 
							"[img]res://assets/ps_triangle.png[/img]", 
							"[img]res://assets/nin_x.png[/img]", 
							"[img]res://assets/pc_space.png[/img]", 
						], 
					LB_BUTTON:  
						[
							"[img]res://assets/xbox_lb.png[/img]", 
							"[img]res://assets/ps_l1.png[/img]", 
							"[img]res://assets/nin_l.png[/img]", 
							"[img]res://assets/pc_minus.png[/img]", 
						], 
					LT_BUTTON:  
						[
							"[img]res://assets/xbox_lt.png[/img]", 
							"[img]res://assets/ps_l2.png[/img]", 
							"[img]res://assets/nin_zl.png[/img]", 
							"[img]res://assets/pc_shift.png[/img]", 
						], 
					RB_BUTTON: 
						[
							"[img]res://assets/xbox_rb.png[/img]", 
							"[img]res://assets/ps_r1.png[/img]", 
							"[img]res://assets/nin_r.png[/img]", 
							"[img]res://assets/pc_plus.png[/img]", 
						], 
					RT_BUTTON:  
						[
							"[img]res://assets/xbox_rt.png[/img]", 
							"[img]res://assets/ps_r2.png[/img]", 
							"[img]res://assets/nin_zr.png[/img]", 
							"[img]res://assets/pc_alt.png[/img]", 
						], 
					D_PAD:  
						[
							"[img]res://assets/xbox_d_pad.png[/img]", 
							"[img]res://assets/xbox_d_pad.png[/img]", 
							"[img]res://assets/xbox_d_pad.png[/img]", 
							"[img]res://assets/xbox_d_pad.png[/img][img]res://assets/pc_2.png[/img][img]res://assets/pc_3.png[/img][img]res://assets/pc_4.png[/img]", 
						], 
					D_UP:   
						[
							"[img]res://assets/xbox_dpad_up.png[/img]", 
							"[img]res://assets/xbox_dpad_up.png[/img]", 
							"[img]res://assets/xbox_dpad_up.png[/img]", 
							"W",
						], 
					D_DOWN:    
						[
							"[img]res://assets/xbox_dpad_down.png[/img]", 
							"[img]res://assets/xbox_dpad_down.png[/img]", 
							"[img]res://assets/xbox_dpad_down.png[/img]", 
							"S", 
						], 
					D_LEFT: 
						[
							"[img]res://assets/xbox_dpad_left.png[/img]", 
							"[img]res://assets/xbox_dpad_left.png[/img]", 
							"[img]res://assets/xbox_dpad_left.png[/img]", 
							"A", 
						], 
					D_RIGHT:  
						[
							"[img]res://assets/xbox_dpad_right.png[/img]", 
							"[img]res://assets/xbox_dpad_right.png[/img]", 
							"[img]res://assets/xbox_dpad_right.png[/img]", 
							"D", 
						], 
					START_BUTTON:  
						[
							"[img]res://assets/start.png[/img]", 
							"[img]res://assets/start.png[/img]", 
							"[img]res://assets/start.png[/img]", 
							"[img]res://assets/pc_esc.png[/img]", 
						], 
					SELECT_BUTTON:   
						[
							"[img]res://assets/select.png[/img]", 
							"[img]res://assets/select.png[/img]", 
							"[img]res://assets/select.png[/img]", 
							"[img]res://assets/pc_tab.png[/img]", 
						], 
					L3_BUTTON:    
						[
							"[img]res://assets/l3.png[/img]", 
							"[img]res://assets/l3.png[/img]", 
							"[img]res://assets/l3.png[/img]", 
							"[img]res://assets/pc_comma.png[/img]", 
						], 
					R3_BUTTON:   
						[
							"[img]res://assets/r3.png[/img]", 
							"[img]res://assets/r3.png[/img]", 
							"[img]res://assets/r3.png[/img]", 
							"[img]res://assets/pc_period.png[/img]", 
						]
					}


# the big ol' function, that will be called by TagProcessedLabels.
func process_tags(text: String, device_name = ""):
	
	#is PC by default to prevent the game from going apeshit if a foreign gamepad is connected.
	var game_pad = PC
	#checks if controller is supported. if not, the icons will switch to PC by default.
	if device_names.has(device_name):
		game_pad = device_names[device_name]
	
	
	#this loops through all available {TAGS} and replaces them accordingly.
	for key in input_tags.keys():
		
		#grab an array from the input_tag_replacement{} dict and then pick the appropriate item from said array.
		#this extra step is necessary, unfortunately, something like
		#"text = text.replace(input_tags[key], input_tag_replacement[key[gamepad]]" does not work.
		var replace_array = input_tag_replacement[key]
		var replace = replace_array[game_pad]
		
		#now it's time to replace the {TAGS} with [img]BBCode[/img]
		text = text.replace(input_tags[key], replace)
	
	return text
