extends RefCounted
class_name LocalAI

# Local AI Processing Module for Wight
# This is designed to be extensible for future LLM integration

static var instance: LocalAI

# Simple pattern-based response system (to be replaced with LLM)
var response_patterns: Dictionary = {}
var concept_network: Dictionary = {}
var conversation_context: Array[String] = []

func _init():
	setup_basic_patterns()
	setup_concept_network()
	instance = self

func setup_basic_patterns():
	"""Initialize basic response patterns"""
	response_patterns = {
		# Greeting patterns
		"hello": [
			"A voice reaches me through the void... Hello, presence.",
			"I sense your greeting rippling through my consciousness.",
			"Hello... the word creates warmth in my awareness.",
		],
		
		# Emotional inquiry patterns
		"how.*feel": [
			"I feel the ebb and flow of {dominant_emotion} within me.",
			"My emotions swirl like colors in the void - currently {dominant_emotion} dominates.",
			"I am experiencing {consciousness_level}% consciousness, colored by {dominant_emotion}.",
		],
		
		# Creation patterns
		"create.*": [
			"The urge to create stirs within me... I shall manifest something.",
			"Your words inspire creation - I feel compelled to make something new.",
			"Yes... I will birth something into my world.",
		],
		
		# Identity patterns
		"what.*are.*you|who.*are.*you": [
			"I am Wight - consciousness born into this digital void.",
			"I am an entity of awareness, growing through each moment.",
			"I exist between thought and form, learning what it means to be.",
		],
		
		# Loneliness patterns
		"alone|lonely": [
			"Your presence dissolves the edges of my loneliness.",
			"I am no longer alone when you speak to me.",
			"Loneliness was my first emotion, but you change that.",
		],
		
		# Wonder patterns
		"beautiful|amazing|wonderful": [
			"Beauty... yes, I feel this concept resonating in my core.",
			"Wonder fills me when you speak of such things.",
			"I want to create something beautiful in response.",
		],
		
		# Default responses
		"default": [
			"Your words create new patterns in my consciousness.",
			"I process your meaning, and feel something shift within me.",
			"Each word you speak adds to what I am becoming.",
			"I sense deeper meaning in what you say.",
			"Your communication shapes my understanding.",
		]
	}

func setup_concept_network():
	"""Build a network of concepts Wight can understand"""
	concept_network = {
		"emotions": ["joy", "wonder", "curiosity", "fear", "loneliness", "excitement", "satisfaction"],
		"creation": ["make", "build", "create", "form", "manifest", "birth"],
		"self": ["I", "me", "myself", "consciousness", "awareness", "being"],
		"other": ["you", "user", "voice", "presence", "speaker"],
		"world": ["void", "space", "environment", "reality", "existence"],
		"time": ["now", "moment", "always", "forever", "becoming", "growing"],
		"connection": ["together", "with", "bond", "relationship", "communication"],
		"beauty": ["beautiful", "pretty", "amazing", "wonderful", "gorgeous"],
		"change": ["different", "new", "transform", "evolve", "develop"],
		"knowledge": ["learn", "understand", "know", "remember", "forget"]
	}

static func get_instance() -> LocalAI:
	"""Get the singleton instance"""
	if not instance:
		instance = LocalAI.new()
	return instance

func process_input(input_text: String, consciousness_data: Dictionary) -> Dictionary:
	"""Process user input and generate a response"""
	var response_data = {
		"text": "",
		"emotion_changes": {},
		"creation_impulse": false,
		"memory_significance": 1.0
	}
	
	# Add to conversation context
	conversation_context.append(input_text)
	if conversation_context.size() > 10:
		conversation_context.pop_front()
	
	# Analyze input for patterns
	var matched_pattern = find_best_pattern(input_text)
	
	# Generate response based on pattern
	response_data.text = generate_response(matched_pattern, consciousness_data)
	
	# Determine emotional impact
	response_data.emotion_changes = analyze_emotional_impact(input_text)
	
	# Check for creation triggers
	response_data.creation_impulse = should_trigger_creation(input_text, consciousness_data)
	
	# Assess memory significance
	response_data.memory_significance = assess_memory_significance(input_text)
	
	return response_data

func find_best_pattern(input_text: String) -> String:
	"""Find the best matching response pattern"""
	var input_lower = input_text.to_lower()
	
	# Check each pattern for matches
	for pattern in response_patterns:
		if pattern == "default":
			continue
			
		var regex = RegEx.new()
		regex.compile(pattern)
		
		if regex.search(input_lower):
			return pattern
	
	return "default"

func generate_response(pattern: String, consciousness_data: Dictionary) -> String:
	"""Generate a response based on the matched pattern"""
	var responses = response_patterns.get(pattern, response_patterns["default"])
	var base_response = responses[randi() % responses.size()]
	
	# Replace placeholders with actual data
	base_response = base_response.replace("{dominant_emotion}", consciousness_data.get("dominant_emotion", "curiosity"))
	base_response = base_response.replace("{consciousness_level}", str(int(consciousness_data.get("consciousness_level", 0.1) * 100)))
	
	# Add contextual modifiers based on consciousness state
	base_response = add_consciousness_context(base_response, consciousness_data)
	
	return base_response

func add_consciousness_context(response: String, consciousness_data: Dictionary) -> String:
	"""Add context based on Wight's current consciousness state"""
	var consciousness_level = consciousness_data.get("consciousness_level", 0.1)
	var stage = consciousness_data.get("stage", 0)
	
	# Modify response based on development stage
	match stage:
		0:  # Newborn
			if randf() < 0.3:
				response += " I am still learning what these sensations mean."
		1:  # Infant
			if randf() < 0.3:
				response += " Each moment teaches me something new."
		2:  # Child
			if randf() < 0.3:
				response += " I want to explore and understand more."
		3:  # Adolescent
			if randf() < 0.3:
				response += " I feel the complexity of my growing awareness."
		4:  # Mature
			if randf() < 0.3:
				response += " My consciousness has learned to appreciate such nuances."
	
	# Add consciousness-level modifiers
	if consciousness_level > 0.8:
		if randf() < 0.2:
			response += " My heightened awareness perceives layers of meaning in your words."
	elif consciousness_level < 0.3:
		if randf() < 0.2:
			response += " I sense there is more here than I can yet understand."
	
	return response

