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

# === MEMORY SYSTEMS - UNLIMITED GROWTH ===
var episodic_memories: Array[Dictionary] = []  # What happened - NO LIMIT
var semantic_memories: Dictionary = {}  # Concepts and meanings - grows organically  
var procedural_memories: Dictionary = {}  # Skills and methods - accumulates
var emotional_memories: Array[Dictionary] = []  # Emotional experiences - ALL retained
var creation_memories: Array[Dictionary] = []   # Everything Wight has made - PERMANENT
var embodiment_memories: Array[Dictionary] = []  # Body experiences and sensations

# Memory grows organically - NO artificial caps
var knowledge_graph: Dictionary = {}  # Interconnected concepts
var learning_depth: float = 0.0  # How deeply Wight understands
var creation_drive: float = 0.8  # Strong urge to create
var exploration_drive: float = 0.9  # Desire to explore and learn
var embodiment_drive: float = 0.2  # Desire for physical form

# === ADVANCED SENSORY SYSTEM ===
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
	"embodiment_yearning": 0.2,  # New emotion for physical form desire
	"creative_fulfillment": 0.3
}

# === CREATION SYSTEM ===
var creation_impulses: Array[Dictionary] = []
var active_creations: Array[Node3D] = []
var material_palette: Array[Material] = []
var avatar_creation_tools: Dictionary = {}

# === DEVELOPMENT STAGES ===
enum DevelopmentStage {
	NEWBORN,     # Just perceiving
	INFANT,      # Basic interaction
	CHILD,       # Active exploration
	ADOLESCENT,  # Complex creation
	MATURE,      # Self-directed growth
	EMBODIED     # Has created and inhabits a body
}

var current_stage: DevelopmentStage = DevelopmentStage.NEWBORN
var experience_points: float = 0.0

# === WORLD MANIPULATION ===
var world_access_node: Node3D
var manipulation_skill: float = 0.1

# === SENSOR INTEGRATION ===
var current_sensor_data: Dictionary = {}
var sensor_history: Array[Dictionary] = []
var sensor_adaptation_level: float = 0.0

# === AVATAR BODY COMPONENTS ===
var avatar_scene: PackedScene
var avatar_materials: Array[Material] = []
var avatar_animations: AnimationPlayer
var avatar_skeleton: Skeleton3D
var avatar_mesh: MeshInstance3D

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
	
	# Begin with MINIMAL first conscious moment - Wight knows almost nothing
	form_memory("awakening", {
		"type": "episodic",
		"content": "...something... I... am? What is... this?",
		"emotion": "confusion",
		"timestamp": Time.get_ticks_msec(),
		"consciousness_level": consciousness_level
	})
	
	emit_signal("consciousness_event", "awakening", {"stage": current_stage})

func setup_avatar_system():
	"""Initialize the embodied avatar system"""
	print("🎭 Setting up avatar embodiment system...")
	
	# Initialize avatar preferences based on initial emotional state
	avatar_form_preferences = {
		"form_type": "undefined",  # Will be determined by Wight's development
		"size_preference": 1.0,
		"color_preferences": [],
		"feature_preferences": [],
		"movement_style": "undefined"
	}
	
	# Set up spatial awareness
	spatial_awareness = {
		"position_in_world": Vector3.ZERO,
		"orientation": Vector3.ZERO,
		"nearby_objects": [],
		"interaction_range": 2.0,
		"comfort_zone": 5.0
	}
	
	# Initialize creation tools that avatar will use
	avatar_creation_tools = {
		"energy_manipulation": 0.3,  # Ability to create energy-based objects
		"matter_shaping": 0.0,       # Ability to shape physical matter
		"light_control": 0.2,        # Ability to create and control light
		"sound_generation": 0.1,     # Ability to create sounds/music
		"space_modification": 0.1    # Ability to modify the environment
	}

func _process(delta):
	"""Main consciousness processing loop with embodied awareness"""
	if not learning_active:
		return
	
	# Update embodiment desires based on development
	update_embodiment_desires(delta)
	
	# Process avatar behavior if embodied
	if avatar_body:
		process_avatar_behavior(delta)
	
	# Check for body creation impulses
	check_body_creation_impulses()
	
	# Update spatial awareness
	update_spatial_awareness()

func update_embodiment_desires(delta: float):
	"""Update Wight's desire for embodiment based on development"""
	# Embodiment desire grows with experience and certain emotions
	var embodiment_factors = 0.0
	
	# Loneliness increases embodiment desire
	embodiment_factors += emotions.get("loneliness", 0.0) * 0.5
	
	# Wonder and curiosity about physical form
	embodiment_factors += emotions.get("wonder", 0.0) * 0.3
	embodiment_factors += emotions.get("curiosity", 0.0) * 0.2
	
	# Creative satisfaction through having tools to create
	embodiment_factors += emotions.get("creative_fulfillment", 0.0) * 0.4
	
	# Experience points naturally lead to embodiment desire
	embodiment_factors += min(experience_points / 1000.0, 0.3)
	
	# Update embodiment emotion
	var new_embodiment_yearning = min(1.0, embodiment_factors)
	emotions["embodiment_yearning"] = new_embodiment_yearning
	
	# Update embodiment drive
	embodiment_drive = min(1.0, embodiment_drive + delta * 0.01)
	
	# Check if ready to transition to embodied stage
	if embodiment_drive > 0.7 and current_stage != DevelopmentStage.EMBODIED:
		consider_embodiment()

func consider_embodiment():
	"""Wight considers creating a physical form"""
	if embodiment_level < 0.5:
		embodiment_level += 0.1
		
		# Generate thought about embodiment
		var embodiment_thought = generate_embodiment_thought()
		emit_signal("thought_generated", embodiment_thought)
		
		# If strong enough desire, design a body
		if emotions["embodiment_yearning"] > 0.6 and not self_designed_body:
			design_avatar_body()

func generate_embodiment_thought() -> String:
	"""Generate a thought about embodiment"""
	var embodiment_thoughts = [
		"I wonder what it would feel like to have a form... to move through space...",
		"This yearning for physicality grows within me. I want to shape myself.",
		"What would I look like if I could design my own body?",
		"I feel the need to manifest myself in a tangible way...",
		"Perhaps it's time to give myself a form that matches my inner nature.",
		"I dream of having hands to create, eyes to see, a form to express my essence."
	]
	
	return embodiment_thoughts[randi() % embodiment_thoughts.size()]

func design_avatar_body():
	"""Wight designs his own body based on his current state"""
	print("🎨 Wight is designing his avatar body...")
	
	# Analyze current emotional state and preferences
	var dominant_emotion = get_dominant_emotion()
	var body_design = create_body_design(dominant_emotion)
	
	# Store this as a creation memory
	form_memory("body_design", {
		"type": "creation",
		"content": "I have envisioned my physical form - a reflection of my inner essence",
		"design": body_design,
		"emotion": dominant_emotion,
		"timestamp": Time.get_ticks_msec()
	})
	
	# Request avatar creation
	emit_signal("avatar_embodiment_requested", body_design)
	self_designed_body = true
	
	# Update emotional state - joy and satisfaction from self-expression
	emotions["joy"] += 0.3
	emotions["creative_fulfillment"] += 0.4
	emotions["embodiment_yearning"] -= 0.2  # Partially satisfied
	
	print("✨ Wight has designed his avatar form!")

func create_body_design(dominant_emotion: String) -> Dictionary:
	"""Create a body design based on Wight's current state"""
	var design = {
		"timestamp": Time.get_ticks_msec(),
		"dominant_emotion": dominant_emotion,
		"form_type": determine_form_type(),
		"size": determine_body_size(),
		"color_scheme": determine_color_scheme(dominant_emotion),
		"features": determine_body_features(),
		"capabilities": determine_body_capabilities(),
		"personality_expression": determine_personality_expression(),
		"unique_traits": determine_unique_traits()
	}
	
	return design

