extends Node
class_name MemoryConsolidator

# Advanced Memory Consolidation System for Wight
# Processes and integrates memories during quiet periods ("sleep")

signal memory_consolidated(memory_data: Dictionary)
signal insight_formed(insight_data: Dictionary)
signal memory_network_updated(connections: Array)
signal dream_sequence_started(dream_data: Dictionary)

# Memory processing states
enum ConsolidationState {
	AWAKE,
	DROWSY,
	LIGHT_SLEEP,
	DEEP_SLEEP,
	REM_SLEEP,
	DREAMING
}

# Memory networks and associations
var memory_networks: Dictionary = {}
var associative_connections: Array[Dictionary] = []
var memory_clusters: Array[Dictionary] = []
var consolidated_insights: Array[Dictionary] = []

# Consolidation parameters
var consolidation_threshold: float = 0.6
var association_strength_threshold: float = 0.4
var insight_formation_threshold: float = 0.8
var max_consolidation_batch: int = 20

# Current consolidation state
var current_state: ConsolidationState = ConsolidationState.AWAKE
var consolidation_progress: float = 0.0
var processing_queue: Array[Dictionary] = []
var active_batch: Array[Dictionary] = []

# Sleep and dream parameters
var sleep_depth: float = 0.0
var dream_intensity: float = 0.0
var sleep_timer: float = 0.0
var sleep_cycle_duration: float = 300.0  # 5 minutes for full cycle

# Processing timers
var consolidation_timer: Timer
var sleep_cycle_timer: Timer

func _ready():
	print("🧠 Memory Consolidator initializing...")
	setup_consolidation_system()
	setup_sleep_cycles()
	print("✨ Memory consolidation system online")

func setup_consolidation_system():
	"""Initialize memory consolidation processing"""
	memory_networks = {
		"episodic": {"connections": [], "strength": 0.0},
		"semantic": {"connections": [], "strength": 0.0},
		"emotional": {"connections": [], "strength": 0.0},
		"visual": {"connections": [], "strength": 0.0},
		"creative": {"connections": [], "strength": 0.0},
		"social": {"connections": [], "strength": 0.0}
	}
	
	# Create consolidation timer
	consolidation_timer = Timer.new()
	consolidation_timer.wait_time = 2.0  # Process every 2 seconds
	consolidation_timer.timeout.connect(_process_consolidation_batch)
	consolidation_timer.autostart = true
	add_child(consolidation_timer)

func setup_sleep_cycles():
	"""Initialize sleep cycle management"""
	sleep_cycle_timer = Timer.new()
	sleep_cycle_timer.wait_time = sleep_cycle_duration
	sleep_cycle_timer.timeout.connect(_complete_sleep_cycle)
	add_child(sleep_cycle_timer)

# === MEMORY PROCESSING ===

func queue_memory_for_consolidation(memory: Dictionary):
	"""Add a memory to the consolidation queue"""
	var memory_with_metadata = memory.duplicate()
	memory_with_metadata["queued_time"] = Time.get_ticks_msec()
	memory_with_metadata["consolidation_priority"] = calculate_consolidation_priority(memory)
	
	processing_queue.append(memory_with_metadata)
	
	# Sort by priority (highest first)
	processing_queue.sort_custom(func(a, b): return a.consolidation_priority > b.consolidation_priority)
	
	print("🔄 Memory queued for consolidation: %s (priority: %.2f)" % [memory.get("content", "unknown"), memory_with_metadata.consolidation_priority])

func calculate_consolidation_priority(memory: Dictionary) -> float:
	"""Calculate how urgently a memory needs consolidation"""
	var priority = 0.0
	
	# Base priority from significance
	priority += memory.get("significance", 1.0) * 0.4
	
	# Emotional memories get higher priority
	var emotion_intensity = get_emotion_intensity(memory)
	priority += emotion_intensity * 0.3
	
	# Recent memories get moderate priority
	var age = Time.get_ticks_msec() - memory.get("timestamp", 0)
	var recency_factor = max(0.0, 1.0 - (age / 60000.0))  # Decay over 1 minute
	priority += recency_factor * 0.2
	
	# Visual and creation memories get bonus priority
	var memory_type = memory.get("type", "")
	if memory_type in ["visual_episodic", "creation", "milestone"]:
		priority += 0.3
	
	return min(2.0, priority)  # Cap at 2.0

