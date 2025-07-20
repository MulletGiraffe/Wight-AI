class_name SandboxSystem
extends RefCounted

## Manages Wight's interaction with his virtual sandbox environment
## Converted from Python wight_core.py SandboxSystem

signal object_created(object_data: Dictionary)
signal object_moved(object_id: int, new_position: Vector3)
signal object_destroyed(object_id: int)
signal object_modified(object_id: int, changes: Dictionary)

var objects: Dictionary = {}
var object_id_counter: int = 0
var pending_actions: Array = []

# Object type definitions
var object_types = {
	"cube": {"mesh_type": "box", "default_scale": Vector3(1, 1, 1)},
	"sphere": {"mesh_type": "sphere", "default_scale": Vector3(1, 1, 1)},
	"pyramid": {"mesh_type": "pyramid", "default_scale": Vector3(1, 1.5, 1)},
	"cylinder": {"mesh_type": "cylinder", "default_scale": Vector3(1, 2, 1)},
	"torus": {"mesh_type": "torus", "default_scale": Vector3(1, 1, 1)},
	"cone": {"mesh_type": "cone", "default_scale": Vector3(1, 2, 1)}
}

func create_object(object_type: String, name: String = "", properties: Dictionary = {}, size: float = 1.0, position: Vector3 = Vector3.ZERO) -> int:
	"""Create a new object in the sandbox"""
	object_id_counter += 1
	var obj_id = object_id_counter
	
	if name == "":
		name = "%s_%d" % [object_type, obj_id]
	
	if position == Vector3.ZERO:
		position = Vector3(
			randf_range(-5, 5),
			randf_range(-3, 3),
			randf_range(-5, 5)
		)
	
	# Validate object type
	if not object_type in object_types:
		object_type = "cube"
	
	var object_data = {
		"id": obj_id,
		"type": object_type,
		"name": name,
		"position": {"x": position.x, "y": position.y, "z": position.z},
		"rotation": {"x": 0.0, "y": 0.0, "z": 0.0},
		"scale": size,
		"color": {
			"r": randf(),
			"g": randf(),
			"b": randf(),
			"a": 1.0
		},
		"created_at": Time.get_unix_time_from_system(),
		"properties": properties,
		"tags": [],
		"connections": [],
		"behaviors": [],
		"visible": true,
		"emotional_significance": 0.5
	}
	
	objects[obj_id] = object_data
	
	var action = {
		"type": "create_object",
		"object_id": obj_id,
		"object_data": object_data.duplicate(),
		"timestamp": Time.get_unix_time_from_system()
	}
	pending_actions.append(action)
	
	object_created.emit(object_data)
	return obj_id

func create_complex_structure(structure_type: String, name: String = "", base_position: Vector3 = Vector3.ZERO) -> Array:
	"""Create complex multi-object structures"""
	var created_objects = []
	
	match structure_type:
		"house":
			created_objects = _create_house(name, base_position)
		"tower":
			created_objects = _create_tower(name, base_position)
		"garden":
			created_objects = _create_garden(name, base_position)
		"constellation":
			created_objects = _create_constellation(name, base_position)
		"spiral":
			created_objects = _create_spiral(name, base_position)
		"mandala":
			created_objects = _create_mandala(name, base_position)
		_:
			# Create a simple cube if unknown structure
			var obj_id = create_object("cube", name, {}, 1.0, base_position)
			created_objects.append(obj_id)
	
	return created_objects

func _create_house(name: String, pos: Vector3) -> Array:
	"""Create a house structure with foundation, walls, and roof"""
	var house_name = name if name != "" else "CozyHouse"
	var parts = []
	
	# Foundation
	var foundation = create_object("cube", house_name + "_Foundation", 
		{"part_of": "house", "function": "foundation"}, 
		1.5, pos + Vector3(0, -0.5, 0))
	parts.append(foundation)
	
	# Walls
	for i in range(4):
		var angle = i * PI / 2
		var wall_pos = pos + Vector3(cos(angle) * 1.2, 0.5, sin(angle) * 1.2)
		var wall = create_object("cube", house_name + "_Wall" + str(i), 
			{"part_of": "house", "function": "wall"}, 
			0.8, wall_pos)
		parts.append(wall)
	
	# Roof
	var roof = create_object("pyramid", house_name + "_Roof", 
		{"part_of": "house", "function": "roof"}, 
		1.8, pos + Vector3(0, 1.5, 0))
	parts.append(roof)
	
	# Connect all parts
	for part_id in parts:
		if part_id in objects:
			objects[part_id]["connections"] = parts.duplicate()
			objects[part_id]["tags"].append("house_part")
	
	return parts

