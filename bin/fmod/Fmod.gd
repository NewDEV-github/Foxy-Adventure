extends Node2D

var godot_fmod = load("res://bin/fmod/Fmod.gdns").new()
var local_path_prefix = "./"

func _init():
	if OS.get_name() == "Android":
		local_path_prefix = "file:///android_asset/"

func init(numOfChannels: int, studioFlag: int, fmodFlag: int):
	godot_fmod.init(1024, studioFlag, fmodFlag)

func setSoftwareFormat(sampleRate: int, speakerMode: int, numRowSpeakers: int):
	godot_fmod.setSoftwareFormat(sampleRate, speakerMode, numRowSpeakers)

func loadbank(pathToBank: String, loadBankFlag: int):
	godot_fmod.loadbank(getPath(pathToBank), loadBankFlag)

func unloadBank(pathToBank: String):
	godot_fmod.unloadBank(getPath(pathToBank))

func playOneShot(eventPath: String, object):
	godot_fmod.playOneShot(eventPath, object)

func playOneShotWithParams(eventPath: String, object, params: Dictionary):
	godot_fmod.playOneShotWithParams(eventPath, object, params)

func playOneShotAttached(eventPath: String, object):
	godot_fmod.playOneShotAttached(eventPath, object)

func playOneShotAttachedWithParams(eventPath: String, object: Object, params: Dictionary):
	godot_fmod.playOneShotAttachedWithParams(eventPath, object, params)

func createEventInstance(uuid: String, eventPath: String):
	return godot_fmod.createEventInstance(uuid, eventPath)

func startEvent(uuid: String):
	godot_fmod.startEvent(uuid)

func stopEvent(uuid: String, stopMode: int):
	godot_fmod.stopEvent(uuid, stopMode)

func releaseEvent(uuid: String):
	godot_fmod.releaseEvent(uuid)

func setEventVolume(uuid: String, volume: float):
	godot_fmod.setEventVolume(uuid, volume)

func setEventPaused(uuid: String, paused: bool):
	godot_fmod.setEventPaused(uuid, paused)

func setEventPitch(uuid:String, pitch: float):
	godot_fmod.setEventPitch(uuid, pitch)

func addListener(object):
	godot_fmod.addListener(object)

func attachInstanceToNode(uuid: String, object: Object):
	godot_fmod.attachInstanceToNode(uuid, object)

func detachInstanceFromNode(uuid: String):
	godot_fmod.detachInstanceFromNode(uuid)

func loadSound(uuid: String, path:String, mode: int):
	return godot_fmod.loadSound(uuid, getPath(path), mode)

func playSound(uuid: String):
	godot_fmod.playSound(uuid)

func stopSound(uuid: String):
	godot_fmod.stopSound(uuid)

func releaseSound(path: String):
	godot_fmod.releaseSound(getPath(path))

func setSoundPaused(uuid: String, paused: bool):
	godot_fmod.setSoundPaused(uuid, paused)

func setSoundVolume(uuid: String, volume: float):
	godot_fmod.setSoundVolume(uuid, volume)

func setSoundPitch(uuid: String, pitch: float):
	godot_fmod.setSoundPitch(uuid, pitch)

func setSound3DSettings(dopplerScale: float, distanceFactor: float, rollOffScale: float):
	godot_fmod.setSound3DSettings(dopplerScale, distanceFactor, rollOffScale)

func getPath(path: String):
	if path.left(2) == "./":
		return path.replace("./", local_path_prefix)
	return path

func _process(delta):
	godot_fmod.update()
