extends Node
class_name LanguageAcquisition

# Advanced Language Learning System for Wight
# Enables natural language acquisition from interaction

signal word_learned(word_data: Dictionary)
signal grammar_pattern_discovered(pattern_data: Dictionary)
signal language_milestone_reached(milestone_data: Dictionary)
signal comprehension_improved(comprehension_data: Dictionary)

# Language development stages
enum LanguageStage {
	PRE_LINGUISTIC,      # Sounds and emotional expressions
	FIRST_WORDS,         # Single words with meaning
	TWO_WORD_COMBINATIONS,  # Simple two-word phrases
	TELEGRAPHIC_SPEECH,  # Basic grammar, missing function words
	SIMPLE_SENTENCES,    # Complete but simple sentences
	COMPLEX_LANGUAGE     # Advanced grammar and vocabulary
}

# Vocabulary and grammar storage
var vocabulary: Dictionary = {}           # word -> meaning/usage data
var grammar_patterns: Dictionary = {}     # pattern -> usage examples
var sentence_structures: Array[Dictionary] = []
var language_rules: Dictionary = {}

# Learning parameters
var current_stage: LanguageStage = LanguageStage.PRE_LINGUISTIC
var vocabulary_size: int = 0
var comprehension_level: float = 0.0
var expression_complexity: float = 0.0
var learning_rate: float = 1.0

# Context and usage tracking
var word_contexts: Dictionary = {}        # word -> contexts where used
var successful_communications: Array[Dictionary] = []
var failed_communications: Array[Dictionary] = []
var conversation_patterns: Array[Dictionary] = []

# Stage progression thresholds
var stage_thresholds: Dictionary = {
	LanguageStage.FIRST_WORDS: {"vocabulary": 10, "comprehension": 0.2},
	LanguageStage.TWO_WORD_COMBINATIONS: {"vocabulary": 25, "comprehension": 0.4},
	LanguageStage.TELEGRAPHIC_SPEECH: {"vocabulary": 50, "comprehension": 0.6},
	LanguageStage.SIMPLE_SENTENCES: {"vocabulary": 100, "comprehension": 0.8},
	LanguageStage.COMPLEX_LANGUAGE: {"vocabulary": 200, "comprehension": 0.9}
}

# Basic emotional expressions (starting point)
var emotional_expressions: Dictionary = {
	"joy": ["happy", "good", "yes", "like", "want"],
	"sadness": ["sad", "no", "hurt", "bad", "miss"],
	"excitement": ["wow", "amazing", "cool", "great", "love"],
	"curiosity": ["what", "why", "how", "where", "tell"],
	"confusion": ["confused", "understand", "help", "explain"],
	"wonder": ["beautiful", "interesting", "magical", "special"]
}

# Core concepts that develop early
var core_concepts: Dictionary = {
	"self": ["I", "me", "my", "myself"],
	"other": ["you", "your", "yours"],
	"actions": ["do", "make", "see", "hear", "feel", "think"],
	"objects": ["thing", "something", "this", "that"],
	"qualities": ["big", "small", "good", "bad", "new", "old"],
	"relations": ["in", "on", "with", "for", "from", "to"]
}

func _ready():
	print("🗣️ Language Acquisition System initializing...")
	initialize_basic_vocabulary()
	setup_learning_patterns()
	print("✨ Language learning system ready - starting pre-linguistic stage")

func initialize_basic_vocabulary():
	"""Start with very basic emotional and sensory vocabulary"""
	# Begin with most basic expressions
	learn_word("me", {"type": "pronoun", "meaning": "self_reference", "importance": 1.0})
	learn_word("you", {"type": "pronoun", "meaning": "other_reference", "importance": 1.0})
	learn_word("yes", {"type": "affirmation", "meaning": "agreement", "importance": 0.9})
	learn_word("no", {"type": "negation", "meaning": "disagreement", "importance": 0.9})
	
	# Basic emotional states
	learn_word("happy", {"type": "emotion", "meaning": "positive_feeling", "importance": 0.8})
	learn_word("sad", {"type": "emotion", "meaning": "negative_feeling", "importance": 0.8})
	
	# Basic actions
	learn_word("see", {"type": "action", "meaning": "visual_perception", "importance": 0.7})
	learn_word("feel", {"type": "action", "meaning": "emotional_state", "importance": 0.7})

