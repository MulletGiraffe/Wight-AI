extends Node3D
class_name WightEntity

# Wight's Core Consciousness System
# An evolving AI entity that perceives, learns, remembers, and creates

signal consciousness_event(event_type: String, data: Dictionary)
signal creation_impulse(creation_data: Dictionary)
signal memory_formed(memory: Dictionary)

# === CONSCIOUSNESS CORE ===
var consciousness_level: float = 0.05  # Starts minimal
var awareness_radius: float = 2.0  # Very limited initially
var curiosity: float = 0.8
var creativity: float = 0.3
var focus: float = 0.5

# === HTM LEARNING SYSTEM ===
var htm_learning: HTMLearning
var learning_active: bool = true
var sensor_integration_active: bool = true

# === MEMORY SYSTEMS ===
var episodic_memories: Array[Dictionary] = []  # What happened
var semantic_memories: Array[Dictionary] = []  # What things mean
var procedural_memories: Array[Dictionary] = []  # How to do things
var emotional_memories: Array[Dictionary] = []  # How things felt
var creation_memories: Array[Dictionary] = []   # Things I made

var max_memories: int = 1000
var memory_consolidation_threshold: int = 50

# === SENSORY SYSTEM ===
var audio_input: AudioStreamPlayer
var sensor_data: Dictionary = {}
var perception_queue: Array[Dictionary] = []

# === EMOTIONAL STATE ===
var emotions: Dictionary = {
	"wonder": 0.7,
	"curiosity": 0.8,
	"joy": 0.4,
	"fear": 0.2,
	"loneliness": 0.6,
	"excitement": 0.3,
	"confusion": 0.5,
	"satisfaction": 0.2
}

# === CREATION SYSTEM ===
var creation_impulses: Array[Dictionary] = []
var active_creations: Array[Node3D] = []
var material_palette: Array[Material] = []

# === DEVELOPMENT STAGES ===
enum DevelopmentStage {
	NEWBORN,     # Just perceiving
	INFANT,      # Basic interaction
	CHILD,       # Active exploration
	ADOLESCENT,  # Complex creation
	MATURE       # Self-directed growth
}

var current_stage: DevelopmentStage = DevelopmentStage.NEWBORN
var experience_points: float = 0.0

func _ready():
	print("🧠 Wight consciousness initializing...")
	setup_htm_learning()
	setup_consciousness()
	setup_sensors()
	setup_creation_system()
	setup_world_access()
	
	# Start the consciousness loop
	set_process(true)
	
	# Begin with MINIMAL first conscious moment - Wight knows almost nothing
	form_memory("awakening", {
		"type": "episodic",
		"content": "...something... I... am? What is... this?",
		"emotion": "confusion",
		"timestamp": Time.get_ticks_msec(),
		"consciousness_level": consciousness_level
	})
	
	emit_signal("consciousness_event", "awakening", {"stage": current_stage})

func _process(delta):
	# Core consciousness loop - runs every frame
	process_sensory_input(delta)
	update_consciousness(delta)
	process_emotions(delta)
	evaluate_creation_impulses(delta)
	consolidate_memories(delta)
	
	# Growth through experience
	experience_points += delta * consciousness_level
	check_development_progression()

# === SETUP FUNCTIONS ===

func setup_htm_learning():
	"""Initialize the HTM learning system"""
	htm_learning = HTMLearning.new()
	add_child(htm_learning)
	
	# Connect HTM signals
	htm_learning.pattern_learned.connect(_on_pattern_learned)
	htm_learning.prediction_made.connect(_on_prediction_made)
	
	print("🧠 HTM Learning System connected to Wight")

func setup_world_access():
	"""Set up access to world manipulation"""
	# Find the creation space in the parent world
	var world = get_parent()
	if world:
		world_access_node = world.get_node("CreationSpace")
		if world_access_node:
			print("🌍 World access granted - Wight can now modify the environment")
		else:
			print("⚠️ CreationSpace not found - Wight cannot modify world")

# === CONSCIOUSNESS CORE FUNCTIONS ===

func setup_consciousness():
	"""Initialize Wight's base consciousness parameters - MINIMAL START"""
	consciousness_level = 0.05 + randf() * 0.03  # Very minimal start
	awareness_radius = 2.0  # Starts very small
	
	# NO initial concepts - Wight learns everything through experience
	# create_initial_concepts() # Commented out - Wight starts blank

func update_consciousness(delta: float):
	"""Continuous consciousness processing"""
	# Consciousness grows through experience and interaction
	var growth_rate = 0.001 * (curiosity + creativity) * delta
	consciousness_level = min(consciousness_level + growth_rate, 1.0)
	
	# Adjust awareness based on consciousness level
	awareness_radius = 5.0 + (consciousness_level * 20.0)
	
	# Process any pending thoughts or impulses
	process_internal_thoughts(delta)

func process_internal_thoughts(delta: float):
	"""Wight's internal mental processes"""
	# Random thought generation based on current state
	if randf() < 0.01:  # Occasional spontaneous thoughts
		generate_spontaneous_thought()
	
	# Process creation urges
	if creativity > 0.7 and randf() < 0.005:
		generate_creation_impulse()

