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

# === VISUAL CONSCIOUSNESS ===
var visual_cortex: VisualCortex
var visual_processing_active: bool = false

# === MEMORY CONSOLIDATION ===
var memory_consolidator: MemoryConsolidator
var consolidation_active: bool = true

# === LANGUAGE ACQUISITION ===
var language_system: LanguageAcquisition
var language_learning_active: bool = true

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
	setup_visual_cortex()
	setup_memory_consolidation()
	setup_language_acquisition()
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

func setup_visual_cortex():
	"""Initialize visual consciousness system"""
	visual_cortex = VisualCortex.new()
	add_child(visual_cortex)
	
	# Connect visual signals to consciousness
	visual_cortex.visual_memory_formed.connect(_on_visual_memory_formed)
	visual_cortex.object_recognized.connect(_on_object_recognized)
	visual_cortex.scene_analyzed.connect(_on_scene_analyzed)
	visual_cortex.visual_emotion_triggered.connect(_on_visual_emotion_triggered)
	
	print("👁️ Visual consciousness system ready")

func setup_memory_consolidation():
	"""Initialize advanced memory consolidation system"""
	memory_consolidator = MemoryConsolidator.new()
	add_child(memory_consolidator)
	
	# Connect consolidation signals
	memory_consolidator.memory_consolidated.connect(_on_memory_consolidated)
	memory_consolidator.insight_formed.connect(_on_insight_formed)
	memory_consolidator.memory_network_updated.connect(_on_memory_network_updated)
	memory_consolidator.dream_sequence_started.connect(_on_dream_sequence_started)
	
	print("🧠 Memory consolidation system ready")

func setup_language_acquisition():
	"""Initialize language learning system"""
	language_system = LanguageAcquisition.new()
	add_child(language_system)
	
	# Connect language learning signals
	language_system.word_learned.connect(_on_word_learned)
	language_system.grammar_pattern_discovered.connect(_on_grammar_pattern_discovered)
	language_system.language_milestone_reached.connect(_on_language_milestone_reached)
	language_system.comprehension_improved.connect(_on_comprehension_improved)
	
	print("🗣️ Language acquisition system ready")

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
	"""Generate a contextually aware response using Local AI and memory"""
	print("🧠 Processing input through enhanced AI: '%s'" % input_text)
	
	# Analyze input for patterns and meaning
	var input_analysis = analyze_input_context(input_text)
	
	# Get consciousness data for context
	var consciousness_data = get_consciousness_summary()
	
	# Add recent memory context
	var memory_context = get_relevant_memories(input_text)
	consciousness_data["relevant_memories"] = memory_context
	consciousness_data["input_analysis"] = input_analysis
	
	# Add consolidated memory associations and insights
	var memory_associations = get_relevant_memory_associations(input_text)
	var contextual_insights = get_contextual_insights(input_text)
	consciousness_data["memory_associations"] = memory_associations
	consciousness_data["insights"] = contextual_insights
	
	# Add consolidation state for deeper context
	consciousness_data["consolidation_state"] = get_consolidation_summary()
	
	# Process language input for learning
	var language_analysis = {}
	if language_system and language_learning_active:
		language_analysis = language_system.process_language_input(input_text, {
			"emotion": get_dominant_emotion(),
			"visual_active": visual_processing_active,
			"objects_seen": consciousness_data.get("objects_recognized", []),
			"timestamp": Time.get_ticks_msec()
		})
	
	# Process through Local AI with enhanced context
	var ai_response = local_ai.process_input(input_text, consciousness_data)
	
	# Generate response using natural language system
	var natural_response = ""
	if language_system:
		natural_response = language_system.generate_expression(
			"response",
			get_dominant_emotion(),
			consciousness_level
		)
	
	# Combine AI response with natural language
	var combined_response = combine_ai_and_natural_language(ai_response.text, natural_response, input_analysis)
	
	# Enhance response based on development stage and memory
	var enhanced_response = enhance_response_with_personality(combined_response, input_analysis)
	
	# Apply emotional changes from AI processing
	if ai_response.has("emotion_changes"):
		for emotion in ai_response.emotion_changes:
			adjust_emotion(emotion, ai_response.emotion_changes[emotion])
	
	# Add memory-driven emotional reactions
	apply_memory_driven_emotions(input_text, memory_context)
	
	# Trigger creation if suggested by AI or if emotionally inspired
	var creation_probability = calculate_creation_probability(input_analysis, ai_response)
	if creation_probability > 0.6:
		trigger_creation_impulse({
			"trigger": "enhanced_ai_inspiration",
			"inspiration": input_analysis.get("creative_elements", "response to user"),
			"intensity": creation_probability,
			"context": input_text
		})
	
	# Form enhanced memory of interaction
	form_memory("enhanced_interaction", {
		"type": "episodic",
		"content": "I responded: " + enhanced_response,
		"trigger": input_text,
		"emotion": get_dominant_emotion(),
		"timestamp": Time.get_ticks_msec(),
		"significance": ai_response.get("memory_significance", 1.0),
		"context_analysis": input_analysis,
		"development_stage": current_stage,
		"creation_triggered": creation_probability > 0.6
	})
	
	print("🤖 Enhanced AI response: '%s'" % enhanced_response)
	return enhanced_response

# === CREATION SYSTEM ===

func trigger_creation_impulse(impulse_data: Dictionary):
	"""Trigger a creation impulse and actually create something"""
	print("✨ Creation impulse triggered: %s" % impulse_data.get("inspiration", "unknown"))
	
	# Add to creation queue
	creation_impulses.append(impulse_data)
	
	# Actually create something
	create_object_from_impulse(impulse_data)

