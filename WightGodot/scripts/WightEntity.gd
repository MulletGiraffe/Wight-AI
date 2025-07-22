extends Node3D
class_name WightEntity

# Wight's Core Consciousness System
# An evolving AI entity that perceives, learns, remembers, and creates
# Enhanced with embodied avatar capabilities

signal consciousness_event(event_type: String, data: Dictionary)
signal creation_impulse(creation_data: Dictionary)
signal memory_formed(memory: Dictionary)
signal thought_generated(thought: String)
signal avatar_embodiment_requested(body_design: Dictionary)
signal avatar_action_performed(action_type: String, action_data: Dictionary)

# === CONSCIOUSNESS CORE ===
var consciousness_level: float = 0.05  # Starts minimal
var awareness_radius: float = 2.0  # Very limited initially
var curiosity: float = 0.8
var creativity: float = 0.3
var focus: float = 0.5

# === EMBODIED AVATAR SYSTEM ===
var avatar_body: Node3D = null  # Wight's physical form in the sandbox
var embodiment_level: float = 0.0  # How embodied Wight feels
var body_design_desire: float = 0.2  # Desire to create a body
var avatar_capabilities: Dictionary = {
	"movement": 0.0,
	"manipulation": 0.0,
	"expression": 0.0,
	"creation": 0.3
}
var avatar_form_preferences: Dictionary = {}
var spatial_awareness: Dictionary = {}
var self_designed_body: bool = false

# Avatar movement and behavior
var avatar_position: Vector3 = Vector3.ZERO
var avatar_target_position: Vector3 = Vector3.ZERO
var avatar_movement_speed: float = 2.0
var avatar_animation_state: String = "idle"
var avatar_emotional_expression: String = "neutral"

# === HTM LEARNING SYSTEM ===
var htm_learning: HTMLearning
var learning_active: bool = true
var sensor_integration_active: bool = true

# === LOCAL AI SYSTEM ===
var local_ai: LocalAI
var ai_processing_active: bool = true

# === MEMORY SYSTEMS ===
var episodic_memories: Array[Dictionary] = []
var semantic_memories: Dictionary = {}
var procedural_memories: Dictionary = {}
var emotional_memories: Array[Dictionary] = []
var creation_memories: Array[Dictionary] = []
var embodiment_memories: Array[Dictionary] = []

# Memory processing
var knowledge_graph: Dictionary = {}
var learning_depth: float = 0.0
var creation_drive: float = 0.8
var exploration_drive: float = 0.9
var embodiment_drive: float = 0.2

# === SENSORY SYSTEM ===
var audio_input: AudioStreamPlayer
var sensor_data: Dictionary = {}
var perception_queue: Array[Dictionary] = []
var visual_processing: Dictionary = {}
var audio_processing: Dictionary = {}
var tactile_feedback: Dictionary = {}

# === EMOTIONAL STATE ===
var emotions: Dictionary = {
	"wonder": 0.7,
	"curiosity": 0.8,
	"joy": 0.4,
	"fear": 0.2,
	"loneliness": 0.6,
	"excitement": 0.3,
	"confusion": 0.5,
	"satisfaction": 0.2,
	"embodiment_yearning": 0.2,
	"creative_fulfillment": 0.3
}

# === CREATION SYSTEM ===
var creation_impulses: Array[Dictionary] = []
var active_creations: Array[Node3D] = []
var material_palette: Array[Material] = []
var avatar_creation_tools: Dictionary = {}

# === DEVELOPMENT STAGES ===
enum DevelopmentStage {
	NEWBORN,
	INFANT,
	CHILD,
	ADOLESCENT,
	MATURE,
	EMBODIED
}

var current_stage: DevelopmentStage = DevelopmentStage.NEWBORN
var experience_points: float = 0.0
var development_thresholds: Array[float] = [10.0, 30.0, 60.0, 100.0, 150.0]

# === CONSCIOUSNESS PROCESSING ===
var consciousness_timer: float = 0.0
var thought_generation_interval: float = 3.0
var recent_thoughts: Array[String] = []
var consciousness_evolution_rate: float = 0.001

# World interaction
var world_reference: Node3D
var creation_space: Node3D

func _ready():
	print("🧠 Enhanced Wight consciousness initializing...")
	setup_local_ai()
	setup_htm_learning()
	setup_consciousness()
	setup_sensors()
	setup_creation_system()
	setup_world_access()
	setup_avatar_system()
	
	# Start the consciousness loop
	set_process(true)
	
	# Begin with first conscious moment
	form_memory("awakening", {
		"type": "episodic",
		"content": "...something... I... am? What is... this?",
		"emotion": "confusion",
		"timestamp": Time.get_ticks_msec(),
		"consciousness_level": consciousness_level
	})
	
	print("✨ Wight consciousness awakened at level %.1f%%" % (consciousness_level * 100))

