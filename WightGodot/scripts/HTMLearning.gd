extends Node
class_name HTMLearning

# Simplified HTM-like Learning System for Wight AI
# Implements pattern recognition, temporal sequences, and predictive learning

signal pattern_learned(pattern_id: String, confidence: float)
signal prediction_made(prediction: Dictionary)

# HTM-like structure
var columns: Array[Dictionary] = []
var temporal_memory: Dictionary = {}
var spatial_pooler: Dictionary = {}
var prediction_engine: Dictionary = {}

# Learning parameters
var column_count: int = 1024
var cells_per_column: int = 8
var connection_threshold: float = 0.5
var learning_rate: float = 0.1
var decay_rate: float = 0.05

# Memory systems
var working_memory: Array[Dictionary] = []
var long_term_memory: Dictionary = {}
var episodic_memory: Array[Dictionary] = []
var pattern_library: Dictionary = {}

# Current state
var active_columns: Array[int] = []
var predictive_cells: Array[Dictionary] = []
var current_input_pattern: Array[float] = []

func _init():
	initialize_htm_structure()
	print("🧠 HTM Learning System initialized for Wight")

func initialize_htm_structure():
	"""Initialize the HTM-like neural structure"""
	# Create columns with cells
	for i in range(column_count):
		var column = {
			"id": i,
			"cells": [],
			"connections": {},
			"boost": 1.0,
			"activity": 0.0,
			"overlap": 0.0
		}
		
		# Create cells in each column
		for j in range(cells_per_column):
			var cell = {
				"id": j,
				"column_id": i,
				"active": false,
				"predictive": false,
				"learning": false,
				"distal_segments": [],
				"activation_history": []
			}
			column.cells.append(cell)
		
		columns.append(column)
	
	# Initialize spatial pooler
	spatial_pooler = {
		"inhibition_radius": 16,
		"desired_local_activity": 40,
		"min_overlap": 8,
		"stimulus_threshold": 0.5
	}
	
	# Initialize temporal memory
	temporal_memory = {
		"max_segments_per_cell": 255,
		"max_synapses_per_segment": 255,
		"initial_permanence": 0.21,
		"connected_permanence": 0.5,
		"min_threshold": 10,
		"activation_threshold": 13
	}

# === CORE HTM PROCESSING ===

func process_input(sensor_data: Dictionary) -> Dictionary:
	"""Main HTM processing pipeline"""
	
	# Convert sensor data to binary pattern
	var input_pattern = encode_sensor_data(sensor_data)
	current_input_pattern = input_pattern
	
	# Spatial pooling - find active columns
	var active_cols = spatial_pooling(input_pattern)
	active_columns = active_cols
	
	# Temporal memory - sequence learning and prediction
	var prediction_result = temporal_processing(active_cols)
	
	# Update learning based on results
	update_learning(sensor_data, prediction_result)
	
	# Generate behavioral output
	var behavior_output = generate_behavior(prediction_result)
	
	return {
		"active_columns": active_cols,
		"predictions": prediction_result,
		"behavior": behavior_output,
		"confidence": calculate_confidence(prediction_result),
		"novelty": calculate_novelty(input_pattern)
	}

func encode_sensor_data(sensor_data: Dictionary) -> Array[float]:
	"""Convert sensor inputs to sparse binary representation"""
	var encoded = []
	encoded.resize(column_count)
	encoded.fill(0.0)
	
	var bit_index = 0
	
	# Encode each sensor type with different bit ranges
	if sensor_data.has("sound_level"):
		var sound_bits = quantize_value(sensor_data.sound_level, 0.0, 1.0, 64)
		for i in range(64):
			if i < sound_bits:
				encoded[bit_index + i] = 1.0
		bit_index += 64
	
	if sensor_data.has("light_level"):
		var light_bits = quantize_value(sensor_data.light_level, 0.0, 1.0, 64)
		for i in range(64):
			if i < light_bits:
				encoded[bit_index + i] = 1.0
		bit_index += 64
	
	if sensor_data.has("acceleration"):
		var accel = sensor_data.acceleration as Vector3
		var accel_magnitude = accel.length()
		var accel_bits = quantize_value(accel_magnitude, 0.0, 20.0, 64)
		for i in range(64):
			if i < accel_bits:
				encoded[bit_index + i] = 1.0
		bit_index += 64
	
	if sensor_data.has("orientation"):
		var orient = sensor_data.orientation as Vector3
		# Encode orientation as multiple ranges
		var pitch_bits = quantize_value((orient.x + PI) / (2 * PI), 0.0, 1.0, 32)
		var yaw_bits = quantize_value((orient.y + PI) / (2 * PI), 0.0, 1.0, 32)
		
		for i in range(32):
			if i < pitch_bits:
				encoded[bit_index + i] = 1.0
		bit_index += 32
		
		for i in range(32):
			if i < yaw_bits:
				encoded[bit_index + i] = 1.0
		bit_index += 32
	
	if sensor_data.has("touch_events"):
		var touch_count = min(sensor_data.touch_events.size(), 32)
		for i in range(touch_count):
			encoded[bit_index + i] = 1.0
		bit_index += 32
	
	return encoded