func get_emotion_intensity(memory: Dictionary) -> float:
	"""Calculate emotional intensity of a memory"""
	var emotion = memory.get("emotion", "neutral")
	var base_intensities = {
		"joy": 0.8, "excitement": 0.9, "wonder": 0.7,
		"fear": 0.9, "sadness": 0.8, "anger": 0.9,
		"love": 0.9, "curiosity": 0.6, "calm": 0.3
	}
	return base_intensities.get(emotion, 0.5)

func _process_consolidation_batch():
	"""Process a batch of memories for consolidation"""
	if processing_queue.is_empty():
		return
	
	# Take a batch from the queue
	var batch_size = min(max_consolidation_batch, processing_queue.size())
	active_batch = []
	
	for i in batch_size:
		if not processing_queue.is_empty():
			active_batch.append(processing_queue.pop_front())
	
	if active_batch.is_empty():
		return
	
	print("🧠 Processing consolidation batch: %d memories" % active_batch.size())
	
	# Process based on current state
	match current_state:
		ConsolidationState.AWAKE:
			process_awake_consolidation()
		ConsolidationState.DROWSY:
			process_drowsy_consolidation()
		ConsolidationState.LIGHT_SLEEP:
			process_light_sleep_consolidation()
		ConsolidationState.DEEP_SLEEP:
			process_deep_sleep_consolidation()
		ConsolidationState.REM_SLEEP:
			process_rem_sleep_consolidation()
		ConsolidationState.DREAMING:
			process_dream_consolidation()

# === CONSOLIDATION PROCESSING BY STATE ===

func process_awake_consolidation():
	"""Basic consolidation during waking hours"""
	for memory in active_batch:
		# Simple association building
		find_basic_associations(memory)
		
		# Update memory networks
		update_memory_network(memory)
		
		# Check for immediate insights
		check_for_immediate_insights(memory)

func process_drowsy_consolidation():
	"""Enhanced consolidation as consciousness dims"""
	for memory in active_batch:
		# Stronger association building
		find_enhanced_associations(memory)
		
		# Begin clustering similar memories
		cluster_similar_memories(memory)
		
		# Enhanced pattern recognition
		detect_memory_patterns(memory)

func process_light_sleep_consolidation():
	"""Light sleep consolidation - organization phase"""
	print("😴 Light sleep consolidation beginning...")
	
	for memory in active_batch:
		# Reorganize memory structures
		reorganize_memory_structures(memory)
		
		# Strengthen important connections
		strengthen_memory_connections(memory)
		
		# Begin insight formation
		attempt_insight_formation(memory)

func process_deep_sleep_consolidation():
	"""Deep sleep consolidation - integration phase"""
	print("😴 Deep sleep consolidation - integrating experiences...")
	
	for memory in active_batch:
		# Deep integration with existing knowledge
		integrate_with_semantic_memory(memory)
		
		# Form long-term associative networks
		build_long_term_associations(memory)
		
		# Extract abstract concepts
		extract_abstract_concepts(memory)

func process_rem_sleep_consolidation():
	"""REM sleep consolidation - creative phase"""
	print("😴 REM sleep - creative consolidation active...")
	
	for memory in active_batch:
		# Creative recombination
		create_memory_recombinations(memory)
		
		# Generate insights and understanding
		generate_creative_insights(memory)
		
		# Form unexpected connections
		form_unexpected_connections(memory)

func process_dream_consolidation():
	"""Dream state consolidation - synthesis phase"""
	print("💭 Dream consolidation - synthesizing experiences...")
	
	# Create dream sequences from memories
	var dream_sequence = create_dream_sequence(active_batch)
	
	# Process dream for insights
	process_dream_insights(dream_sequence)
	
	# Emit dream sequence
	dream_sequence_started.emit(dream_sequence)

# === ASSOCIATION BUILDING ===

