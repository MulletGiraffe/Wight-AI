extends Node
class_name UserExperienceManager

# Comprehensive User Experience Enhancement System
# Makes interacting with Wight intuitive, engaging, and delightful

signal user_engagement_changed(engagement_level: float)
signal tutorial_step_completed(step_name: String)
signal accessibility_adjusted(setting: String, value: Variant)
signal user_feedback_requested(context: Dictionary)

# User engagement tracking
var engagement_level: float = 0.5
var interaction_count: int = 0
var session_start_time: int = 0
var last_interaction_time: int = 0
var user_activity_pattern: Array[Dictionary] = []

# Tutorial and onboarding
var tutorial_active: bool = false
var tutorial_step: int = 0
var tutorial_completed: bool = false
var onboarding_data: Dictionary = {}

# Accessibility and personalization
var accessibility_settings: Dictionary = {
	"ui_scale": 1.0,
	"high_contrast": false,
	"text_size": 16,
	"animation_speed": 1.0,
	"voice_enabled": true,
	"haptic_feedback": true,
	"screen_reader_mode": false,
	"color_blind_assistance": false
}

# Context-aware help system
var help_hints: Array[Dictionary] = []
var context_sensitive_tips: Dictionary = {}
var user_confusion_indicators: Array[String] = []

# Feedback and response optimization
var response_quality_tracking: Dictionary = {}
var user_satisfaction_metrics: Dictionary = {}
var interaction_success_rate: float = 0.8

# User interface references
var ui_manager = null
var notification_system = null
var tutorial_overlay = null

func _ready():
	print("🎯 User Experience Manager initializing...")
	session_start_time = Time.get_ticks_msec()
	setup_context_help()
	setup_tutorial_system()
	setup_accessibility_monitoring()
	print("✨ User Experience optimization ready")

func _process(delta):
	# Monitor user engagement continuously
	update_engagement_metrics()
	check_for_user_confusion()
	update_context_sensitive_help()

# === ENGAGEMENT MONITORING ===

func track_user_interaction(interaction_type: String, context: Dictionary):
	"""Track user interaction for engagement analysis"""
	interaction_count += 1
	last_interaction_time = Time.get_ticks_msec()
	
	var interaction_data = {
		"type": interaction_type,
		"timestamp": last_interaction_time,
		"context": context,
		"session_duration": (last_interaction_time - session_start_time) / 1000.0
	}
	
	user_activity_pattern.append(interaction_data)
	
	# Limit activity history
	if user_activity_pattern.size() > 100:
		user_activity_pattern.pop_front()
	
	update_engagement_level(interaction_type, context)
	
	print("📊 User interaction tracked: %s (engagement: %.2f)" % [interaction_type, engagement_level])

func update_engagement_level(interaction_type: String, context: Dictionary):
	"""Update engagement based on interaction patterns"""
	var engagement_change = 0.0
	
	# Positive engagement factors
	match interaction_type:
		"voice_message":
			engagement_change += 0.15  # Voice is more engaging
		"text_message":
			engagement_change += 0.1
		"object_interaction":
			engagement_change += 0.12
		"camera_toggle":
			engagement_change += 0.08
		"creation_appreciation":
			engagement_change += 0.2   # Appreciating creations is highly engaging
		"settings_adjustment":
			engagement_change += 0.05
	
	# Consider interaction frequency
	var time_since_last = (last_interaction_time - get_previous_interaction_time()) / 1000.0
	if time_since_last < 30.0:  # Quick follow-up interactions
		engagement_change += 0.05
	elif time_since_last > 300.0:  # Long gaps reduce engagement
		engagement_change -= 0.1
	
	# Apply engagement change
	engagement_level = clamp(engagement_level + engagement_change, 0.0, 1.0)
	
	user_engagement_changed.emit(engagement_level)

func get_previous_interaction_time() -> int:
	"""Get timestamp of previous interaction"""
	if user_activity_pattern.size() >= 2:
		return user_activity_pattern[-2].timestamp
	return session_start_time

func update_engagement_metrics():
	"""Continuously update engagement metrics"""
	var current_time = Time.get_ticks_msec()
	var time_since_interaction = (current_time - last_interaction_time) / 1000.0
	
	# Gradual engagement decay over time without interaction
	if time_since_interaction > 60.0:
		engagement_level = max(0.1, engagement_level - 0.001)