func spatial_pooling(input_pattern: Array[float]) -> Array[int]:
	"""HTM Spatial Pooling - identify active columns"""
	var overlaps = []
	
	# Calculate overlap for each column
	for col_idx in range(columns.size()):
		var column = columns[col_idx]
		var overlap = calculate_overlap(column, input_pattern)
		
		# Apply boosting
		overlap *= column.boost
		
		column.overlap = overlap
		overlaps.append({"index": col_idx, "overlap": overlap})
	
	# Sort by overlap and select top active columns
	overlaps.sort_custom(func(a, b): return a.overlap > b.overlap)
	
	var active_cols = []
	var desired_activity = spatial_pooler.desired_local_activity
	
	for i in range(min(desired_activity, overlaps.size())):
		if overlaps[i].overlap >= spatial_pooler.min_overlap:
			active_cols.append(overlaps[i].index)
	
	# Update boost factors
	update_boost_factors(active_cols)
	
	return active_cols

func temporal_processing(active_cols: Array[int]) -> Dictionary:
	"""HTM Temporal Memory - sequence learning and prediction"""
	var predictions = {}
	var active_cells = []
	var predictive_cells_next = []
	
	# Phase 1: Activate cells in active columns
	for col_idx in active_cols:
		var column = columns[col_idx]
		var column_cells = column.cells
		
		# Check if any cells were predicted
		var predicted_cells = []
		for cell in column_cells:
			if cell.predictive:
				predicted_cells.append(cell)
		
		if predicted_cells.size() > 0:
			# Activate predicted cells
			for cell in predicted_cells:
				cell.active = true
				cell.learning = true
				active_cells.append(cell)
		else:
			# Burst the column - activate all cells
			for cell in column_cells:
				cell.active = true
				active_cells.append(cell)
	
	# Phase 2: Generate predictions for next timestep
	for cell in active_cells:
		var segments = cell.distal_segments
		for segment in segments:
			if is_segment_active(segment):
				# This cell will be predictive
				cell.predictive = true
				predictive_cells_next.append(cell)
	
	# Update predictive cells
	predictive_cells = predictive_cells_next
	
	# Learn temporal sequences
	learn_temporal_sequences(active_cells)
	
	# Generate predictions
	predictions = generate_predictions(predictive_cells)
	
	return predictions

# === LEARNING MECHANISMS ===

func learn_temporal_sequences(active_cells: Array[Dictionary]):
	"""Learn temporal relationships between cell activations"""
	if working_memory.size() < 2:
		working_memory.append({"cells": active_cells, "timestamp": Time.get_ticks_msec()})
		return
	
	# Get previous active cells
	var prev_state = working_memory[-1]
	var prev_cells = prev_state.cells
	
	# For each currently active cell, strengthen connections to previously active cells
	for curr_cell in active_cells:
		if curr_cell.learning:
			strengthen_temporal_connections(curr_cell, prev_cells)
	
	# Add current state to working memory
	working_memory.append({"cells": active_cells, "timestamp": Time.get_ticks_msec()})
	
	# Maintain working memory size
	if working_memory.size() > 10:
		working_memory.pop_front()

func strengthen_temporal_connections(target_cell: Dictionary, source_cells: Array[Dictionary]):
	"""Strengthen synaptic connections between cells"""
	
	# Find or create distal segment
	var segment = find_best_matching_segment(target_cell, source_cells)
	if segment == null:
		segment = create_new_segment(target_cell)
	
	# Strengthen connections to active source cells
	for source_cell in source_cells:
		if source_cell.active:
			strengthen_synapse(segment, source_cell)

