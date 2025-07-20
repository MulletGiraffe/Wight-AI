extends Node
class_name AIBridge

# Bridge between Godot frontend and Python Wight AI agent backend
# Handles communication via HTTP requests or file-based messaging

signal ai_response_received(response: String, metadata: Dictionary)
signal ai_connection_changed(is_connected: bool)
signal ai_thinking_changed(is_thinking: bool)
signal autonomous_thought_received(thought_data: Dictionary)
signal sandbox_update_received(sandbox_data: Dictionary)

var input_file_path: String = "data/input.json"
var output_file_path: String = "data/output.json"
var autonomous_file_path: String = "data/autonomous.json"
var sandbox_file_path: String = "data/sandbox.json"
var last_message_id: int = 0
var monitoring_autonomous: bool = true

func _ready():
	print("AI Bridge initialized - ready to communicate with Wight agent")
	# Ensure data directory exists
	if not DirAccess.dir_exists_absolute("data"):
		DirAccess.open(".").make_dir_recursive_absolute("data")
	
	# Start monitoring for autonomous activities
	start_autonomous_monitoring()

func start_autonomous_monitoring():
	"""Start monitoring for autonomous thoughts and sandbox updates"""
	var autonomous_timer = Timer.new()
	autonomous_timer.wait_time = 1.0  # Check every second
	autonomous_timer.timeout.connect(_check_autonomous_files)
	autonomous_timer.autostart = true
	add_child(autonomous_timer)
	print("👁️ Started autonomous monitoring")

func _check_autonomous_files():
	"""Check for autonomous thoughts and sandbox updates"""
	if not monitoring_autonomous:
		return
	
	# Check for autonomous thoughts
	if FileAccess.file_exists(autonomous_file_path):
		_handle_autonomous_thought()
	
	# Check for sandbox updates
	if FileAccess.file_exists(sandbox_file_path):
		_handle_sandbox_update()

func _handle_autonomous_thought():
	"""Process autonomous thoughts from Wight"""
	try:
		var file = FileAccess.open(autonomous_file_path, FileAccess.READ)
		if file:
			var content = file.get_as_text()
			file.close()
			
			# Remove the file
			DirAccess.remove_absolute(autonomous_file_path)
			
			# Parse the thought
			var json = JSON.new()
			var parse_result = json.parse(content)
			if parse_result == OK:
				var thought_data = json.data
				print("💭 Wight's autonomous thought received")
				autonomous_thought_received.emit(thought_data)
	except:
		print("❌ Error processing autonomous thought")

func _handle_sandbox_update():
	"""Process sandbox updates from Wight"""
	try:
		var file = FileAccess.open(sandbox_file_path, FileAccess.READ)
		if file:
			var content = file.get_as_text()
			file.close()
			
			# Remove the file
			DirAccess.remove_absolute(sandbox_file_path)
			
			# Parse the sandbox data
			var json = JSON.new()
			var parse_result = json.parse(content)
			if parse_result == OK:
				var sandbox_data = json.data
				print("🎨 Sandbox update received")
				sandbox_update_received.emit(sandbox_data)
	except:
		print("❌ Error processing sandbox update")

# Send message to Python AI agent
func send_to_ai(message: String) -> String:
	last_message_id += 1
	var message_id = "msg_" + str(last_message_id)
	
	print("📤 Sending to AI (", message_id, "): ", message)
	
	# Signal that AI is thinking
	ai_thinking_changed.emit(true)
	
	# Create input payload
	var payload = {
		"message": message,
		"timestamp": Time.get_unix_time_from_system(),
		"id": message_id
	}
	
	# Write to input file
	var file = FileAccess.open(input_file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(payload))
		file.close()
		
		# Wait for response
		var response = await wait_for_ai_response(message_id)
		ai_thinking_changed.emit(false)
		return response
	else:
		print("❌ Error: Could not write to input file")
		ai_thinking_changed.emit(false)
		return "Communication error"

# Wait for AI response
func wait_for_ai_response(expected_message_id: String) -> String:
	var max_wait_time = 10.0  # seconds
	var check_interval = 0.1  # seconds
	var elapsed_time = 0.0
	
	while elapsed_time < max_wait_time:
		if FileAccess.file_exists(output_file_path):
			var file = FileAccess.open(output_file_path, FileAccess.READ)
			if file:
				var response_text = file.get_as_text()
				file.close()
				
				# Parse response
				var json = JSON.new()
				var parse_result = json.parse(response_text)
				if parse_result == OK:
					var response_data = json.data
					var message_id = response_data.get("message_id", "")
					
					# Check if this is the response we're waiting for
					if message_id == expected_message_id or message_id == "":
						# Clean up response file
						DirAccess.remove_absolute(output_file_path)
						
						var response = response_data.get("response", "No response")
						var metadata = {
							"memory_count": response_data.get("agent_memory_count", 0),
							"goals_count": response_data.get("agent_goals_count", 0),
							"timestamp": response_data.get("timestamp", 0),
							"message_id": message_id
						}
						
						ai_response_received.emit(response, metadata)
						ai_connection_changed.emit(true)
						print("📥 Received AI response (", message_id, "): ", response)
						return response
		
		await get_tree().create_timer(check_interval).timeout
		elapsed_time += check_interval
	
	ai_connection_changed.emit(false)
	return "AI response timeout"

# Start Python AI agent process (if not already running)
func start_ai_agent():
	print("Starting AI agent...")
	# Note: In production, you might want to start the Python process here
	# For now, we assume the Python agent is running separately
	pass

# Check if AI agent is responsive
func ping_ai() -> bool:
	var response = await send_to_ai("ping")
	var is_responsive = response != "AI response timeout" and response != "Communication error"
	ai_connection_changed.emit(is_responsive)
	return is_responsive