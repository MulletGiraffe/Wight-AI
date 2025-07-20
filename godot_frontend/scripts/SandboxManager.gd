extends Node2D
class_name SandboxManager

# Manages Wight's sandbox world - his creative digital space

signal object_created(object_data: Dictionary)
signal object_moved(object_id: int, new_position: Vector2)
signal object_destroyed(object_id: int)

@export var sandbox_bounds: Rect2 = Rect2(-400, -300, 800, 600)
@export var object_scale: float = 30.0

var sandbox_objects: Dictionary = {}
var object_scenes: Dictionary = {}

# Preload object scenes
var cube_scene: PackedScene
var sphere_scene: PackedScene
var pyramid_scene: PackedScene
var torus_scene: PackedScene

func _ready():
	# Create basic object scenes programmatically since we don't have separate scene files
	print("🎨 Sandbox Manager initialized")
	setup_sandbox_background()

func setup_sandbox_background():
	"""Create a visual background for the sandbox"""
	# Create a subtle grid background
	queue_redraw()

func _draw():
	"""Draw the sandbox environment"""
	# Draw sandbox bounds
	draw_rect(sandbox_bounds, Color(0.1, 0.1, 0.2, 0.3), false, 2.0)
	
	# Draw a subtle grid
	var grid_size = 50
	var grid_color = Color(0.2, 0.2, 0.3, 0.2)
	
	# Vertical lines
	for x in range(int(sandbox_bounds.position.x), int(sandbox_bounds.position.x + sandbox_bounds.size.x), grid_size):
		draw_line(Vector2(x, sandbox_bounds.position.y), 
				  Vector2(x, sandbox_bounds.position.y + sandbox_bounds.size.y), 
				  grid_color, 1.0)
	
	# Horizontal lines
	for y in range(int(sandbox_bounds.position.y), int(sandbox_bounds.position.y + sandbox_bounds.size.y), grid_size):
		draw_line(Vector2(sandbox_bounds.position.x, y), 
				  Vector2(sandbox_bounds.position.x + sandbox_bounds.size.x, y), 
				  grid_color, 1.0)

func create_sandbox_object(object_data: Dictionary):
	"""Create a visual representation of a sandbox object"""
	var obj_id = object_data.get("id", 0)
	var obj_type = object_data.get("type", "cube")
	var obj_name = object_data.get("name", "Object")
	var position_data = object_data.get("position", {"x": 0, "y": 0})
	var color_data = object_data.get("color", {"r": 1.0, "g": 1.0, "b": 1.0})
	var obj_scale = object_data.get("scale", 1.0)
	
	# Convert position to Godot coordinates
	var godot_pos = Vector2(position_data.x * object_scale, position_data.y * object_scale)
	
	# Create visual object
	var visual_object = create_visual_object(obj_type, obj_name, color_data, obj_scale)
	visual_object.position = godot_pos
	
	# Store object data
	sandbox_objects[obj_id] = object_data
	object_scenes[obj_id] = visual_object
	
	add_child(visual_object)
	
	print(f"🎨 Created {obj_type} '{obj_name}' at {godot_pos}")
	object_created.emit(object_data)

func create_visual_object(obj_type: String, obj_name: String, color_data: Dictionary, obj_scale: float) -> Node2D:
	"""Create the actual visual representation"""
	var container = Node2D.new()
	container.name = obj_name
	
	# Create the shape
	var shape_node: Node2D
	
	match obj_type:
		"cube":
			shape_node = create_cube_visual(color_data, obj_scale)
		"sphere":
			shape_node = create_sphere_visual(color_data, obj_scale)
		"pyramid":
			shape_node = create_pyramid_visual(color_data, obj_scale)
		"torus":
			shape_node = create_torus_visual(color_data, obj_scale)
		"cylinder":
			shape_node = create_cylinder_visual(color_data, obj_scale)
		_:
			shape_node = create_cube_visual(color_data, obj_scale)  # Default
	
	container.add_child(shape_node)
	
	# Add a label with the object name
	var label = Label.new()
	label.text = obj_name
	label.position = Vector2(-20, 25)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	container.add_child(label)
	
	# Add floating animation
	add_floating_animation(container)
	
	return container

func create_cube_visual(color_data: Dictionary, obj_scale: float) -> ColorRect:
	"""Create a cube visual representation"""
	var cube = ColorRect.new()
	var size = 20 * obj_scale
	cube.size = Vector2(size, size)
	cube.position = Vector2(-size/2, -size/2)
	cube.color = Color(color_data.r, color_data.g, color_data.b, 0.8)
	return cube

func create_sphere_visual(color_data: Dictionary, obj_scale: float) -> Control:
	"""Create a sphere visual representation"""
	var sphere_container = Control.new()
	var size = 20 * obj_scale
	sphere_container.custom_minimum_size = Vector2(size, size)
	sphere_container.position = Vector2(-size/2, -size/2)
	
	# We'll draw a circle using _draw
	var sphere_drawer = SphereDrawer.new()
	sphere_drawer.color = Color(color_data.r, color_data.g, color_data.b, 0.8)
	sphere_drawer.radius = size / 2
	sphere_container.add_child(sphere_drawer)
	
	return sphere_container

