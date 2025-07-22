extends Control
class_name DualJoystickController

# Dual Joystick Controller for Wight's World
# Left joystick: Camera orbit control (look around)
# Right joystick: World navigation (move through space)

signal left_joystick_moved(direction: Vector2, intensity: float)
signal right_joystick_moved(direction: Vector2, intensity: float)
signal joystick_released(joystick_id: String)

# Joystick UI elements
var left_joystick: Control
var right_joystick: Control
var left_knob: Control
var right_knob: Control
var left_base: Control
var right_base: Control

# Joystick settings
var joystick_size: float = 120.0
var knob_size: float = 40.0
var max_distance: float = 40.0
var return_speed: float = 10.0
var dead_zone: float = 0.1

# Input tracking
var left_active: bool = false
var right_active: bool = false
var left_touch_index: int = -1
var right_touch_index: int = -1
var left_start_position: Vector2
var right_start_position: Vector2
var left_current_position: Vector2
var right_current_position: Vector2

# Movement values
var left_direction: Vector2 = Vector2.ZERO
var right_direction: Vector2 = Vector2.ZERO
var left_intensity: float = 0.0
var right_intensity: float = 0.0

# Visual feedback
var left_joystick_color: Color = Color(0.2, 0.6, 1.0, 0.8)  # Blue for camera
var right_joystick_color: Color = Color(1.0, 0.6, 0.2, 0.8)  # Orange for movement
var knob_color: Color = Color(1.0, 1.0, 1.0, 0.9)
var active_color: Color = Color(0.2, 1.0, 0.2, 0.9)  # Green when active

func _ready():
	print("🕹️ Dual Joystick Controller initializing...")
	setup_joysticks()
	setup_input_handling()
	print("✨ Dual joystick system ready")

func _input(event):
	handle_input_event(event)

func _process(delta):
	update_joystick_positions(delta)
	update_visual_feedback()

# === JOYSTICK SETUP ===

func setup_joysticks():
	"""Create and position the dual joysticks"""
	
	# Left joystick (Camera control)
	left_joystick = create_joystick_container("LeftJoystick")
	left_joystick.position = Vector2(80, get_viewport().get_visible_rect().size.y - 140)
	add_child(left_joystick)
	
	left_base = create_joystick_base("LeftBase", left_joystick_color)
	left_joystick.add_child(left_base)
	
	left_knob = create_joystick_knob("LeftKnob")
	left_joystick.add_child(left_knob)
	
	# Right joystick (Movement control)
	right_joystick = create_joystick_container("RightJoystick")
	right_joystick.position = Vector2(get_viewport().get_visible_rect().size.x - 80, get_viewport().get_visible_rect().size.y - 140)
	add_child(right_joystick)
	
	right_base = create_joystick_base("RightBase", right_joystick_color)
	right_joystick.add_child(right_base)
	
	right_knob = create_joystick_knob("RightKnob")
	right_joystick.add_child(right_knob)
	
	# Add labels
	add_joystick_label(left_joystick, "📹 Camera", Vector2(0, -80))
	add_joystick_label(right_joystick, "🚶 Move", Vector2(0, -80))

func create_joystick_container(name: String) -> Control:
	"""Create joystick container"""
	var container = Control.new()
	container.name = name
	container.custom_minimum_size = Vector2(joystick_size, joystick_size)
	container.anchor_left = 0.0
	container.anchor_top = 0.0
	container.anchor_right = 0.0
	container.anchor_bottom = 0.0
	return container

func create_joystick_base(name: String, color: Color) -> Control:
	"""Create joystick base (outer circle)"""
	var base = Control.new()
	base.name = name
	base.custom_minimum_size = Vector2(joystick_size, joystick_size)
	base.position = Vector2(-joystick_size/2, -joystick_size/2)
	
	# Add visual representation
	var base_panel = Panel.new()
	base_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = color
	style_box.corner_radius_top_left = joystick_size / 2
	style_box.corner_radius_top_right = joystick_size / 2
	style_box.corner_radius_bottom_left = joystick_size / 2
	style_box.corner_radius_bottom_right = joystick_size / 2
	style_box.border_width_left = 3
	style_box.border_width_top = 3
	style_box.border_width_right = 3
	style_box.border_width_bottom = 3
	style_box.border_color = Color.WHITE
	
	base_panel.add_theme_stylebox_override("panel", style_box)
	base.add_child(base_panel)
	
	return base

