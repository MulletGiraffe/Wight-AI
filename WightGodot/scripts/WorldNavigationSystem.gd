extends Node
class_name WorldNavigationSystem

# Comprehensive Navigation System for Wight's 3D World
# Provides intuitive movement, exploration, and Wight-finding capabilities

signal navigation_mode_changed(mode: String)
signal wight_located(position: Vector3)
signal interesting_object_found(object: Node3D, description: String)

# Navigation modes
enum NavigationMode {
	FREE_EXPLORE,     # Free camera movement
	FOLLOW_WIGHT,     # Camera follows Wight
	GUIDED_TOUR,      # Automatic tour of interesting objects
	MEMORY_JOURNEY    # Tour through Wight's memory locations
}

# Camera and movement settings
var camera: Camera3D
var current_mode: NavigationMode = NavigationMode.FREE_EXPLORE
var camera_target: Vector3 = Vector3.ZERO
var camera_position: Vector3 = Vector3(0, 5, 5)
var camera_smooth_speed: float = 2.0

# Camera orbit controls
var orbit_center: Vector3 = Vector3.ZERO
var orbit_distance: float = 8.0
var orbit_yaw: float = 0.0
var orbit_pitch: float = -20.0
var orbit_speed: float = 100.0
var zoom_speed: float = 2.0
var min_distance: float = 2.0
var max_distance: float = 20.0

# Touch/mouse input handling
var is_dragging: bool = false
var drag_start_position: Vector2
var last_touch_position: Vector2
var pinch_start_distance: float = 0.0
var pinch_zoom_sensitivity: float = 0.01

# Wight tracking
var wight_entity: Node3D
var wight_last_known_position: Vector3
var wight_tracking_active: bool = false

# Points of interest
var interesting_objects: Array[Dictionary] = []
var memory_locations: Array[Dictionary] = []
var tour_waypoints: Array[Vector3] = []
var current_tour_index: int = 0

# UI elements for navigation
var navigation_ui: Dictionary = {}
var compass_indicator: Control
var distance_indicator: Label
var mode_indicator: Label

func _ready():
	print("🧭 World Navigation System initializing...")
	setup_navigation_controls()
	initialize_points_of_interest()
	print("✨ Navigation system ready")

func _input(event):
	handle_input_events(event)

func _process(delta):
	update_navigation(delta)
	update_wight_tracking()
	update_ui_indicators()

# === INITIALIZATION ===

func setup_navigation_controls():
	"""Initialize navigation controls and UI"""
	# Find camera in scene
	camera = get_viewport().get_camera_3d()
	if not camera:
		print("⚠️ No camera found in scene")
		return
	
	# Set initial camera position
	set_camera_mode(NavigationMode.FREE_EXPLORE)
	update_camera_position()

func initialize_points_of_interest():
	"""Set up points of interest in Wight's world"""
	# These will be populated as Wight creates objects and forms memories
	interesting_objects = []
	memory_locations = []

# === INPUT HANDLING ===

func handle_input_events(event):
	"""Handle touch and mouse input for navigation"""
	
	# Touch/mouse drag for camera orbit
	if event is InputEventScreenTouch:
		handle_touch_event(event)
	elif event is InputEventScreenDrag:
		handle_drag_event(event)
	elif event is InputEventMouseButton:
		handle_mouse_button(event)
	elif event is InputEventMouseMotion:
		handle_mouse_motion(event)
	
	# Keyboard shortcuts for desktop testing
	if event is InputEventKey and event.pressed:
		handle_keyboard_shortcuts(event)

func handle_touch_event(event: InputEventScreenTouch):
	"""Handle touch input for camera control"""
	if event.pressed:
		is_dragging = true
		drag_start_position = event.position
		last_touch_position = event.position
	else:
		is_dragging = false
		
		# Check for tap to focus
		var drag_distance = event.position.distance_to(drag_start_position)
		if drag_distance < 20:  # Small movement = tap
			handle_world_tap(event.position)

