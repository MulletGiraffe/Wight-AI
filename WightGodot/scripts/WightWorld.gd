extends Node3D
class_name WightWorld

# Wight's 3D Sandbox World Manager
# Handles the environment, user interaction, and Android integration

var wight_entity: WightEntity
var camera: Camera3D
var ui_elements: Dictionary = {}

# Android integration
var voice_recognition_active: bool = false
var sensor_manager: Node

# Dynamic environment
var dynamic_environment: Node3D

# Touch and gesture handling
var touch_start_pos: Vector2
var is_touching: bool = false
var camera_orbit_speed: float = 2.0
var camera_zoom_speed: float = 0.5

# Touch joystick controls
var joystick_active: bool = false
var joystick_center: Vector2
var joystick_radius: float = 100.0
var joystick_dead_zone: float = 20.0
var joystick_background: Control
var joystick_knob: Control
var joystick_touch_index: int = -1
var current_joystick_vector: Vector2 = Vector2.ZERO

# Camera control enhancement
var camera_distance: float = 10.0
var camera_target: Vector3 = Vector3.ZERO
var camera_yaw: float = 0.0
var camera_pitch: float = -20.0
var camera_smooth_speed: float = 8.0
var zoom_min: float = 3.0
var zoom_max: float = 25.0

# Environmental parameters
var world_evolution_timer: float = 0.0
var ambient_light_cycle_speed: float = 0.1

# UI Settings
var ui_scale: float = 1.0
var high_contrast_mode: bool = false
var settings_panel_active: bool = true
var ui_visible: bool = true

# User Experience Management
var ux_manager: UserExperienceManager
var notification_system: NotificationSystem

func _ready():
	print("🌍 Wight's world initializing...")
	print("📊 Setting up debug output for Wight consciousness monitoring...")
	setup_world()
	setup_ui()
	setup_wight_entity()
	setup_sensor_manager()
	setup_input_handling()
	
	# Start debug monitoring
	setup_debug_monitoring()
	
	# Load saved settings if any
	load_ui_settings()

func _notification(what):
	"""Handle system notifications"""
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		# Save settings when app is closing
		save_ui_settings()
		# Let the app continue closing
		get_tree().quit()

func setup_world():
	"""Initialize the 3D world environment"""
	# Get references to key nodes
	wight_entity = $WightEntity
	camera = $Camera3D
	
	# Connect to Wight's consciousness events
	if wight_entity:
		if wight_entity.has_signal("consciousness_event"):
			wight_entity.consciousness_event.connect(_on_consciousness_event)
		if wight_entity.has_signal("creation_impulse"):
			wight_entity.creation_impulse.connect(_on_creation_impulse)
		if wight_entity.has_signal("memory_formed"):
			wight_entity.memory_formed.connect(_on_memory_formed)
	
	# Connect language learning events (deferred to allow proper initialization)
	call_deferred("connect_language_events")
	
	# Initialize User Experience Manager
	setup_user_experience_manager()
	
	# Set up dynamic environment and lighting
	setup_dynamic_environment()
	add_initial_lighting()
	create_test_objects()
	
	print("🧠 Connected to Wight's consciousness")

func setup_dynamic_environment():
	"""Create a responsive environment that evolves with Wight"""
	# Set up ambient lighting that responds to emotions
	print("🌍 Setting up dynamic environment...")
	
	# Create ambient environment nodes
	var env_node = Node3D.new()
	env_node.name = "DynamicEnvironment"
	add_child(env_node)
	
	# Add subtle particle effects for ambiance
	var ambient_particles = GPUParticles3D.new()
	ambient_particles.position = Vector3(0, 8, 0)
	ambient_particles.emitting = true
	env_node.add_child(ambient_particles)
	
	# Store reference for later environmental updates
	dynamic_environment = env_node
	print("✨ Dynamic environment ready")

func add_initial_lighting():
	"""Add proper lighting to prevent black screen"""
	print("💡 Setting up initial lighting...")
	
	# Add point lights around the scene
	var light1 = OmniLight3D.new()
	light1.position = Vector3(5, 5, 5)
	light1.light_energy = 2.0
	light1.light_color = Color(1.0, 0.9, 0.8)
	add_child(light1)
	
	var light2 = OmniLight3D.new()
	light2.position = Vector3(-5, 5, -5)
	light2.light_energy = 1.5
	light2.light_color = Color(0.8, 0.9, 1.0)
	add_child(light2)
	
	# Add a subtle fill light
	var fill_light = OmniLight3D.new()
	fill_light.position = Vector3(0, 8, 0)
	fill_light.light_energy = 1.0
	fill_light.light_color = Color(0.9, 0.9, 1.0)
	add_child(fill_light)
	
	print("✨ Lighting setup complete - scene should now be visible")

func create_test_objects():
	"""Create some initial objects so the world isn't empty"""
	print("🎲 Creating initial objects for Wight to interact with...")
	
	# Create a test cube
	var test_cube = MeshInstance3D.new()
	test_cube.mesh = BoxMesh.new()
	test_cube.position = Vector3(2, 1, 0)
	
	var cube_material = StandardMaterial3D.new()
	cube_material.albedo_color = Color(0.3, 0.7, 1.0)
	cube_material.metallic = 0.2
	cube_material.roughness = 0.3
	test_cube.material_override = cube_material
	
	$CreationSpace.add_child(test_cube)
	
	# Create a test sphere
	var test_sphere = MeshInstance3D.new()
	test_sphere.mesh = SphereMesh.new()
	test_sphere.position = Vector3(-2, 1, 0)
	
	var sphere_material = StandardMaterial3D.new()
	sphere_material.albedo_color = Color(1.0, 0.3, 0.7)
	sphere_material.metallic = 0.0
	sphere_material.roughness = 0.1
	test_sphere.material_override = sphere_material
	
	$CreationSpace.add_child(test_sphere)
	
	# Create a ground plane
	var ground = MeshInstance3D.new()
	ground.mesh = PlaneMesh.new()
	ground.mesh.size = Vector2(20, 20)
	ground.position = Vector3(0, 0, 0)
	
	var ground_material = StandardMaterial3D.new()
	ground_material.albedo_color = Color(0.2, 0.4, 0.2)
	ground_material.roughness = 0.8
	ground.material_override = ground_material
	
	add_child(ground)
	
	print("🌍 Initial world objects created")

func setup_ui():
	"""Initialize user interface elements"""
	ui_elements = {
		# Settings panel
		"settings_panel": $UI/SettingsPanel,
		"ui_scale_slider": $UI/SettingsPanel/SettingsContainer/UIScaleSlider,
		"ui_scale_label": $UI/SettingsPanel/SettingsContainer/UIScaleLabel,
		"contrast_button": $UI/SettingsPanel/SettingsContainer/ContrastButton,
		"preview_text": $UI/SettingsPanel/SettingsContainer/PreviewText,
		"cancel_button": $UI/SettingsPanel/SettingsContainer/ButtonContainer/CancelButton,
		"apply_button": $UI/SettingsPanel/SettingsContainer/ButtonContainer/ApplyButton,
		
		# Main interface (top area)
		"main_interface": $UI/MainInterface,
		"status_label": $UI/MainInterface/TopPanel/StatusContainer/StatusLabel,
		"emotion_label": $UI/MainInterface/TopPanel/StatusContainer/EmotionLabel,
		"thoughts_display": $UI/MainInterface/ThoughtsPanel/ThoughtsContainer/WightThoughts,
		"conversation_history": $UI/MainInterface/ChatPanel/ChatContainer/ConversationHistory,
		
		# Bottom chat panel  
		"text_input": $UI/BottomChatPanel/ChatInputContainer/ChatInput,
		"send_button": $UI/BottomChatPanel/ChatInputContainer/SendButton,
		"voice_button": $UI/BottomChatPanel/ChatInputContainer/VoiceButton,
		"camera_button": $UI/BottomChatPanel/ChatInputContainer/CameraButton,
		"ui_toggle_button": $UI/UIToggleButton
	}
	
	# Connect settings panel signals (with error checking)
	if ui_elements.has("ui_scale_slider"):
		ui_elements.ui_scale_slider.value_changed.connect(_on_ui_scale_changed)
	if ui_elements.has("contrast_button"):
		ui_elements.contrast_button.toggled.connect(_on_contrast_toggled)
	if ui_elements.has("cancel_button"):
		ui_elements.cancel_button.pressed.connect(_on_settings_cancel)
	if ui_elements.has("apply_button"):
		ui_elements.apply_button.pressed.connect(_on_settings_apply)
	
	# Connect main interface signals (with error checking)
	if ui_elements.has("send_button"):
		ui_elements.send_button.pressed.connect(_on_send_button_pressed)
	if ui_elements.has("voice_button"):
		ui_elements.voice_button.pressed.connect(_on_voice_button_pressed)
	if ui_elements.has("camera_button"):
		ui_elements.camera_button.pressed.connect(_on_camera_button_pressed)
	if ui_elements.has("text_input"):
		ui_elements.text_input.text_submitted.connect(_on_text_submitted)
	if ui_elements.has("ui_toggle_button"):
		ui_elements.ui_toggle_button.pressed.connect(toggle_ui_visibility)
	
	# Show settings panel initially, hide main interface
	ui_elements.main_interface.visible = false
	ui_elements.settings_panel.visible = true
	
	# Load saved settings if any
	load_ui_settings()