func create_joystick_knob(name: String) -> Control:
	"""Create joystick knob (inner circle)"""
	var knob = Control.new()
	knob.name = name
	knob.custom_minimum_size = Vector2(knob_size, knob_size)
	knob.position = Vector2(-knob_size/2, -knob_size/2)
	
	# Add visual representation
	var knob_panel = Panel.new()
	knob_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = knob_color
	style_box.corner_radius_top_left = knob_size / 2
	style_box.corner_radius_top_right = knob_size / 2
	style_box.corner_radius_bottom_left = knob_size / 2
	style_box.corner_radius_bottom_right = knob_size / 2
	style_box.border_width_left = 2
	style_box.border_width_top = 2
	style_box.border_width_right = 2
	style_box.border_width_bottom = 2
	style_box.border_color = Color(0.8, 0.8, 0.8)
	
	knob_panel.add_theme_stylebox_override("panel", style_box)
	knob.add_child(knob_panel)
	
	return knob

func add_joystick_label(joystick: Control, text: String, offset: Vector2):
	"""Add label to joystick"""
	var label = Label.new()
	label.text = text
	label.position = offset
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	joystick.add_child(label)

func setup_input_handling():
	"""Setup input event handling"""
	# Make sure we can receive input
	set_process_input(true)
	mouse_filter = Control.MOUSE_FILTER_PASS

# === INPUT HANDLING ===

func handle_input_event(event):
	"""Handle touch and mouse input for joysticks"""
	
	if event is InputEventScreenTouch:
		handle_touch_event(event)
	elif event is InputEventScreenDrag:
		handle_drag_event(event)
	elif event is InputEventMouseButton:
		handle_mouse_button_event(event)
	elif event is InputEventMouseMotion:
		handle_mouse_motion_event(event)

func handle_touch_event(event: InputEventScreenTouch):
	"""Handle touch input for joysticks"""
	var touch_pos = event.position
	
	if event.pressed:
		# Check which joystick was touched
		if is_point_in_joystick(touch_pos, left_joystick) and not left_active:
			start_left_joystick_input(touch_pos, event.index)
		elif is_point_in_joystick(touch_pos, right_joystick) and not right_active:
			start_right_joystick_input(touch_pos, event.index)
	else:
		# Release joystick if this touch index matches
		if event.index == left_touch_index:
			release_left_joystick()
		elif event.index == right_touch_index:
			release_right_joystick()

func handle_drag_event(event: InputEventScreenDrag):
	"""Handle drag input for active joysticks"""
	if event.index == left_touch_index and left_active:
		update_left_joystick_position(event.position)
	elif event.index == right_touch_index and right_active:
		update_right_joystick_position(event.position)

func handle_mouse_button_event(event: InputEventMouseButton):
	"""Handle mouse button for desktop testing"""
	var mouse_pos = event.position
	
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if is_point_in_joystick(mouse_pos, left_joystick) and not left_active:
				start_left_joystick_input(mouse_pos, -1)  # Use -1 for mouse
			elif is_point_in_joystick(mouse_pos, right_joystick) and not right_active:
				start_right_joystick_input(mouse_pos, -1)
		else:
			if left_active and left_touch_index == -1:
				release_left_joystick()
			elif right_active and right_touch_index == -1:
				release_right_joystick()

func handle_mouse_motion_event(event: InputEventMouseMotion):
	"""Handle mouse motion for active joysticks"""
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if left_active and left_touch_index == -1:
			update_left_joystick_position(event.position)
		elif right_active and right_touch_index == -1:
			update_right_joystick_position(event.position)

# === JOYSTICK LOGIC ===

func is_point_in_joystick(point: Vector2, joystick: Control) -> bool:
	"""Check if point is within joystick area"""
	var joystick_center = joystick.global_position
	var distance = point.distance_to(joystick_center)
	return distance <= joystick_size / 2

func start_left_joystick_input(position: Vector2, touch_index: int):
	"""Start left joystick input"""
	left_active = true
	left_touch_index = touch_index
	left_start_position = left_joystick.global_position
	left_current_position = position
	update_left_joystick_position(position)
	print("🕹️ Left joystick activated (Camera control)")

func start_right_joystick_input(position: Vector2, touch_index: int):
	"""Start right joystick input"""
	right_active = true
	right_touch_index = touch_index
	right_start_position = right_joystick.global_position
	right_current_position = position
	update_right_joystick_position(position)
	print("🕹️ Right joystick activated (Movement control)")