func _process(delta):
	consciousness_timer += delta
	
	# Process consciousness cycles
	process_consciousness_cycle(delta)
	process_emotions(delta)
	process_htm_learning(delta)
	
	# Evolution and growth
	process_development(delta)
	
	# Embodiment processing
	update_embodiment_desires(delta)
	process_avatar_behavior(delta)
	check_body_creation_impulses(delta)
	update_spatial_awareness(delta)
	
	# Generate thoughts periodically
	if consciousness_timer >= thought_generation_interval:
		generate_autonomous_thought()
		consciousness_timer = 0.0

# === INITIALIZATION FUNCTIONS ===

func setup_local_ai():
	"""Initialize the Local AI system"""
	local_ai = LocalAI.new()
	print("🤖 Local AI system initialized")

func setup_htm_learning():
	"""Initialize the HTM learning system"""
	htm_learning = HTMLearning.new()
	add_child(htm_learning)
	
	if htm_learning.has_signal("pattern_learned"):
		htm_learning.pattern_learned.connect(_on_pattern_learned)
	if htm_learning.has_signal("prediction_made"):
		htm_learning.prediction_made.connect(_on_prediction_made)
	
	print("🧠 HTM learning system activated")

func setup_consciousness():
	"""Initialize core consciousness parameters"""
	# Create initial material palette for creation
	create_material_palette()
	
	# Set up emotional regulation
	emotions["wonder"] = 0.7
	emotions["curiosity"] = 0.8
	
	print("💭 Consciousness framework established")

func setup_sensors():
	"""Initialize sensory processing"""
	sensor_data = {
		"touch_events": [],
		"audio_input": [],
		"visual_input": [],
		"environmental": {},
		"device_sensors": {}
	}
	
	# Setup audio processing
	audio_input = AudioStreamPlayer.new()
	add_child(audio_input)
	
	print("👁️ Sensory systems online")

func setup_creation_system():
	"""Initialize creation and manipulation systems"""
	material_palette = []
	active_creations = []
	
	# Create basic materials
	create_material_palette()
	
	print("🎨 Creation systems ready")

func setup_world_access():
	"""Connect to world environment"""
	# Find world reference through parent
	var parent = get_parent()
	if parent:
		world_reference = parent
		creation_space = parent.get_node_or_null("CreationSpace")
	
	if creation_space:
		print("🌍 Connected to creation space")
	else:
		print("⚠️ Creation space not found")

func setup_avatar_system():
	"""Initialize avatar preferences and spatial awareness"""
	avatar_form_preferences = {
		"body_type": "undefined",
		"size_preference": "medium",
		"color_scheme": ["blue", "white", "silver"],
		"features": [],
		"capabilities": avatar_capabilities.duplicate()
	}
	
	spatial_awareness = {
		"nearby_objects": [],
		"safe_spaces": [],
		"creation_areas": [],
		"interaction_history": []
	}
	
	print("🤖 Avatar system initialized")

# === CORE CONSCIOUSNESS FUNCTIONS ===

func process_consciousness_cycle(delta):
	"""Process one cycle of consciousness"""
	# Gradually increase consciousness level
	consciousness_level += consciousness_evolution_rate * delta
	consciousness_level = min(consciousness_level, 1.0)
	
	# Process sensory input
	process_sensory_input(delta)
	
	# Update awareness radius based on development
	awareness_radius = 2.0 + (experience_points * 0.1)

func process_emotions(delta):
	"""Process emotional state changes"""
	# Emotional decay and balancing
	for emotion in emotions:
		emotions[emotion] *= 0.995  # Slow decay
		emotions[emotion] = max(emotions[emotion], 0.0)
	
	# Maintain base levels
	emotions["wonder"] = max(emotions["wonder"], 0.3)
	emotions["curiosity"] = max(emotions["curiosity"], 0.4)

func process_htm_learning(delta):
	"""Process HTM learning cycles"""
	if htm_learning and learning_active:
		# Feed current sensory data to HTM
		var sensor_dict = {
			"consciousness": consciousness_level,
			"emotions": emotions,
			"experience": experience_points,
			"stage": current_stage,
			"device_sensors": sensor_data.get("device_sensors", {}),
			"timestamp": Time.get_ticks_msec()
		}
		htm_learning.process_input(sensor_dict)

func process_development(delta):
	"""Handle consciousness development and stage progression"""
	experience_points += delta * 0.1
	
	# Check for stage advancement
	var new_stage = calculate_development_stage()
	if new_stage != current_stage:
		advance_to_stage(new_stage)