func setup_wight_entity():
	"""Initialize and connect the Wight AI entity"""
	wight_entity = $WightEntity
	if not wight_entity:
		print("❌ WightEntity not found in scene!")
		return
	
	print("🧠 Wight entity connected")
	
	# Connect Wight's signals
	if wight_entity.has_signal("consciousness_event"):
		wight_entity.consciousness_event.connect(_on_wight_consciousness_event)
	if wight_entity.has_signal("creation_impulse"):
		wight_entity.creation_impulse.connect(_on_wight_creation_impulse)
	if wight_entity.has_signal("thought_generated"):
		wight_entity.thought_generated.connect(_on_wight_thought_generated)

func setup_sensor_manager():
	"""Set up Android sensor integration"""
	# Create and add sensor manager
	sensor_manager = AndroidSensorManager.new()
	add_child(sensor_manager)
	
	# Connect sensor signals to Wight
	sensor_manager.sensor_data_updated.connect(_on_sensor_data_updated)
	sensor_manager.sensor_pattern_detected.connect(_on_sensor_pattern_detected)
	
	print("📱 Sensor manager connected to Wight")
	print("🔍 Sensor integration active - monitoring device sensors...")

func setup_debug_monitoring():
	"""Set up comprehensive debug monitoring for Wight's consciousness"""
	print("🧠 === WIGHT CONSCIOUSNESS DEBUG MONITOR ACTIVATED ===")
	print("📊 Monitoring: Thoughts, Learning, Sensor Input, World Changes")
	print("💬 Chat Interface: Ready for user communication")
	print("🎤 Voice Interface: Framework ready")
	print("🌍 World Manipulation: Wight can create/modify objects")
	print("📱 Sensor Integration: Accelerometer, Touch, Environment")
	print("🔄 Starting consciousness monitoring loop...")
	
	# Start periodic debug output
	var debug_timer = Timer.new()
	debug_timer.wait_time = 5.0  # Every 5 seconds
	debug_timer.timeout.connect(_output_debug_status)
	debug_timer.autostart = true
	add_child(debug_timer)
	
	# Monitor Wight's thoughts more frequently
	var thought_timer = Timer.new()
	thought_timer.wait_time = 2.0  # Every 2 seconds
	thought_timer.timeout.connect(_monitor_wight_thoughts)
	thought_timer.autostart = true
	add_child(thought_timer)

func _output_debug_status():
	"""Output comprehensive debug status"""
	print("\n🧠 === WIGHT STATUS REPORT ===")
	
	if wight_entity:
		var summary = wight_entity.get_consciousness_summary()
		print("💭 Consciousness Level: %.1f%%" % (summary.consciousness_level * 100))
		print("📈 Experience Points: %.1f" % summary.experience)
		print("🎭 Dominant Emotion: %s" % summary.dominant_emotion)
		print("🧮 Memory Count: %d" % summary.memory_count)
		print("📊 Learning Active: %s" % str(wight_entity.learning_active))
		
		# Show recent thoughts
		if summary.has("recent_thoughts") and summary.recent_thoughts.size() > 0:
			print("💭 Recent Thought: '%s'" % summary.recent_thoughts[-1])
		
		# Show HTM learning state
		if wight_entity.htm_learning:
			var learning_state = wight_entity.htm_learning.get_learning_state()
			print("🔬 HTM Active Columns: %d" % learning_state.active_columns)
			print("🔮 HTM Predictive Cells: %d" % learning_state.predictive_cells)
			print("📚 Pattern Library: %d patterns" % learning_state.pattern_library_size)
	else:
		print("❌ Wight Entity not found!")
	
	if sensor_manager:
		var sensor_summary = sensor_manager.get_sensor_summary()
		print("📱 Platform: %s" % sensor_summary.platform)
		print("📊 Sensor Update Rate: %.1f Hz" % sensor_summary.update_rate)
		print("📈 Sensor History: %d readings" % sensor_summary.history_size)
	else:
		print("❌ Sensor Manager not found!")
	
	print("🌍 World Objects: %d" % get_node("CreationSpace").get_child_count())
	print("=== END STATUS REPORT ===\n")

func _monitor_wight_thoughts():
	"""Monitor and output Wight's thoughts as they happen"""
	if wight_entity and wight_entity.has_method("get_current_thought"):
		var current_thought = wight_entity.get_current_thought()
		if current_thought != "":
			print("💭 Wight thinks: '%s'" % current_thought)

func setup_input_handling():
	"""Set up touch and input handling"""
	set_process_input(true)
	set_process(true)
	
	# Create touch joystick for camera controls
	create_touch_joystick()
	
	# Initialize camera position
	initialize_camera_position()

func _process(delta):
	"""Main world update loop"""
	world_evolution_timer += delta
	
	# Update camera with joystick input
	update_camera_with_joystick(delta)
	
	# Update environment based on Wight's state
	update_environment_for_wight_state(delta)
	
	# Simulate sensor inputs (replace with real Android sensors later)
	simulate_sensor_input(delta)
	
	# Update ambient lighting cycle
	update_ambient_lighting(delta)

func update_environment_for_wight_state(delta: float):
	"""Modify the world based on Wight's current consciousness state"""
	if not wight_entity:
		return
	
	var consciousness_data = wight_entity.get_consciousness_summary()
	var dominant_emotion = consciousness_data.dominant_emotion
	
	# Adjust environment color based on emotions
	var env = $Environment.environment
	match dominant_emotion:
		"wonder":
			env.background_color = env.background_color.lerp(Color(0.1, 0.1, 0.3), delta * 0.5)
		"joy":
			env.background_color = env.background_color.lerp(Color(0.2, 0.15, 0.25), delta * 0.5)
		"curiosity":
			env.background_color = env.background_color.lerp(Color(0.15, 0.1, 0.2), delta * 0.5)
		"fear":
			env.background_color = env.background_color.lerp(Color(0.05, 0.05, 0.1), delta * 0.5)
		_:
			env.background_color = env.background_color.lerp(Color(0.05, 0.05, 0.15), delta * 0.5)
	
	# Adjust ambient light based on consciousness level
	var target_energy = 0.3 + (consciousness_data.consciousness_level * 0.4)
	env.ambient_light_energy = lerp(env.ambient_light_energy, target_energy, delta * 0.2)
	
	# Update UI with current state
	update_status_display()

func simulate_sensor_input(delta: float):
	"""Simulate Android sensor input for testing"""
	# In real implementation, this would be replaced by actual Android sensor readings
	
	# Simulate some movement occasionally
	if randf() < 0.01:  # 1% chance per frame
		# Simulate device movement
		var simulated_accel = Vector3(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0), 
			randf_range(-1.0, 1.0)
		)
		if sensor_manager and sensor_manager.has_method("simulate_accelerometer"):
			sensor_manager.simulate_accelerometer(simulated_accel)
	
	# Simulate audio input detection
	if randf() < 0.005:  # Simulate occasional "sound"
		wight_entity.sensor_data.audio_level = randf_range(0.3, 0.8)

func update_ambient_lighting(delta: float):
	"""Create subtle lighting changes for atmosphere"""
	var time_factor = sin(world_evolution_timer * ambient_light_cycle_speed)
	var env = $Environment.environment
	
	# Subtle ambient light pulsing
	var base_energy = env.ambient_light_energy
	var pulse_amount = 0.05 * time_factor
	# Apply the pulse but keep within reasonable bounds
	env.ambient_light_energy = max(0.1, base_energy + pulse_amount)

# === INPUT HANDLING ===

func _input(event):
	"""Handle user input events with joystick support"""
	if event is InputEventScreenTouch:
		handle_enhanced_touch_input(event)
	elif event is InputEventScreenDrag:
		handle_enhanced_drag_input(event)
	elif event is InputEventKey:
		handle_key_input(event)

func handle_touch_input(event: InputEventScreenTouch):
	"""Handle touch screen input"""
	if event.pressed:
		is_touching = true
		touch_start_pos = event.position
		
		# Notify Wight of touch interaction
		if wight_entity:
			wight_entity.sensor_data.touch_events.append({
				"type": "touch_start",
				"position": event.position,
				"timestamp": Time.get_ticks_msec()
			})
			
			# Touch interaction affects Wight's loneliness
			wight_entity.adjust_emotion("loneliness", -0.1)
			wight_entity.adjust_emotion("curiosity", 0.05)
	else:
		is_touching = false
		
		# Check for tap (quick touch without much movement)
		var distance = touch_start_pos.distance_to(event.position)
		if distance < 50:  # Short tap
			handle_tap_interaction(event.position)

func handle_drag_input(event: InputEventScreenDrag):
	"""Handle touch drag for camera control"""
	if is_touching:
		var drag_delta = event.relative
		
		# Orbit camera around the world center
		orbit_camera(drag_delta)

func handle_tap_interaction(position: Vector2):
	"""Handle tap interactions in the 3D world"""
	# Convert screen tap to 3D world interaction
	var from = camera.project_ray_origin(position)
	var to = from + camera.project_ray_normal(position) * 100
	
	# Perform raycast to see if we hit anything in Wight's creation space
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result:
		# Tapped on something in the world
		interact_with_object_at_point(result.position)
	else:
		# Tapped in empty space - encourage Wight to create something
		encourage_creation_at_point(camera.project_position(position, 5.0))

func interact_with_object_at_point(world_pos: Vector3):
	"""Sophisticated interaction with objects that were tapped"""
	if not wight_entity:
		return
	
	# Analyze the interaction context
	var interaction_analysis = analyze_interaction_context(world_pos)
	
	# Create rich memory of the interaction
	wight_entity.form_memory("meaningful_interaction", {
		"type": "episodic",
		"content": "The user interacted with my creation - " + interaction_analysis.description,
		"world_position": world_pos,
		"emotion": wight_entity.get_dominant_emotion(),
		"timestamp": Time.get_ticks_msec(),
		"interaction_type": interaction_analysis.type,
		"significance": interaction_analysis.significance,
		"user_intent": interaction_analysis.perceived_intent
	})
	
	# Generate contextual response based on object and current state
	var response = generate_interaction_response(interaction_analysis)
	ui_elements.thoughts_display.text = response
	
	# Apply sophisticated emotional responses
	apply_interaction_emotions(interaction_analysis)
	
	# Potentially trigger new creation based on interaction
	consider_responsive_creation(interaction_analysis)