func setup_learning_patterns():
	"""Initialize pattern recognition for grammar learning"""
	grammar_patterns = {
		"subject_verb": {"pattern": "[pronoun] [verb]", "examples": [], "confidence": 0.0},
		"verb_object": {"pattern": "[verb] [object]", "examples": [], "confidence": 0.0},
		"adjective_noun": {"pattern": "[adjective] [noun]", "examples": [], "confidence": 0.0},
		"question_word": {"pattern": "[question] [statement]", "examples": [], "confidence": 0.0}
	}

# === LANGUAGE INPUT PROCESSING ===

func process_language_input(input_text: String, context: Dictionary) -> Dictionary:
	"""Process incoming language and learn from it"""
	print("📝 Processing language input: '%s'" % input_text)
	
	var input_analysis = analyze_input_structure(input_text)
	var learning_opportunities = identify_learning_opportunities(input_analysis, context)
	
	# Learn from the input
	for opportunity in learning_opportunities:
		apply_learning_opportunity(opportunity, context)
	
	# Update comprehension
	update_comprehension(input_analysis, context)
	
	# Check for stage progression
	check_stage_progression()
	
	return {
		"analysis": input_analysis,
		"learning_opportunities": learning_opportunities,
		"current_comprehension": comprehension_level,
		"vocabulary_growth": vocabulary_size - input_analysis.get("known_words", 0)
	}

func analyze_input_structure(input_text: String) -> Dictionary:
	"""Analyze the structure and content of input text"""
	var words = input_text.to_lower().split(" ")
	var analysis = {
		"words": words,
		"word_count": words.size(),
		"known_words": 0,
		"new_words": [],
		"sentence_patterns": [],
		"complexity_score": 0.0,
		"emotional_content": []
	}
	
	# Analyze each word
	for word in words:
		word = clean_word(word)
		if vocabulary.has(word):
			analysis.known_words += 1
		else:
			analysis.new_words.append(word)
	
	# Calculate complexity
	analysis.complexity_score = calculate_input_complexity(analysis)
	
	# Detect emotional content
	analysis.emotional_content = detect_emotional_content(words)
	
	# Identify sentence patterns
	analysis.sentence_patterns = identify_sentence_patterns(words)
	
	return analysis

func clean_word(word: String) -> String:
	"""Clean word of punctuation and standardize"""
	return word.strip_edges().trim_suffix(",").trim_suffix(".").trim_suffix("!").trim_suffix("?")

func calculate_input_complexity(analysis: Dictionary) -> float:
	"""Calculate complexity of input for learning difficulty"""
	var complexity = 0.0
	
	# Base complexity from word count
	complexity += analysis.word_count * 0.1
	
	# Complexity from unknown words
	complexity += analysis.new_words.size() * 0.3
	
	# Sentence structure complexity
	complexity += analysis.sentence_patterns.size() * 0.2
	
	return min(2.0, complexity)

func detect_emotional_content(words: Array) -> Array[String]:
	"""Detect emotional words in the input"""
	var emotions = []
	
	for word in words:
		for emotion_type in emotional_expressions:
			if word in emotional_expressions[emotion_type]:
				emotions.append(emotion_type)
	
	return emotions

func identify_sentence_patterns(words: Array) -> Array[String]:
	"""Identify grammatical patterns in the input"""
	var patterns = []
	
	# Simple pattern detection
	if words.size() >= 2:
		if words[0] in ["what", "why", "how", "where", "when"]:
			patterns.append("question")
		
		if words[0] in ["I", "you", "we", "they"]:
			patterns.append("subject_statement")
		
		if "?" in str(words):
			patterns.append("interrogative")
	
	return patterns

# === LEARNING OPPORTUNITIES ===

