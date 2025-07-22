extends Control
class_name NotificationSystem

# Notification System for contextual help, tutorials, and feedback
# Provides non-intrusive user guidance and information

signal notification_dismissed(notification_id: String)
signal tutorial_overlay_closed(step: String)

# Notification types and styling
enum NotificationType {
	HELP_TIP,
	TUTORIAL,
	ACHIEVEMENT,
	WARNING,
	INFO
}

# Active notifications
var active_notifications: Array[Dictionary] = []
var notification_id_counter: int = 0
var max_simultaneous_notifications: int = 3

# Tutorial overlay
var tutorial_overlay_active: bool = false
var current_tutorial_data: Dictionary = {}

# UI elements for notifications
var notification_container: VBoxContainer
var tutorial_overlay: Panel
var tutorial_background: ColorRect

# Styling for different notification types
var notification_styles: Dictionary = {
	NotificationType.HELP_TIP: {
		"color": Color(0.2, 0.6, 1.0, 0.9),
		"icon": "💡",
		"duration": 8.0
	},
	NotificationType.TUTORIAL: {
		"color": Color(0.8, 0.4, 1.0, 0.9),
		"icon": "🎓",
		"duration": 0.0  # Manual dismissal
	},
	NotificationType.ACHIEVEMENT: {
		"color": Color(1.0, 0.8, 0.2, 0.9),
		"icon": "🎉",
		"duration": 6.0
	},
	NotificationType.WARNING: {
		"color": Color(1.0, 0.4, 0.2, 0.9),
		"icon": "⚠️",
		"duration": 10.0
	},
	NotificationType.INFO: {
		"color": Color(0.4, 0.8, 0.4, 0.9),
		"icon": "ℹ️",
		"duration": 5.0
	}
}

func _ready():
	print("🔔 Notification System initializing...")
	setup_notification_ui()
	print("✨ Notification System ready")

func setup_notification_ui():
	"""Create UI elements for notifications"""
	# Create notification container
	notification_container = VBoxContainer.new()
	notification_container.name = "NotificationContainer"
	notification_container.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	notification_container.position.x -= 20
	notification_container.position.y += 20
	notification_container.custom_minimum_size = Vector2(300, 0)
	add_child(notification_container)
	
	# Create tutorial overlay background
	tutorial_background = ColorRect.new()
	tutorial_background.name = "TutorialBackground"
	tutorial_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	tutorial_background.color = Color(0, 0, 0, 0.7)
	tutorial_background.visible = false
	add_child(tutorial_background)
	
	# Create tutorial overlay panel
	tutorial_overlay = Panel.new()
	tutorial_overlay.name = "TutorialOverlay"
	tutorial_overlay.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	tutorial_overlay.custom_minimum_size = Vector2(400, 200)
	tutorial_overlay.visible = false
	add_child(tutorial_overlay)

# === NOTIFICATION DISPLAY ===

func show_notification(type: NotificationType, title: String, message: String, context: Dictionary = {}) -> String:
	"""Show a notification to the user"""
	var notification_id = "notification_" + str(notification_id_counter)
	notification_id_counter += 1
	
	var style = notification_styles[type]
	var notification_data = {
		"id": notification_id,
		"type": type,
		"title": title,
		"message": message,
		"context": context,
		"style": style,
		"created_time": Time.get_ticks_msec(),
		"duration": style.duration
	}
	
	# Remove oldest notification if we have too many
	if active_notifications.size() >= max_simultaneous_notifications:
		dismiss_notification(active_notifications[0].id)
	
	active_notifications.append(notification_data)
	create_notification_ui(notification_data)
	
	print("🔔 Notification shown: %s - %s" % [title, message])
	
	# Auto-dismiss after duration (if set)
	if style.duration > 0.0:
		get_tree().create_timer(style.duration).timeout.connect(
			func(): dismiss_notification(notification_id)
		)
	
	return notification_id