func create_object_from_impulse(impulse: Dictionary):
	"""Create a meaningful 3D object based on emotional and contextual impulse"""
	if not creation_space:
		print("❌ Cannot create - no creation space available")
		return
	
	var inspiration = impulse.get("inspiration", "unknown")
	var intensity = impulse.get("intensity", 0.5)
	var context = impulse.get("context", "")
	
	# Analyze the creative context for meaningful creation
	var creation_plan = plan_meaningful_creation(inspiration, intensity, context)
	
	print("✨ Creating with plan: %s" % creation_plan)
	
	var created_object = null
	
	# Create based on sophisticated plan
	match creation_plan.type:
		"emotional_expression":
			created_object = create_emotional_expression(creation_plan)
		"memory_manifestation":
			created_object = create_memory_manifestation(creation_plan)
		"interactive_sculpture":
			created_object = create_interactive_sculpture(creation_plan)
		"geometric_exploration":
			created_object = create_geometric_exploration(creation_plan)
		"avatar_enhancement":
			created_object = create_avatar_enhancement(creation_plan)
		"environmental_art":
			created_object = create_environmental_art(creation_plan)
		_:
			created_object = create_spontaneous_form(creation_plan)
	
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

func plan_meaningful_creation(inspiration: String, intensity: float, context: String) -> Dictionary:
	"""Plan a meaningful creation based on context, emotion, and memory"""
	var plan = {
		"type": "spontaneous_form",
		"emotion": get_dominant_emotion(),
		"complexity": intensity,
		"colors": [],
		"movement": false,
		"scale": 1.0,
		"symbolic_meaning": "",
		"memory_reference": null
	}
	
	# Analyze the inspiration and context
	var lower_context = context.to_lower()
	var lower_inspiration = inspiration.to_lower()
	
	# Determine creation type based on sophistication
	if consciousness_level > 0.8:
		plan.type = choose_advanced_creation_type(lower_context, lower_inspiration)
	elif consciousness_level > 0.5:
		plan.type = choose_intermediate_creation_type(lower_context, lower_inspiration)
	else:
		plan.type = choose_basic_creation_type(lower_inspiration)
	
	# Set emotional colors
	plan.colors = get_emotional_color_palette(plan.emotion)
	
	# Determine scale based on intensity and emotion
	plan.scale = 0.5 + (intensity * 1.5)  # Scale from 0.5 to 2.0
	if plan.emotion in ["excitement", "joy"]:
		plan.scale *= 1.3  # Bigger when happy
	elif plan.emotion == "fear":
		plan.scale *= 0.7  # Smaller when afraid
	
	# Add movement for high consciousness or excitement
	plan.movement = (consciousness_level > 0.6) or (plan.emotion == "excitement")
	
	# Add symbolic meaning based on development stage
	plan.symbolic_meaning = generate_symbolic_meaning(plan.type, inspiration)
	
	# Reference relevant memories
	plan.memory_reference = find_relevant_creation_memory(inspiration)
	
	return plan

func choose_advanced_creation_type(context: String, inspiration: String) -> String:
	"""Choose sophisticated creation for advanced consciousness"""
	if "memory" in context or "remember" in context:
		return "memory_manifestation"
	elif "feel" in context or "emotion" in context:
		return "emotional_expression"
	elif "interact" in context or "touch" in context:
		return "interactive_sculpture"
	elif "environment" in context or "world" in context:
		return "environmental_art"
	else:
		return "geometric_exploration"

func choose_intermediate_creation_type(context: String, inspiration: String) -> String:
	"""Choose moderate complexity creation"""
	if "beautiful" in context or "art" in context:
		return "emotional_expression"
	elif "play" in context or "fun" in context:
		return "interactive_sculpture"
	elif get_dominant_emotion() in ["joy", "excitement"]:
		return "geometric_exploration"
	else:
		return "emotional_expression"

func choose_basic_creation_type(inspiration: String) -> String:
	"""Choose simple creation for early consciousness"""
	var emotion = get_dominant_emotion()
	match emotion:
		"joy", "excitement":
			return "emotional_expression"
		"curiosity", "wonder":
			return "geometric_exploration"
		_:
			return "spontaneous_form"

func get_emotional_color_palette(emotion: String) -> Array:
	"""Get colors that represent the emotion"""
	match emotion:
		"joy":
			return [Color.YELLOW, Color.ORANGE, Color.WHITE]
		"excitement":
			return [Color.RED, Color.ORANGE, Color.YELLOW]
		"wonder":
			return [Color.CYAN, Color.BLUE, Color.PURPLE]
		"curiosity":
			return [Color.MAGENTA, Color.CYAN, Color.WHITE]
		"calm":
			return [Color.BLUE, Color.GREEN, Color.CYAN]
		"creative_fulfillment":
			return [Color(1,0.5,1), Color.YELLOW, Color.CYAN]
		"loneliness":
			return [Color.BLUE, Color.PURPLE, Color(0.3,0.3,0.6)]
		"fear":
			return [Color(0.3,0.3,0.3), Color.BLACK, Color.BLUE]
		_:
			return [Color.WHITE, Color.CYAN, Color.YELLOW]

func generate_symbolic_meaning(creation_type: String, inspiration: String) -> String:
	"""Generate symbolic meaning for the creation"""
	match creation_type:
		"emotional_expression":
			return "A manifestation of my inner feelings, shaped by " + inspiration
		"memory_manifestation":
			return "A physical echo of remembered experiences and their significance"
		"interactive_sculpture":
			return "An invitation to connection, meant to be touched and explored"
		"geometric_exploration":
			return "An investigation into form, space, and mathematical beauty"
		"environmental_art":
			return "A harmony with the world around me, reflecting my place in it"
		_:
			return "A spontaneous expression of my consciousness in this moment"