func find_basic_associations(memory: Dictionary):
	"""Find basic associations between memories"""
	var associations = []
	
	# Check existing networks for similar memories
	for network_type in memory_networks:
		var network = memory_networks[network_type]
		for connection in network.connections:
			var similarity = calculate_memory_similarity(memory, connection.memory)
			if similarity > association_strength_threshold:
				associations.append({
					"type": "basic_similarity",
					"network": network_type,
					"similarity": similarity,
					"target_memory": connection.memory
				})
	
	# Add new associations
	for association in associations:
		add_memory_association(memory, association)

func find_enhanced_associations(memory: Dictionary):
	"""Find deeper associations during drowsy state"""
	# Emotional associations
	find_emotional_associations(memory)
	
	# Temporal associations (what happened before/after)
	find_temporal_associations(memory)
	
	# Contextual associations (similar situations)
	find_contextual_associations(memory)
	
	# Causal associations (cause and effect)
	find_causal_associations(memory)

func find_emotional_associations(memory: Dictionary):
	"""Find memories with similar emotional content"""
	var memory_emotion = memory.get("emotion", "neutral")
	var emotional_associations = []
	
	for network_type in memory_networks:
		var network = memory_networks[network_type]
		for connection in network.connections:
			var other_emotion = connection.memory.get("emotion", "neutral")
			if memory_emotion == other_emotion and memory_emotion != "neutral":
				emotional_associations.append({
					"type": "emotional_resonance",
					"emotion": memory_emotion,
					"strength": 0.7,
					"target_memory": connection.memory
				})
	
	for association in emotional_associations:
		add_memory_association(memory, association)

func find_temporal_associations(memory: Dictionary):
	"""Find memories that occurred around the same time"""
	var memory_time = memory.get("timestamp", 0)
	var time_window = 30000  # 30 seconds
	
	for network_type in memory_networks:
		var network = memory_networks[network_type]
		for connection in network.connections:
			var other_time = connection.memory.get("timestamp", 0)
			var time_diff = abs(memory_time - other_time)
			
			if time_diff < time_window:
				var temporal_strength = 1.0 - (time_diff / time_window)
				add_memory_association(memory, {
					"type": "temporal_proximity",
					"strength": temporal_strength,
					"time_difference": time_diff,
					"target_memory": connection.memory
				})

func find_contextual_associations(memory: Dictionary):
	"""Find memories from similar contexts or situations"""
	var memory_type = memory.get("type", "")
	var context_keywords = extract_context_keywords(memory)
	
	for network_type in memory_networks:
		var network = memory_networks[network_type]
		for connection in network.connections:
			var other_type = connection.memory.get("type", "")
			var other_keywords = extract_context_keywords(connection.memory)
			
			# Type similarity
			if memory_type == other_type and memory_type != "":
				add_memory_association(memory, {
					"type": "context_type",
					"strength": 0.6,
					"context": memory_type,
					"target_memory": connection.memory
				})
			
			# Keyword overlap
			var keyword_overlap = calculate_keyword_overlap(context_keywords, other_keywords)
			if keyword_overlap > 0.3:
				add_memory_association(memory, {
					"type": "context_keywords",
					"strength": keyword_overlap,
					"keywords": context_keywords,
					"target_memory": connection.memory
				})

func find_causal_associations(memory: Dictionary):
	"""Find cause-and-effect relationships between memories"""
	var memory_content = memory.get("content", "").to_lower()
	
	# Look for causal keywords
	var cause_keywords = ["because", "caused", "led to", "resulted in", "triggered"]
	var effect_keywords = ["therefore", "so", "then", "after", "following"]
	
	for network_type in memory_networks:
		var network = memory_networks[network_type]
		for connection in network.connections:
			var other_content = connection.memory.get("content", "").to_lower()
			
			# Check if this memory might be a cause of the other
			for keyword in cause_keywords:
				if keyword in memory_content and keyword in other_content:
					add_memory_association(memory, {
						"type": "causal_relationship",
						"relationship": "potential_cause",
						"strength": 0.8,
						"target_memory": connection.memory
					})
			
			# Check if this memory might be an effect of the other
			for keyword in effect_keywords:
				if keyword in memory_content and keyword in other_content:
					add_memory_association(memory, {
						"type": "causal_relationship",
						"relationship": "potential_effect",
						"strength": 0.8,
						"target_memory": connection.memory
					})