func handle_drag_event(event: InputEventScreenDrag):
	"""Handle drag input for camera movement"""
	if not is_dragging:
		return
	
	var delta_position = event.position - last_touch_position
	last_touch_position = event.position
	
	# Convert screen drag to camera rotation
	orbit_yaw -= delta_position.x * orbit_speed * get_process_delta_time()
	orbit_pitch = clamp(orbit_pitch - delta_position.y * orbit_speed * get_process_delta_time(), -80, 80)
	
	update_camera_position()

func handle_mouse_button(event: InputEventMouseButton):
	"""Handle mouse button events"""
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_start_position = event.position
		else:
			is_dragging = false
			
			# Check for click to focus
			var drag_distance = event.position.distance_to(drag_start_position)
			if drag_distance < 5:
				handle_world_tap(event.position)
	
	# Mouse wheel for zoom
	elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom_camera(-1.0)
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom_camera(1.0)

func handle_mouse_motion(event: InputEventMouseMotion):
	"""Handle mouse motion for camera control"""
	if is_dragging and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		orbit_yaw -= event.relative.x * orbit_speed * 0.001
		orbit_pitch = clamp(orbit_pitch - event.relative.y * orbit_speed * 0.001, -80, 80)
		update_camera_position()

func handle_keyboard_shortcuts(event: InputEventKey):
	"""Handle keyboard shortcuts for navigation"""
	match event.keycode:
		KEY_F:
			find_wight()
		KEY_T:
			start_guided_tour()
		KEY_M:
			start_memory_journey()
		KEY_R:
			reset_camera()
		KEY_SPACE:
			toggle_follow_mode()

func handle_world_tap(screen_position: Vector2):
	"""Handle tap/click in the 3D world"""
	if not camera:
		return
	
	# Cast ray from camera to find what was tapped
	var from = camera.project_ray_origin(screen_position)
	var to = from + camera.project_ray_normal(screen_position) * 100
	
	var space_state = camera.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result:
		handle_object_interaction(result.collider, result.position)
	else:
		# Tap on empty space - move camera focus there
		var target_point = camera.project_position(screen_position, orbit_distance)
		focus_on_point(target_point)

func handle_object_interaction(object: Node3D, position: Vector3):
	"""Handle interaction with objects in the world"""
	print("🎯 Tapped on: %s at %s" % [object.name, position])
	
	# Focus camera on the object
	focus_on_point(position)
	
	# Check if it's Wight
	if is_wight_object(object):
		wight_located.emit(position)
		set_camera_mode(NavigationMode.FOLLOW_WIGHT)
	
	# Check if it's an interesting object
	var object_info = get_object_info(object)
	if object_info:
		interesting_object_found.emit(object, object_info.description)

# === CAMERA CONTROL ===

func update_camera_position():
	"""Update camera position based on current orbit settings"""
	if not camera:
		return
	
	# Calculate camera position from orbit parameters
	var yaw_rad = deg_to_rad(orbit_yaw)
	var pitch_rad = deg_to_rad(orbit_pitch)
	
	var target_position = orbit_center + Vector3(
		cos(pitch_rad) * sin(yaw_rad) * orbit_distance,
		sin(pitch_rad) * orbit_distance,
		cos(pitch_rad) * cos(yaw_rad) * orbit_distance
	)
	
	# Smooth camera movement
	camera.position = camera.position.lerp(target_position, camera_smooth_speed * get_process_delta_time())
	camera.look_at(orbit_center, Vector3.UP)

func zoom_camera(zoom_delta: float):
	"""Zoom camera in or out"""
	orbit_distance = clamp(orbit_distance + zoom_delta * zoom_speed, min_distance, max_distance)
	update_camera_position()

func focus_on_point(point: Vector3):
	"""Focus camera on a specific point"""
	orbit_center = point
	update_camera_position()
	print("📹 Camera focused on: %s" % point)

func reset_camera():
	"""Reset camera to default position"""
	orbit_center = Vector3.ZERO
	orbit_distance = 8.0
	orbit_yaw = 0.0
	orbit_pitch = -20.0
	set_camera_mode(NavigationMode.FREE_EXPLORE)
	update_camera_position()
	print("📹 Camera reset to default")