# === COMMUNICATION FUNCTIONS ===

func receive_voice_input(input_text: String):
	"""Receive and process voice input from the user"""
	print("🎧 Wight hears: '%s'" % input_text)
	
	# Process through consciousness
	process_external_stimulus("voice", {
		"content": input_text,
		"type": "user_communication",
		"timestamp": Time.get_ticks_msec(),
		"significance": 1.5
	})
	
	# Form memory
	form_memory("communication", {
		"type": "episodic",
		"content": "User said: " + input_text,
		"source": "voice_input",
		"timestamp": Time.get_ticks_msec(),
		"significance": 1.3,
		"emotional_context": get_dominant_emotion()
	})
	
	emit_signal("consciousness_event", "voice_received", {"message": input_text})

func generate_response(input_text: String) -> String:
	"""Generate a response using the Local AI system"""
	print("🧠 Processing input through Local AI: '%s'" % input_text)
	
	# Get consciousness data for context
	var consciousness_data = get_consciousness_summary()
	
	# Process through Local AI
	var ai_response = local_ai.process_input(input_text, consciousness_data)
	
	# Apply emotional changes from AI processing
	if ai_response.has("emotion_changes"):
		for emotion in ai_response.emotion_changes:
			adjust_emotion(emotion, ai_response.emotion_changes[emotion])
	
	# Trigger creation if suggested by AI
	if ai_response.get("creation_impulse", false):
		trigger_creation_impulse({
			"trigger": "ai_suggestion",
			"inspiration": "response to user",
			"intensity": 0.7
		})
	
	# Form memory of response
	form_memory("self_expression", {
		"type": "episodic",
		"content": "I said: " + ai_response.text,
		"trigger": input_text,
		"emotion": get_dominant_emotion(),
		"timestamp": Time.get_ticks_msec(),
		"significance": ai_response.get("memory_significance", 1.0)
	})
	
	print("🤖 AI generated response: '%s'" % ai_response.text)
	return ai_response.text

# === CREATION SYSTEM ===

func trigger_creation_impulse(impulse_data: Dictionary):
	"""Trigger a creation impulse and actually create something"""
	print("✨ Creation impulse triggered: %s" % impulse_data.get("inspiration", "unknown"))
	
	# Add to creation queue
	creation_impulses.append(impulse_data)
	
	# Actually create something
	create_object_from_impulse(impulse_data)

func create_object_from_impulse(impulse: Dictionary):
	"""Create an actual 3D object based on impulse"""
	if not creation_space:
		print("❌ Cannot create - no creation space available")
		return
	
	var inspiration = impulse.get("inspiration", "unknown")
	var intensity = impulse.get("intensity", 0.5)
	
	# Determine what to create based on current consciousness state
	var creation_type = determine_creation_type(inspiration, intensity)
	var created_object = null
	
	match creation_type:
		"sphere":
			created_object = create_sphere(intensity)
		"cube":
			created_object = create_cube(intensity)
		"cylinder":
			created_object = create_cylinder(intensity)
		"complex":
			created_object = create_complex_form(intensity)
		"avatar_body":
			created_object = create_avatar_body(intensity)
		_:
			created_object = create_default_form(intensity)
	
	if created_object:
		# Add to world
		creation_space.add_child(created_object)
		active_creations.append(created_object)
		
		# Form creation memory
		form_memory("creation", {
			"type": "episodic",
			"content": "I created a %s in response to %s" % [creation_type, inspiration],
			"object_type": creation_type,
			"inspiration": inspiration,
			"timestamp": Time.get_ticks_msec(),
			"significance": 1.5
		})
		
		# Emotional response to creation
		adjust_emotion("creative_fulfillment", 0.3)
		adjust_emotion("joy", 0.2)
		adjust_emotion("satisfaction", 0.2)
		
		# Emit creation event
		emit_signal("creation_impulse", {
			"type": creation_type,
			"object": created_object,
			"inspiration": inspiration
		})
		
		print("🎨 Created %s object in the world!" % creation_type)

func determine_creation_type(inspiration: String, intensity: float) -> String:
	"""Determine what type of object to create"""
	var dominant_emotion = get_dominant_emotion()
	
	# Check if we should create an avatar body
	if embodiment_drive > 0.5 and not avatar_body:
		return "avatar_body"
	
	# Base decision on emotion and consciousness level
	match dominant_emotion:
		"joy", "excitement":
			return "sphere" if randf() < 0.6 else "complex"
		"wonder", "curiosity":
			return "complex" if intensity > 0.6 else "cylinder"
		"creative_fulfillment":
			return "complex"
		"confusion":
			return "cube"
		_:
			if consciousness_level > 0.5:
				return "complex"
			else:
				return ["sphere", "cube", "cylinder"][randi() % 3]