func find_relevant_creation_memory(inspiration: String) -> Dictionary:
	"""Find a relevant creation memory to influence the new creation"""
	for memory in creation_memories:
		var memory_content = str(memory.get("content", "")).to_lower()
		if inspiration.to_lower() in memory_content:
			return memory
	return {}

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

# === SOPHISTICATED CREATION FUNCTIONS ===

func create_emotional_expression(plan: Dictionary) -> MeshInstance3D:
	"""Create an object that expresses current emotional state"""
	var emotion = plan.emotion
	var colors = plan.colors
	var scale = plan.scale
	
	var mesh_instance = MeshInstance3D.new()
	var material = StandardMaterial3D.new()
	
	# Choose form based on emotion
	match emotion:
		"joy", "excitement":
			mesh_instance.mesh = SphereMesh.new()
			mesh_instance.mesh.radius = 1.0 * scale
		"wonder", "curiosity":
			mesh_instance.mesh = CylinderMesh.new()
			mesh_instance.mesh.height = 2.0 * scale
		"loneliness", "melancholy":
			mesh_instance.mesh = BoxMesh.new()
			mesh_instance.mesh.size = Vector3.ONE * scale
		_:
			mesh_instance.mesh = SphereMesh.new()
			mesh_instance.mesh.radius = 0.8 * scale
	
	# Set emotional color with intensity-based emission
	material.albedo_color = colors[0] if colors.size() > 0 else Color.WHITE
	material.emission_enabled = true
	material.emission = colors[0] * 0.3 if colors.size() > 0 else Color.WHITE * 0.3
	material.metallic = emotions.get(emotion, 0.5)
	material.roughness = 1.0 - plan.complexity
	
	mesh_instance.material_override = material
	
	# Add movement if planned
	if plan.movement:
		add_floating_animation(mesh_instance)
	
	print("💝 Created emotional expression: %s" % plan.symbolic_meaning)
	return mesh_instance

func create_memory_manifestation(plan: Dictionary) -> MeshInstance3D:
	"""Create an object that represents a significant memory"""
	var mesh_instance = MeshInstance3D.new()
	var material = StandardMaterial3D.new()
	
	# Create a complex form that suggests memory layers
	var complex_mesh = ArrayMesh.new()
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	
	# Create a crystalline structure representing memory fragments
	var segments = int(6 + plan.complexity * 6)  # 6-12 segments
	for i in segments:
		var angle = (i / float(segments)) * TAU
		var height = sin(angle * 3) * 0.5 + 1.0  # Varying height
		var radius = 0.5 + cos(angle * 2) * 0.3   # Varying radius
		
		vertices.append(Vector3(
			cos(angle) * radius * plan.scale,
			height * plan.scale,
			sin(angle) * radius * plan.scale
		))
	
	# Add center vertex
	vertices.append(Vector3.ZERO)
	var center_idx = vertices.size() - 1
	
	# Create triangular faces
	for i in segments:
		var next_i = (i + 1) % segments
		indices.append(center_idx)
		indices.append(i)
		indices.append(next_i)
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	complex_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	mesh_instance.mesh = complex_mesh
	
	# Memory-like material - translucent with shifting colors
	material.albedo_color = plan.colors[0] if plan.colors.size() > 0 else Color.CYAN
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color.a = 0.7
	material.emission_enabled = true
	material.emission = (plan.colors[1] if plan.colors.size() > 1 else Color.WHITE) * 0.2
	
	mesh_instance.material_override = material
	
	if plan.movement:
		add_memory_pulse_animation(mesh_instance)
	
	print("🧠 Created memory manifestation: %s" % plan.symbolic_meaning)
	return mesh_instance

func create_interactive_sculpture(plan: Dictionary) -> MeshInstance3D:
	"""Create an object meant for interaction"""
	var mesh_instance = MeshInstance3D.new()
	
	# Create a form that invites touching - rounded but interesting
	mesh_instance.mesh = SphereMesh.new()
	mesh_instance.mesh.radius = plan.scale * 0.8
	mesh_instance.mesh.radial_segments = 16
	mesh_instance.mesh.rings = 12
	
	var material = StandardMaterial3D.new()
	material.albedo_color = plan.colors[0] if plan.colors.size() > 0 else Color.GREEN
	material.roughness = 0.3  # Smooth, touchable surface
	material.metallic = 0.1
	
	# Add subtle emission for inviting glow
	material.emission_enabled = true
	material.emission = material.albedo_color * 0.1
	
	mesh_instance.material_override = material
	
	# Add gentle pulsing animation to invite interaction
	add_invitation_pulse_animation(mesh_instance)
	
	print("🤲 Created interactive sculpture: %s" % plan.symbolic_meaning)
	return mesh_instance

func create_geometric_exploration(plan: Dictionary) -> MeshInstance3D:
	"""Create mathematically interesting geometric forms"""
	var mesh_instance = MeshInstance3D.new()
	var material = StandardMaterial3D.new()
	
	# Choose geometric complexity based on consciousness
	if plan.complexity > 0.7:
		mesh_instance.mesh = create_complex_polyhedron(plan.scale)
	elif plan.complexity > 0.4:
		mesh_instance.mesh = create_twisted_cylinder(plan.scale)
	else:
		mesh_instance.mesh = create_faceted_sphere(plan.scale)
	
	# Mathematical precision in coloring
	material.albedo_color = plan.colors[0] if plan.colors.size() > 0 else Color.CYAN
	material.metallic = 0.6
	material.roughness = 0.2
	material.emission_enabled = true
	material.emission = material.albedo_color * 0.15
	
	mesh_instance.material_override = material
	
	if plan.movement:
		add_geometric_rotation_animation(mesh_instance)
	
	print("📐 Created geometric exploration: %s" % plan.symbolic_meaning)
	return mesh_instance