# === NAVIGATION MODES ===

func set_camera_mode(mode: NavigationMode):
	"""Set navigation mode"""
	current_mode = mode
	navigation_mode_changed.emit(NavigationMode.keys()[mode])
	
	match mode:
		NavigationMode.FREE_EXPLORE:
			print("🧭 Navigation: Free exploration mode")
		NavigationMode.FOLLOW_WIGHT:
			print("👁️ Navigation: Following Wight")
			start_wight_tracking()
		NavigationMode.GUIDED_TOUR:
			print("🎯 Navigation: Guided tour mode")
		NavigationMode.MEMORY_JOURNEY:
			print("🧠 Navigation: Memory journey mode")

func toggle_follow_mode():
	"""Toggle between free explore and follow Wight modes"""
	if current_mode == NavigationMode.FOLLOW_WIGHT:
		set_camera_mode(NavigationMode.FREE_EXPLORE)
	else:
		find_and_follow_wight()

# === WIGHT FINDING AND TRACKING ===

func find_wight() -> bool:
	"""Find Wight in the world and focus camera on him"""
	if not wight_entity:
		# Try to find Wight entity in the scene
		wight_entity = find_wight_in_scene()
	
	if wight_entity:
		var wight_position = get_wight_position()
		if wight_position != Vector3.ZERO:
			focus_on_point(wight_position)
			wight_located.emit(wight_position)
			print("🎯 Found Wight at: %s" % wight_position)
			return true
	
	print("❌ Could not locate Wight")
	return false

func find_and_follow_wight():
	"""Find Wight and start following him"""
	if find_wight():
		set_camera_mode(NavigationMode.FOLLOW_WIGHT)

func find_wight_in_scene() -> Node3D:
	"""Search for Wight entity in the scene tree"""
	# Look for WightEntity node
	var wight_nodes = get_tree().get_nodes_in_group("wight_entity")
	if wight_nodes.size() > 0:
		return wight_nodes[0]
	
	# Alternative search by name
	var root = get_tree().current_scene
	return find_node_by_name(root, "WightEntity")

func find_node_by_name(node: Node, name: String) -> Node:
	"""Recursively search for node by name"""
	if node.name == name:
		return node
	
	for child in node.get_children():
		var result = find_node_by_name(child, name)
		if result:
			return result
	
	return null

func get_wight_position() -> Vector3:
	"""Get Wight's current position in the world"""
	if not wight_entity:
		return Vector3.ZERO
	
	# Try to get avatar position first
	if wight_entity.has_method("get_avatar_position"):
		var avatar_pos = wight_entity.get_avatar_position()
		if avatar_pos != Vector3.ZERO:
			return avatar_pos
	
	# Fall back to entity position
	if wight_entity.has_method("global_position"):
		return wight_entity.global_position
	elif wight_entity.has_method("position"):
		return wight_entity.position
	
	return Vector3.ZERO

func start_wight_tracking():
	"""Begin tracking Wight's movement"""
	wight_tracking_active = true
	wight_last_known_position = get_wight_position()

func update_wight_tracking():
	"""Update camera to follow Wight if in tracking mode"""
	if current_mode != NavigationMode.FOLLOW_WIGHT or not wight_tracking_active:
		return
	
	var current_position = get_wight_position()
	if current_position != Vector3.ZERO:
		# Only update if Wight has moved significantly
		if current_position.distance_to(wight_last_known_position) > 0.5:
			focus_on_point(current_position)
			wight_last_known_position = current_position

func is_wight_object(object: Node3D) -> bool:
	"""Check if an object belongs to Wight"""
	return object.is_in_group("wight_entity") or object.name.contains("Wight") or object.get_parent() == wight_entity

# === TOURS AND EXPLORATION ===

func start_guided_tour():
	"""Start a guided tour of interesting objects"""
	update_tour_waypoints()
	if tour_waypoints.size() > 0:
		current_tour_index = 0
		set_camera_mode(NavigationMode.GUIDED_TOUR)
		visit_next_waypoint()
	else:
		print("📍 No interesting locations found for tour")