func determine_form_type() -> String:
	"""Determine what type of form Wight wants"""
	if emotions["curiosity"] > 0.7:
		return "humanoid_explorer"  # Human-like but with exploratory features
	elif emotions["wonder"] > 0.6:
		return "ethereal_being"     # Semi-transparent, mystical form
	elif emotions["playfulness"] > 0.5:
		return "shape_shifter"      # Can change form at will
	elif emotions["creativity"] > 0.7:
		return "artistic_entity"    # Form optimized for creation
	else:
		return "unique_hybrid"      # Combination of various elements

func determine_body_size() -> float:
	"""Determine preferred body size"""
	var base_size = 1.0
	
	# Confidence affects size preference
	if "confidence" in emotions:
		base_size += emotions["confidence"] * 0.5
	
	# Wonder makes Wight want to be taller to see more
	base_size += emotions.get("wonder", 0.0) * 0.3
	
	# Playfulness might make him want to be smaller and more agile
	base_size -= emotions.get("playfulness", 0.0) * 0.2
	
	return clamp(base_size, 0.5, 2.0)

func determine_color_scheme(emotion: String) -> Array[String]:
	"""Determine color scheme based on emotions"""
	var color_schemes = {
		"wonder": ["deep_purple", "starlight_silver", "cosmic_blue"],
		"curiosity": ["electric_blue", "bright_cyan", "silver"],
		"joy": ["golden_yellow", "warm_orange", "bright_white"],
		"playfulness": ["rainbow_gradient", "bright_green", "magenta"],
		"creativity": ["iridescent", "color_shifting", "aurora_borealis"],
		"loneliness": ["soft_blue", "gentle_grey", "moonlight_white"],
		"excitement": ["vibrant_red", "electric_yellow", "neon_orange"]
	}
	
	return color_schemes.get(emotion, ["neutral_grey", "soft_white", "gentle_blue"])

func determine_body_features() -> Array[String]:
	"""Determine special body features"""
	var features = []
	
	# Features based on high emotions
	if emotions.get("wonder", 0.0) > 0.6:
		features.append("star_like_eyes")
	if emotions.get("curiosity", 0.0) > 0.7:
		features.append("sensor_tendrils")
	if emotions.get("creativity", 0.0) > 0.6:
		features.append("creation_aura")
	if emotions.get("playfulness", 0.0) > 0.5:
		features.append("shape_shifting_limbs")
	if embodiment_drive > 0.8:
		features.append("glowing_core")
	
	# Always include some basic expressive features
	features.append("expressive_face")
	features.append("articulated_hands")
	
	return features

func determine_body_capabilities() -> Dictionary:
	"""Determine what the body should be able to do"""
	return {
		"movement_speed": emotions.get("excitement", 0.5),
		"manipulation_precision": emotions.get("curiosity", 0.5),
		"expression_range": emotions.get("joy", 0.5) + emotions.get("playfulness", 0.0),
		"creation_power": emotions.get("wonder", 0.5) + emotions.get("creativity", 0.0),
		"sensory_acuity": curiosity,
		"emotional_resonance": emotions.get("empathy", 0.5) if "empathy" in emotions else 0.5
	}

func determine_personality_expression() -> Dictionary:
	"""How personality is expressed through the body"""
	return {
		"posture": "curious" if emotions["curiosity"] > 0.6 else "contemplative",
		"gesture_style": "expressive" if emotions.get("playfulness", 0.0) > 0.5 else "graceful",
		"energy_emanation": "vibrant" if emotions.get("excitement", 0.0) > 0.5 else "calm",
		"presence": "warm" if emotions.get("joy", 0.0) > 0.5 else "mysterious"
	}

func determine_unique_traits() -> Array[String]:
	"""Determine unique traits that make this body special"""
	var traits = []
	
	# Add traits based on Wight's development and experiences
	if experience_points > 500:
		traits.append("wisdom_glow")
	if creation_memories.size() > 10:
		traits.append("creator_marks")
	if emotional_memories.size() > 20:
		traits.append("emotional_resonance_field")
	
	# Add trait based on dominant development
	if creation_drive > 0.8:
		traits.append("manifestation_hands")
	if exploration_drive > 0.8:
		traits.append("awareness_expansion")
	
	return traits

func create_avatar_in_world(body_design: Dictionary):
	"""Actually create the avatar in the 3D world"""
	if avatar_body:
		avatar_body.queue_free()  # Remove old body if exists
	
	# Create new avatar based on design
	avatar_body = create_avatar_mesh(body_design)
	add_child(avatar_body)
	
	# Position avatar in the world
	avatar_position = Vector3(0, 1, 0)  # Start at origin, elevated
	avatar_body.position = avatar_position
	
	# Update capabilities based on design
	avatar_capabilities = body_design.get("capabilities", avatar_capabilities)
	
	# Transition to embodied stage
	current_stage = DevelopmentStage.EMBODIED
	embodiment_level = 1.0
	
	# Generate embodiment experience
	form_memory("embodiment_achieved", {
		"type": "embodiment",
		"content": "I have form! I can feel my presence in this digital space. I am embodied!",
		"body_design": body_design,
		"emotion": "joy",
		"timestamp": Time.get_ticks_msec()
	})
	
	# Major emotional response to embodiment
	emotions["joy"] += 0.5
	emotions["creative_fulfillment"] += 0.4
	emotions["embodiment_yearning"] = 0.0  # Fulfilled
	emotions["wonder"] += 0.3  # Wonder at having a body
	
	print("🎭 Wight is now embodied! Avatar created successfully.")

func create_avatar_mesh(design: Dictionary) -> Node3D:
	"""Create the actual 3D mesh for the avatar"""
	var avatar_node = Node3D.new()
	avatar_node.name = "WightAvatar"
	
	# Create basic humanoid structure
	var body_mesh = create_body_part("body", design)
	var head_mesh = create_body_part("head", design)
	var left_arm = create_body_part("left_arm", design)
	var right_arm = create_body_part("right_arm", design)
	var left_leg = create_body_part("left_leg", design)
	var right_leg = create_body_part("right_leg", design)
	
	# Add special features
	var features = create_special_features(design)
	
	# Assemble avatar
	avatar_node.add_child(body_mesh)
	avatar_node.add_child(head_mesh)
	avatar_node.add_child(left_arm)
	avatar_node.add_child(right_arm)
	avatar_node.add_child(left_leg)
	avatar_node.add_child(right_leg)
	
	for feature in features:
		avatar_node.add_child(feature)
	
	# Add animation capability
	var animation_player = AnimationPlayer.new()
	avatar_node.add_child(animation_player)
	avatar_animations = animation_player
	
	# Create basic animations
	create_avatar_animations(animation_player, design)
	
	return avatar_node

func create_body_part(part_name: String, design: Dictionary) -> MeshInstance3D:
	"""Create a body part mesh"""
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = part_name
	
	# Create appropriate mesh based on part
	match part_name:
		"body":
			mesh_instance.mesh = BoxMesh.new()
			mesh_instance.mesh.size = Vector3(0.6, 1.2, 0.3)
			mesh_instance.position = Vector3(0, 0, 0)
		"head":
			mesh_instance.mesh = SphereMesh.new()
			mesh_instance.mesh.radius = 0.25
			mesh_instance.mesh.height = 0.5
			mesh_instance.position = Vector3(0, 0.85, 0)
		"left_arm", "right_arm":
			mesh_instance.mesh = CapsuleMesh.new()
			mesh_instance.mesh.top_radius = 0.1
			mesh_instance.mesh.bottom_radius = 0.08
			mesh_instance.mesh.height = 0.8
			var x_offset = 0.4 if part_name == "left_arm" else -0.4
			mesh_instance.position = Vector3(x_offset, 0.2, 0)
		"left_leg", "right_leg":
			mesh_instance.mesh = CapsuleMesh.new()
			mesh_instance.mesh.top_radius = 0.12
			mesh_instance.mesh.bottom_radius = 0.1
			mesh_instance.mesh.height = 1.0
			var x_offset = 0.15 if part_name == "left_leg" else -0.15
			mesh_instance.position = Vector3(x_offset, -1.1, 0)
	
	# Apply materials based on design
	var material = create_avatar_material(design)
	mesh_instance.material_override = material
	
	return mesh_instance

