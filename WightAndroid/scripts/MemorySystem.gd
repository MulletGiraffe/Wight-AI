class_name MemorySystem
extends RefCounted

## Manages Wight's memory, learned facts, and experiences
## Converted from Python wight_core.py memory functionality

signal memory_added(memory: Dictionary)
signal fact_learned(key: String, value)
signal goal_added(goal: Dictionary)

var memory: Array = []
var learned_facts: Dictionary = {}
var goals: Array = []
var conversation_history: Array = []

# Memory types for organization
enum MemoryType {
	CONVERSATION,
	SELF_AWARENESS,
	FACT_LEARNING,
	EMOTIONAL_EVENT,
	CREATIVE_ACTION,
	GOAL_SETTING,
	EXPERIENCE,
	REFLECTION
}

func add_memory(data: String, memory_type: MemoryType = MemoryType.EXPERIENCE, significance: float = 0.5, metadata: Dictionary = {}) -> Dictionary:
	"""Add a new memory with timestamp and context"""
	var memory_entry = {
		"data": data,
		"timestamp": Time.get_unix_time_from_system(),
		"type": MemoryType.keys()[memory_type].to_lower(),
		"significance": clamp(significance, 0.0, 1.0),
		"metadata": metadata,
		"id": generate_memory_id()
	}
	
	memory.append(memory_entry)
	
	# Keep memory manageable (retain most significant and recent)
	if memory.size() > 1000:
		_trim_memory()
	
	memory_added.emit(memory_entry)
	return memory_entry

func add_conversation(user_message: String, ai_response: String, emotional_context: String = "") -> Dictionary:
	"""Add a conversation exchange to memory"""
	var conversation = {
		"user_message": user_message,
		"ai_response": ai_response,
		"emotional_context": emotional_context,
		"timestamp": Time.get_unix_time_from_system()
	}
	
	conversation_history.append(conversation)
	
	# Also add to general memory
	var memory_data = "User said: '%s' | I responded: '%s'" % [user_message, ai_response]
	add_memory(memory_data, MemoryType.CONVERSATION, 0.7, 
		{"emotional_context": emotional_context})
	
	return conversation

func learn_fact(key: String, value, confidence: float = 1.0):
	"""Learn a new fact or update existing knowledge"""
	var fact_entry = {
		"value": value,
		"confidence": clamp(confidence, 0.0, 1.0),
		"learned_at": Time.get_unix_time_from_system(),
		"reinforcement_count": 1
	}
	
	# If fact already exists, reinforce it
	if key in learned_facts:
		var existing = learned_facts[key]
		fact_entry["reinforcement_count"] = existing.get("reinforcement_count", 1) + 1
		fact_entry["confidence"] = min(1.0, existing.get("confidence", 0.5) + 0.1)
	
	learned_facts[key] = fact_entry
	
	# Add to memory
	add_memory("Learned fact: %s = %s" % [key, str(value)], 
		MemoryType.FACT_LEARNING, 0.8, {"fact_key": key, "confidence": confidence})
	
	fact_learned.emit(key, value)

func get_fact(key: String):
	"""Get a learned fact"""
	if key in learned_facts:
		return learned_facts[key]["value"]
	return null

func has_fact(key: String) -> bool:
	"""Check if a fact is known"""
	return key in learned_facts

func get_fact_confidence(key: String) -> float:
	"""Get confidence level of a fact"""
	if key in learned_facts:
		return learned_facts[key]["confidence"]
	return 0.0

func add_goal(description: String, priority: float = 0.5, category: String = "general") -> Dictionary:
	"""Add a new goal"""
	var goal = {
		"description": description,
		"priority": clamp(priority, 0.0, 1.0),
		"category": category,
		"created_at": Time.get_unix_time_from_system(),
		"status": "active",
		"progress": 0.0,
		"id": generate_goal_id()
	}
	
	goals.append(goal)
	
	add_memory("Set new goal: %s" % description, MemoryType.GOAL_SETTING, 0.6, 
		{"goal_id": goal["id"], "category": category})
	
	goal_added.emit(goal)
	return goal

func update_goal_progress(goal_id: String, progress: float):
	"""Update progress on a goal"""
	for goal in goals:
		if goal["id"] == goal_id:
			goal["progress"] = clamp(progress, 0.0, 1.0)
			if goal["progress"] >= 1.0:
				goal["status"] = "completed"
			break

func get_active_goals() -> Array:
	"""Get all active goals"""
	var active = []
	for goal in goals:
		if goal["status"] == "active":
			active.append(goal)
	return active

func get_recent_memories(count: int = 10) -> Array:
	"""Get the most recent memories"""
	var recent = memory.duplicate()
	recent.sort_custom(func(a, b): return a["timestamp"] > b["timestamp"])
	return recent.slice(0, min(count, recent.size()))