func _create_tower(name: String, pos: Vector3) -> Array:
	"""Create a tall tower structure"""
	var tower_name = name if name != "" else "MajesticTower"
	var parts = []
	var height = 5
	
	for i in range(height):
		var level_pos = pos + Vector3(0, i * 1.2, 0)
		var scale = 1.2 - (i * 0.1)  # Taper towards top
		var level = create_object("cube", tower_name + "_Level" + str(i), 
			{"part_of": "tower", "level": i}, 
			scale, level_pos)
		parts.append(level)
	
	# Add spire
	var spire = create_object("cone", tower_name + "_Spire", 
		{"part_of": "tower", "function": "spire"}, 
		0.8, pos + Vector3(0, height * 1.2, 0))
	parts.append(spire)
	
	# Connect all parts
	for part_id in parts:
		if part_id in objects:
			objects[part_id]["connections"] = parts.duplicate()
			objects[part_id]["tags"].append("tower_part")
	
	return parts

func _create_garden(name: String, pos: Vector3) -> Array:
	"""Create a garden with multiple objects"""
	var garden_name = name if name != "" else "PeacefulGarden"
	var parts = []
	
	# Create plants/trees (spheres representing foliage)
	for i in range(randi_range(3, 6)):
		var tree_pos = pos + Vector3(
			randf_range(-3, 3),
			0,
			randf_range(-3, 3)
		)
		var tree = create_object("sphere", garden_name + "_Tree" + str(i), 
			{"part_of": "garden", "type": "tree"}, 
			randf_range(0.8, 1.5), tree_pos)
		objects[tree]["color"]["g"] = 0.8  # Make it green
		parts.append(tree)
	
	# Add some decorative elements
	for i in range(randi_range(2, 4)):
		var deco_pos = pos + Vector3(
			randf_range(-2, 2),
			0,
			randf_range(-2, 2)
		)
		var decoration = create_object("pyramid", garden_name + "_Deco" + str(i), 
			{"part_of": "garden", "type": "decoration"}, 
			randf_range(0.5, 1.0), deco_pos)
		parts.append(decoration)
	
	return parts

func _create_constellation(name: String, pos: Vector3) -> Array:
	"""Create a constellation pattern of spheres"""
	var constellation_name = name if name != "" else "StarConstellation"
	var parts = []
	var star_count = randi_range(5, 8)
	
	for i in range(star_count):
		var angle = (i * 2 * PI) / star_count
		var radius = randf_range(2, 4)
		var star_pos = pos + Vector3(
			cos(angle) * radius,
			randf_range(-1, 1),
			sin(angle) * radius
		)
		var star = create_object("sphere", constellation_name + "_Star" + str(i), 
			{"part_of": "constellation", "star_index": i}, 
			randf_range(0.3, 0.7), star_pos)
		
		# Make stars bright
		objects[star]["color"] = {"r": 1.0, "g": 1.0, "b": 0.8, "a": 1.0}
		parts.append(star)
	
	return parts

func _create_spiral(name: String, pos: Vector3) -> Array:
	"""Create a spiral pattern"""
	var spiral_name = name if name != "" else "WonderSpiral"
	var parts = []
	var element_count = 12
	
	for i in range(element_count):
		var t = float(i) / element_count
		var angle = t * 4 * PI
		var radius = t * 3
		var height = t * 2
		
		var element_pos = pos + Vector3(
			cos(angle) * radius,
			height,
			sin(angle) * radius
		)
		
		var element = create_object("sphere", spiral_name + "_Element" + str(i), 
			{"part_of": "spiral", "index": i}, 
			0.3, element_pos)
		parts.append(element)
	
	return parts