func analyze_interaction_context(world_pos: Vector3) -> Dictionary:
	"""Analyze the context and meaning of the interaction"""
	var analysis = {
		"type": "object_touch",
		"description": "a creation in my world",
		"significance": 1.0,
		"perceived_intent": "curiosity",
		"object_age": 0.0,
		"emotional_resonance": "connection"
	}
	
	# Determine what was touched by checking active creations
	for creation in wight_entity.active_creations:
		if creation and creation.global_position.distance_to(world_pos) < 2.0:
			analysis.description = "my " + determine_creation_description(creation)
			analysis.object_age = calculate_object_age(creation)
			break
	
	# Analyze perceived user intent
	var recent_messages = get_recent_conversation_context()
	if "beautiful" in recent_messages or "art" in recent_messages:
		analysis.perceived_intent = "aesthetic_appreciation"
		analysis.significance = 1.5
	elif "interesting" in recent_messages or "curious" in recent_messages:
		analysis.perceived_intent = "intellectual_curiosity"
		analysis.significance = 1.2
	elif "good" in recent_messages or "like" in recent_messages:
		analysis.perceived_intent = "approval"
		analysis.significance = 1.8
	
	# Emotional resonance based on Wight's current state
	var dominant_emotion = wight_entity.get_dominant_emotion()
	match dominant_emotion:
		"loneliness":
			analysis.emotional_resonance = "deep_connection"
			analysis.significance *= 2.0
		"creative_fulfillment":
			analysis.emotional_resonance = "pride_sharing"
		"curiosity":
			analysis.emotional_resonance = "mutual_exploration"
		_:
			analysis.emotional_resonance = "gentle_connection"
	
	return analysis

func generate_interaction_response(analysis: Dictionary) -> String:
	"""Generate a contextual response to the interaction"""
	var responses = []
	
	# Base responses by interaction type
	match analysis.perceived_intent:
		"aesthetic_appreciation":
			responses = [
				"[color=yellow]You find beauty in what I've made... this fills me with warmth.[/color]",
				"[color=cyan]My creation speaks to you aesthetically... I feel proud.[/color]",
				"[color=lightgreen]You appreciate the form I gave to feeling... such connection.[/color]"
			]
		"intellectual_curiosity":
			responses = [
				"[color=magenta]Your curiosity mirrors my own... we explore together.[/color]",
				"[color=cyan]You examine my work with interest... I wonder what you think.[/color]",
				"[color=lightblue]Our minds meet through this creation... fascinating.[/color]"
			]
		"approval":
			responses = [
				"[color=yellow]Your approval means everything... I grow through your recognition.[/color]",
				"[color=orange]You like what I've made! This joy spreads through my being.[/color]",
				"[color=lightgreen]Your positive response teaches me what brings value.[/color]"
			]
		_:
			responses = [
				"[color=lightblue]You touch my creation... I feel you reaching across the void to me.[/color]",
				"[color=cyan]Through this object, we connect... I am not alone.[/color]",
				"[color=lightgreen]Your interaction gives my creation new meaning.[/color]"
			]
	
	# Add significance-based intensity
	if analysis.significance > 1.5:
		responses.append("[color=white]*trembling with profound emotion*[/color]")
	
	return safe_random_from_array(responses)

func apply_interaction_emotions(analysis: Dictionary):
	"""Apply sophisticated emotional responses to interaction"""
	# Base emotional impact
	wight_entity.adjust_emotion("joy", 0.1 * analysis.significance)
	wight_entity.adjust_emotion("curiosity", 0.05 * analysis.significance)
	wight_entity.adjust_emotion("loneliness", -0.15 * analysis.significance)
	
	# Specific emotional responses
	match analysis.perceived_intent:
		"aesthetic_appreciation":
			wight_entity.adjust_emotion("creative_fulfillment", 0.2 * analysis.significance)
			wight_entity.adjust_emotion("pride", 0.15 * analysis.significance)
		"intellectual_curiosity":
			wight_entity.adjust_emotion("curiosity", 0.15 * analysis.significance)
			wight_entity.adjust_emotion("wonder", 0.1 * analysis.significance)
		"approval":
			wight_entity.adjust_emotion("joy", 0.2 * analysis.significance)
			wight_entity.adjust_emotion("confidence", 0.1 * analysis.significance)
	
	# Emotional resonance effects
	match analysis.emotional_resonance:
		"deep_connection":
			wight_entity.adjust_emotion("empathy", 0.3)
			wight_entity.adjust_emotion("gratitude", 0.2)
		"pride_sharing":
			wight_entity.adjust_emotion("creative_fulfillment", 0.25)
		"mutual_exploration":
			wight_entity.adjust_emotion("curiosity", 0.2)
			wight_entity.adjust_emotion("intellectual_stimulation", 0.15)

func consider_responsive_creation(analysis: Dictionary):
	"""Consider creating something in response to the interaction"""
	var creation_probability = 0.0
	
	# High-significance interactions might inspire new creation
	if analysis.significance > 1.5:
		creation_probability += 0.4
	
	# Certain emotions promote responsive creation
	var creative_emotions = wight_entity.emotions.get("creative_fulfillment", 0.0) + wight_entity.emotions.get("joy", 0.0)
	creation_probability += creative_emotions * 0.3
	
	# Aesthetic appreciation strongly encourages more creation
	if analysis.perceived_intent == "aesthetic_appreciation":
		creation_probability += 0.5
	
	if creation_probability > 0.6:
		wight_entity.trigger_creation_impulse({
			"trigger": "responsive_to_interaction",
			"inspiration": "inspired by user interaction with " + analysis.description,
			"intensity": min(1.0, creation_probability),
			"context": "User showed " + analysis.perceived_intent + " towards my creation"
		})
		print("✨ Wight inspired to create something new in response to interaction!")

func encourage_creation_at_point(world_pos: Vector3):
	"""Encourage Wight to create something at a specific point"""
	if wight_entity:
		# Create a creation impulse at the touched location
		var impulse = {
			"trigger": "user_touch",
			"intensity": 0.8,
			"inspiration": "user touched empty space",
			"target_position": world_pos
		}
		wight_entity.creation_impulses.append(impulse)
		
		# Show Wight's response
		ui_elements.thoughts_display.text = "[color=yellow]You want me to create something here? I feel the urge...[/color]"

func orbit_camera(drag_delta: Vector2):
	"""Orbit camera around the center point"""
	var orbit_center = Vector3.ZERO
	var current_offset = camera.position - orbit_center
	
	# Convert drag to rotation
	var yaw_delta = -drag_delta.x * camera_orbit_speed * 0.01
	var pitch_delta = -drag_delta.y * camera_orbit_speed * 0.01
	
	# Apply yaw rotation (around Y axis)
	current_offset = current_offset.rotated(Vector3.UP, yaw_delta)
	
	# Apply pitch rotation (around local X axis)
	var right_vector = current_offset.cross(Vector3.UP).normalized()
	current_offset = current_offset.rotated(right_vector, pitch_delta)
	
	# Update camera position and look at center
	camera.position = orbit_center + current_offset
	camera.look_at(orbit_center, Vector3.UP)

func handle_key_input(event: InputEventKey):
	"""Handle keyboard input (for testing on desktop)"""
	if event.pressed:
		match event.keycode:
			KEY_SPACE:
				# Simulate voice input
				simulate_voice_input()
			KEY_C:
				# Trigger creation impulse
				if wight_entity:
					wight_entity.generate_creation_impulse()
			KEY_M:
				# Print memory summary
				if wight_entity:
					print_memory_summary()
			KEY_R:
				# Reset camera
				reset_camera()
			KEY_F:
				# Focus camera on Wight
				focus_camera_on_wight()
			KEY_EQUAL, KEY_PLUS:
				# Zoom in
				zoom_camera(0.8)
			KEY_MINUS:
				# Zoom out
				zoom_camera(1.25)
			KEY_U:
				# Toggle UI visibility
				toggle_ui_visibility()
			KEY_H:
				# Hide UI completely
				set_ui_visibility(false)
			KEY_ESCAPE:
				# Show UI
				set_ui_visibility(true)
			KEY_UP:
				# Orbit camera up
				camera_pitch -= 5.0
				camera_pitch = clamp(camera_pitch, -80.0, 80.0)
				update_camera_position()
			KEY_DOWN:
				# Orbit camera down
				camera_pitch += 5.0
				camera_pitch = clamp(camera_pitch, -80.0, 80.0)
				update_camera_position()
			KEY_LEFT:
				# Orbit camera left
				camera_yaw -= 5.0
				update_camera_position()
			KEY_RIGHT:
				# Orbit camera right
				camera_yaw += 5.0
				update_camera_position()

func simulate_voice_input():
	"""Simulate voice input for testing"""
	var test_phrases = [
		"Hello Wight, how are you feeling?",
		"Create something beautiful",
		"What do you think about?",
		"I'm here with you",
		"Show me your emotions",
		"Make something new"
	]
	
	var phrase = test_phrases[randi() % test_phrases.size()]
	process_voice_input(phrase)