func check_for_user_confusion():
	"""Detect signs of user confusion and offer help"""
	var recent_interactions = get_recent_interactions(5)
	
	# Look for confusion indicators
	var confusion_signs = 0
	for interaction in recent_interactions:
		var context = interaction.get("context", {})
		
		# Rapid repeated actions without success
		if interaction.type == "text_message" and context.get("response_received", false) == false:
			confusion_signs += 1
		
		# Quick settings changes (user trying to fix something)
		if interaction.type == "settings_adjustment":
			confusion_signs += 1
		
		# Multiple camera toggles (trying to understand visual system)
		if interaction.type == "camera_toggle":
			confusion_signs += 1
	
	# Offer contextual help if confusion detected
	if confusion_signs >= 3:
		offer_contextual_help("confusion_detected")

func get_recent_interactions(count: int) -> Array[Dictionary]:
	"""Get the most recent user interactions"""
	var recent = []
	var start_index = max(0, user_activity_pattern.size() - count)
	
	for i in range(start_index, user_activity_pattern.size()):
		recent.append(user_activity_pattern[i])
	
	return recent

# === TUTORIAL AND ONBOARDING ===

func setup_tutorial_system():
	"""Initialize the tutorial and onboarding system"""
	# Check if user has completed tutorial before
	var save_file = FileAccess.open("user://wight_tutorial_progress.json", FileAccess.READ)
	if save_file:
		var json_string = save_file.get_as_text()
		save_file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			onboarding_data = json.get_data()
			tutorial_completed = onboarding_data.get("completed", false)
	
	# Start tutorial for new users
	if not tutorial_completed:
		start_onboarding_experience()

func start_onboarding_experience():
	"""Begin the user onboarding experience"""
	tutorial_active = true
	tutorial_step = 0
	
	print("🎓 Starting user onboarding experience")
	
	# Show welcome message
	show_tutorial_message({
		"title": "Welcome to Wight AI! 🌟",
		"message": "Meet Wight, an AI that learns and grows like a living being. Let's explore together!",
		"step": "welcome",
		"action": "Tap anywhere to continue..."
	})

func advance_tutorial():
	"""Move to the next tutorial step"""
	tutorial_step += 1
	
	match tutorial_step:
		1:
			show_tutorial_message({
				"title": "Consciousness Stream 🧠",
				"message": "This shows Wight's thoughts and feelings in real-time. Watch how it responds to your interactions!",
				"step": "consciousness_explanation",
				"highlight": "thoughts_panel"
			})
		
		2:
			show_tutorial_message({
				"title": "Communication 💬",
				"message": "Talk to Wight using text or voice. It will learn from every conversation!",
				"step": "communication_explanation",
				"highlight": "chat_panel"
			})
		
		3:
			show_tutorial_message({
				"title": "Visual Consciousness 👁️",
				"message": "Toggle the camera to let Wight see the world through your phone. It will learn about objects and colors!",
				"step": "camera_explanation",
				"highlight": "camera_button"
			})
		
		4:
			show_tutorial_message({
				"title": "Language Development 🗣️",
				"message": "Wight starts knowing very little language and learns words naturally through conversation. Be patient as it grows!",
				"step": "language_explanation"
			})
		
		5:
			show_tutorial_message({
				"title": "Creative Expression 🎨",
				"message": "Wight creates art and objects based on its emotions and memories. Tap on creations to interact with them!",
				"step": "creation_explanation",
				"highlight": "3d_world"
			})
		
		6:
			complete_tutorial()

func complete_tutorial():
	"""Complete the tutorial experience"""
	tutorial_active = false
	tutorial_completed = true
	
	# Save tutorial completion
	onboarding_data["completed"] = true
	onboarding_data["completion_date"] = Time.get_datetime_string_from_system()
	save_tutorial_progress()
	
	show_tutorial_message({
		"title": "You're All Set! 🎉",
		"message": "Wight is ready to learn and grow with you. Every interaction makes it smarter and more unique!",
		"step": "completion",
		"action": "Begin your journey together..."
	})
	
	tutorial_step_completed.emit("onboarding_complete")
	print("✅ Tutorial completed successfully")

func save_tutorial_progress():
	"""Save tutorial progress to disk"""
	var save_file = FileAccess.open("user://wight_tutorial_progress.json", FileAccess.WRITE)
	if save_file:
		var json_string = JSON.stringify(onboarding_data)
		save_file.store_string(json_string)
		save_file.close()