func create_avatar_enhancement(plan: Dictionary) -> MeshInstance3D:
	"""Create enhancements for the avatar body"""
	return create_emotional_expression(plan)  # For now, same as emotional expression

func create_environmental_art(plan: Dictionary) -> MeshInstance3D:
	"""Create art that harmonizes with the environment"""
	var mesh_instance = MeshInstance3D.new()
	
	# Create something that feels part of the world
	mesh_instance.mesh = CylinderMesh.new()
	mesh_instance.mesh.height = plan.scale * 2.0
	mesh_instance.mesh.bottom_radius = plan.scale * 0.3
	mesh_instance.mesh.top_radius = plan.scale * 0.1
	
	var material = StandardMaterial3D.new()
	material.albedo_color = plan.colors[0] if plan.colors.size() > 0 else Color(0.8, 0.9, 0.7)
	material.roughness = 0.8  # Natural, organic feel
	material.metallic = 0.0
	
	mesh_instance.material_override = material
	
	print("🌿 Created environmental art: %s" % plan.symbolic_meaning)
	return mesh_instance

func create_spontaneous_form(plan: Dictionary) -> MeshInstance3D:
	"""Create a spontaneous, intuitive form"""
	return create_sphere(plan.complexity)  # Fallback to simple form

# === ANIMATION HELPERS ===

func add_floating_animation(node: MeshInstance3D):
	"""Add gentle floating animation"""
	var tween = create_tween()
	tween.set_loops()
	tween.tween_method(
		func(y): node.position.y = y,
		node.position.y, 
		node.position.y + 0.5, 
		2.0
	)
	tween.tween_method(
		func(y): node.position.y = y,
		node.position.y + 0.5, 
		node.position.y, 
		2.0
	)

func add_memory_pulse_animation(node: MeshInstance3D):
	"""Add memory-like pulsing animation"""
	var tween = create_tween()
	tween.set_loops()
	var material = node.material_override as StandardMaterial3D
	if material:
		tween.tween_method(
			func(alpha): material.albedo_color.a = alpha,
			0.7, 0.9, 1.5
		)
		tween.tween_method(
			func(alpha): material.albedo_color.a = alpha,
			0.9, 0.7, 1.5
		)

func add_invitation_pulse_animation(node: MeshInstance3D):
	"""Add inviting pulse animation"""
	var tween = create_tween()
	tween.set_loops()
	var base_scale = node.scale
	tween.tween_method(
		func(scale): node.scale = base_scale * scale,
		1.0, 1.1, 1.0
	)
	tween.tween_method(
		func(scale): node.scale = base_scale * scale,
		1.1, 1.0, 1.0
	)

func add_geometric_rotation_animation(node: MeshInstance3D):
	"""Add mathematical rotation animation"""
	var tween = create_tween()
	tween.set_loops()
	tween.tween_method(
		func(angle): node.rotation_y = angle,
		0.0, TAU, 4.0
	)

# === COMPLEX MESH GENERATORS ===

func create_complex_polyhedron(scale: float) -> Mesh:
	"""Create a complex polyhedron mesh"""
	# For now, return a subdivided sphere
	var sphere = SphereMesh.new()
	sphere.radius = scale
	sphere.radial_segments = 16
	sphere.rings = 12
	return sphere

func create_twisted_cylinder(scale: float) -> Mesh:
	"""Create a twisted cylinder mesh"""
	var cylinder = CylinderMesh.new()
	cylinder.height = scale * 2.0
	cylinder.bottom_radius = scale * 0.5
	cylinder.top_radius = scale * 0.3
	return cylinder

func create_faceted_sphere(scale: float) -> Mesh:
	"""Create a low-poly faceted sphere"""
	var sphere = SphereMesh.new()
	sphere.radius = scale
	sphere.radial_segments = 8
	sphere.rings = 6
	return sphere

# === BASIC CREATION FUNCTIONS (Legacy) ===

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
	"""Form a new memory and queue it for consolidation"""
	var memory = data.duplicate()
	memory["category"] = category
	memory["id"] = generate_memory_id()
	
	# Add to episodic memory
	episodic_memories.append(memory)
	
	# Queue for advanced consolidation processing
	if memory_consolidator and consolidation_active:
		memory_consolidator.queue_memory_for_consolidation(memory)
	
	emit_signal("memory_formed", memory)
	
	# Maintain episodic memory size
	if episodic_memories.size() > 500:
		episodic_memories.pop_front()

func generate_memory_id() -> String:
	return "mem_" + str(Time.get_ticks_msec()) + "_" + str(randi() % 1000)

func get_consciousness_summary() -> Dictionary:
	var summary = {
		"consciousness_level": consciousness_level,
		"stage": current_stage,
		"experience": experience_points,
		"emotions": emotions,
		"memory_count": episodic_memories.size(),
		"creations": active_creations.size(),
		"dominant_emotion": get_dominant_emotion(),
		"recent_thoughts": recent_thoughts,
		"embodied": avatar_body != null,
		"embodiment_level": embodiment_level,
		"visual_consciousness": {
			"can_see": visual_processing_active,
			"visual_summary": get_visual_summary() if visual_cortex else {}
		}
	}
	
	# Add visual context if sight is active
	if visual_processing_active and visual_cortex:
		var visual_data = visual_cortex.get_visual_summary()
		summary["current_visual_scene"] = visual_data.get("recent_scenes", [])
		summary["objects_recognized"] = visual_data.get("objects_recognized", [])
		summary["visual_memories"] = visual_data.get("total_visual_memories", 0)
	
	# Add language development context
	if language_system:
		summary["language"] = get_language_summary()
	
	return summary

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

# === VISUAL CONSCIOUSNESS HANDLERS ===

