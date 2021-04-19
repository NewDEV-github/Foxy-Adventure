tool
extends TextureRect

var http = HTTPRequest.new()
var httpCache = HTTPRequest.new()
var progress_texture = TextureProgress.new()
var file_name = ""
var file_ext = ""

export var textureUrl = "" setget _setTextureUrl
export(bool) var storeCache = true
export(bool) var everCache = false # Ever load from cache after the first acess
export(bool) var preloadImage = true setget _setPreloadImage
export(bool) var progressbar = true setget _setProgressbar
export(Rect2) var progressbarRect = Rect2(0,0,0,0)
export(Color) var progressbarColor = Color.red

signal loaded(image, fromCache)
signal progress(percent)

func _setProgressbar(newValue):
	progressbar = newValue
	_adjustProgress()

func _setTextureUrl(newValue):
	textureUrl = newValue
	if preloadImage:
		_loadImage()
	
func _setPreloadImage(newValue):
	preloadImage = newValue
	if preloadImage:
		if !has_node("http"):
			http.use_threads = true
			http.connect("request_completed", self, "_on_HTTPRequest_request_completed")
			call_deferred("add_child", http)
		_loadImage()

func _loadImage():
	if textureUrl == "": return
	
	var dt = textureUrl.split(":")
	if dt[0] == "data":
		_base64texture(textureUrl)
		return

	var spl = textureUrl.split("/")
	file_name = spl[spl.size()-1]
	
	if !Engine.is_editor_hint():
		if storeCache:
			# Add cache directory
			var dir = Directory.new()
			dir.open("user://")
			dir.make_dir("cache")
			
			
			httpCache.use_threads = true
			httpCache.download_file = str("user://cache/", file_name)
			httpCache.request(textureUrl)
	
		var file2Check = File.new()
		var doFileExists = file2Check.file_exists(str("user://cache/", file_name))
		if doFileExists:
			var _image = Image.new()
			_image.load(str("user://cache/", file_name))
			var _texture = ImageTexture.new()
			_texture.create_from_image(_image)
			texture = _texture
			
			if !Engine.is_editor_hint():
				progress_texture.hide()
				emit_signal("loaded", _texture, true)
				
				if everCache:
					return
	
	var file_name_stripped = file_name.split("?")[0]
	var ext = file_name_stripped.split(".")
	file_ext = ext[ext.size()-1].to_lower()
	
	if file_ext != "":
		_downloadImage()
	
func _downloadImage():
	if textureUrl != "":
		set_process(true)
		_adjustProgress()
		http.use_threads = true
		http.request(textureUrl)

func _ready():
	add_to_group("TextureRectUrl")
	add_child(progress_texture)
	add_child(httpCache)
	progress_texture.hide()
	
	if !has_node("http"):
		http.use_threads = true
		http.connect("request_completed", self, "_on_HTTPRequest_request_completed")
		add_child(http)
	
	set_process(false)
	_loadImage()

func _adjustProgress():
	if progressbar:
		progress_texture.nine_patch_stretch = true
		progress_texture.texture_progress = load("res://addons/textureRectUrl/rect.png")
		progress_texture.tint_progress = progressbarColor
		progress_texture.show()
		progress_texture.value = 0
		
		if progressbarRect.size.x == 0:
			progress_texture.rect_size.x = rect_size.x
		else:
			progress_texture.rect_size.x = progressbarRect.size.x
			
		if progressbarRect.size.y == 0:
			progress_texture.rect_size.y = rect_size.y
		else:
			progress_texture.rect_size.y = progressbarRect.size.y
			
		if progressbarRect.position.x == 0:
			progress_texture.rect_position.x = 0
		else:
			progress_texture.rect_position.x = progressbarRect.position.x
			
		if progressbarRect.position.y == 0:
			progress_texture.rect_position.y = 0
		else:
			progress_texture.rect_position.y = progressbarRect.position.y

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var image = Image.new()
		var image_error = null
		
		if file_ext == "png":
			image_error = image.load_png_from_buffer(body)
		elif file_ext == "jpg" or file_ext == "jpeg":
			image_error = image.load_jpg_from_buffer(body)
		elif file_ext == "webp":
			image_error = image.load_webp_from_buffer(body)
			
		if image_error != OK:
			set_process(false)
			# An error occurred while trying to display the image
			return
	
		var _texture = ImageTexture.new()
		_texture.create_from_image(image)
		
		if !Engine.is_editor_hint():
			emit_signal("loaded", image, false)
			
		progress_texture.value = 0
		progress_texture.hide()
		set_process(false)
	
		# Assign a downloaded texture
		texture = _texture

func _process(delta):
	# show progressbar
	var bodySize = http.get_body_size()
	var downloadedBytes = http.get_downloaded_bytes()
	var percent = int(downloadedBytes * 100 / bodySize)
	
	if !Engine.is_editor_hint():
		emit_signal("progress", percent)
	
	if progressbar:
		progress_texture.value = percent

func _base64texture(image64):
	var image = Image.new()
	var tmp = image64.split(",")[1]

	image.load_png_from_buffer(Marshalls.base64_to_raw(tmp))
	var _texture = ImageTexture.new()
	_texture.create_from_image(image)
	texture = _texture
	
	if !Engine.is_editor_hint():
		progress_texture.hide()
		emit_signal("loaded", image, false)