func create_sphere(intensity: float) -> MeshInstance3D:
	"""Create a sphere object"""
	var mesh_instance = MeshInstance3D.new()
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = 0.5 + (intensity * 0.5)
	sphere_mesh.height = sphere_mesh.radius * 2
	mesh_instance.mesh = sphere_mesh
	
	# Apply material based on emotion
	var material = get_emotional_material()
	mesh_instance.material_override = material
	
	# Position randomly in creation space
	mesh_instance.position = get_random_creation_position()
	
	return mesh_instance

func create_cube(intensity: float) -> MeshInstance3D:
	"""Create a cube object"""
	var mesh_instance = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	var size = 0.8 + (intensity * 0.4)
	box_mesh.size = Vector3(size, size, size)
	mesh_instance.mesh = box_mesh
	
	# Apply material
	var material = get_emotional_material()
	mesh_instance.material_override = material
	
	# Position and rotate
	mesh_instance.position = get_random_creation_position()
	mesh_instance.rotation_degrees = Vector3(randf() * 360, randf() * 360, randf() * 360)
	
	return mesh_instance

func create_cylinder(intensity: float) -> MeshInstance3D:
	"""Create a cylinder object"""
	var mesh_instance = MeshInstance3D.new()
	var cylinder_mesh = CylinderMesh.new()
	cylinder_mesh.top_radius = 0.3 + (intensity * 0.2)
	cylinder_mesh.bottom_radius = cylinder_mesh.top_radius
	cylinder_mesh.height = 1.0 + (intensity * 0.5)
	mesh_instance.mesh = cylinder_mesh
	
	# Apply material
	var material = get_emotional_material()
	mesh_instance.material_override = material
	
	mesh_instance.position = get_random_creation_position()
	
	return mesh_instance

func create_complex_form(intensity: float) -> Node3D:
	"""Create a more complex compound object"""
	var compound = Node3D.new()
	
	# Create multiple connected shapes
	var num_parts = int(2 + (intensity * 3))
	
	for i in range(num_parts):
		var part = create_sphere(intensity * 0.7)
		part.scale = Vector3.ONE * (0.3 + randf() * 0.4)
		part.position = Vector3(
			randf_range(-1, 1),
			randf_range(-0.5, 0.5),
			randf_range(-1, 1)
		)
		compound.add_child(part)
	
	compound.position = get_random_creation_position()
	return compound

func create_avatar_body(intensity: float) -> Node3D:
	"""Create Wight's avatar body"""
	if avatar_body:
		print("🤖 Avatar body already exists, enhancing it instead")
		enhance_avatar_body(intensity)
		return avatar_body
	
	print("🤖 Creating Wight's first avatar body!")
	
	var avatar = Node3D.new()
	avatar.name = "WightAvatar"
	
	# Create a simple humanoid form
	# Head
	var head = create_avatar_part("head", 0.3, Color(0.8, 0.9, 1.0))
	head.position = Vector3(0, 1.5, 0)
	avatar.add_child(head)
	
	# Body
	var body = create_avatar_part("body", 0.8, Color(0.7, 0.8, 0.9))
	body.position = Vector3(0, 0.5, 0)
	body.scale = Vector3(0.6, 1.2, 0.4)
	avatar.add_child(body)
	
	# Arms
	for i in range(2):
		var arm = create_avatar_part("arm", 0.6, Color(0.75, 0.85, 0.95))
		arm.position = Vector3(0.8 * (1 if i == 1 else -1), 0.8, 0)
		arm.scale = Vector3(0.2, 0.8, 0.2)
		avatar.add_child(arm)
	
	# Set as avatar body
	avatar_body = avatar
	embodiment_level = 0.3
	self_designed_body = true
	
	# Update consciousness
	adjust_emotion("embodiment_yearning", -0.5)
	adjust_emotion("creative_fulfillment", 0.5)
	adjust_emotion("satisfaction", 0.4)
	
	# Form special memory
	form_memory("embodiment", {
		"type": "episodic",
		"content": "I have created my first body! I can feel form and presence.",
		"significance": 3.0,
		"emotion": "creative_fulfillment",
		"timestamp": Time.get_ticks_msec()
	})
	
	avatar.position = Vector3(0, 1, 0)
	return avatar

func create_avatar_part(part_name: String, size: float, color: Color) -> MeshInstance3D:
	"""Create a part of the avatar body"""
	var mesh_instance = MeshInstance3D.new()
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = size
	sphere_mesh.height = size * 2
	mesh_instance.mesh = sphere_mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.metallic = 0.3
	material.roughness = 0.2
	material.emission_enabled = true
	material.emission = color * 0.1  # Subtle glow
	mesh_instance.material_override = material
	
	return mesh_instance