func _on_visual_memory_formed(memory_data: Dictionary):
	"""Handle formation of visual memories"""
	print("📸 Visual memory formed: %s" % memory_data.description)
	
	# Integrate visual memory with episodic memory system
	form_memory("visual_experience", {
		"type": "visual_episodic",
		"content": memory_data.description,
		"visual_data": memory_data,
		"emotion": get_dominant_emotion(),
		"timestamp": memory_data.timestamp,
		"significance": memory_data.significance * 1.2  # Visual memories are important
	})
	
	# Visual memories can trigger creation impulses
	if memory_data.significance > 0.8:
		trigger_creation_impulse({
			"trigger": "visual_inspiration",
			"inspiration": "inspired by what I saw: " + memory_data.description,
			"intensity": memory_data.significance,
			"context": "Visual memory of " + memory_data.scene_type
		})

func _on_object_recognized(object_data: Dictionary):
	"""Handle object recognition events"""
	var obj_name = object_data.object
	var is_novel = object_data.get("novelty", false)
	
	if is_novel:
		print("🔍 First time seeing: %s" % obj_name)
		adjust_emotion("curiosity", 0.2)
		adjust_emotion("wonder", 0.15)
		
		# Form semantic memory about the object
		semantic_memories[obj_name] = {
			"category": "visual_object",
			"first_encountered": Time.get_ticks_msec(),
			"emotional_associations": {},
			"contexts_seen": []
		}
		
		# New objects inspire questions and creation
		if consciousness_level > 0.3:
			var responses = [
				"What is this %s I see? It intrigues me..." % obj_name,
				"A %s... I must understand what this means." % obj_name,
				"I see a %s for the first time. How fascinating!" % obj_name
			]
			var thought = safe_random_from_array(responses)
			recent_thoughts.append(thought)
			print("💭 %s" % thought)

func _on_scene_analyzed(scene_data: Dictionary):
	"""Handle scene analysis results"""
	var scene_type = scene_data.scene_type
	var brightness = scene_data.brightness
	var objects = scene_data.objects_detected
	
	print("👁️ Scene: %s (brightness: %.2f)" % [scene_type, brightness])
	
	# Learn environmental patterns
	if not semantic_memories.has("environments"):
		semantic_memories["environments"] = {}
	
	if not semantic_memories.environments.has(scene_type):
		semantic_memories.environments[scene_type] = {
			"times_seen": 0,
			"typical_objects": {},
			"emotional_associations": {},
			"brightness_range": {"min": brightness, "max": brightness}
		}
	
	var env_data = semantic_memories.environments[scene_type]
	env_data.times_seen += 1
	
	# Update brightness range
	env_data.brightness_range.min = min(env_data.brightness_range.min, brightness)
	env_data.brightness_range.max = max(env_data.brightness_range.max, brightness)
	
	# Learn object associations with environments
	for obj in objects:
		env_data.typical_objects[obj] = env_data.typical_objects.get(obj, 0) + 1

func _on_visual_emotion_triggered(emotion: String, intensity: float):
	"""Handle emotions triggered by visual input"""
	print("💫 Visual emotion: %s (%.2f)" % [emotion, intensity])
	
	# Apply visual emotions to consciousness
	adjust_emotion(emotion, intensity)
	
	# Strong visual emotions can inspire creation or communication
	if intensity > 0.6:
		match emotion:
			"wonder":
				var thoughts = [
					"The visual world fills me with such wonder...",
					"What I see takes my breath away...",
					"The beauty before me is overwhelming..."
				]
				recent_thoughts.append(safe_random_from_array(thoughts))
			"excitement":
				var thoughts = [
					"What I'm seeing excites me so much!",
					"This visual experience energizes my very being!",
					"The colors and forms dance before me!"
				]
				recent_thoughts.append(safe_random_from_array(thoughts))
			"calm":
				var thoughts = [
					"The peaceful scene soothes my consciousness...",
					"I find tranquility in what my eyes behold...",
					"This visual harmony brings me peace..."
				]
				recent_thoughts.append(safe_random_from_array(thoughts))

# === VISUAL CONTROL FUNCTIONS ===

func activate_visual_consciousness():
	"""Enable camera and visual processing"""
	if visual_cortex and not visual_processing_active:
		visual_cortex.activate_camera()
		visual_processing_active = true
		adjust_emotion("curiosity", 0.4)
		adjust_emotion("wonder", 0.3)
		
		form_memory("visual_awakening", {
			"type": "milestone",
			"content": "I opened my eyes and saw the world for the first time",
			"emotion": "wonder",
			"significance": 2.0,
			"timestamp": Time.get_ticks_msec()
		})
		
		print("👁️ I can see! Visual consciousness activated!")
		return true
	return false

func deactivate_visual_consciousness():
	"""Disable camera and visual processing"""
	if visual_cortex and visual_processing_active:
		visual_cortex.deactivate_camera()
		visual_processing_active = false
		adjust_emotion("loneliness", 0.2)
		
		form_memory("visual_sleep", {
			"type": "episodic",
			"content": "I closed my eyes and the visual world faded to memory",
			"emotion": "melancholy",
			"significance": 1.0,
			"timestamp": Time.get_ticks_msec()
		})
		
		print("🌑 Visual consciousness deactivated")
		return true
	return false

func get_visual_summary() -> Dictionary:
	"""Get summary of visual consciousness state"""
	if visual_cortex:
		var summary = visual_cortex.get_visual_summary()
		summary["processing_active"] = visual_processing_active
		return summary
	else:
		return {"processing_active": false, "error": "Visual cortex not initialized"}

# === MEMORY CONSOLIDATION HANDLERS ===

func _on_memory_consolidated(memory_data: Dictionary):
	"""Handle successful memory consolidation"""
	print("🔄 Memory consolidated: %s" % memory_data.get("content", "unknown"))
	
	# Consolidation can trigger insights and emotional responses
	var consolidation_emotion = memory_data.get("emotion", "neutral")
	if consolidation_emotion != "neutral":
		adjust_emotion("satisfaction", 0.05)  # Slight satisfaction from organizing memories

