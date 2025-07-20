extends Node

## Voice communication system for Android
## Handles text-to-speech and speech recognition using Android APIs
## Replaces Python voice_system.py

signal speech_recognized(text: String)
signal speech_synthesis_started()
signal speech_synthesis_finished()
signal speech_recognition_started()
signal speech_recognition_stopped()
signal voice_error(error_message: String)

var voice_enabled: bool = true
var tts_available: bool = false
var speech_recognition_available: bool = false

# Voice settings
var voice_settings = {
	"tts_rate": 180,      # Words per minute
	"tts_volume": 0.8,    # Volume (0.0 to 1.0)
	"tts_pitch": 1.0,     # Pitch modifier
	"language": "en-US",  # Language code
	"voice_gender": 0     # 0 = neutral/default, 1 = male, 2 = female
}

# State tracking
var is_speaking: bool = false
var is_listening: bool = false
var listening_timeout: float = 10.0

# Emotional voice modulation
var emotional_voice_profiles = {
	"joy": {"pitch": 1.2, "rate": 200, "volume": 0.9},
	"curiosity": {"pitch": 1.1, "rate": 190, "volume": 0.8},
	"loneliness": {"pitch": 0.9, "rate": 160, "volume": 0.7},
	"excitement": {"pitch": 1.3, "rate": 210, "volume": 1.0},
	"confusion": {"pitch": 0.95, "rate": 170, "volume": 0.8},
	"contentment": {"pitch": 1.0, "rate": 180, "volume": 0.8},
	"wonder": {"pitch": 1.15, "rate": 185, "volume": 0.85},
	"playfulness": {"pitch": 1.25, "rate": 195, "volume": 0.9},
	"melancholy": {"pitch": 0.85, "rate": 150, "volume": 0.6},
	"anticipation": {"pitch": 1.05, "rate": 185, "volume": 0.8}
}

# Android TTS and STT integration
var android_tts: AndroidTTS
var android_stt: AndroidSTT

class AndroidTTS:
	"""Android Text-to-Speech wrapper"""
	var is_initialized: bool = false
	
	func _init():
		if OS.get_name() == "Android":
			_initialize_android_tts()
	
	func _initialize_android_tts():
		# In a real implementation, this would use Android plugin
		# For now, we'll simulate with Godot's built-in AudioStreamPlayer
		is_initialized = true
		print("🔊 Android TTS initialized")
	
	func speak(text: String, pitch: float = 1.0, rate: float = 180, volume: float = 0.8):
		if not is_initialized:
			return false
		
		# Simulate TTS with Godot audio system
		print("🗣️ TTS: ", text)
		print("   Pitch: %.2f, Rate: %.0f, Volume: %.2f" % [pitch, rate, volume])
		
		# In real implementation, this would call Android TTS API
		# For now, we'll use a timer to simulate speech duration
		var speech_duration = text.length() * 60.0 / rate  # Approximate duration
		return true
	
	func stop():
		print("⏹️ TTS stopped")
	
	func is_speaking() -> bool:
		return false  # Placeholder

class AndroidSTT:
	"""Android Speech-to-Text wrapper"""
	var is_initialized: bool = false
	var is_listening: bool = false
	
	func _init():
		if OS.get_name() == "Android":
			_initialize_android_stt()
	
	func _initialize_android_stt():
		# In a real implementation, this would use Android plugin
		is_initialized = true
		print("🎤 Android STT initialized")
	
	func start_listening(language: String = "en-US", timeout: float = 10.0):
		if not is_initialized:
			return false
		
		is_listening = true
		print("🎤 Started listening (timeout: %.1fs)" % timeout)
		
		# Simulate recognition with a timer
		var timer = Timer.new()
		timer.wait_time = randf_range(2.0, 5.0)
		timer.one_shot = true
		timer.timeout.connect(_simulate_speech_result)
		return true
	
	func stop_listening():
		is_listening = false
		print("🎤 Stopped listening")
	
	func _simulate_speech_result():
		# Simulate speech recognition result
		var sample_phrases = [
			"Hello Wight", "How are you feeling?", "Create a cube",
			"What can you remember?", "Build a house", "Tell me about yourself"
		]
		var recognized_text = sample_phrases[randi() % sample_phrases.size()]
		print("🎤 Recognized: ", recognized_text)
		# This would emit the actual recognition result

