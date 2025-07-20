extends Control
class_name MessageBubble

@onready var background: NinePatchRect
@onready var message_label: RichTextLabel
@onready var timestamp_label: Label
@onready var metadata_label: Label

func setup_message(message_data: Dictionary):
	var sender = message_data.get("sender", "unknown")
	var content = message_data.get("content", "")
	var timestamp = message_data.get("timestamp", 0)
	var metadata = message_data.get("metadata", {})
	
	# Set message content
	message_label.text = content
	
	# Format timestamp
	var time_str = Time.get_datetime_string_from_unix_time(timestamp)
	timestamp_label.text = time_str.split(" ")[1]  # Just the time part
	
	# Configure appearance based on sender
	configure_appearance(sender)
	
	# Show metadata for AI messages
	if sender == "ai" and metadata.size() > 0:
		var memory_count = metadata.get("memory_count", 0)
		metadata_label.text = "Memories: %d" % memory_count
		metadata_label.visible = true
	else:
		metadata_label.visible = false

func configure_appearance(sender: String):
	match sender:
		"user":
			# User messages on the right, blue
			set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
			background.modulate = Color(0.2, 0.4, 0.8, 0.9)  # Blue
			message_label.add_theme_color_override("default_color", Color.WHITE)
			
		"ai":
			# AI messages on the left, dark gray
			set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
			background.modulate = Color(0.3, 0.3, 0.3, 0.9)  # Dark gray
			message_label.add_theme_color_override("default_color", Color.WHITE)
			
		"system":
			# System messages centered, yellow
			set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
			background.modulate = Color(0.8, 0.6, 0.2, 0.8)  # Yellow
			message_label.add_theme_color_override("default_color", Color.BLACK)
	
	# Adjust size to fit content
	custom_minimum_size.y = 60 + message_label.get_content_height()