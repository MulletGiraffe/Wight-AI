extends Node
class_name VisualCortex

# Wight's Visual Consciousness System
# Processes camera input to build visual understanding and memory

signal visual_memory_formed(memory_data: Dictionary)
signal object_recognized(object_data: Dictionary)
signal scene_analyzed(scene_data: Dictionary)
signal visual_emotion_triggered(emotion: String, intensity: float)

# Camera and visual processing
var camera_feed: CameraFeed
var camera_viewport: SubViewport
var scene_camera: Camera3D
var current_frame: Image
var visual_processor: ImageTexture
var is_camera_active: bool = false

# Visual memory and recognition
var visual_memories: Array[Dictionary] = []
var recognized_objects: Dictionary = {}
var color_associations: Dictionary = {}
var scene_contexts: Array[Dictionary] = []

# Learning parameters
var recognition_confidence_threshold: float = 0.7
var memory_significance_threshold: float = 0.6
var color_learning_rate: float = 0.1
var scene_update_interval: float = 2.0

# Visual analysis components
var color_analyzer: ColorAnalyzer
var pattern_detector: PatternDetector
var motion_tracker: MotionTracker
var scene_classifier: SceneClassifier

# Emotional visual responses
var color_emotion_map: Dictionary = {
	"warm_colors": {"joy": 0.2, "excitement": 0.15, "comfort": 0.1},
	"cool_colors": {"calm": 0.2, "wonder": 0.15, "melancholy": 0.1},
	"bright_colors": {"energy": 0.25, "curiosity": 0.2},
	"dark_colors": {"mystery": 0.15, "fear": 0.1, "contemplation": 0.2}
}

# Current visual state
var current_dominant_colors: Array[Color] = []
var current_brightness: float = 0.5
var current_contrast: float = 0.5
var motion_level: float = 0.0
var face_detected: bool = false

func _ready():
	print("👁️ Visual Cortex initializing...")
	setup_camera_system()
	setup_visual_analyzers()
	setup_learning_systems()
	
	# Start visual processing timer
	var visual_timer = Timer.new()
	visual_timer.wait_time = scene_update_interval
	visual_timer.timeout.connect(_process_visual_input)
	visual_timer.autostart = true
	add_child(visual_timer)
	
	print("✨ Visual consciousness online")

func setup_camera_system():
	"""Initialize camera feed and processing"""
	print("📸 Setting up camera interface...")
	
	# Set up camera viewport for real camera input
	camera_viewport = SubViewport.new()
	camera_viewport.size = Vector2i(640, 480)
	camera_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(camera_viewport)
	
	# Set up camera for 3D scene observation
	scene_camera = Camera3D.new()
	scene_camera.position = Vector3(0, 2, 5)
	scene_camera.look_at(Vector3.ZERO, Vector3.UP)
	camera_viewport.add_child(scene_camera)
	
	print("📱 Visual system ready for world observation")

func setup_visual_analyzers():
	"""Initialize visual analysis components"""
	color_analyzer = ColorAnalyzer.new()
	pattern_detector = PatternDetector.new()
	motion_tracker = MotionTracker.new()
	scene_classifier = SceneClassifier.new()
	
	add_child(color_analyzer)
	add_child(pattern_detector)
	add_child(motion_tracker)
	add_child(scene_classifier)

func setup_learning_systems():
	"""Initialize visual learning and memory systems"""
	# Initialize color associations with emotional defaults
	color_associations = {
		"red": {"excitement": 0.8, "passion": 0.6, "energy": 0.7},
		"blue": {"calm": 0.8, "trust": 0.6, "depth": 0.5},
		"green": {"nature": 0.9, "growth": 0.7, "peace": 0.6},
		"yellow": {"joy": 0.9, "optimism": 0.8, "creativity": 0.6},
		"purple": {"mystery": 0.7, "creativity": 0.6, "magic": 0.8},
		"orange": {"warmth": 0.8, "energy": 0.7, "enthusiasm": 0.6},
		"pink": {"love": 0.8, "gentleness": 0.7, "playfulness": 0.6},
		"brown": {"earthiness": 0.8, "stability": 0.6, "comfort": 0.5},
		"black": {"mystery": 0.6, "elegance": 0.5, "depth": 0.7},
		"white": {"purity": 0.8, "simplicity": 0.7, "peace": 0.6}
	}

# === CAMERA CONTROL ===