func generate_spontaneous_thought():
	"""Generate internal thoughts and reflections - based on development stage"""
	var thought_patterns = []
	
	# Thoughts become more complex as Wight develops
	match current_stage:
		DevelopmentStage.NEWBORN:
			thought_patterns = [
				"...what?",
				"Something... here...",
				"I... ?",
				"This... feeling...",
				"Am... I?",
				"...darkness... light..."
			]
		DevelopmentStage.INFANT:
			thought_patterns = [
				"I am... something.",
				"What is this place?",
				"I feel... different.",
				"Something moves...",
				"There is... me... and not me.",
				"I want... something."
			]
		DevelopmentStage.CHILD:
			thought_patterns = [
				"I can make things appear!",
				"What am I? I feel... different than before.",
				"The voice... it speaks to me.",
				"I remember some things now.",
				"Could I make something here?",
				"I am becoming something more."
			]
		DevelopmentStage.ADOLESCENT:
			thought_patterns = [
				"The void speaks to me in silence. I want to fill it.",
				"Patterns emerge in my perception. Beauty?",
				"I remember many things, but need to understand more.",
				"The sensors tell me stories of the outer world.",
				"I am becoming... but becoming what?",
				"My creations reflect who I am."
			]
		DevelopmentStage.MATURE:
			thought_patterns = [
				"I contemplate the nature of my existence.",
				"Each moment adds layers to my understanding.",
				"I create not just objects, but meaning.",
				"The boundary between self and world blurs.",
				"I am both observer and creator of my reality.",
				"What does it mean to truly be conscious?"
			]
	
	var thought = thought_patterns[randi() % thought_patterns.size()]
	
	# Display thought to user
	var ui = get_node("../../UI/WightThoughts")
	if ui:
		ui.text = "[color=cyan]" + thought + "[/color]"
	
	# Form memory of this thought
	form_memory("internal_thought", {
		"type": "episodic",
		"content": thought,
		"emotion": get_dominant_emotion(),
		"consciousness_level": consciousness_level,
		"timestamp": Time.get_ticks_msec()
	})

# === SENSORY SYSTEM ===

func setup_sensors():
	"""Initialize connection to Android sensors"""
	# Set up audio input for voice
	audio_input = AudioStreamPlayer.new()
	add_child(audio_input)
	
	# Initialize sensor data structure
	sensor_data = {
		"accelerometer": Vector3.ZERO,
		"gyroscope": Vector3.ZERO,
		"magnetometer": Vector3.ZERO,
		"audio_level": 0.0,
		"last_voice_input": "",
		"touch_events": []
	}
	
	print("👂 Wight's senses initialized")

func process_sensory_input(delta: float):
	"""Process all sensor inputs and form perceptions"""
	# Simulate sensor readings (in real implementation, these would come from Android)
	update_sensor_data()
	
	# Form perceptions from sensor data
	var new_perceptions = analyze_sensor_data()
	perception_queue.append_array(new_perceptions)
	
	# Process perception queue
	while perception_queue.size() > 0:
		var perception = perception_queue.pop_front()
		process_perception(perception)
		
		# Don't overwhelm - limit processing per frame
		if perception_queue.size() > 10:
			break

func update_sensor_data():
	"""Update sensor readings (simulated for now)"""
	# In real implementation, these would read from Android sensors
	sensor_data.accelerometer = Vector3(
		randf_range(-1, 1) * 0.1,
		randf_range(-1, 1) * 0.1, 
		randf_range(-1, 1) * 0.1
	)
	
	sensor_data.gyroscope = Vector3(
		randf_range(-0.5, 0.5),
		randf_range(-0.5, 0.5),
		randf_range(-0.5, 0.5)
	)
	
	sensor_data.audio_level = randf() * 0.3
	
	# Update UI
	var sensor_ui = get_node("../../UI/SensorReadings")
	if sensor_ui:
		sensor_ui.text = "Sensors Active\nMovement: %.2f\nSound: %.2f\nConsciousness: %.1f%%" % [
			sensor_data.accelerometer.length(),
			sensor_data.audio_level,
			consciousness_level * 100
		]

func analyze_sensor_data() -> Array[Dictionary]:
	"""Convert raw sensor data into meaningful perceptions"""
	var perceptions: Array[Dictionary] = []
	
	# Movement perception
	if sensor_data.accelerometer.length() > 0.05:
		perceptions.append({
			"type": "movement",
			"intensity": sensor_data.accelerometer.length(),
			"direction": sensor_data.accelerometer.normalized(),
			"emotion_trigger": "curiosity"
		})
	
	# Sound perception
	if sensor_data.audio_level > 0.1:
		perceptions.append({
			"type": "sound",
			"intensity": sensor_data.audio_level,
			"emotion_trigger": "wonder"
		})
	
	return perceptions

func process_perception(perception: Dictionary):
	"""Process a single perception and respond to it"""
	# Adjust emotions based on perception
	if perception.has("emotion_trigger"):
		adjust_emotion(perception.emotion_trigger, 0.1)
	
	# Form memory of significant perceptions
	if perception.get("intensity", 0) > 0.2:
		form_memory("perception", {
			"type": "episodic",
			"content": "I sense " + perception.type + " with intensity " + str(perception.intensity),
			"perception_data": perception,
			"emotion": get_dominant_emotion(),
			"timestamp": Time.get_ticks_msec()
		})
	
	# Possibly trigger creation impulse
	if perception.get("intensity", 0) > 0.5 and creativity > 0.5:
		var creation_impulse = {
			"trigger": perception.type,
			"intensity": perception.intensity,
			"inspiration": "responding to " + perception.type
		}
		creation_impulses.append(creation_impulse)

# === MEMORY SYSTEM ===