func get_memories_by_type(memory_type: MemoryType) -> Array:
	"""Get memories of a specific type"""
	var type_string = MemoryType.keys()[memory_type].to_lower()
	var filtered = []
	for mem in memory:
		if mem["type"] == type_string:
			filtered.append(mem)
	return filtered

func search_memories(query: String) -> Array:
	"""Search memories by content"""
	var results = []
	var query_lower = query.to_lower()
	
	for mem in memory:
		if mem["data"].to_lower().contains(query_lower):
			results.append(mem)
	
	# Sort by relevance (exact matches first, then by significance)
	results.sort_custom(func(a, b): 
		var a_exact = a["data"].to_lower().find(query_lower) == 0
		var b_exact = b["data"].to_lower().find(query_lower) == 0
		if a_exact != b_exact:
			return a_exact
		return a["significance"] > b["significance"]
	)
	
	return results

func get_conversation_count() -> int:
	"""Get total number of conversations"""
	return conversation_history.size()

func get_memory_count() -> int:
	"""Get total number of memories"""
	return memory.size()

func get_learned_facts_count() -> int:
	"""Get number of learned facts"""
	return learned_facts.size()

func remember_user_preference(preference_type: String, value):
	"""Remember a user preference"""
	var key = "user_preference_" + preference_type
	learn_fact(key, value, 0.9)

func get_user_preference(preference_type: String):
	"""Get a remembered user preference"""
	var key = "user_preference_" + preference_type
	return get_fact(key)

func add_emotional_memory(emotion: String, trigger: String, intensity: float):
	"""Add an emotional memory"""
	var memory_data = "Felt %s (intensity: %.2f) because: %s" % [emotion, intensity, trigger]
	add_memory(memory_data, MemoryType.EMOTIONAL_EVENT, intensity, 
		{"emotion": emotion, "trigger": trigger, "intensity": intensity})

func get_emotional_memories(emotion: String = "") -> Array:
	"""Get emotional memories, optionally filtered by emotion"""
	var emotional_mems = get_memories_by_type(MemoryType.EMOTIONAL_EVENT)
	
	if emotion != "":
		emotional_mems = emotional_mems.filter(func(mem): 
			return mem["metadata"].get("emotion", "") == emotion)
	
	return emotional_mems

func consolidate_similar_facts():
	"""Consolidate similar or related facts (simple deduplication)"""
	# This is a simplified version - in a full implementation,
	# you'd use more sophisticated similarity detection
	var keys_to_remove = []
	
	for key1 in learned_facts:
		for key2 in learned_facts:
			if key1 != key2 and key1.similarity(key2) > 0.8:
				# Keep the one with higher confidence
				if learned_facts[key1]["confidence"] > learned_facts[key2]["confidence"]:
					keys_to_remove.append(key2)
				else:
					keys_to_remove.append(key1)
	
	for key in keys_to_remove:
		learned_facts.erase(key)

func generate_memory_summary() -> String:
	"""Generate a summary of current memory state"""
	var total_memories = memory.size()
	var total_facts = learned_facts.size()
	var total_goals = goals.size()
	var active_goals = get_active_goals().size()
	
	var summary = "I have %d memories, %d learned facts, and %d goals (%d active)." % [
		total_memories, total_facts, total_goals, active_goals]
	
	if learned_facts.has("user_name"):
		summary += " I remember your name is %s." % learned_facts["user_name"]["value"]
	
	return summary

func _trim_memory():
	"""Remove less significant older memories to keep memory manageable"""
	# Sort by significance and recency
	memory.sort_custom(func(a, b):
		var significance_diff = a["significance"] - b["significance"]
		if abs(significance_diff) < 0.1:  # Similar significance
			return a["timestamp"] > b["timestamp"]  # Prefer recent
		return significance_diff > 0  # Prefer significant
	)
	
	# Keep top 800 memories
	memory = memory.slice(0, 800)

func generate_memory_id() -> String:
	"""Generate a unique ID for a memory"""
	return "mem_%d_%d" % [Time.get_unix_time_from_system(), randi()]

func generate_goal_id() -> String:
	"""Generate a unique ID for a goal"""
	return "goal_%d_%d" % [Time.get_unix_time_from_system(), randi()]

func get_save_data() -> Dictionary:
	"""Get data for saving memory state"""
	return {
		"memory": memory.slice(-200),  # Save last 200 memories
		"learned_facts": learned_facts,
		"goals": goals,
		"conversation_history": conversation_history.slice(-50)  # Save last 50 conversations
	}

func load_save_data(data: Dictionary):
	"""Load memory state from saved data"""
	if data.has("memory"):
		memory = data["memory"]
	if data.has("learned_facts"):
		learned_facts = data["learned_facts"]
	if data.has("goals"):
		goals = data["goals"]
	if data.has("conversation_history"):
		conversation_history = data["conversation_history"]

func to_string() -> String:
	"""String representation of memory system"""
	return "MemorySystem(memories=%d, facts=%d, goals=%d)" % [
		memory.size(), learned_facts.size(), goals.size()]