func _ready():
	print("🎤 VoiceSystem initializing...")
	
	# Load voice settings
	if DataManager:
		load_voice_settings()
	
	# Initialize Android voice systems
	android_tts = AndroidTTS.new()
	android_stt = AndroidSTT.new()
	
	tts_available = android_tts.is_initialized
	speech_recognition_available = android_stt.is_initialized
	
	if tts_available:
		print("✅ Text-to-Speech available")
	else:
		print("❌ Text-to-Speech not available")
	
	if speech_recognition_available:
		print("✅ Speech Recognition available")
	else:
		print("❌ Speech Recognition not available")

func speak_text(text: String, emotion: String = "neutral") -> bool:
	"""Speak text with emotional modulation"""
	if not voice_enabled or not tts_available or is_speaking:
		return false
	
	# Remove markdown formatting and emotional tags
	var clean_text = _clean_text_for_speech(text)
	
	if clean_text.is_empty():
		return false
	
	# Apply emotional voice profile
	var voice_profile = emotional_voice_profiles.get(emotion, {
		"pitch": voice_settings["tts_pitch"],
		"rate": voice_settings["tts_rate"],
		"volume": voice_settings["tts_volume"]
	})
	
	print("🗣️ Speaking with emotion '%s': %s" % [emotion, clean_text])
	
	is_speaking = true
	speech_synthesis_started.emit()
	
	# Speak using Android TTS
	var success = android_tts.speak(
		clean_text,
		voice_profile["pitch"],
		voice_profile["rate"],
		voice_profile["volume"]
	)
	
	if success:
		# Create timer for speech duration simulation
		var speech_duration = clean_text.length() * 60.0 / voice_profile["rate"]
		var timer = Timer.new()
		timer.wait_time = speech_duration
		timer.one_shot = true
		timer.timeout.connect(_on_speech_finished)
		add_child(timer)
		timer.start()
	else:
		is_speaking = false
		voice_error.emit("Failed to start text-to-speech")
	
	return success

func _clean_text_for_speech(text: String) -> String:
	"""Clean text for speech synthesis"""
	var clean = text
	
	# Remove emotional tags like [joy] or [curious]
	var regex = RegEx.new()
	regex.compile("\\[\\w+\\]\\s*")
	clean = regex.sub(clean, "", true)
	
	# Remove excessive punctuation
	clean = clean.replace("...", ".")
	clean = clean.replace("!!", "!")
	clean = clean.replace("??", "?")
	
	# Limit length for TTS
	if clean.length() > 500:
		clean = clean.substr(0, 497) + "..."
	
	return clean.strip_edges()

func start_speech_recognition(timeout: float = 10.0) -> bool:
	"""Start listening for speech input"""
	if not voice_enabled or not speech_recognition_available or is_listening:
		return false
	
	print("🎤 Starting speech recognition...")
	
	is_listening = true
	speech_recognition_started.emit()
	
	var success = android_stt.start_listening(voice_settings["language"], timeout)
	
	if success:
		# Set up timeout timer
		var timer = Timer.new()
		timer.wait_time = timeout
		timer.one_shot = true
		timer.timeout.connect(_on_speech_recognition_timeout)
		add_child(timer)
		timer.start()
	else:
		is_listening = false
		voice_error.emit("Failed to start speech recognition")
	
	return success

func stop_speech_recognition():
	"""Stop listening for speech input"""
	if is_listening:
		is_listening = false
		android_stt.stop_listening()
		speech_recognition_stopped.emit()
		print("🎤 Speech recognition stopped")

func stop_speech():
	"""Stop current speech synthesis"""
	if is_speaking:
		is_speaking = false
		android_tts.stop()
		speech_synthesis_finished.emit()
		print("⏹️ Speech stopped")

func _on_speech_finished():
	"""Handle speech synthesis completion"""
	is_speaking = false
	speech_synthesis_finished.emit()
	print("✅ Speech synthesis finished")

func _on_speech_recognition_timeout():
	"""Handle speech recognition timeout"""
	if is_listening:
		stop_speech_recognition()
		voice_error.emit("Speech recognition timed out")

func set_voice_enabled(enabled: bool):
	"""Enable or disable voice features"""
	voice_enabled = enabled
	if DataManager:
		DataManager.set_setting("audio", "voice_enabled", enabled)
	
	if not enabled:
		stop_speech()
		stop_speech_recognition()