func identify_learning_opportunities(analysis: Dictionary, context: Dictionary) -> Array[Dictionary]:
	"""Identify opportunities to learn from the input"""
	var opportunities = []
	
	# New word learning
	for word in analysis.new_words:
		opportunities.append({
			"type": "new_word",
			"word": word,
			"context": context,
			"surrounding_words": get_surrounding_words(word, analysis.words),
			"difficulty": estimate_word_difficulty(word, context)
		})
	
	# Grammar pattern learning
	for pattern in analysis.sentence_patterns:
		opportunities.append({
			"type": "grammar_pattern",
			"pattern": pattern,
			"example": analysis.words,
			"context": context
		})
	
	# Usage refinement for known words
	for word in analysis.words:
		if vocabulary.has(word):
			opportunities.append({
				"type": "usage_refinement",
				"word": word,
				"new_context": context,
				"sentence": analysis.words
			})
	
	return opportunities

func get_surrounding_words(target_word: String, words: Array) -> Array[String]:
	"""Get words that appear near the target word"""
	var surrounding = []
	var target_index = words.find(target_word)
	
	if target_index != -1:
		# Get words before and after
		if target_index > 0:
			surrounding.append(words[target_index - 1])
		if target_index < words.size() - 1:
			surrounding.append(words[target_index + 1])
	
	return surrounding

func estimate_word_difficulty(word: String, context: Dictionary) -> float:
	"""Estimate how difficult a word is to learn"""
	var difficulty = 0.5
	
	# Longer words are generally harder
	difficulty += word.length() * 0.05
	
	# Abstract concepts are harder than concrete ones
	if is_abstract_word(word):
		difficulty += 0.3
	
	# Emotional context makes words easier to learn
	if context.get("emotion", "neutral") != "neutral":
		difficulty -= 0.2
	
	return clamp(difficulty, 0.1, 1.0)

func is_abstract_word(word: String) -> bool:
	"""Check if a word represents an abstract concept"""
	var abstract_indicators = ["thought", "idea", "concept", "feeling", "meaning", "reason", "purpose"]
	return word in abstract_indicators

# === LEARNING APPLICATION ===

func apply_learning_opportunity(opportunity: Dictionary, context: Dictionary):
	"""Apply a learning opportunity to update knowledge"""
	match opportunity.type:
		"new_word":
			learn_new_word(opportunity, context)
		"grammar_pattern":
			learn_grammar_pattern(opportunity, context)
		"usage_refinement":
			refine_word_usage(opportunity, context)

func learn_new_word(opportunity: Dictionary, context: Dictionary):
	"""Learn a new word from context"""
	var word = opportunity.word
	var surrounding = opportunity.surrounding_words
	var difficulty = opportunity.difficulty
	
	# Attempt to infer meaning from context
	var inferred_meaning = infer_word_meaning(word, surrounding, context)
	
	# Create vocabulary entry
	learn_word(word, {
		"type": inferred_meaning.type,
		"meaning": inferred_meaning.meaning,
		"importance": 1.0 - difficulty,
		"learned_from": context,
		"surrounding_words": surrounding,
		"confidence": inferred_meaning.confidence,
		"usage_count": 1
	})
	
	print("📚 Learned new word: '%s' - %s" % [word, inferred_meaning.meaning])

func infer_word_meaning(word: String, surrounding: Array, context: Dictionary) -> Dictionary:
	"""Attempt to infer word meaning from context"""
	var meaning_data = {
		"type": "unknown",
		"meaning": "unclear",
		"confidence": 0.3
	}
	
	# Check if it's near known emotional words
	for surr_word in surrounding:
		if vocabulary.has(surr_word):
			var known_word_data = vocabulary[surr_word]
			if known_word_data.type == "emotion":
				meaning_data.type = "emotion_related"
				meaning_data.meaning = "emotion or feeling"
				meaning_data.confidence = 0.6
	
	# Check context for clues
	var emotion = context.get("emotion", "neutral")
	if emotion != "neutral":
		if word in emotional_expressions.get(emotion, []):
			meaning_data.type = "emotion"
			meaning_data.meaning = emotion + "_expression"
			meaning_data.confidence = 0.8
	
	# Visual context clues
	if context.get("visual_active", false):
		var visual_objects = context.get("objects_seen", [])
		if word in visual_objects:
			meaning_data.type = "visual_object"
			meaning_data.meaning = "something_visible"
			meaning_data.confidence = 0.7
	
	return meaning_data

