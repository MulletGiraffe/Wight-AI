extends Node

# Main scene for Wight AI Frontend
# Handles user interface and coordinates with AI agent backend

@onready var ai_bridge: AIBridge
@onready var chat_scroll: ScrollContainer
@onready var chat_container: VBoxContainer
@onready var message_input: LineEdit
@onready var send_button: Button
@onready var status_label: Label
@onready var thinking_label: Label
@onready var sandbox_manager: SandboxManager

var conversation_history: Array[Dictionary] = []
var message_bubble_scene = preload("res://scenes/MessageBubble.tscn")
var autonomous_thoughts_enabled: bool = true

func _ready():
	print("Wight AI Frontend initialized")
	setup_ai_bridge()
	setup_ui_connections()
	
	# Initial AI connection test
	test_ai_connection()

func setup_ai_bridge():
	# Create AI Bridge
	ai_bridge = AIBridge.new()
	add_child(ai_bridge)
	
	# Connect AI signals
	ai_bridge.ai_response_received.connect(_on_ai_response)
	ai_bridge.ai_connection_changed.connect(_on_ai_connection_changed)
	ai_bridge.ai_thinking_changed.connect(_on_ai_thinking_changed)
	ai_bridge.autonomous_thought_received.connect(_on_autonomous_thought)
	ai_bridge.sandbox_update_received.connect(_on_sandbox_update)

func setup_ui_connections():
	# Find UI nodes
	chat_scroll = $UI/HSplit/ChatSide/ChatPanel/ChatScroll
	chat_container = $UI/HSplit/ChatSide/ChatPanel/ChatScroll/ChatContainer
	message_input = $UI/HSplit/ChatSide/InputPanel/MessageInput
	send_button = $UI/HSplit/ChatSide/InputPanel/SendButton
	status_label = $UI/HSplit/ChatSide/StatusPanel/StatusLabel
	thinking_label = $UI/HSplit/ChatSide/StatusPanel/ThinkingLabel
	sandbox_manager = $UI/HSplit/SandboxSide/SandboxPanel/SandboxManager
	
	# Connect UI signals
	send_button.pressed.connect(_on_send_button_pressed)
	message_input.text_submitted.connect(_on_message_submitted)
	
	# Connect sandbox signals
	if sandbox_manager:
		sandbox_manager.object_created.connect(_on_sandbox_object_created)
		sandbox_manager.object_moved.connect(_on_sandbox_object_moved)
		sandbox_manager.object_destroyed.connect(_on_sandbox_object_destroyed)
	
	# Set initial status
	status_label.text = "🔄 Connecting to AI agent..."
	thinking_label.text = ""
	thinking_label.visible = false

func test_ai_connection():
	var is_connected = await ai_bridge.ping_ai()
	if is_connected:
		add_system_message("Connected to Wight AI Agent. You can start chatting! 🚀")
	else:
		add_system_message("⚠️ Warning: AI Agent not responding. Check if Python backend is running.")

func _on_send_button_pressed():
	send_message()

func _on_message_submitted(text: String):
	send_message()

func send_message():
	var message = message_input.text.strip_edges()
	if message == "":
		return
	
	# Add user message to display
	add_user_message(message)
	
	# Clear input
	message_input.text = ""
	
	# Send to AI (the thinking indicator is handled by the bridge)
	var response = await ai_bridge.send_to_ai(message)

func _on_ai_response(response: String, metadata: Dictionary):
	add_ai_message(response, metadata)

func _on_ai_connection_changed(is_connected: bool):
	if is_connected:
		status_label.text = "🟢 Connected"
		status_label.modulate = Color.GREEN
	else:
		status_label.text = "🔴 Disconnected"
		status_label.modulate = Color.RED

func _on_ai_thinking_changed(is_thinking: bool):
	thinking_label.visible = is_thinking
	if is_thinking:
		thinking_label.text = "🤔 Wight is thinking..."
	else:
		thinking_label.text = ""