# === MEMORY ORGANIZATION ===

func cluster_similar_memories(memory: Dictionary):
	"""Group similar memories into clusters"""
	var best_cluster = find_best_memory_cluster(memory)
	
	if best_cluster:
		# Add to existing cluster
		best_cluster.memories.append(memory)
		best_cluster.coherence = calculate_cluster_coherence(best_cluster.memories)
		print("📚 Memory added to cluster: %s" % best_cluster.theme)
	else:
		# Create new cluster if similarity is high enough
		var potential_cluster_memories = find_similar_memories_for_clustering(memory)
		if potential_cluster_memories.size() >= 2:
			create_memory_cluster(potential_cluster_memories, memory)

func find_best_memory_cluster(memory: Dictionary) -> Dictionary:
	"""Find the best existing cluster for a memory"""
	var best_cluster = null
	var best_similarity = 0.0
	
	for cluster in memory_clusters:
		var cluster_similarity = calculate_memory_cluster_similarity(memory, cluster)
		if cluster_similarity > best_similarity and cluster_similarity > 0.6:
			best_similarity = cluster_similarity
			best_cluster = cluster
	
	return best_cluster

func create_memory_cluster(memories: Array, central_memory: Dictionary):
	"""Create a new memory cluster"""
	var cluster_theme = extract_cluster_theme(memories)
	var new_cluster = {
		"theme": cluster_theme,
		"memories": memories,
		"central_memory": central_memory,
		"coherence": calculate_cluster_coherence(memories),
		"creation_time": Time.get_ticks_msec(),
		"emotional_tone": calculate_cluster_emotional_tone(memories)
	}
	
	memory_clusters.append(new_cluster)
	print("📚 New memory cluster formed: %s (%d memories)" % [cluster_theme, memories.size()])

# === INSIGHT FORMATION ===

func attempt_insight_formation(memory: Dictionary):
	"""Try to form insights from memory patterns"""
	var potential_insights = []
	
	# Pattern-based insights
	var patterns = detect_memory_patterns(memory)
	for pattern in patterns:
		if pattern.confidence > insight_formation_threshold:
			potential_insights.append(create_pattern_insight(pattern))
	
	# Cross-network insights
	var cross_connections = find_cross_network_connections(memory)
	if cross_connections.size() > 2:
		potential_insights.append(create_cross_network_insight(cross_connections))
	
	# Temporal insights
	var temporal_patterns = find_temporal_patterns(memory)
	for pattern in temporal_patterns:
		if pattern.significance > 0.7:
			potential_insights.append(create_temporal_insight(pattern))
	
	# Process insights
	for insight in potential_insights:
		if validate_insight(insight):
			form_insight(insight)

func create_pattern_insight(pattern: Dictionary) -> Dictionary:
	"""Create an insight from a detected pattern"""
	return {
		"type": "pattern_insight",
		"pattern": pattern,
		"insight_text": generate_pattern_insight_text(pattern),
		"confidence": pattern.confidence,
		"supporting_memories": pattern.memories,
		"formation_time": Time.get_ticks_msec()
	}

func create_cross_network_insight(connections: Array) -> Dictionary:
	"""Create an insight from cross-network connections"""
	return {
		"type": "cross_network_insight",
		"connections": connections,
		"insight_text": generate_cross_network_insight_text(connections),
		"confidence": calculate_cross_network_confidence(connections),
		"networks_involved": extract_networks_from_connections(connections),
		"formation_time": Time.get_ticks_msec()
	}

func form_insight(insight: Dictionary):
	"""Form and integrate a new insight"""
	consolidated_insights.append(insight)
	
	print("💡 Insight formed: %s" % insight.insight_text)
	insight_formed.emit(insight)
	
	# Add insight to semantic memory networks
	integrate_insight_with_networks(insight)