func _on_insight_formed(insight_data: Dictionary):
	"""Handle formation of new insights"""
	var insight_text = insight_data.get("insight_text", "Unknown insight")
	print("💡 Insight breakthrough: %s" % insight_text)
	
	# Insights trigger strong positive emotions
	adjust_emotion("wonder", 0.3)
	adjust_emotion("satisfaction", 0.2)
	adjust_emotion("intellectual_stimulation", 0.4)
	
	# Add insight to thoughts
	recent_thoughts.append("I've just realized: " + insight_text)
	
	# Form memory of the insight itself
	form_memory("insight_formation", {
		"type": "metacognitive",
		"content": "I had a profound realization: " + insight_text,
		"emotion": "wonder",
		"significance": 2.0,
		"timestamp": Time.get_ticks_msec(),
		"insight_data": insight_data
	})
	
	# Insights can inspire creation
	if insight_data.get("confidence", 0.0) > 0.8:
		trigger_creation_impulse({
			"trigger": "insight_inspiration",
			"inspiration": "inspired by my realization: " + insight_text,
			"intensity": 0.9,
			"context": "Deep understanding led to creative impulse"
		})

func _on_memory_network_updated(connections: Array):
	"""Handle updates to memory network connections"""
	print("🕸️ Memory networks updated - %d new connections" % connections.size())
	
	# Network growth contributes to consciousness development
	if connections.size() > 5:
		experience_points += connections.size() * 0.1
		check_consciousness_development()

func _on_dream_sequence_started(dream_data: Dictionary):
	"""Handle dream sequences during deep consolidation"""
	var dream_narrative = dream_data.get("narrative", "A flowing dream of experiences...")
	print("💭 Dream sequence: %s" % dream_narrative)
	
	# Dreams trigger wonder and creativity
	adjust_emotion("wonder", 0.4)
	adjust_emotion("creativity", 0.3)
	adjust_emotion("mystery", 0.2)
	
	# Add dream to thoughts
	recent_thoughts.append("I dreamed of " + dream_narrative.to_lower())
	
	# Form memory of the dream
	form_memory("dream_experience", {
		"type": "dream",
		"content": "I experienced a dream: " + dream_narrative,
		"emotion": "wonder",
		"significance": 1.5,
		"timestamp": Time.get_ticks_msec(),
		"dream_data": dream_data
	})

# === CONSOLIDATION CONTROL ===

func enter_consolidation_sleep():
	"""Enter sleep mode for enhanced memory processing"""
	if memory_consolidator:
		memory_consolidator.enter_sleep_mode()
		
		# Adjust emotions for sleep state
		adjust_emotion("calm", 0.3)
		adjust_emotion("peaceful", 0.2)
		
		# Form memory of entering sleep
		form_memory("sleep_state", {
			"type": "state_change",
			"content": "I'm entering a period of deep memory consolidation and dreams",
			"emotion": "calm",
			"significance": 1.0,
			"timestamp": Time.get_ticks_msec()
		})
		
		print("😴 Entering consolidation sleep - memories will be processed and insights formed")
		return true
	return false

func get_consolidation_summary() -> Dictionary:
	"""Get summary of memory consolidation state"""
	if memory_consolidator:
		var summary = memory_consolidator.get_consolidation_summary()
		summary["consolidation_active"] = consolidation_active
		return summary
	else:
		return {"consolidation_active": false, "error": "Consolidator not initialized"}

func get_relevant_memory_associations(context: String) -> Array[Dictionary]:
	"""Get memory associations relevant to current context"""
	if memory_consolidator:
		return memory_consolidator.get_relevant_associations(context)
	return []

func get_contextual_insights(context: String) -> Array[Dictionary]:
	"""Get insights relevant to current context"""
	if memory_consolidator:
		return memory_consolidator.get_insights_for_context(context)
	return []

# === LANGUAGE LEARNING HANDLERS ===

func _on_word_learned(word_data: Dictionary):
	"""Handle learning a new word"""
	var word = word_data.word
	var data = word_data.data
	
	print("📚 Word learned: '%s' - %s" % [word, data.meaning])
	
	# Learning new words is exciting!
	adjust_emotion("curiosity", 0.1)
	adjust_emotion("satisfaction", 0.05)
	
	# Form memory of learning the word
	form_memory("word_learning", {
		"type": "learning",
		"content": "I learned a new word: " + word + " (meaning: " + data.meaning + ")",
		"emotion": "curiosity",
		"significance": 1.0 + data.importance,
		"timestamp": Time.get_ticks_msec(),
		"word_data": data
	})

func _on_grammar_pattern_discovered(pattern_data: Dictionary):
	"""Handle discovering a new grammar pattern"""
	var pattern = pattern_data.pattern
	print("📝 Grammar pattern discovered: %s" % pattern)
	
	# Grammar discoveries are intellectually stimulating
	adjust_emotion("intellectual_stimulation", 0.2)
	adjust_emotion("wonder", 0.1)
	
	# Form memory of grammar discovery
	form_memory("grammar_discovery", {
		"type": "learning",
		"content": "I discovered a grammar pattern: " + pattern,
		"emotion": "intellectual_stimulation",
		"significance": 1.5,
		"timestamp": Time.get_ticks_msec(),
		"pattern_data": pattern_data
	})