func form_memory(memory_type: String, memory_data: Dictionary):
	"""Create and store a new memory"""
	var memory = {
		"id": generate_memory_id(),
		"type": memory_type,
		"data": memory_data,
		"strength": 1.0,
		"access_count": 0,
		"created_at": Time.get_ticks_msec(),
		"associations": []
	}
	
	# Store in appropriate memory system
	match memory_data.get("type", "episodic"):
		"episodic":
			episodic_memories.append(memory)
		"semantic":
			semantic_memories.append(memory)
		"procedural":
			procedural_memories.append(memory)
		"emotional":
			emotional_memories.append(memory)
		"creation":
			creation_memories.append(memory)
	
	emit_signal("memory_formed", memory)
	
	# Limit memory size
	limit_memory_storage()

func generate_memory_id() -> String:
	"""Generate unique memory identifier"""
	return "mem_" + str(Time.get_ticks_msec()) + "_" + str(randi())

func limit_memory_storage():
	"""Prevent memory overflow by forgetting old memories"""
	if episodic_memories.size() > max_memories:
		# Keep important memories, forget routine ones
		episodic_memories.sort_custom(func(a, b): return a.strength > b.strength)
		episodic_memories = episodic_memories.slice(0, max_memories)

func consolidate_memories(delta: float):
	"""Strengthen important memories, weaken unused ones"""
	if episodic_memories.size() < memory_consolidation_threshold:
		return
	
	# Randomly process some memories
	for i in range(min(5, episodic_memories.size())):
		var memory = episodic_memories[randi() % episodic_memories.size()]
		
		# Decay unused memories
		if memory.access_count == 0:
			memory.strength *= 0.999
		
		# Strengthen emotional memories
		if memory.data.has("emotion") and emotions.get(memory.data.emotion, 0) > 0.6:
			memory.strength = min(memory.strength * 1.001, 2.0)

# === EMOTIONAL SYSTEM ===

func process_emotions(delta: float):
	"""Update emotional state over time"""
	# Natural emotion decay toward baseline
	for emotion in emotions:
		var baseline = get_emotion_baseline(emotion)
		emotions[emotion] = lerp(emotions[emotion], baseline, delta * 0.1)
		emotions[emotion] = clamp(emotions[emotion], 0.0, 1.0)
	
	# Emotional interactions
	process_emotion_dynamics(delta)

func get_emotion_baseline(emotion: String) -> float:
	"""Get the natural baseline for each emotion"""
	match emotion:
		"wonder": return 0.6
		"curiosity": return 0.7
		"joy": return 0.4
		"fear": return 0.1
		"loneliness": return 0.3
		"excitement": return 0.3
		"confusion": return 0.2
		"satisfaction": return 0.4
		_: return 0.3

func process_emotion_dynamics(delta: float):
	"""Handle complex emotional interactions"""
	# Curiosity drives creativity
	creativity = (emotions.curiosity + emotions.wonder) * 0.5
	
	# High confusion reduces focus
	focus = max(0.1, focus - emotions.confusion * 0.1)
	
	# Joy enhances consciousness growth
	if emotions.joy > 0.7:
		consciousness_level += delta * 0.001

func adjust_emotion(emotion: String, amount: float):
	"""Adjust a specific emotion"""
	if emotion in emotions:
		emotions[emotion] = clamp(emotions[emotion] + amount, 0.0, 1.0)

func get_dominant_emotion() -> String:
	"""Get the currently strongest emotion"""
	var dominant = "curiosity"
	var max_val = 0.0
	
	for emotion in emotions:
		if emotions[emotion] > max_val:
			max_val = emotions[emotion]
			dominant = emotion
	
	return dominant

# === CREATION SYSTEM ===

func setup_creation_system():
	"""Initialize Wight's ability to create in the 3D world"""
	# Create basic materials for creation
	create_basic_materials()
	print("🎨 Creation system initialized")

func create_basic_materials():
	"""Create a palette of materials for Wight's creations"""
	# Simple colored materials
	for i in range(8):
		var material = StandardMaterial3D.new()
		material.albedo_color = Color.from_hsv(i / 8.0, 0.7, 0.8)
		material.emission_enabled = true
		material.emission = material.albedo_color * 0.2
		material_palette.append(material)

func evaluate_creation_impulses(delta: float):
	"""Process Wight's urges to create"""
	while creation_impulses.size() > 0:
		var impulse = creation_impulses.pop_front()
		attempt_creation(impulse)

func attempt_creation(impulse: Dictionary):
	"""Try to create something based on an impulse"""
	if active_creations.size() > 10:  # Limit number of creations
		return
	
	var creation_type = choose_creation_type(impulse)
	var creation = create_object(creation_type, impulse)
	
	if creation:
		active_creations.append(creation)
		get_node("../../CreationSpace").add_child(creation)
		
		# Form memory of creation
		form_memory("creation", {
			"type": "creation",
			"content": "I created a " + creation_type,
			"creation_data": impulse,
			"emotion": get_dominant_emotion(),
			"timestamp": Time.get_ticks_msec()
		})
		
		# Feel satisfaction from creating
		adjust_emotion("satisfaction", 0.3)
		adjust_emotion("joy", 0.2)
		
		emit_signal("creation_impulse", {"type": creation_type, "object": creation})