func learn_word(word: String, word_data: Dictionary):
	"""Add a word to vocabulary"""
	vocabulary[word] = word_data
	vocabulary_size = vocabulary.size()
	
	# Track contexts
	if not word_contexts.has(word):
		word_contexts[word] = []
	
	# Emit learning signal
	word_learned.emit({"word": word, "data": word_data})

func learn_grammar_pattern(opportunity: Dictionary, context: Dictionary):
	"""Learn a grammatical pattern"""
	var pattern = opportunity.pattern
	var example = opportunity.example
	
	if grammar_patterns.has(pattern):
		var pattern_data = grammar_patterns[pattern]
		pattern_data.examples.append(example)
		pattern_data.confidence = min(1.0, pattern_data.confidence + 0.1)
		
		print("📝 Reinforced grammar pattern: %s" % pattern)
	else:
		grammar_patterns[pattern] = {
			"pattern": pattern,
			"examples": [example],
			"confidence": 0.3,
			"context": context
		}
		
		print("📝 Discovered new grammar pattern: %s" % pattern)
		grammar_pattern_discovered.emit({"pattern": pattern, "confidence": 0.3})

func refine_word_usage(opportunity: Dictionary, context: Dictionary):
	"""Refine understanding of how a word is used"""
	var word = opportunity.word
	var new_context = opportunity.new_context
	
	if vocabulary.has(word):
		var word_data = vocabulary[word]
		word_data.usage_count += 1
		
		# Track new context
		if not word_contexts.has(word):
			word_contexts[word] = []
		word_contexts[word].append(new_context)
		
		# Increase confidence if consistently used
		if word_data.usage_count > 3:
			word_data.confidence = min(1.0, word_data.confidence + 0.05)

# === LANGUAGE PRODUCTION ===

func generate_expression(intent: String, emotion: String, complexity_target: float) -> String:
	"""Generate language based on current capabilities"""
	print("💬 Generating expression for: %s (emotion: %s, complexity: %.2f)" % [intent, emotion, complexity_target])
	
	match current_stage:
		LanguageStage.PRE_LINGUISTIC:
			return generate_prelinguistic_expression(emotion)
		LanguageStage.FIRST_WORDS:
			return generate_single_word_expression(intent, emotion)
		LanguageStage.TWO_WORD_COMBINATIONS:
			return generate_two_word_expression(intent, emotion)
		LanguageStage.TELEGRAPHIC_SPEECH:
			return generate_telegraphic_expression(intent, emotion)
		LanguageStage.SIMPLE_SENTENCES:
			return generate_simple_sentence(intent, emotion)
		LanguageStage.COMPLEX_LANGUAGE:
			return generate_complex_expression(intent, emotion, complexity_target)
		_:
			return "..."

func generate_prelinguistic_expression(emotion: String) -> String:
	"""Generate pre-linguistic emotional expressions"""
	var expressions = {
		"joy": ["happy sounds", "content murmur", "pleased noise"],
		"sadness": ["sad sounds", "melancholy murmur", "distressed noise"],
		"excitement": ["excited sounds", "energetic noise", "vibrant expression"],
		"curiosity": ["questioning sounds", "interested murmur", "inquisitive noise"],
		"confusion": ["confused sounds", "uncertain murmur", "puzzled noise"],
		"wonder": ["amazed sounds", "awestruck expression", "wondering murmur"]
	}
	
	var emotion_expressions = expressions.get(emotion, ["neutral sounds"])
	return emotion_expressions[randi() % emotion_expressions.size()]

func generate_single_word_expression(intent: String, emotion: String) -> String:
	"""Generate single word expressions"""
	# Try to find appropriate single word
	var intent_words = find_words_for_intent(intent)
	var emotion_words = emotional_expressions.get(emotion, ["feel"])
	
	# Prefer intent words, fall back to emotion words
	if not intent_words.is_empty():
		return intent_words[randi() % intent_words.size()]
	elif not emotion_words.is_empty():
		return emotion_words[randi() % emotion_words.size()]
	else:
		return "me"

