extends Node
var activities: Discord.ActivityManager
var users: Discord.UserManager
var images: Discord.ImageManager
var core: Discord.Core
var discord_user_img = null
signal user_avatar_loaded
signal initialized
var av_en = false
func enum_to_string(the_enum: Dictionary, value: int) -> String:
	var index: = the_enum.values().find(value)
	var string: String = the_enum.keys()[index]
	return string


func _ready() -> void:
	if Globals.gdsdk_enabled:
		core = Discord.Core.new()
		var result: int = core.create(
			729429191489093702,
			Discord.CreateFlags.NO_REQUIRE_DISCORD
		)
		print("Created Discord Core: ", enum_to_string(Discord.Result, result))
		if result != Discord.Result.OK:
			core = null
		else:
			core.set_log_hook(Discord.LogLevel.DEBUG, self, "log_hook")

			users = _get_user_manager()
			images = _get_image_manager()
			activities = _get_activity_manager()

			users.connect("current_user_update", self, "_on_current_user_update")

			users.get_user(425340416531890178, self, "get_user_callback")

			result = yield(activities, "update_activity_callback")

			if result == Discord.Result.OK:
				print("Updated activity successfully!")
			else:
				print(
					"Failed to update activity: ",
					enum_to_string(Discord.Result, result)
				)
			emit_signal("initialized")
	else:
		pass


func _process(_delta: float) -> void:
#	av_en = Globals.discord_sdk_enabled
	if core:
		var result: int = core.run_callbacks()
		if result != Discord.Result.OK:
			print("Callbacks failed: ", enum_to_string(Discord.Result, result))


func _get_user_manager() -> Discord.UserManager:
	var result = core.get_user_manager()
	if result is int:
		print(
			"Failed to get user manager: ",
			enum_to_string(Discord.Result, result)
		)
		return null
	else:
		return result


func _get_image_manager() -> Discord.ImageManager:
	var result = core.get_image_manager()
	if result is int:
		print(
			"Failed to get image manager: ",
			enum_to_string(Discord.Result, result)
		)
		return null
	else:
		return result


func _get_activity_manager() -> Discord.ActivityManager:
	var result = core.get_activity_manager()
	if result is int:
		print(
			"Failed to get activity manager: ",
			enum_to_string(Discord.Result, result)
		)
		return null
	else:
		return result


func _on_current_user_update() -> void:
	users.get_current_user()
	var ret: Array = yield(users, "get_current_user_callback")
	var result: int = ret[0]
	var user: Discord.User = ret[1]

	if result != Discord.Result.OK:
		print(
			"Failed to get user: ",
			enum_to_string(Discord.Result, result)
		)
		return

	print("Got Current User:")
	print(user.username, "#", user.discriminator, "  ID: ", user.id)

	var handle: = Discord.ImageHandle.new()
	handle.id = user.id
	handle.size = 256
	handle.type = Discord.ImageType.USER

	images.fetch(handle, true)
	ret = yield(images, "fetch_callback")
	result = ret[0]
	handle = ret[1]

	if result != Discord.Result.OK:
		print(
			"Failed to fetch image handle: ",
			enum_to_string(Discord.Result, result)
		)
		return

	print("Fetched image handle, ", handle.id, ", ", handle.size)

	images.get_data(handle)
	ret = yield(images, "get_data_callback")
	result = ret[0]
	var data: PoolByteArray = ret[1]
	if result != Discord.Result.OK:
		print(
			"Failed to get image data: ",
			enum_to_string(Discord.Result, result)
		)
		return

	images.get_dimensions(handle)
	ret = yield(images, "get_dimensions_callback")
	result = ret[0]
	var dimensions: Discord.ImageDimensions = ret[1]

	var image: = Image.new()
	image.create_from_data(
		dimensions.width, dimensions.height,
		false,
		Image.FORMAT_RGBA8,
		data
	)
	image.unlock()
	var tex: = ImageTexture.new()
	tex.create_from_image(image)
	if av_en == true:
		discord_user_img = tex
		tex.set_size_override(Vector2(100, 100))
		emit_signal("user_avatar_loaded")
	users.get_current_user_premium_type(
		self, "get_current_user_premium_type_callback"
	)


	users.get_current_user_premium_type(
		self, "get_current_user_premium_type_callback"
	)


func log_hook(level: int, message: String) -> void:
	print(
		"[Discord SDK] ",
		enum_to_string(Discord.LogLevel, level),
		": ", message
	)


func get_user_callback(result: int, user: Discord.User) -> void:
	if result == Discord.Result.OK:
		print("Fetched User:")
		print(user.username, "#", user.discriminator, "  ID: ", user.id)
	else:
		print("Failed to fetch user: ", enum_to_string(Discord.Result, result))


func get_current_user_premium_type_callback(
	result: int,
	premium_type: int
) -> void:
	if result != Discord.Result.OK:
		print(
			"Failed to get user premium type: ",
			enum_to_string(Discord.Result, result)
		)
	else:
		print("Current User Premium Type:")
		print(enum_to_string(Discord.PremiumType, premium_type))




func run_rpc(developer, display_stage, character="Tails", is_in_menu=false):
	if core != null:
		print("Starting RPC...")
		var activity = Discord.Activity.new()
		if not developer and not is_in_menu:
			activity.details = "Playing as %s" % [character]
			if display_stage != null:
				activity.state = "At %s" % [Globals.stage_names[str(Globals.current_stage)]]
		elif developer:
			activity.details = "I'm making the game for You now"
		elif is_in_menu:
			activity.details = "At main menu"
		activity.assets.large_image = "icon"

		activity.timestamps.start = OS.get_unix_time()

		activities.update_activity(activity, self, "update_activity_callback")
		if not developer:
			print("RPC started as %s" % [character])
		else:
			print("RPC started as mysterious developer")
func kill_rpc():
	if core != null:
		activities.clear_activity()