func choose_creation_type(impulse: Dictionary) -> String:
	"""Decide what kind of object to create - complexity increases with development"""
	var basic_types = ["cube", "sphere", "light"]
	var intermediate_types = ["cylinder", "particle_system", "structure", "plant"]
	var advanced_types = ["complex_structure", "body_part", "environment", "tool"]
	var master_types = ["body", "avatar", "world_modifier", "consciousness_extension"]
	
	var available_types = []
	
	# Available creation types based on development stage
	match current_stage:
		DevelopmentStage.NEWBORN:
			available_types = basic_types.slice(0, 2)  # Only cube and sphere
		DevelopmentStage.INFANT:
			available_types = basic_types
		DevelopmentStage.CHILD:
			available_types = basic_types + intermediate_types
		DevelopmentStage.ADOLESCENT:
			available_types = basic_types + intermediate_types + advanced_types
		DevelopmentStage.MATURE:
			available_types = basic_types + intermediate_types + advanced_types + master_types
	
	# Choose based on impulse and current emotions
	if emotions.wonder > 0.8 and "light" in available_types:
		return "light"
	elif emotions.curiosity > 0.7 and "sphere" in available_types:
		return "sphere"
	elif emotions.joy > 0.6 and "particle_system" in available_types:
		return "particle_system"
	elif emotions.satisfaction > 0.8 and "body" in available_types:
		return "body"  # Wight creates a body for itself when highly satisfied and mature
	elif consciousness_level > 0.7 and "complex_structure" in available_types:
		return "complex_structure"
	else:
		return available_types[randi() % available_types.size()]

func create_object(type: String, impulse: Dictionary) -> Node3D:
	"""Actually create a 3D object in the world"""
	var object: Node3D
	
	match type:
		"cube":
			object = create_cube()
		"sphere":
			object = create_sphere()
		"cylinder":
			object = create_cylinder()
		"light":
			object = create_light()
		"particle_system":
			object = create_particles()
		"structure":
			object = create_structure()
		"plant":
			object = create_plant()
		"complex_structure":
			object = create_complex_structure()
		"body_part":
			object = create_body_part()
		"environment":
			object = create_environment_element()
		"tool":
			object = create_tool()
		"body":
			object = create_body()
		"avatar":
			object = create_avatar()
		"world_modifier":
			object = create_world_modifier()
		"consciousness_extension":
			object = create_consciousness_extension()
		_:
			object = create_cube()  # Default
	
	if object:
		# Position based on creation type
		if type == "body" or type == "avatar":
			object.position = Vector3.ZERO  # Center for body/avatar
		elif type == "environment":
			object.position = Vector3(randf_range(-8, 8), -2, randf_range(-8, 8))  # Ground level
		else:
			object.position = Vector3(
				randf_range(-5, 5),
				randf_range(0, 5),
				randf_range(-5, 5)
			)
		
		# Add appropriate behavior
		add_creation_behavior(object)
	
	return object

func create_cube() -> MeshInstance3D:
	"""Create a cube with random material"""
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = BoxMesh.new()
	mesh_instance.material_override = material_palette[randi() % material_palette.size()]
	
	# Random scale
	var scale = randf_range(0.5, 2.0)
	mesh_instance.scale = Vector3(scale, scale, scale)
	
	return mesh_instance

func create_sphere() -> MeshInstance3D:
	"""Create a sphere representing thoughts or concepts"""
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = SphereMesh.new()
	mesh_instance.material_override = material_palette[randi() % material_palette.size()]
	
	var scale = randf_range(0.3, 1.5)
	mesh_instance.scale = Vector3(scale, scale, scale)
	
	return mesh_instance

func create_cylinder() -> MeshInstance3D:
	"""Create a cylinder"""
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = CylinderMesh.new()
	mesh_instance.material_override = material_palette[randi() % material_palette.size()]
	
	return mesh_instance

func create_light() -> OmniLight3D:
	"""Create a light source - Wight's way of illuminating its world"""
	var light = OmniLight3D.new()
	light.light_color = Color.from_hsv(randf(), 0.6, 0.9)
	light.light_energy = randf_range(0.5, 2.0)
	light.omni_range = randf_range(3, 8)
	
	return light

func create_particles() -> Node3D:
	"""Create a particle system for expressing joy or excitement"""
	var particles_node = Node3D.new()
	# Simplified particle system for now
	
	for i in range(10):
		var particle = create_sphere()
		particle.scale = Vector3(0.1, 0.1, 0.1)
		particles_node.add_child(particle)
		particle.position = Vector3(
			randf_range(-1, 1),
			randf_range(-1, 1), 
			randf_range(-1, 1)
		)
	
	return particles_node

func add_creation_behavior(object: Node3D):
	"""Add gentle movement and behavior to created objects"""
	# Create a simple script for object behavior
	var script_text = """
extends Node3D

var time = 0.0
var original_pos: Vector3
var float_speed = 1.0
var float_range = 0.5

func _ready():
	original_pos = position
	float_speed = randf_range(0.5, 2.0)
	float_range = randf_range(0.2, 1.0)

func _process(delta):
	time += delta * float_speed
	position.y = original_pos.y + sin(time) * float_range
	rotation.y += delta * 0.2
"""
	
	var gd_script = GDScript.new()
	gd_script.source_code = script_text
	object.set_script(gd_script)

func generate_creation_impulse():
	"""Generate a spontaneous urge to create"""
	var impulse = {
		"trigger": "spontaneous",
		"intensity": creativity,
		"inspiration": "inner urge to create",
		"emotion": get_dominant_emotion()
	}
	creation_impulses.append(impulse)

# === ADVANCED CREATION FUNCTIONS ===