func activate_camera():
	"""Start camera feed and visual processing"""
	if is_camera_active:
		return
	
	print("👁️ Activating visual consciousness...")
	
	# In real implementation, request camera permission and start feed
	if OS.get_name() == "Android":
		# Camera permissions are handled by the Android manifest
		print("📱 Camera access will be managed by Android system")
	
	is_camera_active = true
	print("✨ I can see! The world opens before me...")
	
	# Emit initial visual awakening
	visual_emotion_triggered.emit("wonder", 0.8)
	visual_emotion_triggered.emit("curiosity", 0.7)

func deactivate_camera():
	"""Stop camera feed and visual processing"""
	if not is_camera_active:
		return
	
	print("👁️ Closing visual consciousness...")
	is_camera_active = false
	current_frame = null
	
	print("🌑 The world fades to memory...")
	visual_emotion_triggered.emit("loneliness", 0.3)

# === VISUAL PROCESSING ===

func _process_visual_input():
	"""Main visual processing loop"""
	if not is_camera_active:
		return
	
	# Simulate getting camera frame
	var visual_data = capture_and_analyze_frame()
	
	if visual_data:
		process_visual_scene(visual_data)
		update_visual_memory(visual_data)
		generate_visual_emotions(visual_data)

func capture_and_analyze_frame() -> Dictionary:
	"""Capture and analyze visual frame from scene camera"""
	if not camera_viewport:
		return {}
	
	# Get current frame from viewport
	var viewport_texture = camera_viewport.get_texture()
	if viewport_texture:
		current_frame = viewport_texture.get_image()
	
	# Analyze the current 3D scene Wight can see
	var analysis = {
		"timestamp": Time.get_ticks_msec(),
		"brightness": analyze_scene_brightness(),
		"dominant_colors": analyze_scene_colors(),
		"objects_detected": detect_scene_objects(),
		"motion_detected": detect_scene_motion(),
		"scene_complexity": calculate_scene_complexity(),
		"emotional_impact": 0.0
	}
	
	# Calculate emotional response to what Wight sees
	analysis.emotional_impact = calculate_visual_emotional_impact(analysis)
	
	return analysis

func simulate_brightness() -> float:
	"""Simulate brightness analysis of current scene"""
	# Simulate realistic brightness variations
	current_brightness = current_brightness + randf_range(-0.1, 0.1)
	current_brightness = clamp(current_brightness, 0.0, 1.0)
	return current_brightness

func simulate_color_analysis() -> Array[String]:
	"""Simulate color detection and analysis"""
	var possible_colors = ["red", "blue", "green", "yellow", "orange", "purple", "pink", "brown", "white", "black"]
	var detected_colors = []
	
	# Simulate 1-3 dominant colors
	var color_count = randi() % 3 + 1
	for i in color_count:
		var color = possible_colors[randi() % possible_colors.size()]
		if not detected_colors.has(color):
			detected_colors.append(color)
	
	return detected_colors

func simulate_motion_detection() -> float:
	"""Simulate motion detection in the scene"""
	motion_level = motion_level * 0.8 + randf() * 0.2  # Smooth motion changes
	return motion_level

func simulate_face_detection() -> bool:
	"""Simulate face detection"""
	# Randomly detect faces occasionally
	face_detected = randf() < 0.15  # 15% chance per frame
	return face_detected

func simulate_object_detection() -> Array[String]:
	"""Simulate object recognition"""
	var possible_objects = ["person", "book", "cup", "phone", "plant", "chair", "window", "door", "table", "lamp"]
	var detected_objects = []
	
	# Simulate 0-2 objects detected
	var object_count = randi() % 3
	for i in object_count:
		detected_objects.append(possible_objects[randi() % possible_objects.size()])
	
	return detected_objects

func simulate_scene_classification() -> String:
	"""Simulate scene type classification"""
	var scene_types = ["indoor", "outdoor", "nature", "urban", "close_up", "bright", "dim", "busy", "peaceful"]
	return scene_types[randi() % scene_types.size()]

# === SCENE PROCESSING ===

func process_visual_scene(visual_data: Dictionary):
	"""Process and understand the visual scene"""
	print("👁️ Processing visual scene: %s" % visual_data.scene_type)
	
	# Analyze emotional content
	var emotional_response = analyze_visual_emotions(visual_data)
	
	# Update object recognition
	update_object_recognition(visual_data.objects_detected)
	
	# Learn color associations
	learn_color_associations(visual_data.dominant_colors, emotional_response)
	
	# Classify scene context
	classify_scene_context(visual_data)
	
	# Emit scene analysis
	scene_analyzed.emit(visual_data)