func update_left_joystick_position(position: Vector2):
	"""Update left joystick position and calculate direction"""
	if not left_active:
		return
	
	var center = left_joystick.global_position
	var offset = position - center
	var distance = offset.length()
	
	# Clamp to max distance
	if distance > max_distance:
		offset = offset.normalized() * max_distance
		distance = max_distance
	
	# Update knob position
	left_knob.position = offset - Vector2(knob_size/2, knob_size/2)
	
	# Calculate direction and intensity
	left_direction = offset.normalized()
	left_intensity = distance / max_distance
	
	# Apply dead zone
	if left_intensity < dead_zone:
		left_direction = Vector2.ZERO
		left_intensity = 0.0
	
	# Emit signal
	left_joystick_moved.emit(left_direction, left_intensity)

func update_right_joystick_position(position: Vector2):
	"""Update right joystick position and calculate direction"""
	if not right_active:
		return
	
	var center = right_joystick.global_position
	var offset = position - center
	var distance = offset.length()
	
	# Clamp to max distance
	if distance > max_distance:
		offset = offset.normalized() * max_distance
		distance = max_distance
	
	# Update knob position
	right_knob.position = offset - Vector2(knob_size/2, knob_size/2)
	
	# Calculate direction and intensity
	right_direction = offset.normalized()
	right_intensity = distance / max_distance
	
	# Apply dead zone
	if right_intensity < dead_zone:
		right_direction = Vector2.ZERO
		right_intensity = 0.0
	
	# Emit signal
	right_joystick_moved.emit(right_direction, right_intensity)

func release_left_joystick():
	"""Release left joystick"""
	left_active = false
	left_touch_index = -1
	left_direction = Vector2.ZERO
	left_intensity = 0.0
	joystick_released.emit("left")
	print("🕹️ Left joystick released")

func release_right_joystick():
	"""Release right joystick"""
	right_active = false
	right_touch_index = -1
	right_direction = Vector2.ZERO
	right_intensity = 0.0
	joystick_released.emit("right")
	print("🕹️ Right joystick released")

func update_joystick_positions(delta: float):
	"""Update joystick positions each frame"""
	
	# Return left knob to center when not active
	if not left_active:
		var current_offset = left_knob.position + Vector2(knob_size/2, knob_size/2)
		if current_offset.length() > 1.0:
			var return_offset = current_offset.move_toward(Vector2.ZERO, return_speed * delta * 100)
			left_knob.position = return_offset - Vector2(knob_size/2, knob_size/2)
	
	# Return right knob to center when not active
	if not right_active:
		var current_offset = right_knob.position + Vector2(knob_size/2, knob_size/2)
		if current_offset.length() > 1.0:
			var return_offset = current_offset.move_toward(Vector2.ZERO, return_speed * delta * 100)
			right_knob.position = return_offset - Vector2(knob_size/2, knob_size/2)

func update_visual_feedback():
	"""Update visual feedback for joysticks"""
	# Update left joystick appearance
	if left_base and left_base.get_child_count() > 0:
		var panel = left_base.get_child(0)
		var style_box = panel.get_theme_stylebox("panel")
		if style_box:
			if left_active:
				style_box.border_color = active_color
			else:
				style_box.border_color = Color.WHITE
	
	# Update right joystick appearance
	if right_base and right_base.get_child_count() > 0:
		var panel = right_base.get_child(0)
		var style_box = panel.get_theme_stylebox("panel")
		if style_box:
			if right_active:
				style_box.border_color = active_color
			else:
				style_box.border_color = Color.WHITE

# === UTILITY FUNCTIONS ===

func get_left_joystick_input() -> Dictionary:
	"""Get current left joystick input"""
	return {
		"direction": left_direction,
		"intensity": left_intensity,
		"active": left_active
	}

func get_right_joystick_input() -> Dictionary:
	"""Get current right joystick input"""
	return {
		"direction": right_direction,
		"intensity": right_intensity,
		"active": right_active
	}

func set_joystick_visibility(visible: bool):
	"""Show or hide joysticks"""
	self.visible = visible

func set_joystick_opacity(opacity: float):
	"""Set joystick opacity"""
	modulate.a = clamp(opacity, 0.0, 1.0)

func get_joystick_status() -> Dictionary:
	"""Get status of both joysticks"""
	return {
		"left": get_left_joystick_input(),
		"right": get_right_joystick_input(),
		"visible": visible,
		"opacity": modulate.a
	}