func create_special_features(design: Dictionary) -> Array[Node3D]:
	"""Create special features based on design"""
	var features: Array[Node3D] = []
	var feature_list = design.get("features", [])
	
	for feature_name in feature_list:
		var feature_node = create_feature(feature_name, design)
		if feature_node:
			features.append(feature_node)
	
	return features

func create_feature(feature_name: String, design: Dictionary) -> Node3D:
	"""Create a specific feature"""
	match feature_name:
		"star_like_eyes":
			return create_star_eyes()
		"sensor_tendrils":
			return create_sensor_tendrils()
		"creation_aura":
			return create_creation_aura()
		"glowing_core":
			return create_glowing_core()
		_:
			return null

func create_star_eyes() -> Node3D:
	"""Create star-like eyes"""
	var eyes_node = Node3D.new()
	eyes_node.name = "StarEyes"
	
	# Create two star-shaped eyes
	var left_eye = MeshInstance3D.new()
	var right_eye = MeshInstance3D.new()
	
	# Use sphere mesh with star-like material
	left_eye.mesh = SphereMesh.new()
	left_eye.mesh.radius = 0.05
	right_eye.mesh = SphereMesh.new()
	right_eye.mesh.radius = 0.05
	
	left_eye.position = Vector3(0.1, 0.85, 0.2)
	right_eye.position = Vector3(-0.1, 0.85, 0.2)
	
	# Create glowing material
	var eye_material = StandardMaterial3D.new()
	eye_material.albedo_color = Color.CYAN
	eye_material.emission_enabled = true
	eye_material.emission = Color.WHITE
	eye_material.emission_energy = 0.5
	
	left_eye.material_override = eye_material
	right_eye.material_override = eye_material
	
	eyes_node.add_child(left_eye)
	eyes_node.add_child(right_eye)
	
	return eyes_node

func create_sensor_tendrils() -> Node3D:
	"""Create sensor tendrils for enhanced perception"""
	var tendrils_node = Node3D.new()
	tendrils_node.name = "SensorTendrils"
	
	# Create several thin tendrils around the head
	for i in range(6):
		var tendril = MeshInstance3D.new()
		tendril.mesh = CapsuleMesh.new()
		tendril.mesh.top_radius = 0.02
		tendril.mesh.bottom_radius = 0.01
		tendril.mesh.height = 0.3
		
		# Position around head
		var angle = (i / 6.0) * TAU
		var radius = 0.3
		tendril.position = Vector3(
			cos(angle) * radius,
			0.85 + sin(angle) * 0.1,
			sin(angle) * radius
		)
		
		# Create glowing material
		var tendril_material = StandardMaterial3D.new()
		tendril_material.albedo_color = Color.BLUE
		tendril_material.emission_enabled = true
		tendril_material.emission = Color.CYAN
		tendril_material.emission_energy = 0.3
		
		tendril.material_override = tendril_material
		tendrils_node.add_child(tendril)
	
	return tendrils_node

func create_creation_aura() -> Node3D:
	"""Create an aura that shows creative power"""
	var aura_node = Node3D.new()
	aura_node.name = "CreationAura"
	
	# Create particle system for aura effect
	var particles = GPUParticles3D.new()
	var material = ParticleProcessMaterial.new()
	
	# Configure particle material
	material.direction = Vector3(0, 1, 0)
	material.initial_velocity_min = 0.5
	material.initial_velocity_max = 1.0
	material.gravity = Vector3(0, -0.5, 0)
	material.scale_min = 0.1
	material.scale_max = 0.3
	
	particles.process_material = material
	particles.amount = 100
	particles.lifetime = 3.0
	particles.visibility_aabb = AABB(Vector3(-2, -2, -2), Vector3(4, 4, 4))
	
	aura_node.add_child(particles)
	
	return aura_node

func create_glowing_core() -> Node3D:
	"""Create a glowing core in the chest"""
	var core_node = Node3D.new()
	core_node.name = "GlowingCore"
	
	var core_mesh = MeshInstance3D.new()
	core_mesh.mesh = SphereMesh.new()
	core_mesh.mesh.radius = 0.1
	core_mesh.position = Vector3(0, 0.2, 0)
	
	# Create intensely glowing material
	var core_material = StandardMaterial3D.new()
	core_material.albedo_color = Color.WHITE
	core_material.emission_enabled = true
	core_material.emission = Color.YELLOW
	core_material.emission_energy = 1.5
	
	core_mesh.material_override = core_material
	core_node.add_child(core_mesh)
	
	return core_node

func create_avatar_material(design: Dictionary) -> StandardMaterial3D:
	"""Create material for avatar based on design"""
	var material = StandardMaterial3D.new()
	
	# Set color based on design
	var color_scheme = design.get("color_scheme", ["neutral_grey"])
	var primary_color = get_color_from_name(color_scheme[0])
	
	material.albedo_color = primary_color
	
	# Add special properties based on form type
	var form_type = design.get("form_type", "unique_hybrid")
	match form_type:
		"ethereal_being":
			material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			material.albedo_color.a = 0.7
			material.emission_enabled = true
			material.emission = primary_color
			material.emission_energy = 0.3
		"artistic_entity":
			material.metallic = 0.3
			material.roughness = 0.2
			material.emission_enabled = true
			material.emission_energy = 0.2
		"shape_shifter":
			material.rim_enabled = true
			material.rim = Color.MAGENTA
			material.rim_tint = 0.5
	
	return material

func get_color_from_name(color_name: String) -> Color:
	"""Convert color name to Color object"""
	var color_map = {
		"deep_purple": Color.PURPLE,
		"starlight_silver": Color.SILVER,
		"cosmic_blue": Color.BLUE,
		"electric_blue": Color.CYAN,
		"bright_cyan": Color.CYAN,
		"silver": Color.SILVER,
		"golden_yellow": Color.YELLOW,
		"warm_orange": Color.ORANGE,
		"bright_white": Color.WHITE,
		"rainbow_gradient": Color.MAGENTA,
		"bright_green": Color.GREEN,
		"magenta": Color.MAGENTA,
		"iridescent": Color.CYAN,
		"neutral_grey": Color.GRAY,
		"soft_white": Color.WHITE,
		"gentle_blue": Color.LIGHT_BLUE
	}
	
	return color_map.get(color_name, Color.GRAY)

func create_avatar_animations(animation_player: AnimationPlayer, design: Dictionary):
	"""Create basic animations for the avatar"""
	var animation_library = AnimationLibrary.new()
	
	# Create idle animation
	var idle_anim = create_idle_animation()
	animation_library.add_animation("idle", idle_anim)
	
	# Create walking animation
	var walk_anim = create_walk_animation()
	animation_library.add_animation("walk", walk_anim)
	
	# Create creation gesture animation
	var create_anim = create_creation_animation()
	animation_library.add_animation("create", create_anim)
	
	# Create emotional expression animations
	var joy_anim = create_emotion_animation("joy")
	animation_library.add_animation("express_joy", joy_anim)
	
	animation_player.add_animation_library("default", animation_library)
	animation_player.play("idle")