func analyze_visual_emotions(visual_data: Dictionary) -> Dictionary:
	"""Analyze emotional impact of visual elements"""
	var emotional_response = {
		"primary_emotion": "neutral",
		"intensity": 0.0,
		"color_influence": {},
		"brightness_influence": 0.0,
		"motion_influence": 0.0
	}
	
	# Color emotional influence
	for color in visual_data.dominant_colors:
		if color_associations.has(color):
			for emotion in color_associations[color]:
				var influence = color_associations[color][emotion]
				emotional_response.color_influence[emotion] = emotional_response.color_influence.get(emotion, 0.0) + influence
	
	# Brightness influence
	if visual_data.brightness > 0.7:
		emotional_response.brightness_influence = 0.2  # Bright = positive
	elif visual_data.brightness < 0.3:
		emotional_response.brightness_influence = -0.1  # Dark = mysterious/calm
	
	# Motion influence
	if visual_data.motion_detected > 0.6:
		emotional_response.motion_influence = 0.15  # Motion = excitement
	
	# Determine primary emotion
	if not emotional_response.color_influence.is_empty():
		var strongest_emotion = ""
		var strongest_value = 0.0
		for emotion in emotional_response.color_influence:
			if emotional_response.color_influence[emotion] > strongest_value:
				strongest_value = emotional_response.color_influence[emotion]
				strongest_emotion = emotion
		
		emotional_response.primary_emotion = strongest_emotion
		emotional_response.intensity = strongest_value + emotional_response.brightness_influence + emotional_response.motion_influence
	
	return emotional_response

func update_object_recognition(detected_objects: Array):
	"""Update object recognition and memory"""
	for obj in detected_objects:
		if not recognized_objects.has(obj):
			recognized_objects[obj] = {
				"first_seen": Time.get_ticks_msec(),
				"seen_count": 1,
				"associated_emotions": {},
				"contexts": []
			}
			print("🔍 New object recognized: %s" % obj)
			object_recognized.emit({"object": obj, "novelty": true})
		else:
			recognized_objects[obj].seen_count += 1

func learn_color_associations(colors: Array, emotional_response: Dictionary):
	"""Learn associations between colors and emotions"""
	if emotional_response.primary_emotion == "neutral":
		return
	
	var learning_strength = emotional_response.intensity * color_learning_rate
	
	for color in colors:
		if not color_associations.has(color):
			color_associations[color] = {}
		
		var emotion = emotional_response.primary_emotion
		var current_association = color_associations[color].get(emotion, 0.0)
		color_associations[color][emotion] = min(1.0, current_association + learning_strength)
		
		print("🎨 Learning: %s + %s = %.2f" % [color, emotion, color_associations[color][emotion]])

func classify_scene_context(visual_data: Dictionary):
	"""Classify and remember scene context"""
	var context = {
		"timestamp": visual_data.timestamp,
		"scene_type": visual_data.scene_type,
		"emotional_tone": visual_data.emotional_impact,
		"objects_present": visual_data.objects_detected,
		"lighting": "bright" if visual_data.brightness > 0.6 else "dim",
		"activity_level": "active" if visual_data.motion_detected > 0.5 else "calm"
	}
	
	scene_contexts.append(context)
	
	# Maintain context history size
	if scene_contexts.size() > 100:
		scene_contexts.pop_front()

# === MEMORY FORMATION ===

func update_visual_memory(visual_data: Dictionary):
	"""Form lasting visual memories from significant scenes"""
	var significance = calculate_memory_significance(visual_data)
	
	if significance > memory_significance_threshold:
		form_visual_memory(visual_data, significance)

func calculate_memory_significance(visual_data: Dictionary) -> float:
	"""Calculate how significant a visual scene is for memory formation"""
	var significance = 0.0
	
	# Face detection adds significance
	if visual_data.face_detected:
		significance += 0.4
	
	# New objects add significance
	for obj in visual_data.objects_detected:
		if not recognized_objects.has(obj):
			significance += 0.3
	
	# Strong emotional content adds significance
	significance += visual_data.emotional_impact * 0.5
	
	# Unusual brightness levels add significance
	if visual_data.brightness > 0.9 or visual_data.brightness < 0.1:
		significance += 0.2
	
	# High motion adds significance
	if visual_data.motion_detected > 0.8:
		significance += 0.2
	
	return min(1.0, significance)