func create_pyramid_visual(color_data: Dictionary, obj_scale: float) -> Polygon2D:
	"""Create a pyramid visual representation"""
	var pyramid = Polygon2D.new()
	var size = 20 * obj_scale
	
	# Triangle points
	var points = PackedVector2Array([
		Vector2(0, -size/2),      # Top
		Vector2(-size/2, size/2), # Bottom left
		Vector2(size/2, size/2)   # Bottom right
	])
	
	pyramid.polygon = points
	pyramid.color = Color(color_data.r, color_data.g, color_data.b, 0.8)
	return pyramid

func create_torus_visual(color_data: Dictionary, obj_scale: float) -> Control:
	"""Create a torus visual representation"""
	var torus_container = Control.new()
	var size = 20 * obj_scale
	torus_container.custom_minimum_size = Vector2(size, size)
	torus_container.position = Vector2(-size/2, -size/2)
	
	var torus_drawer = TorusDrawer.new()
	torus_drawer.color = Color(color_data.r, color_data.g, color_data.b, 0.8)
	torus_drawer.outer_radius = size / 2
	torus_drawer.inner_radius = size / 4
	torus_container.add_child(torus_drawer)
	
	return torus_container

func create_cylinder_visual(color_data: Dictionary, obj_scale: float) -> ColorRect:
	"""Create a cylinder visual representation (as a rounded rectangle)"""
	var cylinder = ColorRect.new()
	var size = 20 * obj_scale
	cylinder.size = Vector2(size * 0.8, size)
	cylinder.position = Vector2(-size * 0.4, -size/2)
	cylinder.color = Color(color_data.r, color_data.g, color_data.b, 0.8)
	return cylinder

func add_floating_animation(object_node: Node2D):
	"""Add a subtle floating animation to make objects feel alive"""
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	var original_y = object_node.position.y
	tween.tween_method(func(y): object_node.position.y = y, 
					   original_y, original_y - 5, randf_range(2.0, 4.0))
	tween.tween_method(func(y): object_node.position.y = y, 
					   original_y - 5, original_y + 5, randf_range(2.0, 4.0))
	tween.tween_method(func(y): object_node.position.y = y, 
					   original_y + 5, original_y, randf_range(2.0, 4.0))

func move_sandbox_object(obj_id: int, new_position: Dictionary):
	"""Move an existing sandbox object"""
	if obj_id in object_scenes:
		var visual_object = object_scenes[obj_id]
		var godot_pos = Vector2(new_position.x * object_scale, new_position.y * object_scale)
		
		# Animate the movement
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(visual_object, "position", godot_pos, 1.0)
		
		# Update stored data
		if obj_id in sandbox_objects:
			sandbox_objects[obj_id]["position"] = new_position
		
		print(f"🎨 Moved object {obj_id} to {godot_pos}")
		object_moved.emit(obj_id, godot_pos)

func destroy_sandbox_object(obj_id: int):
	"""Remove a sandbox object"""
	if obj_id in object_scenes:
		var visual_object = object_scenes[obj_id]
		
		# Animate destruction
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(visual_object, "scale", Vector2.ZERO, 0.5)
		tween.tween_property(visual_object, "modulate", Color.TRANSPARENT, 0.5)
		tween.tween_callback(visual_object.queue_free).set_delay(0.5)
		
		object_scenes.erase(obj_id)
		sandbox_objects.erase(obj_id)
		
		print(f"🎨 Destroyed object {obj_id}")
		object_destroyed.emit(obj_id)

func update_from_sandbox_data(sandbox_data: Dictionary):
	"""Update the entire sandbox from Wight's data"""
	var actions = sandbox_data.get("actions", [])
	
	for action in actions:
		var action_type = action.get("type", "")
		
		match action_type:
			"create_object":
				create_sandbox_object(action.get("object_data", {}))
			"move_object":
				move_sandbox_object(action.get("object_id", 0), action.get("new_position", {}))
			"destroy_object":
				destroy_sandbox_object(action.get("object_id", 0))

func get_sandbox_stats() -> Dictionary:
	"""Get current sandbox statistics"""
	return {
		"object_count": len(sandbox_objects),
		"types": _count_object_types(),
		"bounds": sandbox_bounds
	}

func _count_object_types() -> Dictionary:
	"""Count objects by type"""
	var type_counts = {}
	for obj_data in sandbox_objects.values():
		var obj_type = obj_data.get("type", "unknown")
		type_counts[obj_type] = type_counts.get(obj_type, 0) + 1
	return type_counts

# Helper classes for drawing complex shapes

class SphereDrawer extends Control:
	var color: Color = Color.WHITE
	var radius: float = 10.0
	
	func _draw():
		draw_circle(Vector2(radius, radius), radius, color)

class TorusDrawer extends Control:
	var color: Color = Color.WHITE
	var outer_radius: float = 15.0
	var inner_radius: float = 7.0
	
	func _draw():
		var center = Vector2(outer_radius, outer_radius)
		draw_circle(center, outer_radius, color)
		draw_circle(center, inner_radius, Color.BLACK)  # Create the hole