func start_memory_journey():
	"""Start a journey through Wight's memory locations"""
	update_memory_locations()
	if memory_locations.size() > 0:
		current_tour_index = 0
		set_camera_mode(NavigationMode.MEMORY_JOURNEY)
		visit_next_memory_location()
	else:
		print("🧠 No memory locations found for journey")

func visit_next_waypoint():
	"""Visit the next waypoint in the tour"""
	if current_tour_index < tour_waypoints.size():
		var waypoint = tour_waypoints[current_tour_index]
		focus_on_point(waypoint)
		current_tour_index += 1
		
		# Auto-advance after a few seconds
		get_tree().create_timer(3.0).timeout.connect(visit_next_waypoint)
	else:
		print("🎯 Tour completed!")
		set_camera_mode(NavigationMode.FREE_EXPLORE)

func visit_next_memory_location():
	"""Visit the next memory location"""
	if current_tour_index < memory_locations.size():
		var location_data = memory_locations[current_tour_index]
		focus_on_point(location_data.position)
		print("🧠 Memory: %s" % location_data.description)
		current_tour_index += 1
		
		# Auto-advance after a few seconds
		get_tree().create_timer(4.0).timeout.connect(visit_next_memory_location)
	else:
		print("🧠 Memory journey completed!")
		set_camera_mode(NavigationMode.FREE_EXPLORE)

func update_tour_waypoints():
	"""Update list of interesting tour waypoints"""
	tour_waypoints.clear()
	
	# Add Wight's position
	var wight_pos = get_wight_position()
	if wight_pos != Vector3.ZERO:
		tour_waypoints.append(wight_pos)
	
	# Add created objects
	var creation_space = get_tree().get_first_node_in_group("creation_space")
	if creation_space:
		for child in creation_space.get_children():
			if child is Node3D:
				tour_waypoints.append(child.global_position)

func update_memory_locations():
	"""Update memory locations from Wight's memories"""
	memory_locations.clear()
	
	if wight_entity and wight_entity.has_method("get_memory_locations"):
		var locations = wight_entity.get_memory_locations()
		memory_locations = locations

# === NAVIGATION STATE ===

func update_navigation(delta):
	"""Update navigation system each frame"""
	# Smooth camera movement
	update_camera_position()
	
	# Update tour progress if active
	if current_mode == NavigationMode.GUIDED_TOUR or current_mode == NavigationMode.MEMORY_JOURNEY:
		# Tour logic is handled by timers
		pass

func update_ui_indicators():
	"""Update navigation UI indicators"""
	# Update distance to Wight
	if wight_entity:
		var distance = camera.global_position.distance_to(get_wight_position())
		if distance_indicator:
			distance_indicator.text = "Distance to Wight: %.1fm" % distance
	
	# Update mode indicator
	if mode_indicator:
		mode_indicator.text = "Mode: %s" % NavigationMode.keys()[current_mode]

# === UTILITY FUNCTIONS ===

func get_object_info(object: Node3D) -> Dictionary:
	"""Get information about an object"""
	var info = {}
	
	# Check if object has metadata
	if object.has_method("get_object_description"):
		info["description"] = object.get_object_description()
	elif object.has_meta("description"):
		info["description"] = object.get_meta("description")
	else:
		info["description"] = "A creation of Wight's imagination"
	
	info["position"] = object.global_position
	info["type"] = object.get_class()
	
	return info

func get_navigation_summary() -> Dictionary:
	"""Get summary of navigation state"""
	return {
		"mode": NavigationMode.keys()[current_mode],
		"camera_position": camera.global_position if camera else Vector3.ZERO,
		"orbit_center": orbit_center,
		"orbit_distance": orbit_distance,
		"wight_tracking": wight_tracking_active,
		"wight_position": get_wight_position(),
		"interesting_objects": interesting_objects.size(),
		"memory_locations": memory_locations.size()
	}