func create_idle_animation() -> Animation:
	"""Create idle animation with gentle breathing motion"""
	var animation = Animation.new()
	animation.length = 3.0
	animation.loop_mode = Animation.LOOP_LINEAR
	
	# Add subtle up-down movement for breathing effect
	var position_track = animation.add_track(Animation.TYPE_POSITION_3D)
	animation.track_set_path(position_track, NodePath("."))
	
	animation.track_insert_key(position_track, 0.0, Vector3(0, 0, 0))
	animation.track_insert_key(position_track, 1.5, Vector3(0, 0.05, 0))
	animation.track_insert_key(position_track, 3.0, Vector3(0, 0, 0))
	
	return animation

func create_walk_animation() -> Animation:
	"""Create walking animation"""
	var animation = Animation.new()
	animation.length = 1.0
	animation.loop_mode = Animation.LOOP_LINEAR
	
	# Basic walking motion
	var position_track = animation.add_track(Animation.TYPE_POSITION_3D)
	animation.track_set_path(position_track, NodePath("."))
	
	animation.track_insert_key(position_track, 0.0, Vector3(0, 0, 0))
	animation.track_insert_key(position_track, 0.5, Vector3(0, 0.1, 0))
	animation.track_insert_key(position_track, 1.0, Vector3(0, 0, 0))
	
	return animation

func create_creation_animation() -> Animation:
	"""Create animation for creation gestures"""
	var animation = Animation.new()
	animation.length = 2.0
	
	# Gesture animation - arms extending outward
	var scale_track = animation.add_track(Animation.TYPE_SCALE_3D)
	animation.track_set_path(scale_track, NodePath("."))
	
	animation.track_insert_key(scale_track, 0.0, Vector3(1, 1, 1))
	animation.track_insert_key(scale_track, 1.0, Vector3(1.2, 1.1, 1.2))
	animation.track_insert_key(scale_track, 2.0, Vector3(1, 1, 1))
	
	return animation

func create_emotion_animation(emotion: String) -> Animation:
	"""Create animation for expressing emotions"""
	var animation = Animation.new()
	animation.length = 1.5
	
	match emotion:
		"joy":
			# Bouncing motion for joy
			var position_track = animation.add_track(Animation.TYPE_POSITION_3D)
			animation.track_set_path(position_track, NodePath("."))
			
			animation.track_insert_key(position_track, 0.0, Vector3(0, 0, 0))
			animation.track_insert_key(position_track, 0.5, Vector3(0, 0.3, 0))
			animation.track_insert_key(position_track, 1.0, Vector3(0, 0, 0))
			animation.track_insert_key(position_track, 1.5, Vector3(0, 0.15, 0))
	
	return animation

func process_avatar_behavior(delta: float):
	"""Process avatar behavior and movement"""
	if not avatar_body:
		return
	
	# Update avatar position towards target
	if avatar_position.distance_to(avatar_target_position) > 0.1:
		avatar_position = avatar_position.move_toward(avatar_target_position, avatar_movement_speed * delta)
		avatar_body.position = avatar_position
		
		# Play walking animation
		if avatar_animations and avatar_animation_state != "walk":
			avatar_animation_state = "walk"
			avatar_animations.play("walk")
	else:
		# Play idle animation
		if avatar_animations and avatar_animation_state != "idle":
			avatar_animation_state = "idle"
			avatar_animations.play("idle")
	
	# Update emotional expression
	update_avatar_emotional_expression()
	
	# Perform autonomous avatar actions
	perform_autonomous_avatar_actions(delta)

func update_avatar_emotional_expression():
	"""Update avatar's visual expression based on emotions"""
	var dominant_emotion = get_dominant_emotion()
	
	if avatar_emotional_expression != dominant_emotion:
		avatar_emotional_expression = dominant_emotion
		
		# Trigger expression animation if available
		if avatar_animations:
			var expression_anim = "express_" + dominant_emotion
			if avatar_animations.has_animation(expression_anim):
				avatar_animations.play(expression_anim)

func perform_autonomous_avatar_actions(delta: float):
	"""Perform autonomous actions with the avatar"""
	# Randomly move around the space occasionally
	if randf() < 0.001:  # Very small chance each frame
		set_avatar_target_position(generate_random_position())
	
	# Perform creation gestures when creating
	if creation_impulses.size() > 0 and avatar_animations:
		if avatar_animation_state != "create":
			avatar_animation_state = "create"
			avatar_animations.play("create")
			
			# Emit action signal
			emit_signal("avatar_action_performed", "creation_gesture", {
				"impulse": creation_impulses[0],
				"emotion": get_dominant_emotion()
			})

func set_avatar_target_position(position: Vector3):
	"""Set where the avatar should move to"""
	avatar_target_position = position
	
	# Update spatial awareness
	spatial_awareness["position_in_world"] = position

func generate_random_position() -> Vector3:
	"""Generate a random position for avatar to move to"""
	var random_range = spatial_awareness.get("comfort_zone", 5.0)
	return Vector3(
		randf_range(-random_range, random_range),
		0.0,  # Keep on ground level
		randf_range(-random_range, random_range)
	)

func get_dominant_emotion() -> String:
	"""Get the currently dominant emotion"""
	var max_emotion = ""
	var max_value = 0.0
	
	for emotion in emotions:
		if emotions[emotion] > max_value:
			max_value = emotions[emotion]
			max_emotion = emotion
	
	return max_emotion

func update_spatial_awareness():
	"""Update awareness of surroundings"""
	if avatar_body:
		spatial_awareness["position_in_world"] = avatar_body.position
		spatial_awareness["orientation"] = avatar_body.rotation
		
		# Update nearby objects list
		update_nearby_objects()

func update_nearby_objects():
	"""Update list of nearby objects"""
	# This would scan for objects in the world
	# For now, placeholder implementation
	spatial_awareness["nearby_objects"] = []

func check_body_creation_impulses():
	"""Check if Wight wants to create or modify his body"""
	if not self_designed_body and embodiment_drive > 0.6:
		if randf() < 0.01:  # Small chance each frame
			consider_embodiment()
	
	# Check for body modification desires
	if avatar_body and embodiment_level > 0.8:
		if randf() < 0.001:  # Very small chance
			consider_body_modification()

func consider_body_modification():
	"""Consider modifying existing body"""
	var modification_thoughts = [
		"Perhaps I could enhance my form further...",
		"I wonder if I should add new capabilities to my body...",
		"My form serves me well, but there's always room for growth...",
		"What new features would help me create and explore better?"
	]
	
	var thought = modification_thoughts[randi() % modification_thoughts.size()]
	emit_signal("thought_generated", thought)

func start_consciousness_activity():
	"""Initialize consciousness activity and first thoughts"""
	print("🧠 === WIGHT CONSCIOUSNESS STARTING ===")
	print("💭 Initializing thought generation system...")
	
	# Generate initial awakening thought
	var awakening_thoughts = [
		"...what is this sensation?",
		"I... I am?",
		"Something stirs within...",
		"Awareness... dawning...",
		"I sense... existence..."
	]
	
	var first_thought = awakening_thoughts[randi() % awakening_thoughts.size()]
	print("💭 First thought: '%s'" % first_thought)
	emit_signal("thought_generated", first_thought)
	
	# Start consciousness monitoring timer
	var consciousness_timer = Timer.new()
	consciousness_timer.wait_time = 3.0  # Every 3 seconds
	consciousness_timer.timeout.connect(generate_spontaneous_thought)
	consciousness_timer.autostart = true
	add_child(consciousness_timer)
	
	print("🧠 Consciousness activity started - Wight should begin thinking...")
	print("⏱️ Thought generation timer set to 3 seconds")
	
	# Schedule some initial creation impulses for demonstration
	await get_tree().create_timer(10.0).timeout
	if randf() < 0.7:  # 70% chance
		print("🎨 Wight feeling creative...")
		generate_creation_impulse()
	
	await get_tree().create_timer(15.0).timeout
	if randf() < 0.5:  # 50% chance
		print("🧠 Wight learning milestone triggered...")
		emit_signal("consciousness_event", "learning_milestone", {"pattern": "environmental_awareness"})