func add_user_message(message: String):
	var message_data = {
		"sender": "user",
		"content": message,
		"timestamp": Time.get_unix_time_from_system()
	}
	conversation_history.append(message_data)
	create_message_bubble(message_data)

func add_ai_message(message: String, metadata: Dictionary):
	var message_data = {
		"sender": "ai",
		"content": message,
		"timestamp": Time.get_unix_time_from_system(),
		"metadata": metadata
	}
	conversation_history.append(message_data)
	create_message_bubble(message_data)

func add_system_message(message: String):
	var message_data = {
		"sender": "system",
		"content": message,
		"timestamp": Time.get_unix_time_from_system()
	}
	conversation_history.append(message_data)
	create_message_bubble(message_data)

func create_message_bubble(message_data: Dictionary):
	var bubble = message_bubble_scene.instantiate()
	chat_container.add_child(bubble)
	bubble.setup_message(message_data)
	
	# Auto-scroll to bottom
	await get_tree().process_frame
	chat_scroll.scroll_vertical = chat_scroll.get_v_scroll_bar().max_value

func _on_autonomous_thought(thought_data: Dictionary):
	"""Handle autonomous thoughts from Wight"""
	if autonomous_thoughts_enabled:
		var content = thought_data.get("content", "")
		var thought_type = thought_data.get("thought_type", "autonomous")
		var emotional_state = thought_data.get("emotional_state", "contemplative")
		
		# Create a special autonomous message
		var message_data = {
			"sender": "ai_autonomous",
			"content": content,
			"timestamp": Time.get_unix_time_from_system(),
			"metadata": {
				"thought_type": thought_type,
				"emotional_state": emotional_state,
				"autonomous": true
			}
		}
		
		conversation_history.append(message_data)
		create_message_bubble(message_data)
		
		print(f"💭 Autonomous thought: {content}")

func _on_sandbox_update(sandbox_data: Dictionary):
	"""Handle sandbox updates from Wight"""
	if sandbox_manager:
		sandbox_manager.update_from_sandbox_data(sandbox_data)
		
		# Add a system message about the sandbox activity
		var actions = sandbox_data.get("actions", [])
		if actions.size() > 0:
			var action_descriptions = []
			for action in actions:
				var action_type = action.get("type", "unknown")
				match action_type:
					"create_object":
						var obj_data = action.get("object_data", {})
						action_descriptions.append(f"created {obj_data.get('type', 'object')} '{obj_data.get('name', 'Unknown')}'")
					"move_object":
						action_descriptions.append("moved an object")
					"destroy_object":
						action_descriptions.append("destroyed an object")
			
			if action_descriptions.size() > 0:
				var description = "🎨 Wight " + action_descriptions[0]
				if action_descriptions.size() > 1:
					description += f" (and {action_descriptions.size() - 1} more actions)"
				
				add_system_message(description)

func _on_sandbox_object_created(object_data: Dictionary):
	"""Handle sandbox object creation"""
	print(f"🎨 Sandbox object created: {object_data}")

func _on_sandbox_object_moved(object_id: int, new_position: Vector2):
	"""Handle sandbox object movement"""
	print(f"🎨 Object {object_id} moved to {new_position}")

func _on_sandbox_object_destroyed(object_id: int):
	"""Handle sandbox object destruction"""
	print(f"🎨 Object {object_id} destroyed")

func _input(event):
	# Handle global input
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif event.is_action_pressed("interact"):
		message_input.grab_focus()
	elif event.is_action_just_pressed("ui_accept") and Input.is_key_pressed(KEY_CTRL):
		# Ctrl+Enter to toggle autonomous thoughts
		autonomous_thoughts_enabled = !autonomous_thoughts_enabled
		var status = "enabled" if autonomous_thoughts_enabled else "disabled"
		add_system_message(f"Autonomous thoughts {status}")