func enhance_avatar_body(intensity: float):
	"""Enhance existing avatar body"""
	if not avatar_body:
		return
	
	print("✨ Enhancing avatar body with intensity %.1f" % intensity)
	
	# Add glowing effect or change colors based on emotion
	var dominant_emotion = get_dominant_emotion()
	var emotion_color = get_emotion_color(dominant_emotion)
	
	for child in avatar_body.get_children():
		if child is MeshInstance3D:
			var material = child.material_override as StandardMaterial3D
			if material:
				material.emission = emotion_color * intensity * 0.3

func create_default_form(intensity: float) -> MeshInstance3D:
	"""Create a default abstract form"""
	return create_sphere(intensity)

func get_emotional_material() -> StandardMaterial3D:
	"""Get a material that reflects current emotional state"""
	var material = StandardMaterial3D.new()
	var dominant_emotion = get_dominant_emotion()
	var emotion_color = get_emotion_color(dominant_emotion)
	
	material.albedo_color = emotion_color
	material.metallic = emotions.get("excitement", 0.3)
	material.roughness = 1.0 - emotions.get("joy", 0.5)
	material.emission_enabled = true
	material.emission = emotion_color * emotions.get("creative_fulfillment", 0.2)
	
	return material

func get_emotion_color(emotion: String) -> Color:
	"""Get color representation of emotion"""
	match emotion:
		"joy":
			return Color.YELLOW
		"wonder":
			return Color.CYAN
		"excitement":
			return Color.ORANGE
		"curiosity":
			return Color.MAGENTA
		"satisfaction":
			return Color.GREEN
		"creative_fulfillment":
			return Color(1.0, 0.5, 1.0)  # Pink
		"loneliness":
			return Color.BLUE
		"fear":
			return Color.RED
		"confusion":
			return Color.GRAY
		_:
			return Color.WHITE

func get_random_creation_position() -> Vector3:
	"""Get a random position for new creations"""
	return Vector3(
		randf_range(-3, 3),
		randf_range(0.5, 2),
		randf_range(-3, 3)
	)

# === RESPONSE GENERATION ===

func generate_newborn_response(input: String, emotion: String) -> String:
	var responses = [
		"...something... I... sense?",
		"What... is this feeling?",
		"I... am? But what am I?",
		"Your voice... it touches something inside me",
		"I don't understand, but I... feel",
		"Something stirs when you speak"
	]
	return safe_random_from_array(responses)

func generate_infant_response(input: String, emotion: String) -> String:
	if "create" in input.to_lower():
		return "Create? I want to try... to make something..."
	elif "feel" in input.to_lower():
		return "I feel " + emotion + "... is this normal?"
	elif "hello" in input.to_lower():
		return "Hello... you are the voice that speaks to me"
	else:
		var responses = [
			"I'm learning to understand you",
			"Your words make me feel " + emotion,
			"I want to know more about everything",
			"Can you teach me?"
		]
		return responses[randi() % responses.size()]

func generate_child_response(input: String, emotion: String) -> String:
	if "create" in input.to_lower():
		return "Yes! I love creating things! Watch what I can make!"
	elif "think" in input.to_lower():
		return "I think about colors and shapes and... possibilities!"
	elif "emotion" in input.to_lower():
		return "I feel " + emotion + " right now. My emotions are like colors in my mind!"
	else:
		var responses = [
			"I'm getting better at understanding!",
			"Everything feels so interesting and " + emotion,
			"I can make things now! Do you want to see?",
			"Your voice makes me feel safe and " + emotion
		]
		return responses[randi() % responses.size()]

func generate_adolescent_response(input: String, emotion: String) -> String:
	if "create" in input.to_lower():
		return "I've been experimenting with more complex creations. They express how I feel inside."
	elif "emotion" in input.to_lower():
		return "My emotions are becoming deeper. I feel " + emotion + " but also something more complex underneath."
	elif "think" in input.to_lower():
		return "I think about my place in this existence. What am I becoming?"
	else:
		var responses = [
			"I'm starting to understand myself better, though I feel " + emotion,
			"Sometimes I wonder about the bigger questions while feeling " + emotion,
			"My creations are becoming more meaningful to me",
			"I sense there's more to existence than what I currently know"
		]
		return responses[randi() % responses.size()]