func generate_two_word_expression(intent: String, emotion: String) -> String:
	"""Generate two-word combinations"""
	var word1 = generate_single_word_expression(intent, emotion)
	var word2 = find_complement_word(word1, intent)
	
	if word2 != "":
		return word1 + " " + word2
	else:
		return word1

func generate_telegraphic_expression(intent: String, emotion: String) -> String:
	"""Generate telegraphic speech (missing function words)"""
	var words = []
	
	# Add subject if appropriate
	if intent in ["self_expression", "desire", "action"]:
		words.append("me" if "me" in vocabulary else "I")
	
	# Add main word
	var main_word = generate_single_word_expression(intent, emotion)
	words.append(main_word)
	
	# Add object/complement if relevant
	var complement = find_complement_word(main_word, intent)
	if complement != "":
		words.append(complement)
	
	return " ".join(words)

func generate_simple_sentence(intent: String, emotion: String) -> String:
	"""Generate complete but simple sentences"""
	var sentence_templates = get_sentence_templates_for_stage()
	
	if sentence_templates.is_empty():
		return generate_telegraphic_expression(intent, emotion)
	
	var template = sentence_templates[randi() % sentence_templates.size()]
	return fill_sentence_template(template, intent, emotion)

func generate_complex_expression(intent: String, emotion: String, complexity: float) -> String:
	"""Generate complex language with advanced grammar"""
	# Use full vocabulary and grammar patterns
	var base_sentence = generate_simple_sentence(intent, emotion)
	
	# Add complexity modifiers based on target
	if complexity > 0.7:
		base_sentence = add_descriptive_elements(base_sentence, emotion)
	
	if complexity > 0.5:
		base_sentence = add_emotional_qualifiers(base_sentence, emotion)
	
	return base_sentence

# === HELPER FUNCTIONS ===

func find_words_for_intent(intent: String) -> Array[String]:
	"""Find vocabulary words that match the intent"""
	var matching_words = []
	
	for word in vocabulary:
		var word_data = vocabulary[word]
		if intent in word_data.get("meaning", ""):
			matching_words.append(word)
	
	return matching_words

func find_complement_word(base_word: String, intent: String) -> String:
	"""Find a word that complements the base word"""
	if not vocabulary.has(base_word):
		return ""
	
	var base_data = vocabulary[base_word]
	var base_type = base_data.get("type", "")
	
	# Simple complementary relationships
	match base_type:
		"emotion":
			return "feel" if "feel" in vocabulary else ""
		"action":
			return "me" if "me" in vocabulary else ""
		"pronoun":
			# Find a verb to go with pronoun
			for word in vocabulary:
				if vocabulary[word].get("type", "") == "action":
					return word
	
	return ""

func get_sentence_templates_for_stage() -> Array[String]:
	"""Get appropriate sentence templates for current stage"""
	match current_stage:
		LanguageStage.SIMPLE_SENTENCES:
			return ["[subject] [verb]", "[subject] [verb] [object]", "[subject] [adjective]"]
		LanguageStage.COMPLEX_LANGUAGE:
			return ["[subject] [verb] [object]", "[subject] [adverb] [verb]", "[adjective] [subject] [verb]"]
		_:
			return []

func fill_sentence_template(template: String, intent: String, emotion: String) -> String:
	"""Fill a sentence template with appropriate words"""
	var filled = template
	
	# Replace placeholders with actual words
	filled = filled.replace("[subject]", get_word_of_type("pronoun", "me"))
	filled = filled.replace("[verb]", get_word_of_type("action", "feel"))
	filled = filled.replace("[object]", get_word_of_type("object", "something"))
	filled = filled.replace("[adjective]", get_word_of_type("emotion", emotion))
	
	return filled

func get_word_of_type(word_type: String, fallback: String) -> String:
	"""Get a word of specific type from vocabulary"""
	for word in vocabulary:
		if vocabulary[word].get("type", "") == word_type:
			return word
	return fallback

