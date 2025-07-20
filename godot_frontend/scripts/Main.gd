extends Node

# Main scene for Wight AI Frontend
# Handles user interface and coordinates with AI agent backend

@onready var ai_bridge: AIBridge
@onready var chat_display: RichTextLabel
@onready var message_input: LineEdit
@onready var send_button: Button
@onready var status_label: Label

var conversation_history: Array[String] = []

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
	ai_bridge.ai_learning_update.connect(_on_ai_learning_update)

func setup_ui_connections():
	# Find UI nodes
	chat_display = $UI/ChatPanel/ChatDisplay
	message_input = $UI/InputPanel/MessageInput
	send_button = $UI/InputPanel/SendButton
	status_label = $UI/StatusPanel/StatusLabel
	
	# Connect UI signals
	send_button.pressed.connect(_on_send_button_pressed)
	message_input.text_submitted.connect(_on_message_submitted)
	
	# Set initial status
	status_label.text = "Connecting to AI agent..."

func test_ai_connection():
	var is_connected = await ai_bridge.ping_ai()
	if is_connected:
		status_label.text = "Connected to Wight AI Agent"
		status_label.modulate = Color.GREEN
		add_message("System", "Connected to Wight AI Agent. You can start chatting!")
	else:
		status_label.text = "AI Agent not responding"
		status_label.modulate = Color.RED
		add_message("System", "Warning: AI Agent not responding. Check if Python backend is running.")

func _on_send_button_pressed():
	send_message()

func _on_message_submitted(text: String):
	send_message()

func send_message():
	var message = message_input.text.strip_edges()
	if message == "":
		return
	
	# Add user message to display
	add_message("You", message)
	
	# Clear input
	message_input.text = ""
	
	# Send to AI
	status_label.text = "AI is thinking..."
	status_label.modulate = Color.YELLOW
	
	var response = await ai_bridge.send_to_ai(message)
	
	# Update status
	status_label.text = "Connected to Wight AI Agent"
	status_label.modulate = Color.GREEN

func _on_ai_response(response: String):
	add_message("Wight", response)

func _on_ai_learning_update(data: Dictionary):
	print("AI learning update: ", data)
	# Handle learning updates from AI

func add_message(sender: String, message: String):
	var timestamp = Time.get_datetime_string_from_system()
	var formatted_message = "[b][color=cyan]%s[/color][/b] (%s): %s\n" % [sender, timestamp, message]
	
	conversation_history.append(formatted_message)
	chat_display.append_text(formatted_message)
	
	# Auto-scroll to bottom
	chat_display.scroll_to_line(chat_display.get_line_count())

func _input(event):
	# Handle global input
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif event.is_action_pressed("interact"):
		message_input.grab_focus()