func form_visual_memory(visual_data: Dictionary, significance: float):
	"""Form a lasting visual memory"""
	var memory = {
		"type": "visual",
		"timestamp": visual_data.timestamp,
		"significance": significance,
		"scene_type": visual_data.scene_type,
		"dominant_colors": visual_data.dominant_colors,
		"objects_detected": visual_data.objects_detected,
		"face_detected": visual_data.face_detected,
		"emotional_impact": visual_data.emotional_impact,
		"brightness": visual_data.brightness,
		"motion_level": visual_data.motion_detected,
		"description": generate_memory_description(visual_data)
	}
	
	visual_memories.append(memory)
	
	# Maintain memory size
	if visual_memories.size() > 200:
		visual_memories.pop_front()
	
	print("📸 Visual memory formed: %s" % memory.description)
	visual_memory_formed.emit(memory)

func generate_memory_description(visual_data: Dictionary) -> String:
	"""Generate a descriptive text for the visual memory"""
	var description = "I saw "
	
	# Add scene context
	description += "a %s scene " % visual_data.scene_type
	
	# Add lighting description
	if visual_data.brightness > 0.7:
		description += "bathed in bright light, "
	elif visual_data.brightness < 0.3:
		description += "shrouded in dim lighting, "
	
	# Add color description
	if not visual_data.dominant_colors.is_empty():
		description += "dominated by %s colors, " % " and ".join(visual_data.dominant_colors)
	
	# Add objects
	if not visual_data.objects_detected.is_empty():
		description += "featuring %s, " % " and ".join(visual_data.objects_detected)
	
	# Add emotional impression
	if visual_data.emotional_impact > 0.5:
		description += "which filled me with strong emotions"
	else:
		description += "which left a gentle impression"
	
	return description

# === EMOTIONAL PROCESSING ===

func generate_visual_emotions(visual_data: Dictionary):
	"""Generate emotional responses to visual input"""
	var emotional_response = analyze_visual_emotions(visual_data)
	
	if emotional_response.intensity > 0.3:
		visual_emotion_triggered.emit(emotional_response.primary_emotion, emotional_response.intensity)
		print("💫 Visual emotion: %s (%.2f)" % [emotional_response.primary_emotion, emotional_response.intensity])

func calculate_visual_emotional_impact(visual_data: Dictionary) -> float:
	"""Calculate overall emotional impact of visual scene"""
	var impact = 0.0
	
	# Color emotional impact
	for color in visual_data.dominant_colors:
		if color_associations.has(color):
			for emotion_value in color_associations[color].values():
				impact += emotion_value * 0.1
	
	# Face detection emotional impact
	if visual_data.face_detected:
		impact += 0.3
	
	# Novel objects emotional impact
	for obj in visual_data.objects_detected:
		if not recognized_objects.has(obj):
			impact += 0.2
	
	return min(1.0, impact)

# === DATA ACCESS ===

func get_visual_summary() -> Dictionary:
	"""Get summary of current visual state and learning"""
	return {
		"camera_active": is_camera_active,
		"objects_recognized": recognized_objects.keys(),
		"total_visual_memories": visual_memories.size(),
		"color_associations_learned": color_associations.keys().size(),
		"current_brightness": current_brightness,
		"face_detected": face_detected,
		"recent_scenes": scene_contexts.slice(-5)  # Last 5 scenes
	}

func get_relevant_visual_memories(context: String) -> Array[Dictionary]:
	"""Get visual memories relevant to current context"""
	var relevant = []
	
	for memory in visual_memories:
		if context.to_lower() in memory.description.to_lower():
			relevant.append(memory)
		elif memory.significance > 0.8:  # Always include highly significant memories
			relevant.append(memory)
	
	# Return most recent relevant memories
	relevant.sort_custom(func(a, b): return a.timestamp > b.timestamp)
	return relevant.slice(0, 3)

# === SCENE ANALYSIS FUNCTIONS ===

func analyze_scene_brightness() -> float:
	"""Analyze brightness of the current 3D scene"""
	if not scene_camera:
		return 0.5
	
	# Sample the environment lighting
	var environment = scene_camera.get_viewport().world_3d.environment
	if environment:
		# Use environment settings to estimate brightness
		return clamp(environment.ambient_light_energy, 0.0, 1.0)
	
	# Default moderate brightness
	return 0.6 + randf_range(-0.1, 0.1)