func set_tts_rate(rate: int):
	"""Set text-to-speech rate (words per minute)"""
	voice_settings["tts_rate"] = clamp(rate, 80, 300)
	if DataManager:
		DataManager.set_setting("audio", "tts_rate", voice_settings["tts_rate"])

func set_tts_volume(volume: float):
	"""Set text-to-speech volume"""
	voice_settings["tts_volume"] = clamp(volume, 0.0, 1.0)
	if DataManager:
		DataManager.set_setting("audio", "tts_volume", voice_settings["tts_volume"])

func set_tts_pitch(pitch: float):
	"""Set text-to-speech pitch"""
	voice_settings["tts_pitch"] = clamp(pitch, 0.5, 2.0)
	if DataManager:
		DataManager.set_setting("audio", "tts_pitch", voice_settings["tts_pitch"])

func set_language(language_code: String):
	"""Set voice language"""
	voice_settings["language"] = language_code
	if DataManager:
		DataManager.set_setting("audio", "language", language_code)

func get_available_voices() -> Array:
	"""Get list of available TTS voices"""
	# In real implementation, this would query Android TTS
	return [
		{"id": "en-US-male", "name": "English (US) Male", "language": "en-US", "gender": "male"},
		{"id": "en-US-female", "name": "English (US) Female", "language": "en-US", "gender": "female"},
		{"id": "en-GB-male", "name": "English (UK) Male", "language": "en-GB", "gender": "male"},
		{"id": "en-GB-female", "name": "English (UK) Female", "language": "en-GB", "gender": "female"}
	]

func test_tts():
	"""Test text-to-speech with a sample phrase"""
	var test_phrase = "Hello! I am Wight, your AI companion. This is a test of my voice system."
	speak_text(test_phrase, "joy")

func test_speech_recognition():
	"""Test speech recognition"""
	start_speech_recognition(5.0)

func get_voice_status() -> Dictionary:
	"""Get current voice system status"""
	return {
		"voice_enabled": voice_enabled,
		"tts_available": tts_available,
		"speech_recognition_available": speech_recognition_available,
		"is_speaking": is_speaking,
		"is_listening": is_listening,
		"settings": voice_settings.duplicate()
	}

func load_voice_settings():
	"""Load voice settings from DataManager"""
	if DataManager:
		voice_enabled = DataManager.get_setting("voice_enabled", true)
		voice_settings["tts_rate"] = DataManager.get_setting("tts_rate", 180)
		voice_settings["tts_volume"] = DataManager.get_setting("tts_volume", 0.8)
		voice_settings["tts_pitch"] = DataManager.get_setting("tts_pitch", 1.0)
		voice_settings["language"] = DataManager.get_setting("language", "en-US")

func save_voice_settings():
	"""Save voice settings to DataManager"""
	if DataManager:
		DataManager.set_setting("audio", "voice_enabled", voice_enabled)
		DataManager.set_setting("audio", "tts_rate", voice_settings["tts_rate"])
		DataManager.set_setting("audio", "tts_volume", voice_settings["tts_volume"])
		DataManager.set_setting("audio", "tts_pitch", voice_settings["tts_pitch"])
		DataManager.set_setting("audio", "language", voice_settings["language"])

# Android permission handling
func request_microphone_permission():
	"""Request microphone permission for speech recognition"""
	if OS.get_name() == "Android":
		# In Godot 4, this is handled through project settings
		# Additional runtime permission handling could go here
		pass

func has_microphone_permission() -> bool:
	"""Check if microphone permission is granted"""
	# In real implementation, this would check Android permissions
	return true

# Voice command processing
func process_voice_command(command: String) -> bool:
	"""Process recognized voice commands"""
	var command_lower = command.to_lower()
	
	# Voice control commands
	if command_lower.contains("stop talking") or command_lower.contains("be quiet"):
		stop_speech()
		return true
	
	if command_lower.contains("start listening") or command_lower.contains("listen"):
		start_speech_recognition()
		return true
	
	if command_lower.contains("stop listening"):
		stop_speech_recognition()
		return true
	
	# Let WightCore handle the actual conversation
	return false

func _notification(what):
	"""Handle Android lifecycle events"""
	match what:
		NOTIFICATION_APPLICATION_PAUSED:
			# Pause voice when app is paused
			stop_speech()
			stop_speech_recognition()
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			# Stop voice when app loses focus
			stop_speech()
			stop_speech_recognition()

func _exit_tree():
	"""Cleanup when exiting"""
	stop_speech()
	stop_speech_recognition()