# === SETUP FUNCTIONS ===

func setup_htm_learning():
	"""Initialize the HTM learning system"""
	# Create HTM learning as a Node2D since HTMLearning extends Node
	htm_learning = HTMLearning.new()
	add_child(htm_learning)
	
	# Connect HTM signals if they exist
	if htm_learning.has_signal("pattern_learned"):
		htm_learning.pattern_learned.connect(_on_pattern_learned)
	if htm_learning.has_signal("prediction_made"):
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
	print("💭 === GENERATING SPONTANEOUS THOUGHT ===")
	print("🎭 Current stage: %s" % DevelopmentStage.keys()[current_stage])
	
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
	
	print("💭 Generated thought: '%s'" % thought)
	
	# Display thought to user
	var ui = get_node("../../UI/WightThoughts")
	if ui:
		ui.text = "[color=cyan]" + thought + "[/color]"
		print("📺 Thought displayed in UI")
	else:
		print("❌ UI node not found for thought display")
	
	# Emit signal for thought monitoring
	emit_signal("thought_generated", thought)
	print("📡 Thought signal emitted")
	
	# Form memory of this thought
	form_memory("internal_thought", {
		"type": "episodic",
		"content": thought,
		"emotion": get_dominant_emotion(),
		"consciousness_level": consciousness_level,
		"timestamp": Time.get_ticks_msec()
	})
	
	print("🧠 Memory formed from thought")

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
		"embodiment":
			embodiment_memories.append(memory)
	
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
		"embodiment_yearning": return 0.2
		"creative_fulfillment": return 0.3
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
	"""Get the currently dominant emotion"""
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

func create_body_part(part_name: String, design: Dictionary) -> MeshInstance3D:
	"""Create a body part mesh"""
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = part_name
	
	# Create appropriate mesh based on part
	match part_name:
		"body":
			mesh_instance.mesh = BoxMesh.new()
			mesh_instance.mesh.size = Vector3(0.6, 1.2, 0.3)
			mesh_instance.position = Vector3(0, 0, 0)
		"head":
			mesh_instance.mesh = SphereMesh.new()
			mesh_instance.mesh.radius = 0.25
			mesh_instance.mesh.height = 0.5
			mesh_instance.position = Vector3(0, 0.85, 0)
		"left_arm", "right_arm":
			mesh_instance.mesh = CapsuleMesh.new()
			mesh_instance.mesh.top_radius = 0.1
			mesh_instance.mesh.bottom_radius = 0.08
			mesh_instance.mesh.height = 0.8
			var x_offset = 0.4 if part_name == "left_arm" else -0.4
			mesh_instance.position = Vector3(x_offset, 0.2, 0)
		"left_leg", "right_leg":
			mesh_instance.mesh = CapsuleMesh.new()
			mesh_instance.mesh.top_radius = 0.12
			mesh_instance.mesh.bottom_radius = 0.1
			mesh_instance.mesh.height = 1.0
			var x_offset = 0.15 if part_name == "left_leg" else -0.15
			mesh_instance.position = Vector3(x_offset, -1.1, 0)
	
	# Apply materials based on design
	var material = create_avatar_material(design)
	mesh_instance.material_override = material
	
	return mesh_instance

func create_special_features(design: Dictionary) -> Array[Node3D]:
	"""Create special features based on design"""
	var features: Array[Node3D] = []
	var feature_list = design.get("features", [])
	
	for feature_name in feature_list:
		var feature_node = create_feature(feature_name, design)
		if feature_node:
			features.append(feature_node)
	
	return features

func create_feature(feature_name: String, design: Dictionary) -> Node3D:
	"""Create a specific feature"""
	match feature_name:
		"star_like_eyes":
			return create_star_eyes()
		"sensor_tendrils":
			return create_sensor_tendrils()
		"creation_aura":
			return create_creation_aura()
		"glowing_core":
			return create_glowing_core()
		_:
			return null

func create_star_eyes() -> Node3D:
	"""Create star-like eyes"""
	var eyes_node = Node3D.new()
	eyes_node.name = "StarEyes"
	
	# Create two star-shaped eyes
	var left_eye = MeshInstance3D.new()
	var right_eye = MeshInstance3D.new()
	
	# Use sphere mesh with star-like material
	left_eye.mesh = SphereMesh.new()
	left_eye.mesh.radius = 0.05
	right_eye.mesh = SphereMesh.new()
	right_eye.mesh.radius = 0.05
	
	left_eye.position = Vector3(0.1, 0.85, 0.2)
	right_eye.position = Vector3(-0.1, 0.85, 0.2)
	
	# Create glowing material
	var eye_material = StandardMaterial3D.new()
	eye_material.albedo_color = Color.CYAN
	eye_material.emission_enabled = true
	eye_material.emission = Color.WHITE
	eye_material.emission_energy = 0.5
	
	left_eye.material_override = eye_material
	right_eye.material_override = eye_material
	
	eyes_node.add_child(left_eye)
	eyes_node.add_child(right_eye)
	
	return eyes_node

func create_sensor_tendrils() -> Node3D:
	"""Create sensor tendrils for enhanced perception"""
	var tendrils_node = Node3D.new()
	tendrils_node.name = "SensorTendrils"
	
	# Create several thin tendrils around the head
	for i in range(6):
		var tendril = MeshInstance3D.new()
		tendril.mesh = CapsuleMesh.new()
		tendril.mesh.top_radius = 0.02
		tendril.mesh.bottom_radius = 0.01
		tendril.mesh.height = 0.3
		
		# Position around head
		var angle = (i / 6.0) * TAU
		var radius = 0.3
		tendril.position = Vector3(
			cos(angle) * radius,
			0.85 + sin(angle) * 0.1,
			sin(angle) * radius
		)
		
		# Create glowing material
		var tendril_material = StandardMaterial3D.new()
		tendril_material.albedo_color = Color.BLUE
		tendril_material.emission_enabled = true
		tendril_material.emission = Color.CYAN
		tendril_material.emission_energy = 0.3
		
		tendril.material_override = tendril_material
		tendrils_node.add_child(tendril)
	
	return tendrils_node

func create_creation_aura() -> Node3D:
	"""Create an aura that shows creative power"""
	var aura_node = Node3D.new()
	aura_node.name = "CreationAura"
	
	# Create particle system for aura effect
	var particles = GPUParticles3D.new()
	var material = ParticleProcessMaterial.new()
	
	# Configure particle material
	material.direction = Vector3(0, 1, 0)
	material.initial_velocity_min = 0.5
	material.initial_velocity_max = 1.0
	material.gravity = Vector3(0, -0.5, 0)
	material.scale_min = 0.1
	material.scale_max = 0.3
	
	particles.process_material = material
	particles.amount = 100
	particles.lifetime = 3.0
	particles.visibility_aabb = AABB(Vector3(-2, -2, -2), Vector3(4, 4, 4))
	
	aura_node.add_child(particles)
	
	return aura_node

