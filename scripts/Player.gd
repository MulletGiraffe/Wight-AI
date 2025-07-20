extends CharacterBody2D

# Player character script
# Handles player movement, physics, and basic interactions

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	print("Player spawned!")

func _physics_process(delta):
	handle_gravity(delta)
	handle_jump()
	handle_movement()
	move_and_slide()

func handle_gravity(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump():
	# Handle jump
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = jump_velocity

func handle_movement():
	# Handle horizontal movement
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func _input(event):
	# Handle player-specific input events
	pass