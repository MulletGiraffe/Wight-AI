extends Node

# Main game scene script
# This handles the overall game state and coordinates between different systems

@onready var player_scene = preload("res://scenes/Player.tscn")
var player_instance: Node

func _ready():
	print("Wight game started!")
	setup_game()

func setup_game():
	# Initialize the game
	spawn_player()

func spawn_player():
	# Instantiate the player
	player_instance = player_scene.instantiate()
	add_child(player_instance)
	
	# Position the player at the center of the screen
	if player_instance.has_method("set_position"):
		player_instance.position = Vector2(960, 540)  # Center of 1920x1080 screen

func _input(event):
	# Handle global input events
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()