extends Node

## Data persistence manager for Wight Android app
## Handles saving/loading consciousness state, settings, and user data
## Replaces Python file-based communication system

const SAVE_PATH = "user://wight_consciousness.save"
const SETTINGS_PATH = "user://wight_settings.cfg"
const BACKUP_PATH = "user://wight_backup.save"

var wight_core: Node  # Reference to WightCore
var settings: ConfigFile

signal data_saved()
signal data_loaded()
signal backup_created()

func _ready():
	print("💾 DataManager initialized")
	settings = ConfigFile.new()
	load_settings()

func save_wight_state():
	"""Save complete Wight consciousness state"""
	if not wight_core:
		print("⚠️ No WightCore reference for saving")
		return
	
	var save_data = wight_core.get_current_state()
	save_data["save_version"] = "1.0"
	save_data["saved_at"] = Time.get_unix_time_from_system()
	save_data["app_version"] = "Android_1.0"
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("💾 Consciousness state saved")
		data_saved.emit()
		
		# Create backup every 10 saves
		if save_data.get("conversation_count", 0) % 10 == 0:
			create_backup()
	else:
		print("❌ Failed to save consciousness state")

func load_wight_state() -> Dictionary:
	"""Load Wight consciousness state"""
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if parse_result == OK:
				print("💾 Consciousness state loaded")
				data_loaded.emit()
				return json.data
			else:
				print("❌ Failed to parse consciousness data")
	
	print("📝 No previous consciousness state found - starting fresh")
	return {}

func create_backup():
	"""Create a backup of current consciousness state"""
	if FileAccess.file_exists(SAVE_PATH):
		var original = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var backup = FileAccess.open(BACKUP_PATH, FileAccess.WRITE)
		
		if original and backup:
			backup.store_string(original.get_as_text())
			original.close()
			backup.close()
			print("🔄 Backup created")
			backup_created.emit()

func restore_from_backup() -> bool:
	"""Restore consciousness state from backup"""
	if FileAccess.file_exists(BACKUP_PATH):
		var backup = FileAccess.open(BACKUP_PATH, FileAccess.READ)
		var main = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		
		if backup and main:
			main.store_string(backup.get_as_text())
			backup.close()
			main.close()
			print("🔄 Restored from backup")
			return true
	
	print("❌ No backup available")
	return false

func save_settings():
	"""Save app settings"""
	settings.set_value("audio", "voice_enabled", get_setting("voice_enabled", true))
	settings.set_value("audio", "tts_rate", get_setting("tts_rate", 180))
	settings.set_value("audio", "tts_volume", get_setting("tts_volume", 0.8))
	
	settings.set_value("ui", "theme", get_setting("theme", "dark"))
	settings.set_value("ui", "font_size", get_setting("font_size", 16))
	settings.set_value("ui", "animation_speed", get_setting("animation_speed", 1.0))
	
	settings.set_value("behavior", "autonomous_enabled", get_setting("autonomous_enabled", true))
	settings.set_value("behavior", "mind_loop_speed", get_setting("mind_loop_speed", 2.0))
	settings.set_value("behavior", "creativity_level", get_setting("creativity_level", 0.8))
	
	settings.save(SETTINGS_PATH)
	print("⚙️ Settings saved")

func load_settings():
	"""Load app settings"""
	var error = settings.load(SETTINGS_PATH)
	if error == OK:
		print("⚙️ Settings loaded")
	else:
		print("⚙️ Using default settings")
		save_settings()  # Create default settings file

func get_setting(key: String, default_value = null):
	"""Get a setting value with fallback to default"""
	# Try different sections where the setting might be
	var sections = ["audio", "ui", "behavior", "general"]
	
	for section in sections:
		if settings.has_section_key(section, key):
			return settings.get_value(section, key, default_value)
	
	return default_value

func set_setting(section: String, key: String, value):
	"""Set a setting value"""
	settings.set_value(section, key, value)
	save_settings()