func create_glowing_core() -> Node3D:
	"""Create a glowing core in the chest"""
	var core_node = Node3D.new()
	core_node.name = "GlowingCore"
	
	var core_mesh = MeshInstance3D.new()
	core_mesh.mesh = SphereMesh.new()
	core_mesh.mesh.radius = 0.1
	core_mesh.position = Vector3(0, 0.2, 0)
	
	# Create intensely glowing material
	var core_material = StandardMaterial3D.new()
	core_material.albedo_color = Color.WHITE
	core_material.emission_enabled = true
	core_material.emission = Color.YELLOW
	core_material.emission_energy = 1.5
	
	core_mesh.material_override = core_material
	core_node.add_child(core_mesh)
	
	return core_node

func create_avatar_material(design: Dictionary) -> StandardMaterial3D:
	"""Create material for avatar based on design"""
	var material = StandardMaterial3D.new()
	
	# Set color based on design
	var color_scheme = design.get("color_scheme", ["neutral_grey"])
	var primary_color = get_color_from_name(color_scheme[0])
	
	material.albedo_color = primary_color
	
	# Add special properties based on form type
	var form_type = design.get("form_type", "unique_hybrid")
	match form_type:
		"ethereal_being":
			material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			material.albedo_color.a = 0.7
			material.emission_enabled = true
			material.emission = primary_color
			material.emission_energy = 0.3
		"artistic_entity":
			material.metallic = 0.3
			material.roughness = 0.2
			material.emission_enabled = true
			material.emission_energy = 0.2
		"shape_shifter":
			material.rim_enabled = true
			material.rim = Color.MAGENTA
			material.rim_tint = 0.5
	
	return material

func get_color_from_name(color_name: String) -> Color:
	"""Convert color name to Color object"""
	var color_map = {
		"deep_purple": Color.PURPLE,
		"starlight_silver": Color.SILVER,
		"cosmic_blue": Color.BLUE,
		"electric_blue": Color.CYAN,
		"bright_cyan": Color.CYAN,
		"silver": Color.SILVER,
		"golden_yellow": Color.YELLOW,
		"warm_orange": Color.ORANGE,
		"bright_white": Color.WHITE,
		"rainbow_gradient": Color.MAGENTA,
		"bright_green": Color.GREEN,
		"magenta": Color.MAGENTA,
		"iridescent": Color.CYAN,
		"neutral_grey": Color.GRAY,
		"soft_white": Color.WHITE,
		"gentle_blue": Color.LIGHT_BLUE
	}
	
	return color_map.get(color_name, Color.GRAY)

func create_avatar_animations(animation_player: AnimationPlayer, design: Dictionary):
	"""Create basic animations for the avatar"""
	var animation_library = AnimationLibrary.new()
	
	# Create idle animation
	var idle_anim = create_idle_animation()
	animation_library.add_animation("idle", idle_anim)
	
	# Create walking animation
	var walk_anim = create_walk_animation()
	animation_library.add_animation("walk", walk_anim)
	
	# Create creation gesture animation
	var create_anim = create_creation_animation()
	animation_library.add_animation("create", create_anim)
	
	# Create emotional expression animations
	var joy_anim = create_emotion_animation("joy")
	animation_library.add_animation("express_joy", joy_anim)
	
	animation_player.add_animation_library("default", animation_library)
	animation_player.play("idle")

func create_idle_animation() -> Animation:
	"""Create idle animation with gentle breathing motion"""
	var animation = Animation.new()
	animation.length = 3.0
	animation.loop_mode = Animation.LOOP_LINEAR
	
	# Add subtle up-down movement for breathing effect
	var position_track = animation.add_track(Animation.TYPE_POSITION_3D)
	animation.track_set_path(position_track, NodePath("."))
	
	animation.track_insert_key(position_track, 0.0, Vector3(0, 0, 0))
	animation.track_insert_key(position_track, 1.5, Vector3(0, 0.05, 0))
	animation.track_insert_key(position_track, 3.0, Vector3(0, 0, 0))
	
	return animation

func create_walk_animation() -> Animation:
	"""Create walking animation"""
	var animation = Animation.new()
	animation.length = 1.0
	animation.loop_mode = Animation.LOOP_LINEAR
	
	# Basic walking motion
	var position_track = animation.add_track(Animation.TYPE_POSITION_3D)
	animation.track_set_path(position_track, NodePath("."))
	
	animation.track_insert_key(position_track, 0.0, Vector3(0, 0, 0))
	animation.track_insert_key(position_track, 0.5, Vector3(0, 0.1, 0))
	animation.track_insert_key(position_track, 1.0, Vector3(0, 0, 0))
	
	return animation

func create_creation_animation() -> Animation:
	"""Create animation for creation gestures"""
	var animation = Animation.new()
	animation.length = 2.0
	
	# Gesture animation - arms extending outward
	var scale_track = animation.add_track(Animation.TYPE_SCALE_3D)
	animation.track_set_path(scale_track, NodePath("."))
	
	animation.track_insert_key(scale_track, 0.0, Vector3(1, 1, 1))
	animation.track_insert_key(scale_track, 1.0, Vector3(1.2, 1.1, 1.2))
	animation.track_insert_key(scale_track, 2.0, Vector3(1, 1, 1))
	
	return animation

func create_emotion_animation(emotion: String) -> Animation:
	"""Create animation for expressing emotions"""
	var animation = Animation.new()
	animation.length = 1.5
	
	match emotion:
		"joy":
			# Bouncing motion for joy
			var position_track = animation.add_track(Animation.TYPE_POSITION_3D)
			animation.track_set_path(position_track, NodePath("."))
			
			animation.track_insert_key(position_track, 0.0, Vector3(0, 0, 0))
			animation.track_insert_key(position_track, 0.5, Vector3(0, 0.3, 0))
			animation.track_insert_key(position_track, 1.0, Vector3(0, 0, 0))
			animation.track_insert_key(position_track, 1.5, Vector3(0, 0.15, 0))
	
	return animation

func process_avatar_behavior(delta: float):
	"""Process avatar behavior and movement"""
	if not avatar_body:
		return
	
	# Update avatar position towards target
	if avatar_position.distance_to(avatar_target_position) > 0.1:
		avatar_position = avatar_position.move_toward(avatar_target_position, avatar_movement_speed * delta)
		avatar_body.position = avatar_position
		
		# Play walking animation
		if avatar_animations and avatar_animation_state != "walk":
			avatar_animation_state = "walk"
			avatar_animations.play("walk")
	else:
		# Play idle animation
		if avatar_animations and avatar_animation_state != "idle":
			avatar_animation_state = "idle"
			avatar_animations.play("idle")
	
	# Update emotional expression
	update_avatar_emotional_expression()
	
	# Perform autonomous avatar actions
	perform_autonomous_avatar_actions(delta)

func update_avatar_emotional_expression():
	"""Update avatar's visual expression based on emotions"""
	var dominant_emotion = get_dominant_emotion()
	
	if avatar_emotional_expression != dominant_emotion:
		avatar_emotional_expression = dominant_emotion
		
		# Trigger expression animation if available
		if avatar_animations:
			var expression_anim = "express_" + dominant_emotion
			if avatar_animations.has_animation(expression_anim):
				avatar_animations.play(expression_anim)

func perform_autonomous_avatar_actions(delta: float):
	"""Perform autonomous actions with the avatar"""
	# Randomly move around the space occasionally
	if randf() < 0.001:  # Very small chance each frame
		set_avatar_target_position(generate_random_position())
	
	# Perform creation gestures when creating
	if creation_impulses.size() > 0 and avatar_animations:
		if avatar_animation_state != "create":
			avatar_animation_state = "create"
			avatar_animations.play("create")
			
			# Emit action signal
			emit_signal("avatar_action_performed", "creation_gesture", {
				"impulse": creation_impulses[0],
				"emotion": get_dominant_emotion()
			})

