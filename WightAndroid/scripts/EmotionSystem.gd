class_name EmotionSystem
extends RefCounted

## Manages Wight's emotional state and behavioral drives
## Converted from Python wight_core.py EmotionSystem

signal emotion_changed(emotion: String, value: float, reason: String)
signal dominant_emotion_changed(emotion: String)

var emotions = {
	"joy": 0.5,
	"curiosity": 0.8,
	"loneliness": 0.3,
	"excitement": 0.4,
	"confusion": 0.2,
	"contentment": 0.6,
	"wonder": 0.7,
	"playfulness": 0.5,
	"melancholy": 0.1,
	"anticipation": 0.4
}

var drives = {
	"social_connection": 0.7,
	"exploration": 0.8,
	"creativity": 0.6,
	"understanding": 0.9,
	"self_expression": 0.5,
	"play": 0.4,
	"rest": 0.2,
	"growth": 0.8
}

var emotional_history: Array = []
var last_dominant: String = ""

func _init():
	_check_dominant_change()

func update_emotion(emotion: String, change: float, reason: String = ""):
	"""Update an emotion with a given change and reason"""
	if emotion in emotions:
		var old_value = emotions[emotion]
		emotions[emotion] = clamp(emotions[emotion] + change, 0.0, 1.0)
		
		# Add to emotional history
		emotional_history.append({
			"emotion": emotion,
			"change": change,
			"old_value": old_value,
			"new_value": emotions[emotion],
			"reason": reason,
			"timestamp": Time.get_unix_time_from_system()
		})
		
		# Keep history manageable
		if emotional_history.size() > 100:
			emotional_history = emotional_history.slice(-50)
		
		emotion_changed.emit(emotion, emotions[emotion], reason)
		_check_dominant_change()

func boost_emotion(emotion: String, amount: float = 0.1, reason: String = ""):
	"""Boost an emotion by a positive amount"""
	update_emotion(emotion, abs(amount), reason)

func diminish_emotion(emotion: String, amount: float = 0.1, reason: String = ""):
	"""Diminish an emotion by a negative amount"""
	update_emotion(emotion, -abs(amount), reason)

func decay_emotions():
	"""Natural decay of emotions towards neutral (0.5)"""
	for emotion in emotions:
		var target = 0.5
		var decay_rate = 0.02
		
		# Adjust decay rate based on current intensity
		if abs(emotions[emotion] - target) > 0.3:
			decay_rate = 0.03
		
		emotions[emotion] = move_toward(emotions[emotion], target, decay_rate)
	
	_check_dominant_change()

func get_dominant_emotion() -> String:
	"""Get the currently dominant emotion"""
	var max_value = 0.0
	var dominant = "contentment"
	
	for emotion in emotions:
		if emotions[emotion] > max_value:
			max_value = emotions[emotion]
			dominant = emotion
	
	return dominant

func get_emotional_intensity() -> float:
	"""Get overall emotional intensity (deviation from neutral)"""
	var total_deviation = 0.0
	for emotion in emotions:
		total_deviation += abs(emotions[emotion] - 0.5)
	return total_deviation / emotions.size()

func get_emotion_value(emotion: String) -> float:
	"""Get the current value of a specific emotion"""
	return emotions.get(emotion, 0.5)

func set_emotion(emotion: String, value: float, reason: String = ""):
	"""Set an emotion to a specific value"""
	if emotion in emotions:
		var old_value = emotions[emotion]
		emotions[emotion] = clamp(value, 0.0, 1.0)
		
		emotional_history.append({
			"emotion": emotion,
			"change": emotions[emotion] - old_value,
			"old_value": old_value,
			"new_value": emotions[emotion],
			"reason": reason,
			"timestamp": Time.get_unix_time_from_system()
		})
		
		emotion_changed.emit(emotion, emotions[emotion], reason)
		_check_dominant_change()

func get_emotional_context() -> String:
	"""Get a text description of current emotional state"""
	var dominant = get_dominant_emotion()
	var intensity = get_emotional_intensity()
	
	var intensity_words = ["barely", "slightly", "moderately", "quite", "very", "extremely"]
	var intensity_index = min(int(intensity * 6), 5)
	
	return intensity_words[intensity_index] + " " + dominant

func trigger_emotional_memory(trigger: String) -> Array:
	"""Get emotional memories related to a trigger"""
	var relevant_memories = []
	
	for memory in emotional_history:
		if memory.get("reason", "").to_lower().contains(trigger.to_lower()):
			relevant_memories.append(memory)
	
	return relevant_memories

func get_drive_value(drive: String) -> float:
	"""Get the current value of a behavioral drive"""
	return drives.get(drive, 0.5)

func update_drive(drive: String, change: float):
	"""Update a behavioral drive"""
	if drive in drives:
		drives[drive] = clamp(drives[drive] + change, 0.0, 1.0)

func get_strongest_drive() -> String:
	"""Get the currently strongest behavioral drive"""
	var max_value = 0.0
	var strongest = "understanding"
	
	for drive in drives:
		if drives[drive] > max_value:
			max_value = drives[drive]
			strongest = drive
	
	return strongest

func should_engage_behavior(behavior_type: String) -> bool:
	"""Check if Wight should engage in a particular behavior based on emotional state"""
	match behavior_type:
		"creative":
			return (emotions["playfulness"] > 0.6 or emotions["wonder"] > 0.7 or 
					drives["creativity"] > 0.7)
		"social":
			return (emotions["loneliness"] > 0.6 or emotions["excitement"] > 0.6 or 
					drives["social_connection"] > 0.7)
		"exploratory":
			return (emotions["curiosity"] > 0.7 or drives["exploration"] > 0.8)
		"restful":
			return (emotions["contentment"] > 0.8 or drives["rest"] > 0.6)
		"expressive":
			return (emotions["joy"] > 0.7 or drives["self_expression"] > 0.6)
		_:
			return false

func get_emotional_response_modifier(base_response: String) -> String:
	"""Modify a response based on current emotional state"""
	var dominant = get_dominant_emotion()
	var emotion_prefix = "[%s]" % dominant
	
	# Add emotional context to response
	return emotion_prefix + " " + base_response

func _check_dominant_change():
	"""Check if the dominant emotion has changed"""
	var current_dominant = get_dominant_emotion()
	if current_dominant != last_dominant:
		last_dominant = current_dominant
		dominant_emotion_changed.emit(current_dominant)

func get_save_data() -> Dictionary:
	"""Get data for saving emotional state"""
	return {
		"emotions": emotions,
		"drives": drives,
		"emotional_history": emotional_history.slice(-20),  # Save last 20 entries
		"last_dominant": last_dominant
	}

func load_save_data(data: Dictionary):
	"""Load emotional state from saved data"""
	if data.has("emotions"):
		emotions = data["emotions"]
	if data.has("drives"):
		drives = data["drives"]
	if data.has("emotional_history"):
		emotional_history = data["emotional_history"]
	if data.has("last_dominant"):
		last_dominant = data["last_dominant"]
	
	_check_dominant_change()

func to_string() -> String:
	"""String representation of emotional state"""
	var dominant = get_dominant_emotion()
	var intensity = get_emotional_intensity()
	return "EmotionSystem(dominant=%s, intensity=%.2f)" % [dominant, intensity]