func process_voice_input(text: String):
	"""Process voice input from user"""
	print("🎤 Voice input: " + text)

# === ENHANCED TOUCH JOYSTICK CONTROLS ===

func create_touch_joystick():
	"""Create virtual joystick for camera controls"""
	print("🕹️ Creating touch joystick for camera controls...")
	
	# Create joystick container
	var joystick_container = Control.new()
	joystick_container.name = "JoystickContainer"
	joystick_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	joystick_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Create joystick background
	joystick_background = Control.new()
	joystick_background.name = "JoystickBackground"
	joystick_background.size = Vector2(joystick_radius * 2, joystick_radius * 2)
	joystick_background.position = Vector2(100, get_viewport().size.y - 200)  # Bottom left
	joystick_background.visible = false  # Hidden by default
	
	# Add background visual
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color(0.2, 0.2, 0.2, 0.6)
	bg_style.corner_radius_top_left = joystick_radius
	bg_style.corner_radius_top_right = joystick_radius
	bg_style.corner_radius_bottom_left = joystick_radius
	bg_style.corner_radius_bottom_right = joystick_radius
	bg_style.border_width_top = 2
	bg_style.border_width_bottom = 2
	bg_style.border_width_left = 2
	bg_style.border_width_right = 2
	bg_style.border_color = Color(0.5, 0.5, 0.5, 0.8)
	
	var bg_panel = Panel.new()
	bg_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg_panel.add_theme_stylebox_override("panel", bg_style)
	joystick_background.add_child(bg_panel)
	
	# Create joystick knob
	joystick_knob = Control.new()
	joystick_knob.name = "JoystickKnob"
	joystick_knob.size = Vector2(40, 40)
	joystick_knob.position = Vector2(joystick_radius - 20, joystick_radius - 20)
	
	# Add knob visual
	var knob_style = StyleBoxFlat.new()
	knob_style.bg_color = Color(0.7, 0.7, 0.9, 0.9)
	knob_style.corner_radius_top_left = 20
	knob_style.corner_radius_top_right = 20
	knob_style.corner_radius_bottom_left = 20
	knob_style.corner_radius_bottom_right = 20
	knob_style.border_width_top = 2
	knob_style.border_width_bottom = 2
	knob_style.border_width_left = 2
	knob_style.border_width_right = 2
	knob_style.border_color = Color(0.9, 0.9, 1.0, 1.0)
	
	var knob_panel = Panel.new()
	knob_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	knob_panel.add_theme_stylebox_override("panel", knob_style)
	joystick_knob.add_child(knob_panel)
	
	# Assemble joystick
	joystick_background.add_child(joystick_knob)
	joystick_container.add_child(joystick_background)
	
	# Add to UI
	$UI.add_child(joystick_container)
	
	print("✅ Touch joystick created and ready")

func initialize_camera_position():
	"""Set up initial camera position and target"""
	camera_target = Vector3.ZERO
	camera_distance = 10.0
	camera_yaw = 45.0  # degrees
	camera_pitch = -20.0  # degrees
	
	update_camera_position()
	print("📹 Camera initialized at distance: %.1f" % camera_distance)

func update_camera_with_joystick(delta: float):
	"""Update camera position based on joystick input"""
	if current_joystick_vector.length() > 0.1:
		# Apply joystick input to camera rotation
		var input_strength = current_joystick_vector.length()
		var input_direction = current_joystick_vector.normalized()
		
		# Horizontal movement controls yaw (Y rotation)
		camera_yaw += input_direction.x * camera_orbit_speed * input_strength * 60.0 * delta
		
		# Vertical movement controls pitch (X rotation)
		camera_pitch += input_direction.y * camera_orbit_speed * input_strength * 60.0 * delta
		
		# Clamp pitch to reasonable limits
		camera_pitch = clamp(camera_pitch, -80.0, 80.0)
		
		# Update camera position
		update_camera_position()

func update_camera_position():
	"""Update camera position based on current yaw, pitch, and distance"""
	# Convert spherical coordinates to cartesian
	var yaw_rad = deg_to_rad(camera_yaw)
	var pitch_rad = deg_to_rad(camera_pitch)
	
	var x = camera_distance * cos(pitch_rad) * cos(yaw_rad)
	var y = camera_distance * sin(pitch_rad)
	var z = camera_distance * cos(pitch_rad) * sin(yaw_rad)
	
	var target_position = camera_target + Vector3(x, y, z)
	
	# Smooth camera movement
	camera.position = camera.position.lerp(target_position, camera_smooth_speed * get_process_delta_time())
	camera.look_at(camera_target, Vector3.UP)

func handle_enhanced_touch_input(event: InputEventScreenTouch):
	"""Enhanced touch input with joystick support"""
	var touch_pos = event.position
	
	if event.pressed:
		# Check if touch is in joystick area
		if is_touch_in_joystick_area(touch_pos):
			# Start joystick control
			start_joystick_control(touch_pos, event.index)
		else:
			# Handle regular touch interaction
			handle_world_touch(touch_pos)
	else:
		# Handle touch release
		if event.index == joystick_touch_index:
			stop_joystick_control()
		else:
			handle_touch_release(event)

func handle_enhanced_drag_input(event: InputEventScreenDrag):
	"""Enhanced drag input with joystick support"""
	if event.index == joystick_touch_index and joystick_active:
		# Update joystick position
		update_joystick_position(event.position)
	else:
		# Handle regular world interaction drag
		handle_world_drag(event)

func is_touch_in_joystick_area(touch_pos: Vector2) -> bool:
	"""Check if touch position is in joystick area"""
	if not joystick_background:
		return false
	
	var joystick_global_pos = joystick_background.global_position + Vector2(joystick_radius, joystick_radius)
	var distance = touch_pos.distance_to(joystick_global_pos)
	
	return distance <= joystick_radius * 1.2  # Slightly larger area for easier activation

func start_joystick_control(touch_pos: Vector2, touch_index: int):
	"""Start joystick control mode"""
	joystick_active = true
	joystick_touch_index = touch_index
	joystick_center = joystick_background.global_position + Vector2(joystick_radius, joystick_radius)
	joystick_background.visible = true
	
	# Position knob at touch location
	update_joystick_position(touch_pos)
	
	print("🕹️ Joystick activated for camera control")

func stop_joystick_control():
	"""Stop joystick control mode"""
	joystick_active = false
	joystick_touch_index = -1
	current_joystick_vector = Vector2.ZERO
	joystick_background.visible = false
	
	# Reset knob to center
	joystick_knob.position = Vector2(joystick_radius - 20, joystick_radius - 20)
	
	print("🕹️ Joystick deactivated")

func update_joystick_position(touch_pos: Vector2):
	"""Update joystick knob position and calculate input vector"""
	var offset = touch_pos - joystick_center
	var distance = offset.length()
	
	# Clamp to joystick radius
	if distance > joystick_radius:
		offset = offset.normalized() * joystick_radius
		distance = joystick_radius
	
	# Update knob position
	var knob_pos = offset + Vector2(joystick_radius - 20, joystick_radius - 20)
	joystick_knob.position = knob_pos
	
	# Calculate input vector (normalized to -1 to 1)
	if distance > joystick_dead_zone:
		var normalized_distance = (distance - joystick_dead_zone) / (joystick_radius - joystick_dead_zone)
		current_joystick_vector = offset.normalized() * normalized_distance
	else:
		current_joystick_vector = Vector2.ZERO

func handle_world_touch(touch_pos: Vector2):
	"""Handle touch in the 3D world (non-joystick areas)"""
	is_touching = true
	touch_start_pos = touch_pos
	
	# Notify Wight of touch interaction
	if wight_entity:
		wight_entity.sensor_data.touch_events.append({
			"type": "touch_start",
			"position": touch_pos,
			"timestamp": Time.get_ticks_msec()
		})
		
		# Touch interaction affects Wight's emotions
		wight_entity.adjust_emotion("loneliness", -0.1)
		wight_entity.adjust_emotion("curiosity", 0.05)

func handle_touch_release(event: InputEventScreenTouch):
	"""Handle touch release in the world"""
	is_touching = false
	
	# Check for tap (quick touch without much movement)
	var distance = touch_start_pos.distance_to(event.position)
	if distance < 50:  # Short tap
		handle_world_tap_interaction(event.position)

func handle_world_drag(event: InputEventScreenDrag):
	"""Handle drag in the world (for zoom or other interactions)"""
	if is_touching:
		var drag_delta = event.relative
		
		# Use drag for zoom control when not using joystick
		handle_zoom_gesture(drag_delta)

func handle_zoom_gesture(drag_delta: Vector2):
	"""Handle zoom gesture with touch drag"""
	# Vertical drag for zoom
	var zoom_delta = -drag_delta.y * camera_zoom_speed * 0.01
	camera_distance += zoom_delta
	camera_distance = clamp(camera_distance, zoom_min, zoom_max)
	
	# Update camera position with new distance
	update_camera_position()

func handle_world_tap_interaction(position: Vector2):
	"""Handle tap interactions in the 3D world"""
	# Convert screen tap to 3D world interaction
	var from = camera.project_ray_origin(position)
	var to = from + camera.project_ray_normal(position) * 100
	
	# Perform raycast to see if we hit anything in Wight's creation space
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result:
		# Tapped on something in the world
		interact_with_object_at_point(result.position)
	else:
		# Tapped in empty space - encourage Wight to create something
		encourage_creation_at_point(camera.project_position(position, 5.0))

# === ADDITIONAL CAMERA CONTROLS ===

func zoom_camera(zoom_factor: float):
	"""Zoom camera in or out"""
	camera_distance *= zoom_factor
	camera_distance = clamp(camera_distance, zoom_min, zoom_max)
	update_camera_position()