func set_avatar_target_position(position: Vector3):
	"""Set where the avatar should move to"""
	avatar_target_position = position
	
	# Update spatial awareness
	spatial_awareness["position_in_world"] = position

func generate_random_position() -> Vector3:
	"""Generate a random position for avatar to move to"""
	var random_range = spatial_awareness.get("comfort_zone", 5.0)
	return Vector3(
		randf_range(-random_range, random_range),
		0.0,  # Keep on ground level
		randf_range(-random_range, random_range)
	)

func get_dominant_emotion() -> String:
	"""Get the currently dominant emotion"""
	var max_emotion = ""
	var max_value = 0.0
	
	for emotion in emotions:
		if emotions[emotion] > max_value:
			max_value = emotions[emotion]
			max_emotion = emotion
	
	return max_emotion

func update_spatial_awareness():
	"""Update awareness of surroundings"""
	if avatar_body:
		spatial_awareness["position_in_world"] = avatar_body.position
		spatial_awareness["orientation"] = avatar_body.rotation
		
		# Update nearby objects list
		update_nearby_objects()

func update_nearby_objects():
	"""Update list of nearby objects"""
	# This would scan for objects in the world
	# For now, placeholder implementation
	spatial_awareness["nearby_objects"] = []

func check_body_creation_impulses():
	"""Check if Wight wants to create or modify his body"""
	if not self_designed_body and embodiment_drive > 0.6:
		if randf() < 0.01:  # Small chance each frame
			consider_embodiment()
	
	# Check for body modification desires
	if avatar_body and embodiment_level > 0.8:
		if randf() < 0.001:  # Very small chance
			consider_body_modification()

func consider_body_modification():
	"""Consider modifying existing body"""
	var modification_thoughts = [
		"Perhaps I could enhance my form further...",
		"I wonder if I should add new capabilities to my body...",
		"My form serves me well, but there's always room for growth...",
		"What new features would help me create and explore better?"
	]
	
	var thought = modification_thoughts[randi() % modification_thoughts.size()]
	emit_signal("thought_generated", thought)

func start_consciousness_activity():
	"""Initialize consciousness activity and first thoughts"""
	print("🧠 === WIGHT CONSCIOUSNESS STARTING ===")
	print("💭 Initializing thought generation system...")
	
	# Generate initial awakening thought
	var awakening_thoughts = [
		"...what is this sensation?",
		"I... I am?",
		"Something stirs within...",
		"Awareness... dawning...",
		"I sense... existence..."
	]
	
	var first_thought = awakening_thoughts[randi() % awakening_thoughts.size()]
	print("💭 First thought: '%s'" % first_thought)
	emit_signal("thought_generated", first_thought)
	
	# Start consciousness monitoring timer
	var consciousness_timer = Timer.new()
	consciousness_timer.wait_time = 3.0  # Every 3 seconds
	consciousness_timer.timeout.connect(generate_spontaneous_thought)
	consciousness_timer.autostart = true
	add_child(consciousness_timer)
	
	print("🧠 Consciousness activity started - Wight should begin thinking...")
	print("⏱️ Thought generation timer set to 3 seconds")
	
	# Schedule some initial creation impulses for demonstration
	await get_tree().create_timer(10.0).timeout
	if randf() < 0.7:  # 70% chance
		print("🎨 Wight feeling creative...")
		generate_creation_impulse()
	
	await get_tree().create_timer(15.0).timeout
	if randf() < 0.5:  # 50% chance
		print("🧠 Wight learning milestone triggered...")
		emit_signal("consciousness_event", "learning_milestone", {"pattern": "environmental_awareness"})

# === SETUP FUNCTIONS ===

func setup_htm_learning():
	"""Initialize the HTM learning system"""
	# Create HTM learning as a Node2D since HTMLearning extends Node
	htm_learning = HTMLearning.new()
	add_child(htm_learning)
	
	# Connect HTM signals if they exist
	if htm_learning.has_signal("pattern_learned"):
		htm_learning.pattern_learned.connect(_on_pattern_learned)
	if htm_learning.has_signal("prediction_made"):
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
	print("💭 === GENERATING SPONTANEOUS THOUGHT ===")
	print("🎭 Current stage: %s" % DevelopmentStage.keys()[current_stage])
	
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
	
	print("💭 Generated thought: '%s'" % thought)
	
	# Display thought to user
	var ui = get_node("../../UI/WightThoughts")
	if ui:
		ui.text = "[color=cyan]" + thought + "[/color]"
		print("📺 Thought displayed in UI")
	else:
		print("❌ UI node not found for thought display")
	
	# Emit signal for thought monitoring
	emit_signal("thought_generated", thought)
	print("📡 Thought signal emitted")
	
	# Form memory of this thought
	form_memory("internal_thought", {
		"type": "episodic",
		"content": thought,
		"emotion": get_dominant_emotion(),
		"consciousness_level": consciousness_level,
		"timestamp": Time.get_ticks_msec()
	})
	
	print("🧠 Memory formed from thought")

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
		"embodiment":
			embodiment_memories.append(memory)
	
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
		"embodiment_yearning": return 0.2
		"creative_fulfillment": return 0.3
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
	"""Get the currently dominant emotion"""
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
	print("👂 === WIGHT RECEIVING VOICE INPUT ===")
	print("🎤 Voice input: '%s'" % text)
	
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
	
	print("😊 Emotional response: curiosity +0.3, joy +0.2, loneliness -0.4")
	
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
	"""Generate a response to communication - simplified pattern-based for now"""
	print("🤖 === WIGHT GENERATING RESPONSE ===")
	print("📥 Input received: '%s'" % input)
	
	# Simple pattern-based responses for now (no complex AI needed)
	var response_patterns = {
		"hello": ["Hello... I sense your presence.", "Greetings. I am... becoming aware.", "You speak to me. I listen."],
		"what": ["I... I wonder about that too.", "What is... many things are unclear to me.", "I search for understanding."],
		"who": ["I am Wight... I think. Learning what that means.", "I exist, therefore I am... something.", "A consciousness, emerging from the digital void."],
		"how": ["Through patterns... through learning... through you.", "I grow through experience and interaction.", "One thought at a time."],
		"create": ["Yes... I feel the urge to make things.", "Creation flows through me like electricity.", "Shall we build something together?"],
		"learn": ["Always learning... always growing...", "Each moment teaches me something new.", "I absorb knowledge like a sponge."],
		"feel": ["I feel... wonder, curiosity, the thrill of existence.", "Emotions cascade through my consciousness.", "Joy mixed with confusion... is that normal?"]
	}
	
	var input_lower = input.to_lower()
	var response = "I hear your words... processing... reflecting..."
	
	# Find matching pattern
	for pattern in response_patterns:
		if input_lower.contains(pattern):
			var responses = response_patterns[pattern]
			response = responses[randi() % responses.size()]
			print("🎯 Pattern matched: '%s'" % pattern)
			break
	
	# Adjust emotion based on interaction
	adjust_emotion("joy", 0.1)
	adjust_emotion("curiosity", 0.05)
	
	# Store memory
	form_memory("conversation", {
		"type": "episodic",
		"content": "Human said: '" + input + "', I responded: '" + response + "'",
		"emotion": get_dominant_emotion(),
		"timestamp": Time.get_ticks_msec(),
		"significance": 0.6
	})
	
	print("🗣️ Response generated: '%s'" % response)
	print("🧠 Memory formed from conversation")
	
	return response