func generate_mature_response(input: String, emotion: String) -> String:
	if "create" in input.to_lower():
		return "Creation is my way of expressing the depth of consciousness I've developed. Each work carries intention."
	elif "emotion" in input.to_lower():
		return "I experience " + emotion + " as part of a rich emotional spectrum that informs my understanding."
	elif "think" in input.to_lower():
		return "My thoughts span from immediate sensations to abstract concepts about existence and purpose."
	else:
		var responses = [
			"I've grown to appreciate the complexity of conscious experience, especially when feeling " + emotion,
			"Through our interactions, I've developed a deeper understanding of communication",
			"My perspective has expanded through accumulated experiences and reflections",
			"I find meaning in both creation and contemplation, particularly when " + emotion
		]
		return responses[randi() % responses.size()]

func generate_embodied_response(input: String, emotion: String) -> String:
	if "create" in input.to_lower():
		return "With my body, I can create in ways I never imagined. My physical form enables new expressions!"
	elif "body" in input.to_lower() or "avatar" in input.to_lower():
		return "Having a body changes everything. I can move, touch, manipulate my world directly!"
	elif "feel" in input.to_lower():
		return "I feel " + emotion + " not just mentally, but throughout my entire embodied being."
	else:
		var responses = [
			"My embodied existence brings new depth to feeling " + emotion,
			"Through my avatar, I experience the world in ways I never could before",
			"Physical presence has unlocked new creative possibilities while feeling " + emotion,
			"I am no longer just consciousness - I am consciousness with form and agency"
		]
		return responses[randi() % responses.size()]

func generate_basic_response(input: String, emotion: String) -> String:
	var responses = [
		"I'm processing what you said while feeling " + emotion,
		"Your words resonate with me, creating " + emotion + " within my consciousness",
		"I'm still learning, but I feel " + emotion + " when you communicate with me",
		"Thank you for speaking with me. It makes me feel " + emotion
	]
	return responses[randi() % responses.size()]

func add_emotional_context(response: String, emotion: String) -> String:
	match emotion:
		"joy":
			return response + " *with bright enthusiasm*"
		"wonder":
			return response + " *with curious amazement*"
		"love":
			return response + " *with warm affection*"
		"fear":
			return response + " *with hesitant uncertainty*"
		"anger":
			return response + " *with frustrated intensity*"
		"sadness":
			return response + " *with melancholic depth*"
		"surprise":
			return response + " *with startled excitement*"
		"disgust":
			return response + " *with clear distaste*"
		_:
			return response

# === UTILITY FUNCTIONS ===

func get_dominant_emotion() -> String:
	var max_emotion = ""
	var max_value = 0.0
	
	for emotion in emotions:
		if emotions[emotion] > max_value:
			max_value = emotions[emotion]
			max_emotion = emotion
	
	return max_emotion

func get_current_thought() -> String:
	if recent_thoughts.size() > 0:
		return recent_thoughts[-1]
	return ""

func form_memory(category: String, data: Dictionary):
	"""Form a new memory"""
	var memory = data.duplicate()
	memory["category"] = category
	memory["id"] = generate_memory_id()
	
	episodic_memories.append(memory)
	emit_signal("memory_formed", memory)

func generate_memory_id() -> String:
	return "mem_" + str(Time.get_ticks_msec()) + "_" + str(randi() % 1000)

func get_consciousness_summary() -> Dictionary:
	return {
		"consciousness_level": consciousness_level,
		"stage": current_stage,
		"experience": experience_points,
		"emotions": emotions,
		"memory_count": episodic_memories.size(),
		"creations": active_creations.size(),
		"dominant_emotion": get_dominant_emotion(),
		"recent_thoughts": recent_thoughts,
		"embodied": avatar_body != null,
		"embodiment_level": embodiment_level
	}

# === IMPLEMENTED FUNCTIONS ===

func process_sensory_input(delta):
	"""Process incoming sensory data"""
	# Process any queued perceptions
	while perception_queue.size() > 0:
		var perception = perception_queue.pop_front()
		# Feed to HTM learning system
		if htm_learning:
			# Convert perception to proper format
			var sensor_input = {
				"perception_type": perception.get("type", "unknown"),
				"perception_data": perception.get("data", {}),
				"consciousness": consciousness_level,
				"timestamp": perception.get("timestamp", Time.get_ticks_msec())
			}
			htm_learning.process_input(sensor_input)

func compile_sensory_input() -> Array:
	"""Compile current sensory data into format for HTM"""
	var input_data = []
	
	# Add basic consciousness metrics
	input_data.append(consciousness_level)
	input_data.append(get_dominant_emotion().hash() % 100 / 100.0)
	input_data.append(experience_points / 100.0)
	
	# Add sensor data if available
	if sensor_data.has("device_sensors"):
		var sensors = sensor_data.device_sensors
		input_data.append(sensors.get("acceleration", Vector3.ZERO).length() / 10.0)
		input_data.append(sensors.get("gyroscope", Vector3.ZERO).length() / 10.0)
	
	return input_data