func create_notification_ui(notification_data: Dictionary):
	"""Create UI element for notification"""
	var notification_panel = Panel.new()
	notification_panel.name = notification_data.id
	notification_panel.custom_minimum_size = Vector2(280, 80)
	
	# Style the panel
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = notification_data.style.color
	style_box.corner_radius_top_left = 8
	style_box.corner_radius_top_right = 8
	style_box.corner_radius_bottom_left = 8
	style_box.corner_radius_bottom_right = 8
	style_box.border_width_left = 2
	style_box.border_width_top = 2
	style_box.border_width_right = 2
	style_box.border_width_bottom = 2
	style_box.border_color = Color.WHITE
	notification_panel.add_theme_stylebox_override("panel", style_box)
	
	# Create content container
	var content_container = VBoxContainer.new()
	content_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content_container.add_theme_constant_override("separation", 5)
	notification_panel.add_child(content_container)
	
	# Add some margin
	var margin_container = MarginContainer.new()
	margin_container.add_theme_constant_override("margin_left", 10)
	margin_container.add_theme_constant_override("margin_right", 10)
	margin_container.add_theme_constant_override("margin_top", 8)
	margin_container.add_theme_constant_override("margin_bottom", 8)
	content_container.add_child(margin_container)
	
	var inner_container = VBoxContainer.new()
	margin_container.add_child(inner_container)
	
	# Create title with icon
	var title_label = Label.new()
	title_label.text = notification_data.style.icon + " " + notification_data.title
	title_label.add_theme_font_size_override("font_size", 16)
	title_label.add_theme_color_override("font_color", Color.WHITE)
	inner_container.add_child(title_label)
	
	# Create message
	var message_label = Label.new()
	message_label.text = notification_data.message
	message_label.add_theme_font_size_override("font_size", 14)
	message_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	inner_container.add_child(message_label)
	
	# Add dismiss button for manual notifications
	if notification_data.duration == 0.0:
		var button_container = HBoxContainer.new()
		inner_container.add_child(button_container)
		
		# Spacer
		var spacer = Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button_container.add_child(spacer)
		
		var dismiss_button = Button.new()
		dismiss_button.text = "Got it!"
		dismiss_button.add_theme_font_size_override("font_size", 12)
		dismiss_button.pressed.connect(func(): dismiss_notification(notification_data.id))
		button_container.add_child(dismiss_button)
	
	# Add slide-in animation
	notification_panel.modulate.a = 0.0
	notification_panel.position.x += 50
	notification_container.add_child(notification_panel)
	
	var tween = create_tween()
	tween.parallel().tween_property(notification_panel, "modulate:a", 1.0, 0.3)
	tween.parallel().tween_property(notification_panel, "position:x", 0, 0.3)

func dismiss_notification(notification_id: String):
	"""Dismiss a notification"""
	var notification_node = notification_container.get_node_or_null(notification_id)
	if notification_node:
		# Slide out animation
		var tween = create_tween()
		tween.parallel().tween_property(notification_node, "modulate:a", 0.0, 0.2)
		tween.parallel().tween_property(notification_node, "position:x", 50, 0.2)
		tween.tween_callback(func(): notification_node.queue_free())
	
	# Remove from active list
	for i in range(active_notifications.size()):
		if active_notifications[i].id == notification_id:
			active_notifications.remove_at(i)
			break
	
	notification_dismissed.emit(notification_id)

# === TUTORIAL OVERLAY ===

