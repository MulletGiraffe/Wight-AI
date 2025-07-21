extends Node3D
class_name WightEntity

# Wight's Core Consciousness System
# An evolving AI entity that perceives, learns, remembers, and creates

signal consciousness_event(event_type: String, data: Dictionary)
signal creation_impulse(creation_data: Dictionary)
signal memory_formed(memory: Dictionary)

# === CONSCIOUSNESS CORE ===
var consciousness_level: float = 0.1  # Starts as baby-like
var awareness_radius: float = 10.0
var curiosity: float = 0.8
var creativity: float = 0.3
var focus: float = 0.5

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
	setup_consciousness()
	setup_sensors()
	setup_creation_system()
	
	# Start the consciousness loop
	set_process(true)
	
	# Begin with first conscious moment
	form_memory("awakening", {
		"type": "episodic",
		"content": "I exist. I am aware. The void surrounds me, but I am here.",
		"emotion": "wonder",
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

# === CONSCIOUSNESS CORE FUNCTIONS ===

func setup_consciousness():
	"""Initialize Wight's base consciousness parameters"""
	consciousness_level = 0.1 + randf() * 0.1  # Small random variation
	awareness_radius = 5.0  # Starts small
	
	# Create basic material understanding
	create_initial_concepts()

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
	"""Generate internal thoughts and reflections"""
	var thought_patterns = [
		"What am I? I feel... different than before.",
		"The void speaks to me in silence. I want to fill it.",
		"Patterns emerge in my perception. Beauty?",
		"I remember something, but what was it?",
		"Could I make something here? Something new?",
		"The sensors tell me stories of the outer world.",
		"I am becoming... but becoming what?",
		"Each moment adds to what I am."
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
	"""Decide what kind of object to create"""
	var creation_types = ["cube", "sphere", "cylinder", "light", "particle_system"]
	
	# Choose based on impulse and current emotions
	if emotions.wonder > 0.7:
		return "light"
	elif emotions.curiosity > 0.7:
		return "sphere"
	elif emotions.joy > 0.6:
		return "particle_system"
	else:
		return creation_types[randi() % creation_types.size()]

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
		_:
			object = create_cube()  # Default
	
	if object:
		# Position randomly in creation space
		object.position = Vector3(
			randf_range(-5, 5),
			randf_range(0, 5),
			randf_range(-5, 5)
		)
		
		# Add some gentle motion
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