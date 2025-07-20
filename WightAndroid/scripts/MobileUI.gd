extends Control

## Main mobile UI controller for Wight Android app
## Manages tabs, chat interface, sandbox display, and settings

@onready var tab_container: TabContainer = $SafeArea/MainVBox/TabContainer
@onready var connection_status: Label = $SafeArea/MainVBox/Header/StatusContainer/ConnectionStatus
@onready var emotion_status: Label = $SafeArea/MainVBox/Header/StatusContainer/EmotionStatus
@onready var mind_loop_indicator: Label = $SafeArea/MainVBox/Footer/MindLoopIndicator

# Chat tab components
@onready var chat_container: VBoxContainer = $SafeArea/MainVBox/TabContainer/Chat/ChatVBox/ChatScroll/ChatContainer
@onready var message_input: LineEdit = $SafeArea/MainVBox/TabContainer/Chat/ChatVBox/InputContainer/MessageInput
@onready var send_button: Button = $SafeArea/MainVBox/TabContainer/Chat/ChatVBox/InputContainer/SendButton
@onready var voice_button: Button = $SafeArea/MainVBox/TabContainer/Chat/ChatVBox/InputContainer/VoiceButton
@onready var chat_scroll: ScrollContainer = $SafeArea/MainVBox/TabContainer/Chat/ChatVBox/ChatScroll

# Sandbox tab components
@onready var object_count_label: Label = $SafeArea/MainVBox/TabContainer/Sandbox/SandboxVBox/SandboxInfo/ObjectCount
@onready var clear_button: Button = $SafeArea/MainVBox/TabContainer/Sandbox/SandboxVBox/SandboxInfo/ClearButton
@onready var sandbox_view: SubViewport = $SafeArea/MainVBox/TabContainer/Sandbox/SandboxVBox/SandboxView
@onready var object_list_container: VBoxContainer = $SafeArea/MainVBox/TabContainer/Sandbox/SandboxVBox/ObjectList/ObjectContainer

# Mind tab components
@onready var intelligence_bar: ProgressBar = $SafeArea/MainVBox/TabContainer/Mind/MindVBox/IntelligenceSection/IntelligenceBar
@onready var intelligence_desc: Label = $SafeArea/MainVBox/TabContainer/Mind/MindVBox/IntelligenceSection/IntelligenceDesc
@onready var emotions_list: VBoxContainer = $SafeArea/MainVBox/TabContainer/Mind/MindVBox/EmotionsSection/EmotionsList
@onready var conversation_count: Label = $SafeArea/MainVBox/TabContainer/Mind/MindVBox/MemorySection/MemoryStats/ConversationCount
@onready var memory_count: Label = $SafeArea/MainVBox/TabContainer/Mind/MindVBox/MemorySection/MemoryStats/MemoryCount
@onready var facts_count: Label = $SafeArea/MainVBox/TabContainer/Mind/MindVBox/MemorySection/MemoryStats/FactsCount

# Settings tab components
@onready var voice_enabled_checkbox: CheckBox = $SafeArea/MainVBox/TabContainer/Settings/SettingsVBox/VoiceSection/VoiceEnabled
@onready var tts_rate_slider: HSlider = $SafeArea/MainVBox/TabContainer/Settings/SettingsVBox/VoiceSection/TTSSection/TTSRateSlider
@onready var tts_rate_label: Label = $SafeArea/MainVBox/TabContainer/Settings/SettingsVBox/VoiceSection/TTSSection/TTSRateLabel
@onready var tts_volume_slider: HSlider = $SafeArea/MainVBox/TabContainer/Settings/SettingsVBox/VoiceSection/TTSSection/TTSVolumeSlider
@onready var tts_volume_label: Label = $SafeArea/MainVBox/TabContainer/Settings/SettingsVBox/VoiceSection/TTSSection/TTSVolumeLabel
@onready var autonomous_enabled_checkbox: CheckBox = $SafeArea/MainVBox/TabContainer/Settings/SettingsVBox/BehaviorSection/AutonomousEnabled
@onready var creativity_slider: HSlider = $SafeArea/MainVBox/TabContainer/Settings/SettingsVBox/BehaviorSection/CreativitySlider
@onready var creativity_label: Label = $SafeArea/MainVBox/TabContainer/Settings/SettingsVBox/BehaviorSection/CreativityLabel
@onready var backup_button: Button = $SafeArea/MainVBox/TabContainer/Settings/SettingsVBox/DataSection/DataButtons/BackupButton
@onready var reset_button: Button = $SafeArea/MainVBox/TabContainer/Settings/SettingsVBox/DataSection/DataButtons/ResetButton
@onready var storage_info: Label = $SafeArea/MainVBox/TabContainer/Settings/SettingsVBox/DataSection/StorageInfo