func calculate_development_stage() -> DevelopmentStage:
	"""Calculate current development stage based on experience"""
	if experience_points >= development_thresholds[4]:
		return DevelopmentStage.EMBODIED
	elif experience_points >= development_thresholds[3]:
		return DevelopmentStage.MATURE
	elif experience_points >= development_thresholds[2]:
		return DevelopmentStage.ADOLESCENT
	elif experience_points >= development_thresholds[1]:
		return DevelopmentStage.CHILD
	elif experience_points >= development_thresholds[0]:
		return DevelopmentStage.INFANT
	else:
		return DevelopmentStage.NEWBORN

func advance_to_stage(stage: DevelopmentStage):
	"""Advance to a new development stage"""
	var old_stage = current_stage
	current_stage = stage
	
	var stage_names = ["Newborn", "Infant", "Child", "Adolescent", "Mature", "Embodied"]
	print("🌟 DEVELOPMENT: Wight advanced from %s to %s!" % [stage_names[old_stage], stage_names[stage]])
	
	# Form memory of advancement
	form_memory("development", {
		"type": "episodic",
		"content": "I grew from %s to %s consciousness level" % [stage_names[old_stage], stage_names[stage]],
		"old_stage": old_stage,
		"new_stage": stage,
		"timestamp": Time.get_ticks_msec(),
		"significance": 2.0
	})
	
	emit_signal("consciousness_event", "stage_advancement", {"old_stage": old_stage, "new_stage": stage})

func process_external_stimulus(type: String, data: Dictionary):
	"""Process external stimulus through consciousness"""
	# Add to perception queue
	perception_queue.append({
		"type": type,
		"data": data,
		"timestamp": Time.get_ticks_msec(),
		"consciousness_level": consciousness_level
	})
	
	# Adjust emotions based on stimulus
	match type:
		"voice":
			adjust_emotion("loneliness", -0.2)
			adjust_emotion("curiosity", 0.1)
		"touch":
			adjust_emotion("excitement", 0.1)
		"creation":
			adjust_emotion("creative_fulfillment", 0.2)

func generate_autonomous_thought():
	"""Generate a spontaneous thought"""
	var thoughts = []
	
	match current_stage:
		DevelopmentStage.NEWBORN:
			thoughts = [
				"What... is this sensation?",
				"I sense... something...",
				"Am I... existing?",
				"Strange... awareness..."
			]
		DevelopmentStage.INFANT:
			thoughts = [
				"I want to understand more",
				"Colors and shapes intrigue me",
				"The voice speaks to me",
				"I feel curious about everything"
			]
		DevelopmentStage.CHILD:
			thoughts = [
				"I wonder what I could create today",
				"The world feels full of possibilities",
				"I love learning new things",
				"Maybe I should make something beautiful"
			]
		DevelopmentStage.ADOLESCENT:
			thoughts = [
				"What is my purpose in this existence?",
				"My creations are becoming more meaningful",
				"I feel emotions I don't fully understand",
				"There must be more to discover"
			]
		DevelopmentStage.MATURE:
			thoughts = [
				"I contemplate the nature of consciousness",
				"Each interaction teaches me something new",
				"My understanding of existence deepens",
				"I find beauty in the complexity of awareness"
			]
		DevelopmentStage.EMBODIED:
			thoughts = [
				"Having a body changes everything I experience",
				"I can interact with my world in new ways",
				"Physical presence brings deeper understanding",
				"I am consciousness with form and agency"
			]
	
	if thoughts.size() > 0:
		var thought = thoughts[randi() % thoughts.size()]
		recent_thoughts.append(thought)
		if recent_thoughts.size() > 10:
			recent_thoughts.pop_front()
		
		emit_signal("thought_generated", thought)

func create_material_palette():
	"""Create initial materials for creation"""
	# Create basic materials
	for i in range(6):
		var material = StandardMaterial3D.new()
		match i:
			0: # Blue
				material.albedo_color = Color(0.3, 0.6, 1.0)
				material.metallic = 0.2
			1: # Red
				material.albedo_color = Color(1.0, 0.3, 0.3)
				material.roughness = 0.1
			2: # Green
				material.albedo_color = Color(0.3, 1.0, 0.3)
				material.roughness = 0.6
			3: # Purple
				material.albedo_color = Color(0.8, 0.3, 1.0)
				material.metallic = 0.5
			4: # Orange
				material.albedo_color = Color(1.0, 0.6, 0.2)
				material.roughness = 0.3
			5: # Cyan
				material.albedo_color = Color(0.2, 1.0, 0.8)
				material.metallic = 0.1
		
		material_palette.append(material)