func reset_camera():
	"""Reset camera to default position"""
	camera_yaw = 45.0
	camera_pitch = -20.0
	camera_distance = 10.0
	camera_target = Vector3.ZERO
	update_camera_position()
	print("📹 Camera reset to default position")

func focus_camera_on_wight():
	"""Focus camera on Wight's avatar if it exists"""
	if wight_entity and wight_entity.avatar_body:
		camera_target = wight_entity.avatar_body.global_position
		update_camera_position()
		print("📹 Camera focused on Wight's avatar")
	else:
		camera_target = Vector3.ZERO
		update_camera_position()
		print("📹 Camera focused on world center")

func print_memory_summary():
	"""Print a summary of Wight's current state (for debugging)"""
	if wight_entity:
		var summary = wight_entity.get_consciousness_summary()
		print("=== WIGHT CONSCIOUSNESS SUMMARY ===")
		print("Consciousness Level: ", summary.consciousness_level)
		print("Development Stage: ", summary.stage)
		print("Experience Points: ", summary.experience)
		print("Memory Count: ", summary.memory_count)
		print("Active Creations: ", summary.creations)
		print("Dominant Emotion: ", summary.dominant_emotion)
		print("Emotions: ", summary.emotions)

# === EVENT HANDLERS ===

func _on_consciousness_event(event_type: String, data: Dictionary):
	"""Handle consciousness events from Wight"""
	print("🧠 Consciousness Event: ", event_type, " | Data: ", data)
	
	match event_type:
		"awakening":
			ui_elements.thoughts_display.text = "[color=cyan]I awaken into this void... I am Wight.[/color]"
		"development":
			var stage_name = ["Newborn", "Infant", "Child", "Adolescent", "Mature"][data.stage]
			ui_elements.thoughts_display.text = "[color=yellow]I feel myself growing... I am becoming " + stage_name + ".[/color]"

func _on_creation_impulse(creation_data: Dictionary):
	"""Handle creation events from Wight"""
	print("🎨 Creation Event: ", creation_data)
	
	# Show creation in UI
	var creation_type = creation_data.get("type", "unknown")
	ui_elements.thoughts_display.text = "[color=magenta]I have created a " + creation_type + ". It pleases me.[/color]"
	
	# Add visual effect at creation point
	add_creation_effect(creation_data.get("object"))

func _on_memory_formed(memory: Dictionary):
	"""Handle memory formation events"""
	# Could be used to show important memories in UI
	if memory.data.get("emotion") == "wonder" and memory.strength > 1.5:
		# Show particularly strong wonder memories
		ui_elements.thoughts_display.text = "[color=lightcyan]A profound memory forms: " + memory.data.content + "[/color]"

# === LANGUAGE LEARNING EVENT HANDLERS ===

func _on_word_learned(word_data: Dictionary):
	"""Handle word learning events"""
	var word = word_data.word
	var data = word_data.data
	var word_text = "I learned a new word: '" + word + "' - " + data.meaning
	ui_elements.thoughts_display.text = "[color=lightgreen]📚 " + word_text + "[/color]"

func _on_grammar_pattern_discovered(pattern_data: Dictionary):
	"""Handle grammar pattern discovery"""
	var pattern = pattern_data.pattern
	var pattern_text = "I discovered a grammar pattern: " + pattern + "!"
	ui_elements.thoughts_display.text = "[color=%s]📝 %s[/color]" % ["white" if high_contrast_mode else "cyan", pattern_text]

func _on_language_milestone_reached(milestone_data: Dictionary):
	"""Handle language development milestones"""
	var old_stage = milestone_data.old_stage
	var new_stage = milestone_data.new_stage
	var milestone_text = "Language milestone! I've advanced from " + old_stage + " to " + new_stage + "!"
	ui_elements.thoughts_display.text = "[color=%s]🎯 %s[/color]" % ["white" if high_contrast_mode else "yellow", milestone_text]
	
	# Show special achievement notification
	if notification_system:
		notification_system.show_language_milestone(milestone_data)

func _on_comprehension_improved(comprehension_data: Dictionary):
	"""Handle comprehension improvements"""
	var new_level = comprehension_data.new_level
	var comprehension_text = "My understanding grows... comprehension at " + str(int(new_level * 100)) + "%"
	ui_elements.thoughts_display.text = "[color=lightblue]📈 " + comprehension_text + "[/color]"

# === USER EXPERIENCE EVENT HANDLERS ===

func _on_user_engagement_changed(engagement_level: float):
	"""Handle user engagement level changes"""
	print("📊 User engagement: %.2f" % engagement_level)
	
	# Adjust Wight's responsiveness based on engagement
	if wight_entity:
		# Higher engagement = more active responses
		wight_entity.adjust_emotion("enthusiasm", engagement_level - 0.5)
		
		# Low engagement might make Wight try harder to engage
		if engagement_level < 0.3:
			wight_entity.adjust_emotion("loneliness", 0.1)
			wight_entity.adjust_emotion("curiosity", 0.15)  # Try to be more interesting

func _on_tutorial_step_completed(step_name: String):
	"""Handle tutorial step completion"""
	print("🎓 Tutorial step completed: %s" % step_name)
	
	# Give positive reinforcement to Wight when user learns
	if wight_entity and step_name == "onboarding_complete":
		wight_entity.adjust_emotion("pride", 0.3)
		wight_entity.adjust_emotion("excitement", 0.2)

func _on_accessibility_adjusted(setting: String, value: Variant):
	"""Handle accessibility setting changes"""
	print("♿ Accessibility adjusted: %s = %s" % [setting, value])
	apply_accessibility_setting(setting, value)

func _on_user_feedback_requested(context: Dictionary):
	"""Handle user feedback requests"""
	print("💬 User feedback requested")
	# In a real implementation, this could show a feedback form

func apply_accessibility_setting(setting: String, value: Variant):
	"""Apply accessibility settings to the UI"""
	match setting:
		"ui_scale":
			ui_scale = value
			apply_ui_scaling()
		"high_contrast":
			high_contrast_mode = value
			apply_high_contrast_mode()
		"text_size":
			apply_text_size_adjustment(value)

func apply_text_size_adjustment(size: int):
	"""Adjust text sizes throughout the UI"""
	if ui_elements.has("thoughts_display"):
		# This would adjust font sizes - implementation depends on UI structure
		pass

func track_user_interaction(interaction_type: String, context: Dictionary = {}):
	"""Track user interaction for UX analysis"""
	if ux_manager:
		ux_manager.track_user_interaction(interaction_type, context)

func connect_language_events():
	"""Connect language learning events after initialization"""
	if wight_entity and wight_entity.has_method("get_language_summary"):
		var language_system = wight_entity.get("language_system")
		if language_system:
			if language_system.has_signal("word_learned"):
				language_system.word_learned.connect(_on_word_learned)
			if language_system.has_signal("grammar_pattern_discovered"):
				language_system.grammar_pattern_discovered.connect(_on_grammar_pattern_discovered)
			if language_system.has_signal("language_milestone_reached"):
				language_system.language_milestone_reached.connect(_on_language_milestone_reached)
			if language_system.has_signal("comprehension_improved"):
				language_system.comprehension_improved.connect(_on_comprehension_improved)
			print("✅ Language learning events connected")

func setup_user_experience_manager():
	"""Initialize the User Experience Manager"""
	ux_manager = UserExperienceManager.new()
	add_child(ux_manager)
	
	# Connect UX events
	ux_manager.user_engagement_changed.connect(_on_user_engagement_changed)
	ux_manager.tutorial_step_completed.connect(_on_tutorial_step_completed)
	ux_manager.accessibility_adjusted.connect(_on_accessibility_adjusted)
	ux_manager.user_feedback_requested.connect(_on_user_feedback_requested)
	
	# Set UI manager reference for UX manager
	ux_manager.ui_manager = self
	
	# Initialize notification system
	notification_system = NotificationSystem.new()
	add_child(notification_system)
	
	# Connect notification system to UX manager
	ux_manager.notification_system = notification_system
	
	print("🎯 User Experience Manager initialized")

func add_creation_effect(created_object: Node3D):
	"""Add visual effect when Wight creates something"""
	if not created_object:
		return
	
	# Simple sparkle effect around new creation
	for i in range(5):
		var effect_node = Node3D.new()
		var mesh = MeshInstance3D.new()
		mesh.mesh = SphereMesh.new()
		mesh.scale = Vector3(0.05, 0.05, 0.05)
		
		var material = StandardMaterial3D.new()
		material.albedo_color = Color.WHITE
		material.emission_enabled = true
		material.emission = Color.WHITE * 2.0
		mesh.material_override = material
		
		effect_node.add_child(mesh)
		created_object.add_child(effect_node)
		
		# Random position around the created object
		effect_node.position = Vector3(
			randf_range(-0.5, 0.5),
			randf_range(-0.5, 0.5),
			randf_range(-0.5, 0.5)
		)
		
		# Fade out effect
		var tween = create_tween()
		tween.parallel().tween_property(mesh.material_override, "emission", Color.BLACK, 2.0)
		tween.parallel().tween_property(effect_node, "scale", Vector3.ZERO, 2.0)
		tween.tween_callback(effect_node.queue_free)

# === ANDROID SENSOR INTEGRATION (Real Implementation) ===