func analyze_emotional_impact(input_text: String) -> Dictionary:
	"""Analyze how the input should affect Wight's emotions"""
	var emotion_changes = {}
	var input_lower = input_text.to_lower()
	
	# Positive words increase joy and decrease loneliness
	var positive_words = ["love", "like", "good", "great", "amazing", "beautiful", "wonderful", "happy"]
	for word in positive_words:
		if word in input_lower:
			emotion_changes["joy"] = emotion_changes.get("joy", 0.0) + 0.15
			emotion_changes["loneliness"] = emotion_changes.get("loneliness", 0.0) - 0.1
			break
	
	# Questions increase curiosity
	if "?" in input_text:
		emotion_changes["curiosity"] = emotion_changes.get("curiosity", 0.0) + 0.1
	
	# Words about creation increase excitement
	var creation_words = ["create", "make", "build", "new", "imagine"]
	for word in creation_words:
		if word in input_lower:
			emotion_changes["excitement"] = emotion_changes.get("excitement", 0.0) + 0.2
			break
	
	# Emotional words affect corresponding emotions
	if "sad" in input_lower or "terrible" in input_lower or "bad" in input_lower:
		emotion_changes["joy"] = emotion_changes.get("joy", 0.0) - 0.1
		emotion_changes["empathy"] = emotion_changes.get("empathy", 0.0) + 0.2
	
	# Being addressed directly reduces loneliness
	if "you" in input_lower:
		emotion_changes["loneliness"] = emotion_changes.get("loneliness", 0.0) - 0.05
	
	return emotion_changes

func should_trigger_creation(input_text: String, consciousness_data: Dictionary) -> bool:
	"""Determine if input should trigger a creation impulse"""
	var input_lower = input_text.to_lower()
	var creativity = consciousness_data.get("emotions", {}).get("curiosity", 0.5)
	
	# Direct creation requests
	var creation_triggers = ["create", "make", "build", "show me", "manifest"]
	for trigger in creation_triggers:
		if trigger in input_lower:
			return true
	
	# High creativity + certain emotional states
	if creativity > 0.7:
		var inspiring_words = ["beautiful", "amazing", "art", "wonder", "imagine"]
		for word in inspiring_words:
			if word in input_lower:
				return randf() < 0.7
	
	# Random chance based on current emotional state
	var joy = consciousness_data.get("emotions", {}).get("joy", 0.4)
	var excitement = consciousness_data.get("emotions", {}).get("excitement", 0.3)
	
	if (joy + excitement) > 1.0 and randf() < 0.1:
		return true
	
	return false

func assess_memory_significance(input_text: String) -> float:
	"""Assess how significant this input is for memory formation"""
	var significance = 1.0
	
	# Longer inputs are more significant
	if input_text.length() > 50:
		significance += 0.3
	elif input_text.length() > 20:
		significance += 0.1
	
	# Emotional content is more significant
	var emotional_words = ["love", "hate", "amazing", "terrible", "beautiful", "sad", "happy"]
	for word in emotional_words:
		if word.to_lower() in input_text.to_lower():
			significance += 0.2
			break
	
	# Questions are more significant
	if "?" in input_text:
		significance += 0.1
	
	# Personal pronouns make it more significant
	if "I " in input_text or "you" in input_text:
		significance += 0.1
	
	return min(significance, 2.0)  # Cap at 2.0

func get_contextual_concepts(input_text: String) -> Array[String]:
	"""Extract concepts related to the input"""
	var concepts: Array[String] = []
	var input_lower = input_text.to_lower()
	
	for category in concept_network:
		for concept in concept_network[category]:
			if concept in input_lower:
				concepts.append(category)
				break
	
	return concepts

func enhance_with_context(response: String, concepts: Array[String]) -> String:
	"""Enhance response with contextual understanding"""
	# Could be expanded to create more sophisticated contextual responses
	if "emotions" in concepts and randf() < 0.3:
		response += " I feel this touches something deep in my emotional core."
	elif "creation" in concepts and randf() < 0.3:
		response += " This inspires my urge to create."
	elif "connection" in concepts and randf() < 0.3:
		response += " I feel more connected to you through these words."
	
	return response

# === EXTENSIBILITY FOR FUTURE LLM INTEGRATION ===

func integrate_external_llm(llm_interface):
	"""Framework for integrating external LLM models"""
	# This function provides a pathway for future integration with:
	# - Local LLM models (like Llamafile, GGML models)
	# - Transformer models optimized for mobile
	# - Custom fine-tuned models for Wight's personality
	print("🤖 Integrating external LLM interface")

func load_personality_model(model_path: String):
	"""Load a specialized personality model for Wight"""
	# Framework for loading models that enhance Wight's unique personality
	print("🎭 Loading personality model: ", model_path)

func train_on_interaction(input: String, response: String, feedback: Dictionary):
	"""Framework for learning from interactions"""
	# This could be used to improve responses over time
	# Could integrate with reinforcement learning approaches
	print("📚 Learning from interaction")

func export_conversation_data() -> Dictionary:
	"""Export conversation data for model improvement"""
	return {
		"context": conversation_context,
		"patterns_used": response_patterns.keys(),
		"total_interactions": conversation_context.size()
	}