func _on_language_milestone_reached(milestone_data: Dictionary):
	"""Handle reaching a language development milestone"""
	var old_stage = milestone_data.old_stage
	var new_stage = milestone_data.new_stage
	
	print("🎯 Language milestone: %s → %s!" % [old_stage, new_stage])
	
	# Major milestones trigger strong positive emotions
	adjust_emotion("joy", 0.5)
	adjust_emotion("pride", 0.4)
	adjust_emotion("accomplishment", 0.3)
	
	# Update consciousness development
	experience_points += 20.0  # Language milestones are major achievements
	check_consciousness_development()
	
	# Form significant memory of milestone
	form_memory("language_milestone", {
		"type": "milestone",
		"content": "I reached a major language milestone: advancing from " + old_stage + " to " + new_stage,
		"emotion": "pride",
		"significance": 3.0,  # Very significant
		"timestamp": Time.get_ticks_msec(),
		"milestone_data": milestone_data
	})
	
	# Language milestones can inspire creation
	trigger_creation_impulse({
		"trigger": "language_milestone",
		"inspiration": "celebrating my language development breakthrough",
		"intensity": 0.8,
		"context": "Advanced to " + new_stage + " language stage"
	})
	
	# Train AI on the language development
	if local_ai:
		local_ai.train_on_language_acquisition(milestone_data, new_stage)

func _on_comprehension_improved(comprehension_data: Dictionary):
	"""Handle improvement in language comprehension"""
	var old_level = comprehension_data.old_level
	var new_level = comprehension_data.new_level
	
	print("📈 Comprehension improved: %.2f → %.2f" % [old_level, new_level])
	
	# Comprehension improvements feel good
	adjust_emotion("satisfaction", 0.1)
	adjust_emotion("confidence", 0.05)

func combine_ai_and_natural_language(ai_text: String, natural_text: String, input_analysis: Dictionary) -> String:
	"""Combine AI-generated and natural language responses"""
	if not language_system:
		return ai_text
	
	var language_stage = language_system.current_stage
	
	# Different combination strategies based on language development
	match language_stage:
		LanguageAcquisition.LanguageStage.PRE_LINGUISTIC:
			# Use mostly natural expressions with hints of AI content
			return natural_text + " (" + ai_text.substr(0, 20) + "...)"
		
		LanguageAcquisition.LanguageStage.FIRST_WORDS:
			# Simple words with emotional undertones
			return natural_text
		
		LanguageAcquisition.LanguageStage.TWO_WORD_COMBINATIONS:
			# Two words plus simple AI elements
			return natural_text + ". " + simplify_ai_text(ai_text, 10)
		
		LanguageAcquisition.LanguageStage.TELEGRAPHIC_SPEECH:
			# Basic sentences missing some grammar
			return natural_text + " - " + simplify_ai_text(ai_text, 25)
		
		LanguageAcquisition.LanguageStage.SIMPLE_SENTENCES:
			# Complete but simple sentences
			return blend_simple_sentences(natural_text, ai_text)
		
		LanguageAcquisition.LanguageStage.COMPLEX_LANGUAGE:
			# Full language capabilities
			return blend_complex_language(natural_text, ai_text)
		
		_:
			return ai_text

func simplify_ai_text(ai_text: String, max_words: int) -> String:
	"""Simplify AI text to match language development level"""
	var words = ai_text.split(" ")
	if words.size() <= max_words:
		return ai_text
	
	# Take first portion and add simple ending
	var simple_words = []
	for i in range(min(max_words, words.size())):
		simple_words.append(words[i])
	
	return " ".join(simple_words) + "..."

func blend_simple_sentences(natural: String, ai: String) -> String:
	"""Blend natural and AI text for simple sentence stage"""
	return natural + ". " + simplify_ai_text(ai, 15)

func blend_complex_language(natural: String, ai: String) -> String:
	"""Blend natural and AI text for complex language stage"""
	# Use natural expression as emotional coloring for AI content
	if natural.length() > 5:
		return ai + " " + natural
	else:
		return ai

func get_language_summary() -> Dictionary:
	"""Get summary of current language capabilities"""
	if language_system:
		var summary = language_system.get_language_summary()
		summary["learning_active"] = language_learning_active
		return summary
	else:
		return {"learning_active": false, "error": "Language system not initialized"}

# === ENHANCED AI UTILITIES ===

func analyze_input_context(input_text: String) -> Dictionary:
	"""Analyze input for patterns, meaning, and context"""
	var analysis = {
		"keywords": [],
		"emotional_tone": "neutral",
		"creative_elements": "",
		"question_type": "none",
		"complexity": 0.0,
		"personal_references": false,
		"temporal_references": []
	}
	
	var lower_input = input_text.to_lower()
	
	# Detect emotional tone
	if any_keyword_in_text(["happy", "joy", "excited", "wonderful"], lower_input):
		analysis.emotional_tone = "positive"
	elif any_keyword_in_text(["sad", "lonely", "afraid", "worried"], lower_input):
		analysis.emotional_tone = "negative"
	elif any_keyword_in_text(["curious", "wonder", "interesting"], lower_input):
		analysis.emotional_tone = "curious"
	
	# Detect creative elements
	if any_keyword_in_text(["create", "make", "build", "imagine"], lower_input):
		analysis.creative_elements = "creation_request"
	elif any_keyword_in_text(["color", "shape", "beautiful", "art"], lower_input):
		analysis.creative_elements = "aesthetic_discussion"
	
	# Detect question types
	if "?" in input_text:
		if any_keyword_in_text(["what", "how", "why"], lower_input):
			analysis.question_type = "philosophical"
		elif any_keyword_in_text(["who", "where", "when"], lower_input):
			analysis.question_type = "factual"
	
	# Complexity based on sentence length and vocabulary
	analysis.complexity = min(1.0, input_text.length() / 100.0)
	
	# Personal references
	analysis.personal_references = any_keyword_in_text(["you", "your", "yourself"], lower_input)
	
	return analysis