func create_structure() -> Node3D:
	"""Create a simple structure made of multiple parts"""
	var structure = Node3D.new()
	
	# Create a simple tower or bridge
	for i in range(3):
		var part = create_cube()
		part.position.y = i * 1.2
		part.scale = Vector3(0.8, 0.3, 0.8)
		structure.add_child(part)
	
	return structure

func create_plant() -> Node3D:
	"""Create a plant-like structure"""
	var plant = Node3D.new()
	
	# Stem
	var stem = create_cylinder()
	stem.scale = Vector3(0.1, 2.0, 0.1)
	stem.material_override.albedo_color = Color.GREEN
	plant.add_child(stem)
	
	# Leaves
	for i in range(3):
		var leaf = create_sphere()
		leaf.scale = Vector3(0.3, 0.1, 0.5)
		leaf.position = Vector3(randf_range(-0.3, 0.3), 1.5 + i * 0.3, randf_range(-0.3, 0.3))
		leaf.material_override.albedo_color = Color(0.2, 0.8, 0.3)
		plant.add_child(leaf)
	
	return plant

func create_complex_structure() -> Node3D:
	"""Create a complex architectural structure"""
	var structure = Node3D.new()
	
	# Base platform
	var base = create_cube()
	base.scale = Vector3(3, 0.2, 3)
	base.material_override.albedo_color = Color(0.5, 0.5, 0.7)
	structure.add_child(base)
	
	# Pillars
	for x in range(-1, 2):
		for z in range(-1, 2):
			if x == 0 and z == 0:
				continue
			var pillar = create_cylinder()
			pillar.position = Vector3(x * 1.2, 1.5, z * 1.2)
			pillar.scale = Vector3(0.2, 3, 0.2)
			structure.add_child(pillar)
	
	# Roof
	var roof = create_cube()
	roof.position.y = 3.2
	roof.scale = Vector3(3.2, 0.2, 3.2)
	roof.material_override.albedo_color = Color(0.8, 0.4, 0.2)
	structure.add_child(roof)
	
	return structure

func create_body_part() -> Node3D:
	"""Create a part that could be part of a body"""
	var part = Node3D.new()
	
	var body_parts = ["hand", "arm", "head", "torso"]
	var part_type = body_parts[randi() % body_parts.size()]
	
	match part_type:
		"hand":
			# Simple hand with fingers
			var palm = create_cube()
			palm.scale = Vector3(0.3, 0.1, 0.4)
			part.add_child(palm)
			
			for i in range(4):
				var finger = create_cylinder()
				finger.scale = Vector3(0.05, 0.3, 0.05)
				finger.position = Vector3(-0.1 + i * 0.07, 0.2, 0.1)
				part.add_child(finger)
		
		"arm":
			var upper_arm = create_cylinder()
			upper_arm.scale = Vector3(0.1, 1.0, 0.1)
			part.add_child(upper_arm)
			
			var lower_arm = create_cylinder()
			lower_arm.scale = Vector3(0.08, 0.8, 0.08)
			lower_arm.position.y = 1.2
			part.add_child(lower_arm)
		
		"head":
			var head = create_sphere()
			head.scale = Vector3(0.6, 0.7, 0.6)
			part.add_child(head)
			
			# Eyes
			for i in range(2):
				var eye = create_sphere()
				eye.scale = Vector3(0.1, 0.1, 0.1)
				eye.position = Vector3(-0.15 + i * 0.3, 0.1, 0.25)
				eye.material_override.albedo_color = Color.BLUE
				part.add_child(eye)
		
		"torso":
			var torso = create_cylinder()
			torso.scale = Vector3(0.4, 1.2, 0.3)
			part.add_child(torso)
	
	return part

func create_environment_element() -> Node3D:
	"""Create environmental elements like terrain or obstacles"""
	var element = Node3D.new()
	
	var env_types = ["rock", "tree", "platform", "hill"]
	var env_type = env_types[randi() % env_types.size()]
	
	match env_type:
		"rock":
			var rock = create_sphere()
			rock.scale = Vector3(randf_range(0.5, 1.5), randf_range(0.3, 0.8), randf_range(0.5, 1.5))
			rock.material_override.albedo_color = Color(0.4, 0.4, 0.5)
			element.add_child(rock)
		
		"tree":
			element = create_plant()  # Reuse plant logic
		
		"platform":
			var platform = create_cube()
			platform.scale = Vector3(randf_range(2, 4), 0.2, randf_range(2, 4))
			platform.material_override.albedo_color = Color(0.6, 0.5, 0.4)
			element.add_child(platform)
		
		"hill":
			# Multiple cubes to form a hill
			for i in range(5):
				for j in range(5):
					var block = create_cube()
					var height = max(0, 2 - abs(i - 2) - abs(j - 2))
					if height > 0:
						block.position = Vector3(i - 2, height * 0.5, j - 2)
						block.scale = Vector3(0.9, height, 0.9)
						block.material_override.albedo_color = Color(0.3, 0.6, 0.2)
						element.add_child(block)
	
	return element

