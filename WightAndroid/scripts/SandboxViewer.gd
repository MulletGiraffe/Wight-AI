extends Control

## 3D Sandbox viewer for displaying Wight's created objects

@onready var sandbox_view: SubViewport = $SandboxVBox/SandboxView
var object_nodes: Dictionary = {}

func _ready():
	print("🎨 Sandbox viewer ready")

func add_object_to_scene(object_data: Dictionary):
	"""Add a 3D object to the sandbox view"""
	if not sandbox_view:
		return
	
	var object_id = object_data["id"]
	var object_type = object_data["type"]
	
	# Create 3D node based on type
	var mesh_instance = MeshInstance3D.new()
	var mesh: Mesh
	
	match object_type:
		"cube":
			mesh = BoxMesh.new()
		"sphere":
			mesh = SphereMesh.new()
		"pyramid":
			mesh = PrismMesh.new()
			mesh.left_to_right = 0.0  # Make it pyramid-like
		"cylinder":
			mesh = CylinderMesh.new()
		"torus":
			mesh = TorusMesh.new()
		_:
			mesh = BoxMesh.new()  # Default fallback
	
	mesh_instance.mesh = mesh
	
	# Apply object properties
	var position = object_data.get("position", {"x": 0, "y": 0, "z": 0})
	mesh_instance.position = Vector3(position["x"], position["y"], position["z"])
	
	var scale_value = object_data.get("scale", 1.0)
	mesh_instance.scale = Vector3(scale_value, scale_value, scale_value)
	
	# Apply color
	var color_data = object_data.get("color", {"r": 1.0, "g": 1.0, "b": 1.0, "a": 1.0})
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(color_data["r"], color_data["g"], color_data["b"], color_data["a"])
	mesh_instance.material_override = material
	
	# Add to scene
	var environment = sandbox_view.get_node("SandboxEnvironment")
	if environment:
		environment.add_child(mesh_instance)
		object_nodes[object_id] = mesh_instance

func remove_object_from_scene(object_id: int):
	"""Remove an object from the sandbox view"""
	if object_id in object_nodes:
		object_nodes[object_id].queue_free()
		object_nodes.erase(object_id)

func clear_all_objects():
	"""Clear all objects from the sandbox view"""
	for object_id in object_nodes:
		object_nodes[object_id].queue_free()
	object_nodes.clear()