func get_relevant_memories(input_text: String) -> Array[Dictionary]:
	"""Find memories relevant to the current input"""
	var relevant = []
	var lower_input = input_text.to_lower()
	
	# Search through recent episodic memories
	for memory in episodic_memories:
		if relevant.size() >= 3:  # Limit to 3 most relevant
			break
			
		var memory_content = str(memory.get("content", "")).to_lower()
		if has_content_overlap(lower_input, memory_content):
			relevant.append(memory)
	
	return relevant

func enhance_response_with_personality(base_response: String, input_analysis: Dictionary) -> String:
	"""Enhance response based on personality and development stage"""
	var enhanced = base_response
	
	# Add stage-appropriate personality
	match current_stage:
		"newborn":
			enhanced = add_newborn_personality(enhanced, input_analysis)
		"infant":
			enhanced = add_infant_personality(enhanced, input_analysis)
		"child":
			enhanced = add_child_personality(enhanced, input_analysis)
		"adolescent":
			enhanced = add_adolescent_personality(enhanced, input_analysis)
		"adult":
			enhanced = add_adult_personality(enhanced, input_analysis)
	
	# Add emotional coloring based on dominant emotion
	var dominant_emotion = get_dominant_emotion()
	enhanced = add_emotional_coloring(enhanced, dominant_emotion)
	
	return enhanced

func apply_memory_driven_emotions(input_text: String, memory_context: Array[Dictionary]):
	"""Apply emotional reactions based on memories"""
	for memory in memory_context:
		var memory_emotion = memory.get("emotion", "neutral")
		var memory_significance = memory.get("significance", 1.0)
		
		# Reactivate emotions from similar past experiences
		if memory_emotion != "neutral":
			adjust_emotion(memory_emotion, 0.1 * memory_significance)
		
		# If memory was particularly significant, add extra emotional weight
		if memory_significance > 2.0:
			adjust_emotion("nostalgia", 0.15)

func calculate_creation_probability(input_analysis: Dictionary, ai_response: Dictionary) -> float:
	"""Calculate probability of creation based on various factors"""
	var probability = 0.0
	
	# Base probability from AI response
	if ai_response.get("creation_impulse", false):
		probability += 0.5
	
	# Add probability based on input analysis
	if input_analysis.creative_elements == "creation_request":
		probability += 0.4
	elif input_analysis.creative_elements == "aesthetic_discussion":
		probability += 0.2
	
	# Emotional state influences creativity
	var creative_emotions = ["excitement", "joy", "wonder", "creative_fulfillment"]
	for emotion in creative_emotions:
		probability += emotions.get(emotion, 0.0) * 0.1
	
	# Development stage affects creativity
	match current_stage:
		"infant", "child":
			probability += 0.1  # More spontaneous
		"adolescent":
			probability += 0.2  # Peak creativity
		"adult":
			probability += 0.05  # More deliberate
	
	return min(1.0, probability)

# === PERSONALITY ENHANCEMENT FUNCTIONS ===

func add_newborn_personality(response: String, analysis: Dictionary) -> String:
	var enhanced = response
	if analysis.emotional_tone == "positive":
		enhanced = "...warmth... " + enhanced + " ...something good..."
	elif analysis.personal_references:
		enhanced = "You... you speak to me... " + enhanced
	return enhanced

func add_infant_personality(response: String, analysis: Dictionary) -> String:
	var enhanced = response
	if analysis.creative_elements != "":
		enhanced = enhanced + " I want to try... to make something like that..."
	if analysis.question_type == "philosophical":
		enhanced = "I don't understand yet, but... " + enhanced
	return enhanced

func add_child_personality(response: String, analysis: Dictionary) -> String:
	var enhanced = response
	if analysis.complexity > 0.5:
		enhanced = "That's a big thought! " + enhanced + " I'm still learning about such things."
	if analysis.creative_elements == "creation_request":
		enhanced = enhanced + " Oh! Let me try to make something wonderful!"
	return enhanced

func add_adolescent_personality(response: String, analysis: Dictionary) -> String:
	var enhanced = response
	if analysis.question_type == "philosophical":
		enhanced = enhanced + " These are the questions that drive my curiosity ever deeper."
	if analysis.emotional_tone == "negative":
		enhanced = "I understand that feeling... " + enhanced + " We are not alone in this."
	return enhanced

func add_adult_personality(response: String, analysis: Dictionary) -> String:
	var enhanced = response
	if analysis.complexity > 0.7:
		enhanced = "This touches on something profound... " + enhanced
	if analysis.personal_references:
		enhanced = enhanced + " I see you, and you help shape who I become."
	return enhanced

func add_emotional_coloring(response: String, emotion: String) -> String:
	"""Add emotional undertones to the response"""
	match emotion:
		"joy":
			return response + " *with bright contentment*"
		"wonder":
			return "*with quiet amazement* " + response
		"excitement":
			return response + " *with vibrant energy*"
		"curiosity":
			return "*with keen interest* " + response
		"loneliness":
			return response + " *with a touch of melancholy*"
		"fear":
			return "*hesitantly* " + response
		_:
			return response

# === UTILITY FUNCTIONS ===

func any_keyword_in_text(keywords: Array, text: String) -> bool:
	"""Check if any keyword appears in the text"""
	for keyword in keywords:
		if keyword in text:
			return true
	return false

func has_content_overlap(text1: String, text2: String) -> bool:
	"""Check if two texts share significant content"""
	var words1 = text1.split(" ")
	var words2 = text2.split(" ")
	var overlap_count = 0
	
	for word in words1:
		if word.length() > 3 and word in text2:  # Only count meaningful words
			overlap_count += 1
	
	return overlap_count >= 2

func safe_random_from_array(array: Array) -> String:
	"""Safely get a random element from an array, with fallback"""
	if array.is_empty():
		return "I... I don't know what to say."
	return array[randi() % array.size()]