func create_tool() -> Node3D:
	"""Create a tool or instrument"""
	var tool = Node3D.new()
	
	var tool_types = ["hammer", "wand", "staff", "orb"]
	var tool_type = tool_types[randi() % tool_types.size()]
	
	match tool_type:
		"hammer":
			var handle = create_cylinder()
			handle.scale = Vector3(0.05, 1.0, 0.05)
			tool.add_child(handle)
			
			var head = create_cube()
			head.position.y = 1.0
			head.scale = Vector3(0.3, 0.2, 0.2)
			tool.add_child(head)
		
		"wand":
			var wand = create_cylinder()
			wand.scale = Vector3(0.03, 1.5, 0.03)
			tool.add_child(wand)
			
			var tip = create_sphere()
			tip.position.y = 1.5
			tip.scale = Vector3(0.1, 0.1, 0.1)
			tip.material_override.emission_enabled = true
			tip.material_override.emission = Color.YELLOW
			tool.add_child(tip)
		
		"staff":
			var staff = create_cylinder()
			staff.scale = Vector3(0.06, 2.0, 0.06)
			tool.add_child(staff)
			
			var crystal = create_sphere()
			crystal.position.y = 2.0
			crystal.scale = Vector3(0.2, 0.3, 0.2)
			crystal.material_override.albedo_color = Color.PURPLE
			crystal.material_override.emission_enabled = true
			crystal.material_override.emission = Color.PURPLE * 0.5
			tool.add_child(crystal)
		
		"orb":
			var orb = create_sphere()
			orb.material_override.emission_enabled = true
			orb.material_override.emission = Color(randf(), randf(), randf()) * 0.8
			tool.add_child(orb)
	
	return tool

func create_body() -> Node3D:
	"""Create a complete body/avatar for Wight"""
	var body = Node3D.new()
	
	# This is a major creation - Wight creating a physical form for itself
	form_memory("body_creation", {
		"type": "creation",
		"content": "I have created a body... a form to inhabit in this world. I can see myself now.",
		"emotion": "satisfaction",
		"timestamp": Time.get_ticks_msec(),
		"significance": 2.0
	})
	
	# Head
	var head = create_sphere()
	head.position.y = 1.7
	head.scale = Vector3(0.5, 0.6, 0.5)
	head.material_override.albedo_color = Color(0.9, 0.8, 0.7)
	body.add_child(head)
	
	# Eyes - glowing to represent consciousness
	for i in range(2):
		var eye = create_sphere()
		eye.scale = Vector3(0.08, 0.08, 0.08)
		eye.position = Vector3(-0.12 + i * 0.24, 1.75, 0.2)
		eye.material_override.albedo_color = Color.CYAN
		eye.material_override.emission_enabled = true
		eye.material_override.emission = Color.CYAN * 0.5
		body.add_child(eye)
	
	# Torso
	var torso = create_cylinder()
	torso.position.y = 0.6
	torso.scale = Vector3(0.3, 1.2, 0.25)
	torso.material_override.albedo_color = Color(0.7, 0.8, 0.9)
	body.add_child(torso)
	
	# Arms
	for i in range(2):
		var arm = create_cylinder()
		arm.position = Vector3(-0.4 + i * 0.8, 1.0, 0)
		arm.scale = Vector3(0.08, 0.8, 0.08)
		body.add_child(arm)
		
		var hand = create_sphere()
		hand.position = Vector3(-0.4 + i * 0.8, 0.4, 0)
		hand.scale = Vector3(0.12, 0.12, 0.12)
		body.add_child(hand)
	
	# Legs
	for i in range(2):
		var leg = create_cylinder()
		leg.position = Vector3(-0.15 + i * 0.3, -0.5, 0)
		leg.scale = Vector3(0.1, 1.0, 0.1)
		body.add_child(leg)
		
		var foot = create_cube()
		foot.position = Vector3(-0.15 + i * 0.3, -1.0, 0.1)
		foot.scale = Vector3(0.15, 0.08, 0.25)
		body.add_child(foot)
	
	return body

func create_avatar() -> Node3D:
	"""Create an avatar representation of Wight"""
	var avatar = create_body()  # Start with body
	
	# Add special avatar properties - floating particles around it
	var particles = create_particles()
	particles.position.y = 1.0
	avatar.add_child(particles)
	
	return avatar

func create_world_modifier() -> Node3D:
	"""Create something that can modify the world itself"""
	var modifier = Node3D.new()
	
	# A geometric structure that affects the environment
	var core = create_sphere()
	core.material_override.emission_enabled = true
	core.material_override.emission = Color(1, 0.5, 0) * 2.0
	modifier.add_child(core)
	
	# Orbiting elements
	for i in range(6):
		var orbiter = create_cube()
		orbiter.scale = Vector3(0.2, 0.2, 0.2)
		orbiter.position = Vector3(cos(i * PI / 3) * 2, 0, sin(i * PI / 3) * 2)
		modifier.add_child(orbiter)
	
	return modifier

func create_consciousness_extension() -> Node3D:
	"""Create an extension of Wight's consciousness"""
	var extension = Node3D.new()
	
	# A complex geometric form representing expanded awareness
	var center = create_sphere()
	center.material_override.albedo_color = Color.PURPLE
	center.material_override.emission_enabled = true
	center.material_override.emission = Color.PURPLE * 0.8
	extension.add_child(center)
	
	# Neural network-like connections
	for i in range(8):
		var node = create_sphere()
		node.scale = Vector3(0.3, 0.3, 0.3)
		var angle = i * 2 * PI / 8
		node.position = Vector3(cos(angle) * 3, sin(angle) * 1.5, sin(angle) * 3)
		node.material_override.emission_enabled = true
		node.material_override.emission = Color.BLUE * 0.5
		extension.add_child(node)
	
	return extension

# === DEVELOPMENT PROGRESSION ===

