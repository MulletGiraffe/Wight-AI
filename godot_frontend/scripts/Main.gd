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

var conversation_history: Array[Dictionary] = []
var message_bubble_scene = preload("res://scenes/MessageBubble.tscn")

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

func setup_ui_connections():
	# Find UI nodes
	chat_scroll = $UI/ChatPanel/ChatScroll
	chat_container = $UI/ChatPanel/ChatScroll/ChatContainer
	message_input = $UI/InputPanel/MessageInput
	send_button = $UI/InputPanel/SendButton
	status_label = $UI/StatusPanel/StatusLabel
	thinking_label = $UI/StatusPanel/ThinkingLabel
	
	# Connect UI signals
	send_button.pressed.connect(_on_send_button_pressed)
	message_input.text_submitted.connect(_on_message_submitted)
	
	# Set initial status
	status_label.text = "Connecting to AI agent..."
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

func _input(event):
	# Handle global input
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif event.is_action_pressed("interact"):
		message_input.grab_focus()