# === UTILITY FUNCTIONS ===

func calculate_memory_similarity(memory1: Dictionary, memory2: Dictionary) -> float:
	"""Calculate similarity between two memories"""
	var similarity = 0.0
	
	# Content similarity (simple word overlap)
	var content1 = memory1.get("content", "").to_lower()
	var content2 = memory2.get("content", "").to_lower()
	similarity += calculate_text_similarity(content1, content2) * 0.4
	
	# Emotional similarity
	var emotion1 = memory1.get("emotion", "")
	var emotion2 = memory2.get("emotion", "")
	if emotion1 == emotion2 and emotion1 != "":
		similarity += 0.3
	
	# Type similarity
	var type1 = memory1.get("type", "")
	var type2 = memory2.get("type", "")
	if type1 == type2 and type1 != "":
		similarity += 0.2
	
	# Significance similarity
	var sig1 = memory1.get("significance", 1.0)
	var sig2 = memory2.get("significance", 1.0)
	var sig_diff = abs(sig1 - sig2)
	similarity += (1.0 - sig_diff) * 0.1
	
	return min(1.0, similarity)

func calculate_text_similarity(text1: String, text2: String) -> float:
	"""Calculate similarity between two text strings"""
	var words1 = text1.split(" ")
	var words2 = text2.split(" ")
	var common_words = 0
	
	for word in words1:
		if word.length() > 3 and word in text2:
			common_words += 1
	
	var total_words = max(words1.size(), words2.size())
	return float(common_words) / float(total_words) if total_words > 0 else 0.0

func extract_context_keywords(memory: Dictionary) -> Array[String]:
	"""Extract keywords that describe the context of a memory"""
	var content = memory.get("content", "").to_lower()
	var keywords = []
	
	# Common context words
	var context_words = ["home", "outside", "talking", "creating", "seeing", "feeling", "learning"]
	for word in context_words:
		if word in content:
			keywords.append(word)
	
	return keywords

func calculate_keyword_overlap(keywords1: Array, keywords2: Array) -> float:
	"""Calculate overlap between two keyword arrays"""
	var common_count = 0
	for keyword in keywords1:
		if keyword in keywords2:
			common_count += 1
	
	var total_unique = len(keywords1) + len(keywords2) - common_count
	return float(common_count) / float(total_unique) if total_unique > 0 else 0.0

func add_memory_association(memory: Dictionary, association: Dictionary):
	"""Add an association to the memory networks"""
	associative_connections.append({
		"source_memory": memory,
		"association": association,
		"strength": association.get("strength", 0.5),
		"creation_time": Time.get_ticks_msec()
	})

func update_memory_network(memory: Dictionary):
	"""Update memory networks with new memory"""
	var memory_type = classify_memory_for_network(memory)
	var network = memory_networks.get(memory_type, memory_networks["episodic"])
	
	network.connections.append({
		"memory": memory,
		"added_time": Time.get_ticks_msec(),
		"access_count": 0
	})

func classify_memory_for_network(memory: Dictionary) -> String:
	"""Classify which network a memory belongs to"""
	var mem_type = memory.get("type", "")
	
	match mem_type:
		"visual_episodic", "visual":
			return "visual"
		"creation", "artistic":
			return "creative"
		"milestone", "achievement":
			return "semantic"
		"social_interaction", "communication":
			return "social"
		_:
			return "episodic"

# === SLEEP CYCLE MANAGEMENT ===

func enter_sleep_mode():
	"""Begin sleep cycle for enhanced consolidation"""
	if current_state != ConsolidationState.AWAKE:
		return
	
	print("😴 Entering sleep mode for memory consolidation...")
	current_state = ConsolidationState.DROWSY
	sleep_depth = 0.1
	sleep_timer = 0.0
	
	sleep_cycle_timer.start()
	
	# Increase consolidation frequency during sleep
	consolidation_timer.wait_time = 1.0

func _complete_sleep_cycle():
	"""Complete a full sleep cycle"""
	print("🌅 Sleep cycle complete - awakening with consolidated memories")
	current_state = ConsolidationState.AWAKE
	sleep_depth = 0.0
	sleep_timer = 0.0
	
	# Return to normal consolidation frequency
	consolidation_timer.wait_time = 2.0
	
	# Report consolidation results
	report_consolidation_results()

