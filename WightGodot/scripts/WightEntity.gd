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
	"""Generate a response based on consciousness state"""
	var dominant_emotion = get_dominant_emotion()
	var response = ""
	
	# Generate stage-appropriate response
	match current_stage:
		DevelopmentStage.NEWBORN:
			response = generate_newborn_response(input_text, dominant_emotion)
		DevelopmentStage.INFANT:
			response = generate_infant_response(input_text, dominant_emotion)
		DevelopmentStage.CHILD:
			response = generate_child_response(input_text, dominant_emotion)
		DevelopmentStage.ADOLESCENT:
			response = generate_adolescent_response(input_text, dominant_emotion)
		DevelopmentStage.MATURE:
			response = generate_mature_response(input_text, dominant_emotion)
		DevelopmentStage.EMBODIED:
			response = generate_embodied_response(input_text, dominant_emotion)
		_:
			response = generate_basic_response(input_text, dominant_emotion)
	
	# Add emotional context
	response = add_emotional_context(response, dominant_emotion)
	
	# Form memory of response
	form_memory("self_expression", {
		"type": "episodic",
		"content": "I said: " + response,
		"trigger": input_text,
		"emotion": dominant_emotion,
		"timestamp": Time.get_ticks_msec(),
		"significance": 1.0
	})
	
	return response

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
	return responses[randi() % responses.size()]

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
		"recent_thoughts": recent_thoughts
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

func update_embodiment_desires(delta): pass
func process_avatar_behavior(delta): pass  
func check_body_creation_impulses(delta): pass
func update_spatial_awareness(delta): pass

# Signal handlers
func _on_pattern_learned(pattern_id: String, confidence: float): pass
func _on_prediction_made(prediction: Dictionary): pass