func get_save_file_info() -> Dictionary:
	"""Get information about the save file"""
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var size = file.get_length()
			file.close()
			
			return {
				"exists": true,
				"size": size,
				"modified": FileAccess.get_modified_time(SAVE_PATH),
				"path": SAVE_PATH
			}
	
	return {"exists": false}

func get_storage_usage() -> Dictionary:
	"""Get storage usage information"""
	var total_size = 0
	var file_count = 0
	
	var files_to_check = [SAVE_PATH, SETTINGS_PATH, BACKUP_PATH]
	
	for file_path in files_to_check:
		if FileAccess.file_exists(file_path):
			var file = FileAccess.open(file_path, FileAccess.READ)
			if file:
				total_size += file.get_length()
				file.close()
				file_count += 1
	
	return {
		"total_size": total_size,
		"file_count": file_count,
		"formatted_size": format_bytes(total_size)
	}

func format_bytes(bytes: int) -> String:
	"""Format byte count as human-readable string"""
	if bytes < 1024:
		return "%d B" % bytes
	elif bytes < 1024 * 1024:
		return "%.1f KB" % (bytes / 1024.0)
	elif bytes < 1024 * 1024 * 1024:
		return "%.1f MB" % (bytes / (1024.0 * 1024.0))
	else:
		return "%.1f GB" % (bytes / (1024.0 * 1024.0 * 1024.0))

func export_consciousness_data() -> String:
	"""Export consciousness data as JSON string for sharing/backup"""
	var data = load_wight_state()
	if not data.is_empty():
		return JSON.stringify(data)
	return ""

func import_consciousness_data(json_string: String) -> bool:
	"""Import consciousness data from JSON string"""
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result == OK:
		var data = json.data
		
		# Validate the data structure
		if data.has("save_version") and data.has("emotion_system"):
			var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
			if file:
				file.store_string(json_string)
				file.close()
				print("📥 Consciousness data imported")
				return true
	
	print("❌ Invalid consciousness data format")
	return false

func clear_all_data():
	"""Clear all saved data (reset consciousness)"""
	var files_to_remove = [SAVE_PATH, BACKUP_PATH]
	
	for file_path in files_to_remove:
		if FileAccess.file_exists(file_path):
			DirAccess.remove_absolute(file_path)
	
	print("🗑️ All consciousness data cleared")

func get_app_data_path() -> String:
	"""Get the app's data directory path"""
	return OS.get_user_data_dir()

func create_debug_export() -> String:
	"""Create a debug export with consciousness state and logs"""
	var debug_data = {
		"consciousness_state": load_wight_state(),
		"settings": {},
		"system_info": {
			"platform": OS.get_name(),
			"version": Engine.get_version_info(),
			"export_time": Time.get_unix_time_from_system()
		},
		"storage_info": get_storage_usage()
	}
	
	# Export current settings
	for section in settings.get_sections():
		debug_data["settings"][section] = {}
		for key in settings.get_section_keys(section):
			debug_data["settings"][section][key] = settings.get_value(section, key)
	
	return JSON.stringify(debug_data)

# Android-specific functions
func request_storage_permission():
	"""Request storage permission on Android"""
	if OS.get_name() == "Android":
		# In Godot 4, permissions are handled through project settings
		# This is a placeholder for any additional permission handling
		pass

func get_android_storage_path() -> String:
	"""Get Android-specific storage path"""
	if OS.get_name() == "Android":
		return OS.get_user_data_dir()
	return ""

func is_storage_available() -> bool:
	"""Check if storage is available for saving"""
	var test_path = "user://storage_test.tmp"
	var file = FileAccess.open(test_path, FileAccess.WRITE)
	if file:
		file.store_string("test")
		file.close()
		DirAccess.remove_absolute(test_path)
		return true
	return false

func _notification(what):
	"""Handle Android lifecycle events"""
	match what:
		NOTIFICATION_WM_GO_BACK_REQUEST:
			# Android back button pressed
			save_wight_state()
		NOTIFICATION_APPLICATION_PAUSED:
			# App paused - save state
			save_wight_state()
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			# App lost focus - save state
			save_wight_state()

func _exit_tree():
	"""Save state when app is closing"""
	save_wight_state()