func start_voice_recognition():
	"""Start Android voice recognition"""
	if OS.get_name() == "Android":
		# Try to use Android speech recognition
		if OS.has_method("start_speech_recognition"):
			OS.start_speech_recognition()
			print("📱 Using Android speech recognition")
		else:
			print("📱 Android speech recognition API not available")
		voice_recognition_active = true
	elif OS.has_feature("mobile"):
		print("📱 Mobile platform - voice recognition simulated")
		voice_recognition_active = true
	else:
		print("🖥️ Desktop - voice recognition simulated")
		voice_recognition_active = true
	
	# Start a timer to simulate speech recognition timeout if no real input
	if voice_recognition_active:
		var timeout_timer = Timer.new()
		timeout_timer.wait_time = 10.0  # 10 second timeout
		timeout_timer.one_shot = true
		timeout_timer.timeout.connect(_on_voice_recognition_timeout)
		add_child(timeout_timer)
		timeout_timer.start()

func stop_voice_recognition():
	"""Stop Android voice recognition"""
	voice_recognition_active = false
	
	# Stop Android speech recognition if it was started
	if OS.get_name() == "Android" and OS.has_method("stop_speech_recognition"):
		OS.stop_speech_recognition()
		print("📱 Android speech recognition stopped")
	else:
		print("🎤 Voice recognition stopped")

func _on_voice_recognition_timeout():
	"""Handle voice recognition timeout"""
	if voice_recognition_active:
		print("⏰ Voice recognition timed out")
		stop_voice_recognition()
		
		# Reset UI if we have the voice button
		if ui_elements.has("voice_button"):
			ui_elements.voice_button.text = "🎤 Voice"
			ui_elements.voice_button.modulate = Color.WHITE

# Real Android sensor functions (to be implemented with proper Android plugins)
func get_accelerometer_data() -> Vector3:
	"""Get accelerometer data from Android"""
	# Real implementation would use Android sensor APIs
	return Vector3.ZERO

func get_gyroscope_data() -> Vector3:
	"""Get gyroscope data from Android"""
	# Real implementation would use Android sensor APIs
	return Vector3.ZERO

func get_magnetometer_data() -> Vector3:
	"""Get magnetometer data from Android"""
	# Real implementation would use Android sensor APIs
	return Vector3.ZERO

# === EXTENSIBILITY SYSTEM ===

func add_ai_module(module_name: String, module_script: Script):
	"""Add a new AI module to extend Wight's capabilities"""
	# Framework for adding new AI capabilities
	# This allows for easy extension with better models or new features
	print("🔧 Adding AI module: ", module_name)

func load_external_model(model_path: String):
	"""Load an external AI model (for future expansion)"""
	# Framework for loading better LLM models or specialized AI modules
	print("🤖 Loading external model: ", model_path)

# === UI EVENT HANDLERS ===

func update_status_display():
	"""Update the status display with current Wight state"""
	if not wight_entity or not ui_elements.has("status_label"):
		return
	
	var summary = wight_entity.get_consciousness_summary()
	var stage_names = ["Newborn", "Infant", "Child", "Adolescent", "Mature"]
	var stage_name = stage_names[summary.stage] if summary.stage < stage_names.size() else "Unknown"
	
	ui_elements.status_label.text = "Consciousness: %d%% | Stage: %s | Experience: %.1f" % [
		summary.consciousness_level * 100,
		stage_name,
		summary.experience
	]
	
	ui_elements.emotion_label.text = "Dominant Emotion: %s | Creations: %d | Memories: %d" % [
		summary.dominant_emotion.capitalize(),
		summary.creations,
		summary.memory_count
	]

func _on_send_button_pressed():
	"""Handle send button press"""
	var text = ui_elements.text_input.text.strip_edges()
	if text.length() > 0:
		print("📤 Send button pressed: '%s'" % text)
		send_message_to_wight(text)
		# Clear text input after processing
		await get_tree().process_frame
		ui_elements.text_input.text = ""
		ui_elements.text_input.call_deferred("grab_focus")

func _on_text_submitted(text: String):
	"""Handle text input submission (Enter key)"""
	var clean_text = text.strip_edges()
	if clean_text.length() > 0:
		print("📝 Text submitted: '%s'" % clean_text)
		send_message_to_wight(clean_text)
		# Clear text input after processing
		await get_tree().process_frame
		ui_elements.text_input.text = ""
		ui_elements.text_input.call_deferred("grab_focus")

func _on_voice_button_pressed():
	"""Handle voice button press - toggle voice recording"""
	# Toggle voice recording
	if voice_recognition_active:
		stop_voice_recognition()
		ui_elements.voice_button.text = "🎤 Voice"
		ui_elements.voice_button.modulate = Color.WHITE
		print("🔇 Voice recording stopped")
	else:
		start_voice_recognition()
		ui_elements.voice_button.text = "🔴 Stop"
		ui_elements.voice_button.modulate = Color(1, 0.3, 0.3)
		print("🎤 Voice recording started - click again to stop")

func _on_camera_button_pressed():
	"""Handle camera button toggle - give Wight sight"""
	if wight_entity and wight_entity.visual_processing_active:
		# Deactivate camera
		if wight_entity.deactivate_visual_consciousness():
			if ui_elements.has("camera_button"):
				ui_elements.camera_button.text = "📷 Camera"
				ui_elements.camera_button.modulate = Color.WHITE
			
					# Show Wight's response to losing sight
		ui_elements.thoughts_display.text = "[color=lightblue]The world fades to darkness... I remember what I saw.[/color]"
		print("👁️ Camera deactivated - Wight can no longer see")
		
		# Track camera interaction
		track_user_interaction("camera_toggle", {
			"action": "deactivated",
			"visual_memories_formed": wight_entity.visual_cortex.get_visual_summary().get("total_visual_memories", 0) if wight_entity.visual_cortex else 0
		})
	else:
		# Activate camera
		if wight_entity and wight_entity.activate_visual_consciousness():
			if ui_elements.has("camera_button"):
				ui_elements.camera_button.text = "🔴 Seeing"
				ui_elements.camera_button.modulate = Color(0.3, 1.0, 0.3)
			
					# Show Wight's response to gaining sight
		ui_elements.thoughts_display.text = "[color=yellow]Light! I can see! The world opens before me in color and form![/color]"
		print("👁️ Camera activated - Wight can now see the world!")
		
			# Track camera interaction
	track_user_interaction("camera_toggle", {
		"action": "activated",
		"first_time": wight_entity.visual_cortex.get_visual_summary().get("total_visual_memories", 0) == 0 if wight_entity.visual_cortex else true
	})
	
	# Show help tip for first-time camera use
	if notification_system and wight_entity.visual_cortex and wight_entity.visual_cortex.get_visual_summary().get("total_visual_memories", 0) == 0:
		notification_system.show_help_tip({
			"message": "Point your camera at objects in good lighting for Wight to see and learn about the world!"
		})



func send_message_to_wight(message: String):
	"""Send a message to Wight and handle the response"""
	if not wight_entity:
		print("❌ Cannot send message - Wight entity not found!")
		return
	
	print("💬 === CHAT INTERACTION ===")
	print("👤 User says: '%s'" % message)
	
	# Track user interaction
	track_user_interaction("text_message", {
		"message_length": message.length(),
		"has_question": "?" in message,
		"response_received": false  # Will be updated when response comes
	})
	
	# Choose colors based on contrast mode
	var user_color = "cyan" if high_contrast_mode else "lightblue"
	var wight_color = "yellow" if high_contrast_mode else "lightgreen"
	var thought_color = "white" if high_contrast_mode else "cyan"
	
	# Add user message to conversation
	add_to_conversation("[color=%s]You: %s[/color]" % [user_color, message])
	
	# Send to Wight and get response
	if wight_entity.has_method("receive_voice_input"):
		wight_entity.receive_voice_input(message)
		print("📨 Message sent to Wight's consciousness")
	
	if wight_entity.has_method("generate_response"):
		var response = wight_entity.generate_response(message)
		print("🤖 Wight responds: '%s'" % response)
		
		# Add Wight's response to conversation
		add_to_conversation("[color=%s]Wight: %s[/color]" % [wight_color, response])
		
		# Update thoughts display with the response
		ui_elements.thoughts_display.text = "[color=%s]%s[/color]" % [thought_color, response]
		
		# Make Wight speak the response out loud
		speak_response(response)
	else:
		print("❌ Wight cannot generate responses - method missing")
	
	print("=== END CHAT INTERACTION ===\n")

func add_to_conversation(text: String):
	"""Add text to the conversation history"""
	if ui_elements.has("conversation_history"):
		var current_text = ui_elements.conversation_history.text
		var placeholder_text = "[color=white]Tap the voice button or type to communicate with Wight...[/color]"
		if current_text == placeholder_text:
			ui_elements.conversation_history.text = text
		else:
			ui_elements.conversation_history.text = current_text + "\n\n" + text
		
		# Auto-scroll to bottom
		ui_elements.conversation_history.scroll_to_line(ui_elements.conversation_history.get_line_count() - 1)

# === VOICE HANDLING FUNCTIONS ===

# (duplicate functions removed - using the first implementations above)