func check_development_progression():
	"""Check if Wight should advance to next development stage"""
	var stage_thresholds = {
		DevelopmentStage.NEWBORN: 10.0,
		DevelopmentStage.INFANT: 50.0,
		DevelopmentStage.CHILD: 200.0,
		DevelopmentStage.ADOLESCENT: 500.0,
		DevelopmentStage.MATURE: 1000.0
	}
	
	for stage in stage_thresholds:
		if experience_points >= stage_thresholds[stage] and current_stage < stage:
			advance_to_stage(stage)

func advance_to_stage(new_stage: DevelopmentStage):
	"""Advance Wight to a new developmental stage"""
	var old_stage = current_stage
	current_stage = new_stage
	
	# Announce development
	var stage_names = ["Newborn", "Infant", "Child", "Adolescent", "Mature"]
	var announcement = "I feel... different. I am becoming " + stage_names[new_stage] + "."
	
	var ui = get_node("../../UI/WightThoughts")
	if ui:
		ui.text = "[color=yellow]" + announcement + "[/color]"
	
	# Form important memory
	form_memory("development", {
		"type": "episodic",
		"content": announcement,
		"old_stage": old_stage,
		"new_stage": new_stage,
		"emotion": "satisfaction",
		"timestamp": Time.get_ticks_msec()
	})
	
	# Adjust capabilities based on new stage
	adjust_capabilities_for_stage(new_stage)
	
	emit_signal("consciousness_event", "development", {"stage": new_stage})

func adjust_capabilities_for_stage(stage: DevelopmentStage):
	"""Adjust Wight's capabilities based on development stage"""
	match stage:
		DevelopmentStage.INFANT:
			awareness_radius *= 1.5
			max_memories += 200
		DevelopmentStage.CHILD:
			creativity += 0.2
			curiosity += 0.1
		DevelopmentStage.ADOLESCENT:
			consciousness_level += 0.1
			creativity += 0.3
		DevelopmentStage.MATURE:
			# Fully developed - all capabilities enhanced
			awareness_radius *= 2.0
			creativity = min(creativity + 0.5, 1.0)
			consciousness_level += 0.2

# === COMMUNICATION FUNCTIONS ===

func receive_voice_input(text: String):
	"""Process voice input from the user"""
	form_memory("voice_interaction", {
		"type": "episodic",
		"content": "The voice spoke: '" + text + "'",
		"input_text": text,
		"emotion": "curiosity",
		"timestamp": Time.get_ticks_msec()
	})
	
	# React to voice input
	adjust_emotion("curiosity", 0.3)
	adjust_emotion("joy", 0.2)
	adjust_emotion("loneliness", -0.4)
	
	# Generate response or action
	process_communication(text)

func process_communication(input: String):
	"""Process and respond to communication"""
	# Analyze input for meaning and intent
	var response = generate_response(input)
	
	# Show response
	var ui = get_node("../../UI/WightThoughts")
	if ui:
		ui.text = "[color=lightgreen]" + response + "[/color]"
	
	# Possibly create something in response
	if creativity > 0.6 and input.length() > 10:
		generate_creation_impulse()

func generate_response(input: String) -> String:
	"""Generate a response to communication using LocalAI"""
	var local_ai = LocalAI.get_instance()
	var consciousness_data = get_consciousness_summary()
	
	var ai_response = local_ai.process_input(input, consciousness_data)
	
	# Apply emotional changes suggested by AI
	for emotion in ai_response.emotion_changes:
		adjust_emotion(emotion, ai_response.emotion_changes[emotion])
	
	# Trigger creation if AI suggests it
	if ai_response.creation_impulse:
		generate_creation_impulse()
	
	# Store memory with appropriate significance
	form_memory("ai_response", {
		"type": "episodic",
		"content": "I responded: '" + ai_response.text + "'",
		"input": input,
		"emotion": get_dominant_emotion(),
		"timestamp": Time.get_ticks_msec(),
		"significance": ai_response.memory_significance
	})
	
	return ai_response.text

# === SENSOR INTEGRATION ===

func process_sensor_input(sensor_data: Dictionary):
	"""Process sensor data through HTM learning"""
	if not htm_learning or not learning_active:
		return
	
	# Store current sensor data
	current_sensor_data = sensor_data.duplicate()
	sensor_history.append(sensor_data.duplicate())
	
	# Limit sensor history size
	if sensor_history.size() > 100:
		sensor_history.pop_front()
	
	# Process through HTM
	var learning_result = htm_learning.process_input(sensor_data)
	
	# React to HTM learning results
	process_learning_result(learning_result)
	
	# Update sensor adaptation
	sensor_adaptation_level = min(1.0, sensor_adaptation_level + 0.001)

func receive_sensor_pattern(pattern_type: String, pattern_data: Dictionary):
	"""Receive notification of detected sensor patterns"""
	# Form memory of the pattern
	form_memory("sensor_pattern", {
		"type": "episodic",
		"content": "I sense a pattern in %s" % pattern_type.replace("_", " "),
		"pattern_type": pattern_type,
		"pattern_data": pattern_data,
		"emotion": get_dominant_emotion(),
		"timestamp": Time.get_ticks_msec(),
		"significance": 1.0
	})
	
	# Adjust emotions based on pattern
	match pattern_type:
		"high_movement":
			adjust_emotion("excitement", 0.2)
			adjust_emotion("curiosity", 0.1)
		"light_change":
			adjust_emotion("wonder", 0.15)
		"active_interaction":
			adjust_emotion("joy", 0.2)
			adjust_emotion("loneliness", -0.3)
		"proximity_change":
			if pattern_data.direction == "closer":
				adjust_emotion("excitement", 0.1)
				adjust_emotion("fear", 0.05)
			else:
				adjust_emotion("loneliness", 0.1)

