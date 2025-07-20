extends Control

## Message bubble for chat display

@onready var message_panel: Panel = $BubbleContainer/MessagePanel
@onready var message_label: RichTextLabel = $BubbleContainer/MessagePanel/MessageMargin/MessageLabel
@onready var bubble_container: MarginContainer = $BubbleContainer

func setup_message(text: String, is_user: bool):
	"""Setup the message bubble with text and styling"""
	
	# Set the message text
	message_label.text = text
	
	# Style based on sender
	if is_user:
		# User message - align right, blue background
		bubble_container.theme_override_constants["margin_left"] = 60
		bubble_container.theme_override_constants["margin_right"] = 10
		
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Color(0.2, 0.4, 0.8, 0.8)  # Blue
		style_box.corner_radius_top_left = 15
		style_box.corner_radius_top_right = 15
		style_box.corner_radius_bottom_left = 15
		style_box.corner_radius_bottom_right = 5
		message_panel.add_theme_stylebox_override("panel", style_box)
		
		message_label.text = "[color=white]" + text + "[/color]"
	else:
		# AI message - align left, dark background
		bubble_container.theme_override_constants["margin_left"] = 10
		bubble_container.theme_override_constants["margin_right"] = 60
		
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Color(0.3, 0.3, 0.4, 0.8)  # Dark gray
		style_box.corner_radius_top_left = 15
		style_box.corner_radius_top_right = 15
		style_box.corner_radius_bottom_left = 5
		style_box.corner_radius_bottom_right = 15
		message_panel.add_theme_stylebox_override("panel", style_box)
		
		# Parse emotional tags and add color
		var processed_text = _process_emotional_text(text)
		message_label.text = "[color=white]" + processed_text + "[/color]"

func _process_emotional_text(text: String) -> String:
	"""Process text to highlight emotional states"""
	var processed = text
	
	# Color emotional tags
	var emotion_colors = {
		"[joy]": "[color=yellow]",
		"[curiosity]": "[color=cyan]",
		"[wonder]": "[color=lightblue]",
		"[excitement]": "[color=orange]",
		"[loneliness]": "[color=lightgray]",
		"[playfulness]": "[color=pink]",
		"[contentment]": "[color=lightgreen]"
	}
	
	for emotion in emotion_colors:
		if processed.contains(emotion):
			processed = processed.replace(emotion, emotion_colors[emotion] + emotion + "[/color]")
	
	return processed