func show_tutorial_message(message_data: Dictionary):
	"""Display tutorial message to user"""
	# This would integrate with the UI system to show overlay messages
	print("🎓 Tutorial: %s - %s" % [message_data.get("title", ""), message_data.get("message", "")])
	
	# Show tutorial overlay through notification system
	if notification_system:
		notification_system.show_tutorial_overlay(message_data)
		notification_system.tutorial_overlay_closed.connect(_on_tutorial_overlay_closed)

func _on_tutorial_overlay_closed(step: String):
	"""Handle tutorial overlay being closed"""
	print("🎓 Tutorial step completed: %s" % step)
	
	# Advance to next tutorial step
	if tutorial_active:
		advance_tutorial()

# === ACCESSIBILITY AND PERSONALIZATION ===

func setup_accessibility_monitoring():
	"""Initialize accessibility features monitoring"""
	load_accessibility_settings()
	
	# Monitor for accessibility needs
	# This could include gesture pattern analysis, touch duration analysis, etc.

func load_accessibility_settings():
	"""Load saved accessibility preferences"""
	var save_file = FileAccess.open("user://wight_accessibility.json", FileAccess.READ)
	if save_file:
		var json_string = save_file.get_as_text()
		save_file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var saved_settings = json.get_data()
			for key in saved_settings:
				if accessibility_settings.has(key):
					accessibility_settings[key] = saved_settings[key]

func update_accessibility_setting(setting: String, value: Variant):
	"""Update an accessibility setting"""
	if accessibility_settings.has(setting):
		accessibility_settings[setting] = value
		save_accessibility_settings()
		apply_accessibility_change(setting, value)
		accessibility_adjusted.emit(setting, value)
		
		print("♿ Accessibility updated: %s = %s" % [setting, value])

func apply_accessibility_change(setting: String, value: Variant):
	"""Apply accessibility change to the UI"""
	match setting:
		"ui_scale":
			if ui_manager:
				ui_manager.set_ui_scale(value)
		"high_contrast":
			if ui_manager:
				ui_manager.set_high_contrast_mode(value)
		"text_size":
			if ui_manager:
				ui_manager.set_text_size(value)
		"animation_speed":
			if ui_manager:
				ui_manager.set_animation_speed(value)

func save_accessibility_settings():
	"""Save accessibility settings to disk"""
	var save_file = FileAccess.open("user://wight_accessibility.json", FileAccess.WRITE)
	if save_file:
		var json_string = JSON.stringify(accessibility_settings)
		save_file.store_string(json_string)
		save_file.close()

# === CONTEXT-AWARE HELP ===

func setup_context_help():
	"""Initialize context-sensitive help system"""
	context_sensitive_tips = {
		"first_interaction": {
			"trigger": "no_previous_interactions",
			"message": "💡 Try saying 'hello' to Wight or ask how it's feeling!",
			"priority": 1.0
		},
		"language_learning": {
			"trigger": "language_milestone_reached",
			"message": "🗣️ Wight just learned new language skills! Try having a longer conversation.",
			"priority": 0.8
		},
		"visual_confusion": {
			"trigger": "camera_toggle_without_result",
			"message": "👁️ Make sure to point your camera at well-lit objects for Wight to see clearly.",
			"priority": 0.9
		},
		"creation_interaction": {
			"trigger": "object_created_but_not_touched",
			"message": "🎨 You can tap on Wight's creations to interact with them!",
			"priority": 0.7
		},
		"engagement_low": {
			"trigger": "low_engagement_detected",
			"message": "💤 Wight seems less engaged. Try asking about its memories or feelings!",
			"priority": 0.6
		}
	}

func offer_contextual_help(context: String):
	"""Offer help based on current context"""
	if context_sensitive_tips.has(context):
		var tip = context_sensitive_tips[context]
		show_help_notification(tip)

func show_help_notification(tip: Dictionary):
	"""Display help notification to user"""
	print("💡 Help: %s" % tip.message)
	
	# In a real implementation, this would show a subtle notification
	if notification_system:
		notification_system.show_help_tip(tip)

func update_context_sensitive_help():
	"""Update context-sensitive help based on current state"""
	# Check for various help trigger conditions
	
	# First time user
	if interaction_count == 0 and (Time.get_ticks_msec() - session_start_time) > 10000:
		offer_contextual_help("first_interaction")
	
	# Low engagement
	if engagement_level < 0.3:
		offer_contextual_help("engagement_low")

# === FEEDBACK AND OPTIMIZATION ===