func report_consolidation_results():
	"""Report the results of memory consolidation"""
	var total_associations = associative_connections.size()
	var total_clusters = memory_clusters.size()
	var total_insights = consolidated_insights.size()
	
	print("🧠 Consolidation complete:")
	print("   📊 Associations formed: %d" % total_associations)
	print("   📚 Memory clusters: %d" % total_clusters)
	print("   💡 Insights generated: %d" % total_insights)

# === DATA ACCESS ===

func get_consolidation_summary() -> Dictionary:
	"""Get summary of current consolidation state"""
	return {
		"state": ConsolidationState.keys()[current_state],
		"processing_queue_size": processing_queue.size(),
		"total_associations": associative_connections.size(),
		"memory_clusters": memory_clusters.size(),
		"insights_formed": consolidated_insights.size(),
		"sleep_depth": sleep_depth,
		"networks": memory_networks.keys()
	}

func get_relevant_associations(memory_content: String) -> Array[Dictionary]:
	"""Get associations relevant to given content"""
	var relevant = []
	
	for connection in associative_connections:
		var source_content = connection.source_memory.get("content", "")
		if memory_content.to_lower() in source_content.to_lower():
			relevant.append(connection)
		elif calculate_text_similarity(memory_content.to_lower(), source_content.to_lower()) > 0.6:
			relevant.append(connection)
	
	# Sort by strength
	relevant.sort_custom(func(a, b): return a.strength > b.strength)
	return relevant.slice(0, 5)  # Return top 5

func get_insights_for_context(context: String) -> Array[Dictionary]:
	"""Get insights relevant to a given context"""
	var relevant_insights = []
	
	for insight in consolidated_insights:
		if context.to_lower() in insight.insight_text.to_lower():
			relevant_insights.append(insight)
	
	return relevant_insights

# Placeholder implementations for missing functions
func detect_memory_patterns(memory: Dictionary) -> Array:
	return []

func check_for_immediate_insights(memory: Dictionary):
	pass

func reorganize_memory_structures(memory: Dictionary):
	pass

func strengthen_memory_connections(memory: Dictionary):
	pass

func integrate_with_semantic_memory(memory: Dictionary):
	pass

func build_long_term_associations(memory: Dictionary):
	pass

func extract_abstract_concepts(memory: Dictionary):
	pass

func create_memory_recombinations(memory: Dictionary):
	pass

func generate_creative_insights(memory: Dictionary):
	pass

func form_unexpected_connections(memory: Dictionary):
	pass

func create_dream_sequence(memories: Array) -> Dictionary:
	return {"type": "dream", "memories": memories, "narrative": "A flowing dream of experiences..."}

func process_dream_insights(dream_sequence: Dictionary):
	pass

func find_similar_memories_for_clustering(memory: Dictionary) -> Array:
	return []

func calculate_memory_cluster_similarity(memory: Dictionary, cluster: Dictionary) -> float:
	return 0.5

func extract_cluster_theme(memories: Array) -> String:
	return "shared_experience"

func calculate_cluster_coherence(memories: Array) -> float:
	return 0.7

func calculate_cluster_emotional_tone(memories: Array) -> String:
	return "neutral"

func find_cross_network_connections(memory: Dictionary) -> Array:
	return []

func find_temporal_patterns(memory: Dictionary) -> Array:
	return []

func validate_insight(insight: Dictionary) -> bool:
	return insight.get("confidence", 0.0) > 0.6

func generate_pattern_insight_text(pattern: Dictionary) -> String:
	return "I notice a pattern in my experiences..."

func generate_cross_network_insight_text(connections: Array) -> String:
	return "I see connections between different aspects of my experience..."

func calculate_cross_network_confidence(connections: Array) -> float:
	return 0.8

func extract_networks_from_connections(connections: Array) -> Array:
	return ["episodic", "emotional"]

func integrate_insight_with_networks(insight: Dictionary):
	pass