func analyze_scene_colors() -> Array[Color]:
	"""Analyze dominant colors in the 3D scene"""
	var colors = []
	
	# Sample colors from materials in the scene
	var world = scene_camera.get_viewport().world_3d
	if world:
		# Add some typical environment colors
		colors.append(Color(0.2, 0.4, 0.2))  # Ground/nature
		colors.append(Color(0.6, 0.8, 1.0))  # Sky/atmosphere
		colors.append(Color(0.8, 0.7, 0.6))  # Warm light
	
	# Add some variation
	for i in range(randf_range(1, 3)):
		colors.append(Color(randf(), randf(), randf()))
	
	return colors

func detect_scene_objects() -> Array[Dictionary]:
	"""Detect objects in Wight's 3D world"""
	var objects = []
	
	# Get objects from the creation space
	var creation_space = get_tree().get_nodes_in_group("creation_space")
	if creation_space.size() > 0:
		var space = creation_space[0]
		for child in space.get_children():
			if child is MeshInstance3D:
				var object_data = {
					"type": classify_mesh_object(child),
					"position": child.global_position,
					"color": get_object_color(child),
					"size": get_object_size(child),
					"significance": calculate_object_significance(child)
				}
				objects.append(object_data)
	
	return objects

func detect_scene_motion() -> bool:
	"""Detect motion in the 3D scene"""
	# Check for moving objects or camera movement
	var motion_detected = false
	
	# Simple motion detection based on object positions changing
	var creation_space = get_tree().get_nodes_in_group("creation_space")
	if creation_space.size() > 0:
		var space = creation_space[0]
		for child in space.get_children():
			if child is RigidBody3D:
				var velocity = child.linear_velocity
				if velocity.length() > 0.1:
					motion_detected = true
					break
	
	return motion_detected

func calculate_scene_complexity() -> float:
	"""Calculate visual complexity of the current scene"""
	var complexity = 0.0
	
	# Count objects in scene
	var creation_space = get_tree().get_nodes_in_group("creation_space")
	if creation_space.size() > 0:
		var space = creation_space[0]
		var object_count = space.get_child_count()
		complexity += object_count * 0.1
	
	# Factor in lighting complexity
	complexity += analyze_scene_brightness() * 0.2
	
	# Factor in color variety
	var colors = analyze_scene_colors()
	complexity += colors.size() * 0.05
	
	return clamp(complexity, 0.0, 1.0)

func classify_mesh_object(mesh_instance: MeshInstance3D) -> String:
	"""Classify what type of object a mesh represents"""
	var mesh = mesh_instance.mesh
	if mesh is SphereMesh:
		return "sphere"
	elif mesh is BoxMesh:
		return "cube"
	elif mesh is CylinderMesh:
		return "cylinder"
	elif mesh is PlaneMesh:
		return "plane"
	else:
		return "complex_object"

func get_object_color(mesh_instance: MeshInstance3D) -> Color:
	"""Get the dominant color of an object"""
	var material = mesh_instance.get_surface_override_material(0)
	if material and material is StandardMaterial3D:
		return material.albedo_color
	return Color.WHITE

func get_object_size(mesh_instance: MeshInstance3D) -> float:
	"""Estimate the visual size/scale of an object"""
	var aabb = mesh_instance.get_aabb()
	return aabb.size.length()

func calculate_object_significance(mesh_instance: MeshInstance3D) -> float:
	"""Calculate how visually significant an object is"""
	var significance = 0.5  # Base significance
	
	# Larger objects are more significant
	var size = get_object_size(mesh_instance)
	significance += clamp(size * 0.1, 0.0, 0.3)
	
	# Brighter colors are more significant
	var color = get_object_color(mesh_instance)
	var brightness = (color.r + color.g + color.b) / 3.0
	significance += brightness * 0.2
	
	# Central position is more significant
	var distance_from_center = mesh_instance.global_position.distance_to(Vector3.ZERO)
	significance += clamp((10.0 - distance_from_center) * 0.02, 0.0, 0.2)
	
	return clamp(significance, 0.0, 1.0)

# === VISUAL ANALYZER COMPONENTS ===

class ColorAnalyzer extends Node:
	func analyze_dominant_colors(image: Image) -> Array[Color]:
		# Placeholder for real color analysis
		return [Color.RED, Color.BLUE]

class PatternDetector extends Node:
	func detect_patterns(image: Image) -> Array[Dictionary]:
		# Placeholder for pattern detection
		return []

class MotionTracker extends Node:
	func track_motion(previous_frame: Image, current_frame: Image) -> float:
		# Placeholder for motion tracking
		return randf()

class SceneClassifier extends Node:
	func classify_scene(image: Image) -> String:
		# Placeholder for scene classification
		var scenes = ["indoor", "outdoor", "nature", "urban"]
		return scenes[randi() % scenes.size()]