func show_tutorial_overlay(tutorial_data: Dictionary):
	"""Show tutorial overlay with step information"""
	current_tutorial_data = tutorial_data
	tutorial_overlay_active = true
	
	# Clear previous tutorial content
	for child in tutorial_overlay.get_children():
		child.queue_free()
	
	# Create tutorial content
	var content_container = VBoxContainer.new()
	content_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content_container.add_theme_constant_override("separation", 15)
	tutorial_overlay.add_child(content_container)
	
	# Add margin
	var margin_container = MarginContainer.new()
	margin_container.add_theme_constant_override("margin_left", 30)
	margin_container.add_theme_constant_override("margin_right", 30)
	margin_container.add_theme_constant_override("margin_top", 30)
	margin_container.add_theme_constant_override("margin_bottom", 30)
	content_container.add_child(margin_container)
	
	var inner_container = VBoxContainer.new()
	inner_container.add_theme_constant_override("separation", 10)
	margin_container.add_child(inner_container)
	
	# Title
	var title_label = Label.new()
	title_label.text = tutorial_data.get("title", "Tutorial")
	title_label.add_theme_font_size_override("font_size", 24)
	title_label.add_theme_color_override("font_color", Color.WHITE)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	inner_container.add_child(title_label)
	
	# Message
	var message_label = Label.new()
	message_label.text = tutorial_data.get("message", "")
	message_label.add_theme_font_size_override("font_size", 16)
	message_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	inner_container.add_child(message_label)
	
	# Action button
	var button_container = HBoxContainer.new()
	inner_container.add_child(button_container)
	
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button_container.add_child(spacer)
	
	var action_button = Button.new()
	action_button.text = tutorial_data.get("action", "Continue")
	action_button.add_theme_font_size_override("font_size", 16)
	action_button.custom_minimum_size = Vector2(120, 40)
	action_button.pressed.connect(_on_tutorial_action_pressed)
	button_container.add_child(action_button)
	
	var spacer2 = Control.new()
	spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button_container.add_child(spacer2)
	
	# Style the tutorial overlay
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.1, 0.1, 0.2, 0.95)
	style_box.corner_radius_top_left = 15
	style_box.corner_radius_top_right = 15
	style_box.corner_radius_bottom_left = 15
	style_box.corner_radius_bottom_right = 15
	style_box.border_width_left = 3
	style_box.border_width_top = 3
	style_box.border_width_right = 3
	style_box.border_width_bottom = 3
	style_box.border_color = Color(0.6, 0.4, 1.0)
	tutorial_overlay.add_theme_stylebox_override("panel", style_box)
	
	# Show with fade-in animation
	tutorial_background.visible = true
	tutorial_overlay.visible = true
	tutorial_background.modulate.a = 0.0
	tutorial_overlay.modulate.a = 0.0
	tutorial_overlay.scale = Vector2(0.8, 0.8)
	
	var tween = create_tween()
	tween.parallel().tween_property(tutorial_background, "modulate:a", 1.0, 0.3)
	tween.parallel().tween_property(tutorial_overlay, "modulate:a", 1.0, 0.3)
	tween.parallel().tween_property(tutorial_overlay, "scale", Vector2(1.0, 1.0), 0.3)
	
	print("🎓 Tutorial overlay shown: %s" % tutorial_data.get("title", ""))

func _on_tutorial_action_pressed():
	"""Handle tutorial action button press"""
	hide_tutorial_overlay()
	tutorial_overlay_closed.emit(current_tutorial_data.get("step", ""))

func hide_tutorial_overlay():
	"""Hide tutorial overlay"""
	if not tutorial_overlay_active:
		return
	
	tutorial_overlay_active = false
	
	# Fade out animation
	var tween = create_tween()
	tween.parallel().tween_property(tutorial_background, "modulate:a", 0.0, 0.2)
	tween.parallel().tween_property(tutorial_overlay, "modulate:a", 0.0, 0.2)
	tween.parallel().tween_property(tutorial_overlay, "scale", Vector2(0.8, 0.8), 0.2)
	tween.tween_callback(func(): 
		tutorial_background.visible = false
		tutorial_overlay.visible = false
	)

# === CONVENIENCE METHODS ===

func show_help_tip(tip: Dictionary):
	"""Show a context-sensitive help tip"""
	show_notification(
		NotificationType.HELP_TIP,
		"Tip",
		tip.get("message", ""),
		tip
	)

func show_achievement(title: String, description: String):
	"""Show an achievement notification"""
	show_notification(
		NotificationType.ACHIEVEMENT,
		title,
		description
	)

func show_language_milestone(milestone_data: Dictionary):
	"""Show language development milestone"""
	var old_stage = milestone_data.get("old_stage", "")
	var new_stage = milestone_data.get("new_stage", "")
	
	show_achievement(
		"Language Milestone! 🎯",
		"Wight advanced from " + old_stage + " to " + new_stage + " language stage!"
	)

func show_warning(title: String, message: String):
	"""Show a warning notification"""
	show_notification(
		NotificationType.WARNING,
		title,
		message
	)

func show_info(title: String, message: String):
	"""Show an info notification"""
	show_notification(
		NotificationType.INFO,
		title,
		message
	)

# === STATUS AND CLEANUP ===

func has_active_notifications() -> bool:
	"""Check if there are active notifications"""
	return active_notifications.size() > 0

func clear_all_notifications():
	"""Clear all active notifications"""
	for notification in active_notifications.duplicate():
		dismiss_notification(notification.id)

func get_notification_count() -> int:
	"""Get number of active notifications"""
	return active_notifications.size()