func _create_mandala(name: String, pos: Vector3) -> Array:
	"""Create a mandala pattern"""
	var mandala_name = name if name != "" else "SacredMandala"
	var parts = []
	var ring_count = 3
	
	for ring in range(ring_count):
		var radius = (ring + 1) * 1.5
		var elements_in_ring = (ring + 1) * 6
		
		for i in range(elements_in_ring):
			var angle = (i * 2 * PI) / elements_in_ring
			var element_pos = pos + Vector3(
				cos(angle) * radius,
				0,
				sin(angle) * radius
			)
			
			var element_type = "sphere" if ring % 2 == 0 else "cube"
			var element = create_object(element_type, mandala_name + "_R" + str(ring) + "_E" + str(i), 
				{"part_of": "mandala", "ring": ring, "position_in_ring": i}, 
				0.4, element_pos)
			parts.append(element)
	
	return parts

func move_object(obj_id: int, new_position: Vector3) -> bool:
	"""Move an object to a new position"""
	if obj_id in objects:
		objects[obj_id]["position"] = {"x": new_position.x, "y": new_position.y, "z": new_position.z}
		
		var action = {
			"type": "move_object",
			"object_id": obj_id,
			"new_position": new_position,
			"timestamp": Time.get_unix_time_from_system()
		}
		pending_actions.append(action)
		
		object_moved.emit(obj_id, new_position)
		return true
	return false

func destroy_object(obj_id: int) -> bool:
	"""Remove an object from the sandbox"""
	if obj_id in objects:
		var action = {
			"type": "destroy_object",
			"object_id": obj_id,
			"timestamp": Time.get_unix_time_from_system()
		}
		pending_actions.append(action)
		
		objects.erase(obj_id)
		object_destroyed.emit(obj_id)
		return true
	return false

func clear_sandbox():
	"""Remove all objects from the sandbox"""
	var object_ids = objects.keys()
	for obj_id in object_ids:
		destroy_object(obj_id)

func get_object(obj_id: int) -> Dictionary:
	"""Get object data by ID"""
	return objects.get(obj_id, {})

func get_all_objects() -> Dictionary:
	"""Get all objects in the sandbox"""
	return objects.duplicate()

func get_objects_by_type(object_type: String) -> Array:
	"""Get all objects of a specific type"""
	var matching_objects = []
	for obj_id in objects:
		if objects[obj_id]["type"] == object_type:
			matching_objects.append(obj_id)
	return matching_objects

func get_objects_by_tag(tag: String) -> Array:
	"""Get all objects with a specific tag"""
	var matching_objects = []
	for obj_id in objects:
		if tag in objects[obj_id]["tags"]:
			matching_objects.append(obj_id)
	return matching_objects

func add_behavior(obj_id: int, behavior: Dictionary):
	"""Add a behavior to an object"""
	if obj_id in objects:
		objects[obj_id]["behaviors"].append(behavior)

func animate_object(obj_id: int, animation_type: String):
	"""Add animation behavior to an object"""
	var behavior = {}
	match animation_type:
		"spin":
			behavior = {"type": "rotation", "axis": "y", "speed": 1.0}
		"float":
			behavior = {"type": "float", "amplitude": 0.5, "speed": 0.5}
		"pulse":
			behavior = {"type": "scale", "min_scale": 0.8, "max_scale": 1.2, "speed": 1.0}
		"dance":
			behavior = {"type": "dance", "style": "random"}
	
	add_behavior(obj_id, behavior)

func get_pending_actions() -> Array:
	"""Get and clear pending actions for rendering"""
	var actions = pending_actions.duplicate()
	pending_actions.clear()
	return actions

func get_object_count() -> int:
	"""Get total number of objects"""
	return objects.size()

func get_save_data() -> Dictionary:
	"""Get data for saving sandbox state"""
	return {
		"objects": objects,
		"object_id_counter": object_id_counter
	}

func load_save_data(data: Dictionary):
	"""Load sandbox state from saved data"""
	if data.has("objects"):
		objects = data["objects"]
	if data.has("object_id_counter"):
		object_id_counter = data["object_id_counter"]