func update_learning(sensor_data: Dictionary, prediction_result: Dictionary):
	"""Update long-term learning based on experience"""
	
	# Store episodic memory
	var episode = {
		"timestamp": Time.get_ticks_msec(),
		"sensor_data": sensor_data,
		"predictions": prediction_result,
		"pattern": current_input_pattern.duplicate(),
		"active_columns": active_columns.duplicate()
	}
	
	episodic_memory.append(episode)
	
	# Maintain episodic memory size
	if episodic_memory.size() > 1000:
		episodic_memory.pop_front()
	
	# Update pattern library
	update_pattern_library(episode)
	
	# Consolidate to long-term memory periodically
	if episodic_memory.size() % 50 == 0:
		consolidate_memories()

# === BEHAVIORAL OUTPUT ===

func generate_behavior(prediction_result: Dictionary) -> Dictionary:
	"""Generate behavioral responses based on predictions and internal state"""
	
	var behavior = {
		"action_type": "observe",
		"intensity": 0.1,
		"direction": Vector3.ZERO,
		"create_impulse": false,
		"communication_intent": "",
		"exploration_drive": 0.0
	}
	
	# Calculate novelty and uncertainty
	var novelty = calculate_novelty(current_input_pattern)
	var uncertainty = 1.0 - calculate_confidence(prediction_result)
	
	# High novelty or uncertainty increases exploration
	if novelty > 0.7 or uncertainty > 0.8:
		behavior.action_type = "explore"
		behavior.exploration_drive = novelty + uncertainty
		behavior.intensity = min(1.0, novelty * 2.0)
	
	# Pattern recognition triggers creation impulse
	if prediction_result.has("recognized_patterns"):
		var patterns = prediction_result.recognized_patterns
		if patterns.size() > 2:  # Multiple patterns suggest creativity opportunity
			behavior.create_impulse = true
			behavior.action_type = "create"
			behavior.intensity = min(1.0, patterns.size() * 0.3)
	
	# Temporal predictions influence direction
	if prediction_result.has("temporal_prediction"):
		var temporal = prediction_result.temporal_prediction
		if temporal.confidence > 0.6:
			behavior.direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	
	return behavior

# === UTILITY FUNCTIONS ===

func quantize_value(value: float, min_val: float, max_val: float, buckets: int) -> int:
	"""Quantize continuous value into discrete buckets"""
	var normalized = clamp((value - min_val) / (max_val - min_val), 0.0, 1.0)
	return int(normalized * (buckets - 1))

func calculate_overlap(column: Dictionary, input_pattern: Array[float]) -> float:
	"""Calculate overlap between column and input pattern"""
	var overlap = 0.0
	var connections = column.get("connections", {})
	
	for i in range(input_pattern.size()):
		if input_pattern[i] > 0.5 and connections.has(i):
			if connections[i] > connection_threshold:
				overlap += 1.0
	
	return overlap

func calculate_confidence(prediction_result: Dictionary) -> float:
	"""Calculate confidence in current predictions"""
	if not prediction_result.has("predictions"):
		return 0.1
	
	var predictions = prediction_result.predictions
	var total_confidence = 0.0
	var count = 0
	
	for pred in predictions.values():
		if pred is Dictionary and pred.has("confidence"):
			total_confidence += pred.confidence
			count += 1
	
	return total_confidence / max(1, count)

func calculate_novelty(input_pattern: Array[float]) -> float:
	"""Calculate how novel current input is compared to learned patterns"""
	if pattern_library.is_empty():
		return 1.0  # Everything is novel initially
	
	var min_distance = 1.0
	for pattern_id in pattern_library.keys():
		var stored_pattern = pattern_library[pattern_id].pattern
		var distance = calculate_pattern_distance(input_pattern, stored_pattern)
		min_distance = min(min_distance, distance)
	
	return min_distance

func calculate_pattern_distance(pattern1: Array[float], pattern2: Array[float]) -> float:
	"""Calculate Hamming distance between two patterns"""
	var distance = 0.0
	var size = min(pattern1.size(), pattern2.size())
	
	for i in range(size):
		if abs(pattern1[i] - pattern2[i]) > 0.5:
			distance += 1.0
	
	return distance / size

# === HELPER FUNCTIONS ===

func update_boost_factors(active_cols: Array[int]):
	"""Update boost factors for columns based on activity"""
	for i in range(columns.size()):
		var column = columns[i]
		if i in active_cols:
			column.activity = min(1.0, column.activity + learning_rate)
		else:
			column.activity = max(0.0, column.activity - decay_rate)
		
		# Boost underactive columns
		if column.activity < 0.1:
			column.boost = min(10.0, column.boost + 0.1)
		else:
			column.boost = max(1.0, column.boost - 0.01)