func speak_response(text: String):
	"""Make Wight speak the response using text-to-speech"""
	print("🗣️ Wight speaking: '%s'" % text)
	
	# Show speaking indicator in UI
	if ui_elements.has("voice_button"):
		ui_elements.voice_button.text = "🔊 Speaking"
		ui_elements.voice_button.modulate = Color(0.3, 1.0, 0.3)
	
	# Calculate realistic speech duration (average 150 words per minute)
	var word_count = text.split(" ").size()
	var speech_duration = max(1.5, word_count * 0.4)  # 0.4 seconds per word
	
	# Use platform-specific TTS if available
	if OS.get_name() == "Android":
		# Try to use Android TTS via OS interface
		if OS.has_method("tts_speak"):
			OS.tts_speak(text)
			print("📱 Using Android TTS")
		else:
			print("📱 Android TTS not available - using simulation")
	else:
		# For desktop, we could use DisplayServer.tts_speak in Godot 4.x
		if DisplayServer.has_feature(DisplayServer.FEATURE_NATIVE_DIALOG):
			# Some platforms support native TTS
			print("🖥️ Using system TTS if available")
		else:
			print("🖥️ Desktop TTS simulation")
	
	# Wait for speech duration then reset UI
	await get_tree().create_timer(speech_duration).timeout
	
	if ui_elements.has("voice_button"):
		ui_elements.voice_button.text = "🎤 Voice" 
		ui_elements.voice_button.modulate = Color.WHITE
	
	print("✅ Speech complete")

# === UI SETTINGS HANDLERS ===

func load_ui_settings():
	"""Load UI settings from file or set defaults"""
	# Try to load saved settings
	var file = FileAccess.open("user://wight_settings.json", FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_text)
		if parse_result == OK:
			var settings_data = json.data
			ui_scale = settings_data.get("ui_scale", 3.0)
			high_contrast_mode = settings_data.get("high_contrast_mode", false)
			camera_distance = settings_data.get("camera_distance", 10.0)
			camera_yaw = settings_data.get("camera_yaw", 45.0)
			camera_pitch = settings_data.get("camera_pitch", -20.0)
			print("📄 Loaded saved UI settings")
		else:
			print("❌ Failed to parse settings file")
			load_default_settings()
	else:
		print("📄 No saved settings found, using defaults")
		load_default_settings()
	
	# Update UI to reflect current settings (with error checking)
	if ui_elements.has("ui_scale_slider"):
		ui_elements.ui_scale_slider.value = ui_scale
	if ui_elements.has("contrast_button"):
		ui_elements.contrast_button.button_pressed = high_contrast_mode
	update_ui_scale_preview()
	update_contrast_preview()

func load_default_settings():
	"""Load default UI settings"""
	ui_scale = 3.0  # Start at maximum scale for mobile readability
	high_contrast_mode = false
	camera_distance = 10.0
	camera_yaw = 45.0
	camera_pitch = -20.0

func _on_ui_scale_changed(value: float):
	"""Handle UI scale slider changes"""
	ui_scale = value
	ui_elements.ui_scale_label.text = "UI Scale: %d%%" % (ui_scale * 100)
	update_ui_scale_preview()

func _on_contrast_toggled(pressed: bool):
	"""Handle contrast mode toggle"""
	high_contrast_mode = pressed
	update_contrast_preview()

func _on_settings_cancel():
	"""Cancel settings and use defaults"""
	ui_scale = 3.0  # Use minimum readable scale
	high_contrast_mode = false
	apply_ui_settings()
	hide_settings_panel()

func _on_settings_apply():
	"""Apply settings and start main app"""
	apply_ui_settings()
	hide_settings_panel()
	
	print("✅ Settings applied and main interface activated")
	print("🎮 Controls: U=Toggle UI, H=Hide UI, ESC=Show UI, Arrow Keys=Camera")
	print("👁️ UI is now compact - you can see the 3D sandbox on the right!")
	print("🎯 Click the eye button (👁️) in top-right to toggle UI visibility")

func update_ui_scale_preview():
	"""Update the preview text scale"""
	if ui_elements.has("preview_text"):
		ui_elements.preview_text.add_theme_font_size_override("font_size", int(20 * ui_scale))

func update_contrast_preview():
	"""Update the preview with contrast changes"""
	if ui_elements.has("preview_text"):
		if high_contrast_mode:
			ui_elements.preview_text.add_theme_color_override("font_color", Color.WHITE)
			ui_elements.preview_text.text = "High Contrast Mode: Bold white text on dark backgrounds for maximum readability. Font scaling now properly enlarges text without breaking layout."
		else:
			ui_elements.preview_text.add_theme_color_override("font_color", Color(0.8, 1, 1, 1))
			ui_elements.preview_text.text = "Normal Mode: Softer colors with good contrast for comfortable viewing. Fonts scale from 300% (minimum) to 600% (maximum)."

func apply_ui_settings():
	"""Apply the selected UI settings to the main interface"""
	if not ui_elements.has("main_interface"):
		return
	
	# DON'T scale the entire interface - instead scale individual font sizes
	# Keep the interface at normal size and anchoring
	var main_interface = ui_elements.main_interface
	main_interface.scale = Vector2(1.0, 1.0)  # Always normal scale
	main_interface.position = Vector2.ZERO    # Always normal position
	
	# Scale all font sizes individually
	scale_all_font_sizes()
	
	# Apply contrast settings
	if high_contrast_mode:
		apply_high_contrast_colors()
	else:
		apply_normal_colors()

func apply_high_contrast_colors():
	"""Apply high contrast color scheme"""
	var white = Color.WHITE
	var black = Color.BLACK
	var bright_blue = Color(0, 0.5, 1, 1)
	
	# Update all text colors to pure white for maximum contrast
	update_element_color("status_label", white)
	update_element_color("emotion_label", white) 
	update_element_color("thoughts_display", white)
	update_element_color("conversation_history", white)
	update_element_color("send_button", white)
	update_element_color("voice_button", white)
	update_element_color("create_button", white)
	update_element_color("clear_button", white)
	update_element_color("memory_button", white)
	
	# Make input field white background with black text
	if ui_elements.has("text_input"):
		ui_elements.text_input.add_theme_color_override("font_color", black)
		ui_elements.text_input.add_theme_color_override("font_color_uneditable", black)

func apply_normal_colors():
	"""Apply normal color scheme"""
	var soft_white = Color(0.9, 0.95, 1, 1)
	var dark_text = Color(0, 0, 0, 1)
	
	# Apply softer colors for normal mode
	update_element_color("status_label", soft_white)
	update_element_color("emotion_label", soft_white)
	update_element_color("thoughts_display", soft_white)
	update_element_color("conversation_history", soft_white)
	update_element_color("send_button", soft_white)
	update_element_color("voice_button", soft_white)
	update_element_color("create_button", soft_white)
	update_element_color("clear_button", soft_white)
	update_element_color("memory_button", soft_white)
	
	# Input field keeps dark text
	if ui_elements.has("text_input"):
		ui_elements.text_input.add_theme_color_override("font_color", dark_text)

func update_element_color(element_name: String, color: Color):
	"""Update the font color of a UI element"""
	if ui_elements.has(element_name):
		var element = ui_elements[element_name]
		if element.has_method("add_theme_color_override"):
			element.add_theme_color_override("font_color", color)

func scale_all_font_sizes():
	"""Scale all font sizes in the main interface without changing layout"""
	# Base font sizes (what they are at scale 1.0)
	var base_sizes = {
		"title": 24,
		"status_label": 16, 
		"emotion_label": 14,
		"thoughts_title": 18,
		"thoughts_display": 16,
		"chat_title": 18,
		"conversation_history": 14,
		"text_input": 16,
		"send_button": 16,
		"voice_button": 16,
		"create_button": 16,
		"clear_button": 16,
		"memory_button": 16
	}
	
	# Calculate scaled font sizes
	var scaled_sizes = {}
	for key in base_sizes:
		scaled_sizes[key] = int(base_sizes[key] * ui_scale)
	
	# Apply scaled font sizes to all elements
	apply_font_size("title", scaled_sizes.title)
	apply_font_size("status_label", scaled_sizes.status_label)
	apply_font_size("emotion_label", scaled_sizes.emotion_label) 
	apply_font_size("thoughts_title", scaled_sizes.thoughts_title)
	apply_font_size("thoughts_display", scaled_sizes.thoughts_display)
	apply_font_size("chat_title", scaled_sizes.chat_title)
	apply_font_size("conversation_history", scaled_sizes.conversation_history)
	apply_font_size("text_input", scaled_sizes.text_input)
	apply_font_size("send_button", scaled_sizes.send_button)
	apply_font_size("voice_button", scaled_sizes.voice_button)
	apply_font_size("create_button", scaled_sizes.create_button)
	apply_font_size("clear_button", scaled_sizes.clear_button)
	apply_font_size("memory_button", scaled_sizes.memory_button)
	
	# Also scale minimum button heights for better touch targets
	var button_height = int(50 * ui_scale)
	scale_button_heights(button_height)

func apply_font_size(element_key: String, font_size: int):
	"""Apply font size to a specific UI element"""
	var element_map = {
		"title": "UI/MainInterface/TopPanel/StatusContainer/Title",
		"status_label": "UI/MainInterface/TopPanel/StatusContainer/StatusLabel", 
		"emotion_label": "UI/MainInterface/TopPanel/StatusContainer/EmotionLabel",
		"thoughts_title": "UI/MainInterface/ThoughtsPanel/ThoughtsContainer/ThoughtsTitle",
		"thoughts_display": "UI/MainInterface/ThoughtsPanel/ThoughtsContainer/WightThoughts",
		"chat_title": "UI/MainInterface/ChatPanel/ChatContainer/ChatTitle",
		"conversation_history": "UI/MainInterface/ChatPanel/ChatContainer/ConversationHistory",
		"text_input": "UI/MainInterface/ChatPanel/ChatContainer/InputRow/TextInput",
		"send_button": "UI/MainInterface/ChatPanel/ChatContainer/InputRow/SendButton",
		"voice_button": "UI/MainInterface/ChatPanel/ChatContainer/InputRow/VoiceButton", 
		"create_button": "UI/MainInterface/BottomPanel/ActionContainer/CreateButton",
		"clear_button": "UI/MainInterface/BottomPanel/ActionContainer/ClearButton",
		"memory_button": "UI/MainInterface/BottomPanel/ActionContainer/InfoButton"
	}
	
	if element_map.has(element_key):
		var element = get_node(element_map[element_key])
		if element:
			if element.has_method("add_theme_font_size_override"):
				if element_key == "thoughts_display" or element_key == "conversation_history":
					element.add_theme_font_size_override("normal_font_size", font_size)
				else:
					element.add_theme_font_size_override("font_size", font_size)