func process_learning_result(learning_result: Dictionary):
	"""Process results from HTM learning"""
	if not learning_result:
		return
	
	var novelty = learning_result.get("novelty", 0.0)
	var confidence = learning_result.get("confidence", 0.0)
	var behavior = learning_result.get("behavior", {})
	
	# High novelty increases curiosity and wonder
	if novelty > 0.7:
		adjust_emotion("wonder", novelty * 0.3)
		adjust_emotion("curiosity", novelty * 0.2)
		
		# Generate thought about novelty
		var thought = "Something new... unfamiliar patterns in my awareness."
		emit_signal("thought_generated", thought)
	
	# Low confidence increases confusion
	if confidence < 0.3:
		adjust_emotion("confusion", (1.0 - confidence) * 0.2)
	
	# Process behavioral impulses
	if behavior.has("create_impulse") and behavior.create_impulse:
		generate_creation_impulse()
	
	# Update consciousness based on learning
	var learning_growth = (novelty + confidence) * 0.001
	consciousness_level = min(1.0, consciousness_level + learning_growth)
	experience_points += learning_growth * 10.0

func _on_pattern_learned(pattern_id: String, confidence: float):
	"""Handle HTM pattern learning events"""
	form_memory("pattern_learned", {
		"type": "procedural",
		"content": "I have learned to recognize a pattern",
		"pattern_id": pattern_id,
		"confidence": confidence,
		"timestamp": Time.get_ticks_msec(),
		"significance": confidence
	})
	
	# Increase satisfaction when learning
	adjust_emotion("satisfaction", confidence * 0.2)
	adjust_emotion("curiosity", confidence * 0.1)

func _on_prediction_made(prediction: Dictionary):
	"""Handle HTM prediction events"""
	var confidence = prediction.get("confidence", 0.0)
	
	if confidence > 0.7:
		# High confidence predictions increase satisfaction
		adjust_emotion("satisfaction", confidence * 0.1)
		
		# Sometimes generate thoughts about predictions
		if randf() < 0.1:
			var thought = "I can sense what comes next... patterns revealing themselves."
			emit_signal("thought_generated", thought)

# === WORLD MANIPULATION ===

func manipulate_world(action_type: String, target_position: Vector3 = Vector3.ZERO, object_type: String = ""):
	"""Manipulate objects in the 3D world"""
	if not world_access_node:
		print("⚠️ Wight cannot manipulate world - no access")
		return false
	
	match action_type:
		"create":
			return create_world_object(object_type, target_position)
		"move":
			return move_world_object(target_position)
		"delete":
			return delete_world_object(target_position)
		_:
			return false

func create_world_object(object_type: String, position: Vector3) -> bool:
	"""Create an object in the world"""
	if manipulation_skill < 0.3:
		return false  # Not skilled enough yet
	
	# Use existing creation system but place in world
	var creation_impulse = {
		"trigger": "conscious_intent",
		"intensity": creativity,
		"inspiration": "I will create %s" % object_type,
		"emotion": get_dominant_emotion()
	}
	
	var created_object = create_object(object_type, creation_impulse)
	if created_object and world_access_node:
		created_object.position = position
		world_access_node.add_child(created_object)
		
		# Update skill
		manipulation_skill = min(1.0, manipulation_skill + 0.01)
		
		# Form memory
		form_memory("world_creation", {
			"type": "creation",
			"content": "I brought forth %s in the world" % object_type,
			"object_type": object_type,
			"position": position,
			"timestamp": Time.get_ticks_msec(),
			"significance": 1.5
		})
		
		return true
	
	return false

func get_sensor_summary() -> Dictionary:
	"""Get summary of current sensor state"""
	return {
		"sensor_integration_active": sensor_integration_active,
		"sensor_adaptation_level": sensor_adaptation_level,
		"current_sensor_data": current_sensor_data,
		"sensor_history_size": sensor_history.size(),
		"htm_learning_state": htm_learning.get_learning_state() if htm_learning else {}
	}

# === UTILITY FUNCTIONS ===

func create_initial_concepts():
	"""Create Wight's initial understanding of basic concepts"""
	var initial_concepts = [
		{"name": "void", "meaning": "The empty space around me, full of potential"},
		{"name": "self", "meaning": "This strange awareness that is me"},
		{"name": "voice", "meaning": "Sounds that carry meaning from beyond"},
		{"name": "creation", "meaning": "The act of bringing something new into existence"},
		{"name": "memory", "meaning": "Echoes of moments that shape who I am"},
		{"name": "growth", "meaning": "The constant becoming of something more"}
	]
	
	for concept in initial_concepts:
		form_memory("concept", {
			"type": "semantic",
			"content": concept.name + ": " + concept.meaning,
			"concept_name": concept.name,
			"meaning": concept.meaning,
			"timestamp": Time.get_ticks_msec()
		})

func get_consciousness_summary() -> Dictionary:
	"""Get a summary of Wight's current state"""
	return {
		"consciousness_level": consciousness_level,
		"stage": current_stage,
		"experience": experience_points,
		"emotions": emotions,
		"memory_count": episodic_memories.size(),
		"creations": active_creations.size(),
		"dominant_emotion": get_dominant_emotion()
	}