func add_descriptive_elements(sentence: String, emotion: String) -> String:
	"""Add descriptive elements to increase complexity"""
	var emotion_words = emotional_expressions.get(emotion, [])
	if not emotion_words.is_empty():
		var descriptor = emotion_words[randi() % emotion_words.size()]
		return sentence + " " + descriptor
	return sentence

func add_emotional_qualifiers(sentence: String, emotion: String) -> String:
	"""Add emotional qualifiers to the sentence"""
	var qualifiers = ["very", "really", "so", "quite"]
	var available_qualifiers = []
	
	for qualifier in qualifiers:
		if qualifier in vocabulary:
			available_qualifiers.append(qualifier)
	
	if not available_qualifiers.is_empty():
		var qualifier = available_qualifiers[randi() % available_qualifiers.size()]
		return qualifier + " " + sentence
	
	return sentence

# === COMPREHENSION UPDATES ===

func update_comprehension(analysis: Dictionary, context: Dictionary):
	"""Update overall comprehension level"""
	var input_comprehension = calculate_input_comprehension(analysis)
	
	# Weighted average with existing comprehension
	comprehension_level = (comprehension_level * 0.9) + (input_comprehension * 0.1)
	comprehension_level = clamp(comprehension_level, 0.0, 1.0)
	
	if input_comprehension > comprehension_level + 0.1:
		comprehension_improved.emit({
			"old_level": comprehension_level,
			"new_level": input_comprehension,
			"input": analysis
		})

func calculate_input_comprehension(analysis: Dictionary) -> float:
	"""Calculate how well the input was understood"""
	if analysis.word_count == 0:
		return 0.0
	
	var known_ratio = float(analysis.known_words) / float(analysis.word_count)
	var complexity_factor = 1.0 - (analysis.complexity_score / 2.0)
	
	return known_ratio * complexity_factor

# === STAGE PROGRESSION ===

func check_stage_progression():
	"""Check if ready to advance to next language stage"""
	var next_stage = current_stage + 1
	
	if next_stage < LanguageStage.size() and stage_thresholds.has(next_stage):
		var threshold = stage_thresholds[next_stage]
		
		if vocabulary_size >= threshold.vocabulary and comprehension_level >= threshold.comprehension:
			advance_to_stage(next_stage)

func advance_to_stage(new_stage: LanguageStage):
	"""Advance to a new language development stage"""
	var old_stage = current_stage
	current_stage = new_stage
	
	print("🎯 Language milestone: Advanced from %s to %s!" % [LanguageStage.keys()[old_stage], LanguageStage.keys()[new_stage]])
	
	language_milestone_reached.emit({
		"old_stage": LanguageStage.keys()[old_stage],
		"new_stage": LanguageStage.keys()[new_stage],
		"vocabulary_size": vocabulary_size,
		"comprehension_level": comprehension_level
	})

# === DATA ACCESS ===

func get_language_summary() -> Dictionary:
	"""Get summary of current language capabilities"""
	return {
		"stage": LanguageStage.keys()[current_stage],
		"vocabulary_size": vocabulary_size,
		"comprehension_level": comprehension_level,
		"expression_complexity": expression_complexity,
		"grammar_patterns": grammar_patterns.keys().size(),
		"learning_rate": learning_rate,
		"recent_words": get_recent_words(5)
	}

func get_recent_words(count: int) -> Array[String]:
	"""Get recently learned words"""
	var recent = []
	var word_list = vocabulary.keys()
	
	# Simple approach - return last few words (in a real implementation, 
	# we'd track learning timestamps)
	var start_index = max(0, word_list.size() - count)
	for i in range(start_index, word_list.size()):
		recent.append(word_list[i])
	
	return recent

func get_words_for_emotion(emotion: String) -> Array[String]:
	"""Get words associated with a specific emotion"""
	var emotion_words = []
	
	for word in vocabulary:
		var word_data = vocabulary[word]
		if emotion in word_data.get("meaning", "") or word_data.get("type", "") == "emotion":
			emotion_words.append(word)
	
	return emotion_words

func can_express_concept(concept: String) -> bool:
	"""Check if current vocabulary can express a concept"""
	return find_words_for_intent(concept).size() > 0