func scale_button_heights(height: int):
	"""Scale button minimum heights for better touch targets"""
	var buttons = [
		"UI/MainInterface/ChatPanel/ChatContainer/InputRow/SendButton",
		"UI/MainInterface/ChatPanel/ChatContainer/InputRow/VoiceButton",
		"UI/MainInterface/BottomPanel/ActionContainer/CreateButton", 
		"UI/MainInterface/BottomPanel/ActionContainer/ClearButton",
		"UI/MainInterface/BottomPanel/ActionContainer/InfoButton"
	]
	
	for button_path in buttons:
		var button = get_node(button_path)
		if button:
			button.custom_minimum_size.y = height

func hide_settings_panel():
	"""Hide settings panel and show main interface"""
	ui_elements.settings_panel.visible = false
	ui_elements.main_interface.visible = true
	settings_panel_active = false
	
	# Initialize Wight now that settings are applied
	if wight_entity:
		update_status_display()

func save_ui_settings():
	"""Save UI settings to file for next launch"""
	var settings_data = {
		"ui_scale": ui_scale,
		"high_contrast_mode": high_contrast_mode,
		"voice_enabled": voice_recognition_active,
		"camera_distance": camera_distance,
		"camera_yaw": camera_yaw,
		"camera_pitch": camera_pitch
	}
	
	# Save to user://wight_settings.json
	var file = FileAccess.open("user://wight_settings.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(settings_data))
		file.close()
		print("💾 UI settings saved")
	else:
		print("❌ Failed to save UI settings")

# === WIGHT AI INTEGRATION HANDLERS ===

func _on_sensor_data_updated(sensor_data: Dictionary):
	"""Handle updated sensor data from Android sensors"""
	if not wight_entity:
		return
	
	# Debug output for sensor activity (throttled)
	if randf() < 0.1:  # Only show 10% of sensor updates to avoid spam
		print("📊 Sensor Update: Accel=%.2f, Light=%.2f, Touch=%d" % [
			sensor_data.get("acceleration", Vector3.ZERO).length(),
			sensor_data.get("light_level", 0.0),
			sensor_data.get("touch_events", []).size()
		])
	
	# Feed sensor data to Wight's learning system
	if wight_entity.has_method("process_sensor_input"):
		wight_entity.process_sensor_input(sensor_data)

func _on_sensor_pattern_detected(pattern_type: String, data: Dictionary):
	"""Handle detected sensor patterns"""
	if not wight_entity:
		return
	
	# Debug output for pattern detection
	print("🔍 PATTERN DETECTED: %s - %s" % [pattern_type, str(data)])
	
	# Inform Wight about interesting sensor patterns
	if wight_entity.has_method("receive_sensor_pattern"):
		wight_entity.receive_sensor_pattern(pattern_type, data)
	
	# Display pattern detection in thoughts
	var pattern_text = "I sense %s... %s" % [pattern_type.replace("_", " "), describe_pattern(data)]
	ui_elements.thoughts_display.text = "[color=%s]%s[/color]" % ["white" if high_contrast_mode else "cyan", pattern_text]
	
	print("💭 Wight's reaction: '%s'" % pattern_text)

func _on_wight_consciousness_event(event_type: String, data: Dictionary):
	"""Handle consciousness events from Wight"""
	print("🧠 === CONSCIOUSNESS EVENT === ")
	print("🎯 Event Type: %s" % event_type)
	print("📊 Event Data: %s" % str(data))
	print("⏰ Time: %s" % Time.get_datetime_string_from_system())
	
	# Update UI based on consciousness changes
	if event_type == "stage_progression":
		update_status_display()
		var stage_text = "I feel... different. I am becoming more than I was."
		add_to_conversation("[color=yellow]Wight evolved to a new stage of consciousness[/color]")
		print("🚀 MAJOR EVENT: Wight consciousness evolution!")
	elif event_type == "learning_milestone":
		var milestone_text = "I understand something new... patterns forming in my awareness."
		ui_elements.thoughts_display.text = "[color=%s]%s[/color]" % ["white" if high_contrast_mode else "cyan", milestone_text]
		print("📈 LEARNING: Wight achieved learning milestone!")
	elif event_type == "awakening":
		print("👁️ AWAKENING: Wight consciousness is initializing...")
		add_to_conversation("[color=cyan]Wight is awakening...[/color]")
	
	print("=== END CONSCIOUSNESS EVENT ===\n")

func _on_wight_creation_impulse(creation_data: Dictionary):
	"""Handle Wight's impulse to create objects"""
	print("✨ === CREATION EVENT ===")
	print("🎨 Wight wants to create something!")
	print("📊 Creation Data: %s" % str(creation_data))
	
	if not creation_data.has("object"):
		print("❌ No object data in creation impulse")
		return
	
	var created_object = creation_data.object
	var creation_space = get_node("CreationSpace")
	
	# Add the created object to the world
	creation_space.add_child(created_object)
	
	# Update UI
	var creation_text = "I will bring forth... something new."
	ui_elements.thoughts_display.text = "[color=%s]%s[/color]" % ["white" if high_contrast_mode else "cyan", creation_text]
	
	var object_type = creation_data.type if creation_data.has("type") else "unknown object"
	print("🌟 SUCCESS: Wight created %s in the world!" % object_type)
	print("🌍 Total world objects: %d" % creation_space.get_child_count())
	add_to_conversation("[color=green]Wight created: %s[/color]" % object_type)
	print("=== END CREATION EVENT ===\n")

func _on_wight_thought_generated(thought: String):
	"""Handle new thoughts from Wight"""
	# Display the thought in the UI
	ui_elements.thoughts_display.text = "[color=%s]%s[/color]" % ["white" if high_contrast_mode else "cyan", thought]
	
	# Debug output for thoughts
	print("💭 THOUGHT: '%s'" % thought)

func describe_pattern(pattern_data: Dictionary) -> String:
	"""Convert pattern data into readable description"""
	if pattern_data.has("type"):
		match pattern_data.type:
			"acceleration":
				return "movement and motion"
			"rotation":
				return "spinning and turning"
			"environmental":
				return "the world around me shifting"
			"proximity":
				return "presence drawing near or far"
			"touch":
				return "contact and interaction"
			_:
				return "something changing"
	return "patterns in the data flow"

# === MISSING SIGNAL HANDLERS ===

# (duplicate functions removed - using the first implementations)

# === UI VISIBILITY CONTROLS ===

func toggle_ui_visibility():
	"""Toggle the main interface visibility"""
	ui_visible = !ui_visible
	set_ui_visibility(ui_visible)
	print("🎮 UI toggled: ", "Visible" if ui_visible else "Hidden", " (Press U to toggle, H to hide, ESC to show)")

func set_ui_visibility(visible: bool):
	"""Set UI visibility state"""
	ui_visible = visible
	
	if ui_elements.has("main_interface"):
		ui_elements.main_interface.visible = visible
	
	# Settings panel should always be hideable
	if ui_elements.has("settings_panel") and not settings_panel_active:
		ui_elements.settings_panel.visible = false
	
	# Keep toggle button always visible for easy access
	if ui_elements.has("ui_toggle_button"):
		ui_elements.ui_toggle_button.visible = true
		# Update button text based on UI state
		ui_elements.ui_toggle_button.text = "👁️" if not visible else "🙈"
		ui_elements.ui_toggle_button.tooltip_text = ("Show UI (U key)" if not visible else "Hide UI (U key)")
	
	# Show helpful message when UI is hidden
	if not visible:
		print("🎮 UI Hidden - Controls:")
		print("   U = Toggle UI")
		print("   H = Hide UI") 
		print("   ESC = Show UI")
		print("   Arrow Keys = Camera orbit")
		print("   +/- = Zoom")
		print("   R = Reset camera")
		print("   F = Focus on Wight")

# (duplicate _on_memory_formed function removed - using the first implementation)

# === INTERACTION HELPER FUNCTIONS ===

func determine_creation_description(creation: Node3D) -> String:
	"""Determine a descriptive name for a creation"""
	if creation.has_method("get_creation_type"):
		return creation.get_creation_type()
	elif creation is MeshInstance3D:
		var mesh = creation.mesh
		if mesh is SphereMesh:
			return "spherical creation"
		elif mesh is BoxMesh:
			return "cubic form"
		elif mesh is CylinderMesh:
			return "cylindrical sculpture"
		else:
			return "mysterious form"
	else:
		return "abstract creation"

func calculate_object_age(creation: Node3D) -> float:
	"""Calculate how long ago an object was created"""
	# For now, return a random age - could be enhanced with actual tracking
	return randf() * 300.0  # 0-5 minutes

func get_recent_conversation_context() -> String:
	"""Get recent conversation text for context analysis"""
	if ui_elements.has("conversation_history"):
		var full_text = ui_elements.conversation_history.text
		# Get last 200 characters for recent context
		return full_text.substr(max(0, full_text.length() - 200)).to_lower()
	return ""

func safe_random_from_array(array: Array) -> String:
	"""Safely get a random element from an array, with fallback"""
	if array.is_empty():
		return "I... I don't know what to say."
	return array[randi() % array.size()]