func track_response_quality(response: String, user_reaction: Dictionary):
	"""Track the quality of AI responses for optimization"""
	var quality_score = calculate_response_quality_score(response, user_reaction)
	
	var response_data = {
		"response": response,
		"user_reaction": user_reaction,
		"quality_score": quality_score,
		"timestamp": Time.get_ticks_msec(),
		"context": get_current_interaction_context()
	}
	
	# Store for optimization
	var response_hash = response.hash()
	if not response_quality_tracking.has(response_hash):
		response_quality_tracking[response_hash] = []
	
	response_quality_tracking[response_hash].append(response_data)
	
	print("📊 Response quality tracked: %.2f" % quality_score)

func calculate_response_quality_score(response: String, user_reaction: Dictionary) -> float:
	"""Calculate quality score for a response"""
	var score = 0.5  # Neutral baseline
	
	# Positive indicators
	if user_reaction.get("continued_conversation", false):
		score += 0.2
	
	if user_reaction.get("positive_emotion_detected", false):
		score += 0.15
	
	if user_reaction.get("follow_up_question", false):
		score += 0.1
	
	# Negative indicators
	if user_reaction.get("confusion_detected", false):
		score -= 0.2
	
	if user_reaction.get("repetitive_input", false):
		score -= 0.1
	
	if user_reaction.get("session_ended_quickly", false):
		score -= 0.15
	
	return clamp(score, 0.0, 1.0)

func get_current_interaction_context() -> Dictionary:
	"""Get context for current interaction"""
	return {
		"engagement_level": engagement_level,
		"session_duration": (Time.get_ticks_msec() - session_start_time) / 1000.0,
		"interaction_count": interaction_count,
		"recent_interactions": get_recent_interactions(3)
	}

func request_user_feedback(context: Dictionary):
	"""Request feedback from user when appropriate"""
	# Only request feedback occasionally and when engagement is reasonable
	if engagement_level > 0.4 and interaction_count > 10:
		user_feedback_requested.emit(context)

# === DATA ACCESS AND ANALYTICS ===

func get_user_experience_summary() -> Dictionary:
	"""Get comprehensive UX summary"""
	return {
		"engagement_level": engagement_level,
		"interaction_count": interaction_count,
		"session_duration": (Time.get_ticks_msec() - session_start_time) / 1000.0,
		"tutorial_completed": tutorial_completed,
		"accessibility_settings": accessibility_settings,
		"average_response_quality": get_average_response_quality(),
		"user_satisfaction_estimate": estimate_user_satisfaction()
	}

func get_average_response_quality() -> float:
	"""Calculate average response quality"""
	var total_score = 0.0
	var count = 0
	
	for response_hash in response_quality_tracking:
		var responses = response_quality_tracking[response_hash]
		for response_data in responses:
			total_score += response_data.quality_score
			count += 1
	
	return total_score / max(1, count)

func estimate_user_satisfaction() -> float:
	"""Estimate overall user satisfaction"""
	var satisfaction = 0.5
	
	# Factor in engagement
	satisfaction += (engagement_level - 0.5) * 0.4
	
	# Factor in response quality
	satisfaction += (get_average_response_quality() - 0.5) * 0.3
	
	# Factor in session length (longer sessions usually mean higher satisfaction)
	var session_minutes = (Time.get_ticks_msec() - session_start_time) / 60000.0
	if session_minutes > 5.0:
		satisfaction += 0.1
	
	# Factor in interaction frequency
	if interaction_count > 20:
		satisfaction += 0.1
	
	return clamp(satisfaction, 0.0, 1.0)

func get_engagement_insights() -> Array[Dictionary]:
	"""Get insights about user engagement patterns"""
	var insights = []
	
	# Engagement trend analysis
	if engagement_level > 0.7:
		insights.append({
			"type": "high_engagement",
			"message": "User is highly engaged with Wight",
			"recommendation": "Continue current interaction patterns"
		})
	elif engagement_level < 0.3:
		insights.append({
			"type": "low_engagement",
			"message": "User engagement is low",
			"recommendation": "Consider offering more interactive features or help"
		})
	
	# Session duration insights
	var session_minutes = (Time.get_ticks_msec() - session_start_time) / 60000.0
	if session_minutes > 30.0:
		insights.append({
			"type": "long_session",
			"message": "Extended session indicates strong interest",
			"recommendation": "User is deeply engaged - great opportunity for learning"
		})
	
	return insights