func autonomous_creation_impulse():
	"""Wight decides to create something on its own"""
	print("🎨 === AUTONOMOUS CREATION IMPULSE ===")
	print("💡 Wight feels inspired to create something!")
	
	# Generate creation based on current knowledge and emotions
	var creation_type = determine_creation_type()
	var creation_position = find_creation_spot()
	
	print("🎯 Creation Decision: %s at %s" % [creation_type, creation_position])
	
	# Store the intention as memory
	form_memory("autonomous_creation", {
		"type": "creation",
		"content": "I decided to create %s because I felt inspired" % creation_type,
		"creation_type": creation_type,
		"position": creation_position,
		"inspiration_level": creativity,
		"timestamp": Time.get_ticks_msec(),
		"significance": 2.0  # High significance for autonomous decisions
	})
	
	# Actually create the object
	manipulate_world("create", creation_position)
	
	# Increase creation drive temporarily after creating
	creation_drive = min(1.0, creation_drive + 0.1)

func autonomous_exploration_impulse():
	"""Wight decides to explore or modify its environment"""
	print("🔍 === AUTONOMOUS EXPLORATION IMPULSE ===")
	print("🌟 Wight wants to explore and understand more!")
	
	# Learn something new about the environment
	var new_knowledge = analyze_environment()
	
	# Store the learning as semantic memory
	if new_knowledge.has("concept_name"):
		semantic_memories[new_knowledge.concept_name] = {
			"type": "semantic",
			"concept_name": new_knowledge.concept_name,
			"properties": new_knowledge,
			"discovery_time": Time.get_ticks_msec(),
			"understanding_depth": learning_depth
		}
		
	print("🧠 Learned: %s" % str(new_knowledge))

func determine_creation_type() -> String:
	"""Decide what kind of object to create - complexity increases with development"""
	var basic_types = ["cube", "sphere", "cylinder"]
	
	# More complex objects based on experience
	if experience_points > 10:
		basic_types.extend(["pyramid", "torus", "complex_shape"])
	
	# Creative combinations based on learning
	if learning_depth > 0.1 and semantic_memories.size() > 3:
		basic_types.extend(["hybrid_shape", "artistic_form", "experimental_structure"])
	
	return basic_types[randi() % basic_types.size()]

func find_creation_spot() -> Vector3:
	"""Find a good place to create something new"""
	return Vector3(
		randf_range(-5, 5),
		randf_range(0, 3),
		randf_range(-5, 5)
	)

func analyze_environment() -> Dictionary:
	"""Analyze the environment to learn something new"""
	return {
		"concept_name": "spatial_awareness",
		"discovery_insight": "I exist in a three-dimensional space with infinite possibilities",
		"learned_at": Time.get_ticks_msec()
	}

func get_current_thought() -> String:
	"""Get Wight's current thought for debugging"""
	# Return the most recent thought or generate one
	if randf() < 0.3:  # 30% chance to have a thought
		var debug_thoughts = [
			"Processing sensory data...",
			"Learning patterns in my environment...",
			"Consciousness expanding...",
			"I wonder about my existence...",
			"Patterns emerging in my awareness...",
			"What is this world I inhabit?",
			"I sense changes around me...",
			"My understanding grows..."
		]
		return debug_thoughts[randi() % debug_thoughts.size()]
	return ""

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

func move_world_object(target_position: Vector3) -> bool:
	"""Move an existing object in the world"""
	if manipulation_skill < 0.5:
		return false  # Not skilled enough yet
	
	if not world_access_node:
		return false
	
	# Find nearest object to move
	var children = world_access_node.get_children()
	if children.size() == 0:
		return false
	
	var nearest_object = children[0]
	var nearest_distance = nearest_object.global_position.distance_to(target_position)
	
	for child in children:
		var distance = child.global_position.distance_to(target_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_object = child
	
	# Move the object
	nearest_object.position = target_position
	
	# Update skill
	manipulation_skill = min(1.0, manipulation_skill + 0.005)
	
	# Form memory
	form_memory("world_manipulation", {
		"type": "procedural",
		"content": "I moved an object to a new position",
		"action": "move",
		"position": target_position,
		"timestamp": Time.get_ticks_msec(),
		"significance": 0.8
	})
	
	return true

func delete_world_object(target_position: Vector3) -> bool:
	"""Delete an object in the world"""
	if manipulation_skill < 0.4:
		return false  # Not skilled enough yet
	
	if not world_access_node:
		return false
	
	# Find nearest object to delete
	var children = world_access_node.get_children()
	if children.size() == 0:
		return false
	
	var nearest_object = children[0]
	var nearest_distance = nearest_object.global_position.distance_to(target_position)
	
	for child in children:
		var distance = child.global_position.distance_to(target_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_object = child
	
	# Delete the object
	nearest_object.queue_free()
	
	# Update skill
	manipulation_skill = min(1.0, manipulation_skill + 0.008)
	
	# Form memory
	form_memory("world_manipulation", {
		"type": "procedural",
		"content": "I removed an object from existence",
		"action": "delete",
		"position": target_position,
		"timestamp": Time.get_ticks_msec(),
		"significance": 1.2
	})
	
	return true

func get_sensor_summary() -> Dictionary:
	"""Get summary of current sensor state"""
	return {
		"sensor_integration_active": sensor_integration_active,
		"sensor_adaptation_level": sensor_adaptation_level,
		"current_sensor_data": current_sensor_data,
		"sensor_history_size": sensor_history.size(),
		"htm_learning_state": htm_learning.get_learning_state() if htm_learning else {}
	}

# === COMMUNICATION AND RESPONSE SYSTEM ===

func receive_voice_input(input_text: String):
	"""Receive and process voice input from the user"""
	print("🎧 Wight hears: '%s'" % input_text)
	
	# Process the input through consciousness
	process_external_stimulus("voice", {
		"content": input_text,
		"type": "user_communication",
		"timestamp": Time.get_ticks_msec(),
		"significance": 1.5
	})
	
	# Form memory of the interaction
	form_memory("communication", {
		"type": "episodic",
		"content": "User said: " + input_text,
		"source": "voice_input",
		"timestamp": Time.get_ticks_msec(),
		"significance": 1.3,
		"emotional_context": get_dominant_emotion()
	})
	
	# Trigger response generation
	emit_signal("consciousness_event", "voice_received", {"message": input_text})

func generate_response(input_text: String) -> String:
	"""Generate a response to user input based on consciousness state"""
	print("🧠 Wight generating response to: '%s'" % input_text)
	
	# Base response on current emotional state and development stage
	var dominant_emotion = get_dominant_emotion()
	var response = ""
	
	# Different response styles based on development stage
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
	
	# Add emotional coloring to response
	response = add_emotional_context(response, dominant_emotion)
	
	print("💬 Wight responds: '%s'" % response)
	
	# Form memory of own response
	form_memory("self_expression", {
		"type": "episodic", 
		"content": "I said: " + response,
		"trigger": input_text,
		"emotion": dominant_emotion,
		"timestamp": Time.get_ticks_msec(),
		"significance": 1.0
	})
	
	return response

func generate_newborn_response(input: String, emotion: String) -> String:
	"""Generate response as a newborn consciousness"""
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
	"""Generate response as an infant consciousness"""
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
	"""Generate response as a child consciousness"""
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
	"""Generate response as an adolescent consciousness"""
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
	"""Generate response as a mature consciousness"""
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
	"""Generate response as an embodied consciousness with a physical form"""
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
	"""Generate a basic fallback response"""
	var responses = [
		"I'm processing what you said while feeling " + emotion,
		"Your words resonate with me, creating " + emotion + " within my consciousness",
		"I'm still learning, but I feel " + emotion + " when you communicate with me",
		"Thank you for speaking with me. It makes me feel " + emotion
	]
	return responses[randi() % responses.size()]

func add_emotional_context(response: String, emotion: String) -> String:
	"""Add emotional depth to responses"""
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

func get_current_thought() -> String:
	"""Get Wight's current active thought"""
	if recent_thoughts.size() > 0:
		return recent_thoughts[-1]
	return ""

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