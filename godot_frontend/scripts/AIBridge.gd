extends Node
class_name AIBridge

# Bridge between Godot frontend and Python Wight AI agent backend
# Handles communication via HTTP requests or file-based messaging

signal ai_response_received(response: String)
signal ai_learning_update(data: Dictionary)

var python_process: OS
var communication_file_path: String = "data/communication.json"
var response_file_path: String = "data/response.json"

func _ready():
	print("AI Bridge initialized - ready to communicate with Wight agent")
	# Ensure communication directories exist
	if not DirAccess.dir_exists_absolute("data"):
		DirAccess.open("res://").make_dir_recursive_absolute("data")

# Send message to Python AI agent
func send_to_ai(message: String) -> String:
	print("Sending to AI: ", message)
	
	# Create communication payload
	var payload = {
		"message": message,
		"timestamp": Time.get_unix_time_from_system(),
		"source": "godot_frontend"
	}
	
	# Write to communication file
	var file = FileAccess.open(communication_file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(payload))
		file.close()
		
		# Wait for response (simple polling approach)
		return await wait_for_ai_response()
	else:
		print("Error: Could not write to communication file")
		return "Communication error"

# Wait for AI response
func wait_for_ai_response() -> String:
	var max_wait_time = 5.0  # seconds
	var check_interval = 0.1  # seconds
	var elapsed_time = 0.0
	
	while elapsed_time < max_wait_time:
		if FileAccess.file_exists(response_file_path):
			var file = FileAccess.open(response_file_path, FileAccess.READ)
			if file:
				var response_text = file.get_as_text()
				file.close()
				
				# Clean up response file
				DirAccess.remove_absolute(response_file_path)
				
				# Parse response
				var json = JSON.new()
				var parse_result = json.parse(response_text)
				if parse_result == OK:
					var response_data = json.data
					ai_response_received.emit(response_data.get("response", "No response"))
					return response_data.get("response", "No response")
				else:
					return response_text
		
		await get_tree().create_timer(check_interval).timeout
		elapsed_time += check_interval
	
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
	return response != "AI response timeout"

# Send learning data to AI
func send_learning_data(data: Dictionary):
	var learning_payload = {
		"type": "learning_data",
		"data": data,
		"timestamp": Time.get_unix_time_from_system()
	}
	
	var file = FileAccess.open("data/learning_input.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(learning_payload))
		file.close()
		print("Learning data sent to AI")
	else:
		print("Error: Could not send learning data")