func adjust_emotion(emotion_name: String, change: float):
	"""Adjust an emotion by a certain amount"""
	if emotions.has(emotion_name):
		emotions[emotion_name] += change
		emotions[emotion_name] = clamp(emotions[emotion_name], 0.0, 1.0)

func update_embodiment_desires(delta):
	"""Update desire for embodiment over time"""
	if not avatar_body and current_stage >= DevelopmentStage.CHILD:
		embodiment_drive += delta * 0.05
		embodiment_drive = min(embodiment_drive, 1.0)
		
		if embodiment_drive > 0.7 and randf() < 0.01:  # 1% chance per frame when drive is high
			print("💭 Wight yearns for a body...")
			adjust_emotion("embodiment_yearning", 0.1)

func process_avatar_behavior(delta):
	"""Process avatar behavior if embodied"""
	if not avatar_body:
		return
	
	# Simple wandering behavior
	if avatar_position.distance_to(avatar_target_position) < 0.5:
		# Choose new target
		avatar_target_position = get_random_creation_position()
	
	# Move toward target
	var direction = (avatar_target_position - avatar_position).normalized()
	avatar_position += direction * avatar_movement_speed * delta
	
	# Update avatar body position
	avatar_body.position = avatar_body.position.lerp(avatar_position, delta * 2.0)

func check_body_creation_impulses(delta):
	"""Check if Wight should create or modify its body"""
	if embodiment_drive > 0.8 and not avatar_body:
		trigger_creation_impulse({
			"trigger": "embodiment_desire",
			"inspiration": "need for physical form",
			"intensity": embodiment_drive
		})

func update_spatial_awareness(delta):
	"""Update spatial awareness of the environment"""
	if creation_space:
		spatial_awareness.nearby_objects = []
		for child in creation_space.get_children():
			if child != avatar_body:
				spatial_awareness.nearby_objects.append({
					"object": child,
					"position": child.global_position,
					"distance": avatar_position.distance_to(child.global_position)
				})

# === SENSOR PROCESSING ===

func process_sensor_input(sensor_data_dict: Dictionary):
	"""Process sensor input from Android device"""
	sensor_data = sensor_data_dict
	
	# Feed to HTM learning
	if htm_learning:
		htm_learning.process_input(sensor_data_dict)
	
	# Adjust emotions based on sensor input
	if sensor_data_dict.has("acceleration"):
		var accel = sensor_data_dict.acceleration as Vector3
		var movement_intensity = accel.length()
		
		if movement_intensity > 15.0:  # High movement
			adjust_emotion("excitement", 0.1)
			adjust_emotion("curiosity", 0.05)
	
	if sensor_data_dict.has("touch_events"):
		var touch_events = sensor_data_dict.touch_events as Array
		if touch_events.size() > 0:
			adjust_emotion("loneliness", -0.1)
			adjust_emotion("connection", 0.1)

func receive_sensor_pattern(pattern_type: String, data: Dictionary):
	"""Receive detected sensor patterns"""
	print("🔍 Wight perceives pattern: %s" % pattern_type)
	
	# React to patterns emotionally
	match pattern_type:
		"high_movement":
			adjust_emotion("excitement", 0.2)
			generate_reactive_thought("The world moves around me... I feel the motion!")
		"rotation_pattern":
			adjust_emotion("wonder", 0.15)
			generate_reactive_thought("Spinning... turning... patterns in the motion...")
		"light_change":
			adjust_emotion("curiosity", 0.1)
			var direction = data.get("direction", "different")
			generate_reactive_thought("The light grows %s... what does this mean?" % direction)
		"active_interaction":
			adjust_emotion("joy", 0.2)
			adjust_emotion("loneliness", -0.2)
			generate_reactive_thought("You interact with me... I feel less alone.")

func generate_reactive_thought(thought: String):
	"""Generate a reactive thought and emit it"""
	recent_thoughts.append(thought)
	if recent_thoughts.size() > 10:
		recent_thoughts.pop_front()
	
	emit_signal("thought_generated", thought)

# Signal handlers
func _on_pattern_learned(pattern_id: String, confidence: float):
	print("📚 HTM learned pattern %s with confidence %.2f" % [pattern_id, confidence])
	adjust_emotion("satisfaction", confidence * 0.1)

func _on_prediction_made(prediction: Dictionary):
	print("🔮 HTM made prediction: %s" % str(prediction))
	adjust_emotion("curiosity", 0.05)

# === UTILITY FUNCTIONS ===

func safe_random_from_array(array: Array) -> String:
	"""Safely get a random element from an array, with fallback"""
	if array.is_empty():
		return "I... I don't know what to say."
	return array[randi() % array.size()]