func find_best_matching_segment(cell: Dictionary, source_cells: Array[Dictionary]) -> Dictionary:
	"""Find the best matching distal segment for a cell"""
	# Simplified implementation
	if cell.distal_segments.size() > 0:
		return cell.distal_segments[0]
	# Return an empty segment structure if none exists
	return {
		"synapses": {},
		"permanences": {},
		"threshold": temporal_memory.get("activation_threshold", 0.5)
	}

func create_new_segment(cell: Dictionary) -> Dictionary:
	"""Create a new distal segment for a cell"""
	var segment = {
		"synapses": {},
		"permanences": {},
		"threshold": temporal_memory.activation_threshold
	}
	cell.distal_segments.append(segment)
	return segment

func strengthen_synapse(segment: Dictionary, source_cell: Dictionary):
	"""Strengthen connection between segment and source cell"""
	var cell_id = str(source_cell.column_id) + "_" + str(source_cell.id)
	
	if not segment.permanences.has(cell_id):
		segment.permanences[cell_id] = temporal_memory.initial_permanence
	
	segment.permanences[cell_id] = min(1.0, segment.permanences[cell_id] + learning_rate)

func is_segment_active(segment: Dictionary) -> bool:
	"""Check if a distal segment is active based on its synapses"""
	var active_synapses = 0
	
	for cell_id in segment.permanences.keys():
		if segment.permanences[cell_id] >= temporal_memory.connected_permanence:
			# Check if source cell is active (simplified)
			active_synapses += 1
	
	return active_synapses >= segment.threshold

func generate_predictions(predictive_cells: Array[Dictionary]) -> Dictionary:
	"""Generate predictions based on predictive cells"""
	var predictions = {}
	
	# Group predictive cells by column
	var column_predictions = {}
	for cell in predictive_cells:
		var col_id = cell.column_id
		if not column_predictions.has(col_id):
			column_predictions[col_id] = []
		column_predictions[col_id].append(cell)
	
	# Generate predictions for each column
	for col_id in column_predictions.keys():
		var cells = column_predictions[col_id]
		var confidence = float(cells.size()) / cells_per_column
		
		predictions[col_id] = {
			"confidence": confidence,
			"cells": cells,
			"prediction_type": "temporal_sequence"
		}
	
	return predictions

func update_pattern_library(episode: Dictionary):
	"""Update the pattern library with new episodes"""
	var pattern_id = str(episode.timestamp)
	pattern_library[pattern_id] = {
		"pattern": episode.pattern,
		"frequency": 1,
		"last_seen": episode.timestamp,
		"context": episode.sensor_data
	}

func consolidate_memories():
	"""Consolidate episodic memories into long-term memory"""
	# Find frequently occurring patterns
	var pattern_counts = {}
	
	for episode in episodic_memory:
		var pattern_signature = calculate_pattern_signature(episode.pattern)
		if not pattern_counts.has(pattern_signature):
			pattern_counts[pattern_signature] = 0
		pattern_counts[pattern_signature] += 1
	
	# Move frequent patterns to long-term memory
	for signature in pattern_counts.keys():
		if pattern_counts[signature] >= 5:  # Threshold for consolidation
			if not long_term_memory.has(signature):
				long_term_memory[signature] = {
					"frequency": pattern_counts[signature],
					"consolidated_at": Time.get_ticks_msec(),
					"pattern_type": "consolidated"
				}

func calculate_pattern_signature(pattern: Array[float]) -> String:
	"""Calculate a signature for a pattern for consolidation"""
	var signature = ""
	for i in range(0, pattern.size(), 10):  # Sample every 10th element
		if pattern[i] > 0.5:
			signature += "1"
		else:
			signature += "0"
	return signature

# === PUBLIC API ===

func get_learning_state() -> Dictionary:
	"""Get current learning state for external systems"""
	return {
		"active_columns": active_columns.size(),
		"predictive_cells": predictive_cells.size(),
		"pattern_library_size": pattern_library.size(),
		"episodic_memory_size": episodic_memory.size(),
		"long_term_memory_size": long_term_memory.size(),
		"learning_active": true
	}

func reset_learning():
	"""Reset the learning system"""
	working_memory.clear()
	episodic_memory.clear()
	pattern_library.clear()
	active_columns.clear()
	predictive_cells.clear()
	print("🧠 HTM Learning System reset")