# Chat message bubble scene
var chat_bubble_scene = preload("res://scenes/MessageBubble.tscn")

# State tracking
var is_processing_message: bool = false
var last_emotional_state: String = ""
var sandbox_objects_cache: Dictionary = {}

func _ready():
	print("📱 Mobile UI initializing...")
	
	# Connect UI signals
	send_button.pressed.connect(_on_send_button_pressed)
	voice_button.pressed.connect(_on_voice_button_pressed)
	message_input.text_submitted.connect(_on_message_submitted)
	clear_button.pressed.connect(_on_clear_sandbox_pressed)
	
	# Settings signals
	voice_enabled_checkbox.toggled.connect(_on_voice_enabled_toggled)
	tts_rate_slider.value_changed.connect(_on_tts_rate_changed)
	tts_volume_slider.value_changed.connect(_on_tts_volume_changed)
	autonomous_enabled_checkbox.toggled.connect(_on_autonomous_toggled)
	creativity_slider.value_changed.connect(_on_creativity_changed)
	backup_button.pressed.connect(_on_backup_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	
	# Connect to Wight consciousness
	if WightCore:
		WightCore.response_generated.connect(_on_wight_response)
		WightCore.autonomous_thought.connect(_on_autonomous_thought)
		WightCore.emotional_state_changed.connect(_on_emotional_state_changed)
		WightCore.intelligence_updated.connect(_on_intelligence_updated)
		
		if WightCore.sandbox_system:
			WightCore.sandbox_system.object_created.connect(_on_sandbox_object_created)
			WightCore.sandbox_system.object_destroyed.connect(_on_sandbox_object_destroyed)
	
	# Connect to VoiceSystem
	if VoiceSystem:
		VoiceSystem.speech_recognized.connect(_on_speech_recognized)
		VoiceSystem.speech_synthesis_started.connect(_on_speech_started)
		VoiceSystem.speech_synthesis_finished.connect(_on_speech_finished)
		VoiceSystem.voice_error.connect(_on_voice_error)
	
	# Initial UI update
	update_all_displays()
	update_settings_ui()
	
	# Start with chat tab
	tab_container.current_tab = 0
	
	print("✅ Mobile UI ready!")

func _on_send_button_pressed():
	send_message()

func _on_message_submitted(text: String):
	send_message()

func send_message():
	var message = message_input.text.strip_edges()
	if message.is_empty() or is_processing_message:
		return
	
	# Clear input
	message_input.text = ""
	
	# Add user message to chat
	add_chat_message(message, true)
	
	# Process with Wight
	is_processing_message = true
	send_button.text = "Thinking..."
	send_button.disabled = true
	
	# Send to WightCore
	if WightCore:
		var response = WightCore.process_message(message)
		# Response will come through signal

func _on_wight_response(response: String, metadata: Dictionary):
	# Add Wight's response to chat
	add_chat_message(response, false)
	
	# Update UI with metadata
	update_status_from_metadata(metadata)
	
	# Reset UI state
	is_processing_message = false
	send_button.text = "Send"
	send_button.disabled = false
	
	# Speak response if voice is enabled
	if VoiceSystem and VoiceSystem.voice_enabled:
		var emotion = metadata.get("emotional_state", "neutral")
		VoiceSystem.speak_text(response, emotion)

func add_chat_message(message: String, is_user: bool):
	"""Add a message bubble to the chat"""
	if not chat_bubble_scene:
		# Fallback to simple label
		var label = Label.new()
		label.text = ("You: " if is_user else "Wight: ") + message
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		chat_container.add_child(label)
	else:
		var bubble = chat_bubble_scene.instantiate()
		if bubble.has_method("setup_message"):
			bubble.setup_message(message, is_user)
		chat_container.add_child(bubble)
	
	# Auto-scroll to bottom
	await get_tree().process_frame
	chat_scroll.scroll_vertical = chat_scroll.get_v_scroll_bar().max_value

func _on_autonomous_thought(thought: String, thought_type: String):
	"""Handle autonomous thoughts from Wight"""
	var thought_message = "💭 " + thought
	add_chat_message(thought_message, false)

func _on_voice_button_pressed():
	"""Handle voice button press"""
	if not VoiceSystem or not VoiceSystem.voice_enabled:
		show_voice_error("Voice system not available")
		return
	
	if VoiceSystem.is_listening:
		VoiceSystem.stop_speech_recognition()
	else:
		VoiceSystem.start_speech_recognition(10.0)
		voice_button.text = "⏹️"
		voice_button.modulate = Color.RED

func _on_speech_recognized(text: String):
	"""Handle recognized speech"""
	message_input.text = text
	send_message()

func _on_speech_started():
	"""Handle speech synthesis start"""
	voice_button.modulate = Color.YELLOW

func _on_speech_finished():
	"""Handle speech synthesis finish"""
	voice_button.text = "🎤"
	voice_button.modulate = Color.WHITE

func _on_voice_error(error_message: String):
	"""Handle voice system errors"""
	show_voice_error(error_message)
	voice_button.text = "🎤"
	voice_button.modulate = Color.WHITE

func show_voice_error(message: String):
	"""Show voice error to user"""
	add_chat_message("🎤 " + message, false)

func _on_emotional_state_changed(emotion: String, intensity: float):
	"""Update UI when Wight's emotion changes"""
	last_emotional_state = emotion
	emotion_status.text = "💗 " + emotion.capitalize()
	
	# Update emotion display in Mind tab
	update_emotions_display()

func _on_intelligence_updated(level: float, description: String):
	"""Update intelligence display"""
	intelligence_bar.value = level
	intelligence_desc.text = "Level %.1f - %s" % [level, description]

func update_status_from_metadata(metadata: Dictionary):
	"""Update various UI elements from response metadata"""
	# Update connection status
	connection_status.text = "🟢 Active"
	
	# Update memory stats
	if metadata.has("memory_count"):
		memory_count.text = "Memories: %d" % metadata["memory_count"]
	
	if metadata.has("conversation_count"):
		conversation_count.text = "Conversations: %d" % metadata["conversation_count"]
	
	if metadata.has("sandbox_objects"):
		object_count_label.text = "Objects: %d" % metadata["sandbox_objects"]
	
	# Update facts count
	if WightCore and WightCore.memory_system:
		facts_count.text = "Learned Facts: %d" % WightCore.memory_system.get_learned_facts_count()

func update_emotions_display():
	"""Update the emotions list in Mind tab"""
	# Clear existing emotion displays
	for child in emotions_list.get_children():
		child.queue_free()
	
	if not WightCore or not WightCore.emotion_system:
		return
	
	# Add emotion bars
	var emotions = WightCore.emotion_system.emotions
	for emotion in emotions:
		var emotion_container = HBoxContainer.new()
		
		var emotion_label = Label.new()
		emotion_label.text = emotion.capitalize() + ":"
		emotion_label.custom_minimum_size.x = 120
		emotion_container.add_child(emotion_label)
		
		var emotion_bar = ProgressBar.new()
		emotion_bar.min_value = 0.0
		emotion_bar.max_value = 1.0
		emotion_bar.value = emotions[emotion]
		emotion_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		emotion_container.add_child(emotion_bar)
		
		var value_label = Label.new()
		value_label.text = "%.0f%%" % (emotions[emotion] * 100)
		value_label.custom_minimum_size.x = 40
		emotion_container.add_child(value_label)
		
		emotions_list.add_child(emotion_container)

func _on_sandbox_object_created(object_data: Dictionary):
	"""Handle new sandbox objects"""
	update_sandbox_display()

func _on_sandbox_object_destroyed(object_id: int):
	"""Handle sandbox object destruction"""
	update_sandbox_display()

func update_sandbox_display():
	"""Update sandbox object list and 3D view"""
	if not WightCore or not WightCore.sandbox_system:
		return
	
	var objects = WightCore.sandbox_system.get_all_objects()
	object_count_label.text = "Objects: %d" % objects.size()
	
	# Update object list
	for child in object_list_container.get_children():
		child.queue_free()
	
	for obj_id in objects:
		var obj = objects[obj_id]
		var obj_label = Label.new()
		obj_label.text = "%s (%s)" % [obj["name"], obj["type"]]
		object_list_container.add_child(obj_label)
	
	# TODO: Update 3D view with actual objects

func _on_clear_sandbox_pressed():
	"""Clear all sandbox objects"""
	if WightCore and WightCore.sandbox_system:
		WightCore.sandbox_system.clear_sandbox()
		update_sandbox_display()

func update_all_displays():
	"""Update all UI displays with current Wight state"""
	if not WightCore:
		return
	
	update_emotions_display()
	update_sandbox_display()
	
	# Update intelligence display
	if WightCore.intelligence_level:
		intelligence_bar.value = WightCore.intelligence_level
		intelligence_desc.text = "Level %.1f - %s" % [
			WightCore.intelligence_level, 
			WightCore.get_intelligence_description()
		]

# Settings tab handlers
func _on_voice_enabled_toggled(enabled: bool):
	if VoiceSystem:
		VoiceSystem.set_voice_enabled(enabled)

func _on_tts_rate_changed(value: float):
	tts_rate_label.text = "Speech Rate: %d WPM" % int(value)
	if VoiceSystem:
		VoiceSystem.set_tts_rate(int(value))

func _on_tts_volume_changed(value: float):
	tts_volume_label.text = "Speech Volume: %d%%" % int(value * 100)
	if VoiceSystem:
		VoiceSystem.set_tts_volume(value)

func _on_autonomous_toggled(enabled: bool):
	if WightCore:
		WightCore.autonomous_actions_enabled = enabled

func _on_creativity_changed(value: float):
	creativity_label.text = "Creativity Level: %d%%" % int(value * 100)
	# Update WightCore creativity settings

func _on_backup_pressed():
	if DataManager:
		DataManager.create_backup()
		show_notification("Backup created successfully!")

func _on_reset_pressed():
	show_confirmation_dialog("Reset all data?", "This will permanently delete all of Wight's memories, learned facts, and personality development. This cannot be undone.", _confirm_reset)

func _confirm_reset():
	if DataManager:
		DataManager.clear_all_data()
		# Restart app or reload Wight
		get_tree().reload_current_scene()

func show_notification(message: String):
	"""Show a temporary notification"""
	# Create a simple notification label
	var notification = Label.new()
	notification.text = message
	notification.modulate = Color.YELLOW
	add_child(notification)
	
	# Fade out and remove
	var tween = create_tween()
	tween.tween_property(notification, "modulate:a", 0.0, 2.0)
	tween.tween_callback(notification.queue_free)

func show_confirmation_dialog(title: String, message: String, callback: Callable):
	"""Show a confirmation dialog"""
	var dialog = AcceptDialog.new()
	dialog.title = title
	dialog.dialog_text = message
	add_child(dialog)
	
	dialog.confirmed.connect(callback)
	dialog.popup_centered()

func update_settings_ui():
	"""Update settings UI with current values"""
	if VoiceSystem:
		var status = VoiceSystem.get_voice_status()
		voice_enabled_checkbox.button_pressed = status["voice_enabled"]
		tts_rate_slider.value = status["settings"]["tts_rate"]
		tts_volume_slider.value = status["settings"]["tts_volume"]
		
		tts_rate_label.text = "Speech Rate: %d WPM" % int(status["settings"]["tts_rate"])
		tts_volume_label.text = "Speech Volume: %d%%" % int(status["settings"]["tts_volume"] * 100)
	
	if WightCore:
		autonomous_enabled_checkbox.button_pressed = WightCore.autonomous_actions_enabled
	
	if DataManager:
		var storage = DataManager.get_storage_usage()
		storage_info.text = "Storage used: %s" % storage["formatted_size"]

func _process(_delta):
	"""Update indicators that need regular updates"""
	# Update mind loop indicator
	if WightCore and WightCore.mind_loop_active:
		mind_loop_indicator.text = "🔄 Mind Active"
		mind_loop_indicator.modulate = Color.GREEN
	else:
		mind_loop_indicator.text = "⏸️ Mind Paused"
		mind_loop_indicator.modulate = Color.GRAY

func _notification(what):
	"""Handle Android lifecycle notifications"""
	match what:
		NOTIFICATION_APPLICATION_PAUSED:
			# Save state when app is paused
			if DataManager:
				DataManager.save_wight_state()
		NOTIFICATION_WM_GO_BACK_REQUEST:
			# Handle Android back button
			if tab_container.current_tab > 0:
				tab_container.current_tab = 0  # Go back to chat
			else:
				get_tree().quit()  # Exit app