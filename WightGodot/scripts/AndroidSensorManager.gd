extends Node
class_name AndroidSensorManager

# Android Sensor Integration for Wight AI
# Connects device sensors to the learning system

signal sensor_data_updated(sensor_data: Dictionary)
signal sensor_pattern_detected(pattern_type: String, data: Dictionary)

# Sensor references
var accelerometer_sensor: Dictionary = {}
var gyroscope_sensor: Dictionary = {}
var magnetometer_sensor: Dictionary = {}
var light_sensor: Dictionary = {}
var proximity_sensor: Dictionary = {}

# Audio input
var audio_input: AudioStreamPlayer
var audio_spectrum: AudioEffectSpectrumAnalyzer

# Current sensor readings
var current_sensor_data: Dictionary = {}
var sensor_history: Array[Dictionary] = []

# Sensor processing parameters
var update_interval: float = 0.1  # 10Hz updates
var sensitivity_threshold: float = 0.1
var pattern_detection_window: int = 10

# Touch and interaction
var touch_events: Array[Dictionary] = []
var interaction_history: Array[Dictionary] = []

# Android-specific
var is_android_platform: bool = false
var permissions_granted: bool = false

func _ready():
	print("📱 Android Sensor Manager initializing...")
	detect_platform()
	setup_sensors()
	setup_audio_input()
	setup_touch_detection()
	
	# Start sensor updates
	var timer = Timer.new()
	timer.wait_time = update_interval
	timer.timeout.connect(_update_sensors)
	timer.autostart = true
	add_child(timer)

func detect_platform():
	"""Detect if running on Android"""
	is_android_platform = OS.get_name() == "Android"
	print("🔍 Platform detected: ", OS.get_name())
	
	if is_android_platform:
		request_android_permissions()

func request_android_permissions():
	"""Request necessary Android permissions"""
	if not is_android_platform:
		return
	
	var permissions = [
		"android.permission.RECORD_AUDIO",
		"android.permission.CAMERA",
		"android.permission.ACCESS_FINE_LOCATION",
		"android.permission.VIBRATE"
	]
	
	# Request permissions (Godot 4 method)
	if OS.has_method("request_permissions"):
		for permission in permissions:
			OS.request_permission(permission)
		permissions_granted = true
		print("✅ Android permissions requested")
	else:
		print("⚠️ Permission system not available")

func setup_sensors():
	"""Initialize device sensors"""
	current_sensor_data = {
		"acceleration": Vector3.ZERO,
		"rotation_rate": Vector3.ZERO,
		"magnetic_field": Vector3.ZERO,
		"light_level": 0.0,
		"proximity": 1.0,
		"orientation": Vector3.ZERO,
		"touch_events": [],
		"sound_level": 0.0,
		"sound_spectrum": [],
		"timestamp": Time.get_ticks_msec()
	}
	
	if is_android_platform:
		# Try to access Android sensors
		setup_android_sensors()
	else:
		# Simulate sensors for desktop testing
		setup_simulated_sensors()

func setup_android_sensors():
	"""Set up real Android sensor access"""
	# Note: In Godot 4, direct sensor access may require plugins
	# For now, we'll use Input for available sensors
	
	print("📱 Setting up Android sensors...")
	
	# Check available input methods
	if Input.has_method("get_accelerometer"):
		print("✅ Accelerometer available")
	if Input.has_method("get_gyroscope"):
		print("✅ Gyroscope available")
	if Input.has_method("get_magnetometer"):
		print("✅ Magnetometer available")

func setup_simulated_sensors():
	"""Set up simulated sensors for desktop testing"""
	print("🖥️ Setting up simulated sensors for testing...")
	# Sensors will be simulated in _update_sensors()

func setup_audio_input():
	"""Set up microphone input for sound detection"""
	# Create audio input system
	audio_input = AudioStreamPlayer.new()
	add_child(audio_input)
	
	# Set up audio spectrum analysis
	# Note: For real microphone input, we'd need AudioStreamMicrophone
	# For now, simulate audio detection
	print("🎤 Audio input system initialized")

func setup_touch_detection():
	"""Set up touch event detection"""
	# Touch events will be captured in _input()
	print("👆 Touch detection system ready")

func _input(event):
	"""Capture input events for sensor data"""
	var current_time = Time.get_ticks_msec()
	
	if event is InputEventScreenTouch:
		var touch_event = {
			"type": "touch",
			"position": event.position,
			"pressed": event.pressed,
			"index": event.index,
			"timestamp": current_time
		}
		touch_events.append(touch_event)
		
		# Maintain touch event history
		if touch_events.size() > 20:
			touch_events.pop_front()
	
	elif event is InputEventScreenDrag:
		var drag_event = {
			"type": "drag",
			"position": event.position,
			"relative": event.relative,
			"velocity": event.velocity,
			"timestamp": current_time
		}
		touch_events.append(drag_event)
		
		if touch_events.size() > 20:
			touch_events.pop_front()

func _update_sensors():
	"""Update all sensor readings"""
	var current_time = Time.get_ticks_msec()
	
	# Get sensor data based on platform
	if is_android_platform:
		update_android_sensors()
	else:
		update_simulated_sensors()
	
	# Update timestamp
	current_sensor_data.timestamp = current_time
	
	# Add touch events
	current_sensor_data.touch_events = touch_events.duplicate()
	
	# Add to sensor history
	sensor_history.append(current_sensor_data.duplicate())
	if sensor_history.size() > 100:  # Keep last 100 readings
		sensor_history.pop_front()
	
	# Analyze for patterns
	detect_sensor_patterns()
	
	# Emit sensor data
	emit_signal("sensor_data_updated", current_sensor_data)

func update_android_sensors():
	"""Update real Android sensor readings"""
	
	# Accelerometer
	if Input.has_method("get_accelerometer"):
		current_sensor_data.acceleration = Input.get_accelerometer()
	else:
		# Simulate some movement
		current_sensor_data.acceleration = Vector3(
			sin(Time.get_ticks_msec() * 0.001) * 0.1,
			cos(Time.get_ticks_msec() * 0.0015) * 0.1,
			9.8 + sin(Time.get_ticks_msec() * 0.002) * 0.2
		)
	
	# Gyroscope
	if Input.has_method("get_gyroscope"):
		current_sensor_data.rotation_rate = Input.get_gyroscope()
	else:
		current_sensor_data.rotation_rate = Vector3(
			sin(Time.get_ticks_msec() * 0.0008) * 0.05,
			cos(Time.get_ticks_msec() * 0.0012) * 0.05,
			sin(Time.get_ticks_msec() * 0.0007) * 0.03
		)
	
	# Magnetometer
	if Input.has_method("get_magnetometer"):
		current_sensor_data.magnetic_field = Input.get_magnetometer()
	else:
		current_sensor_data.magnetic_field = Vector3(0.2, 0.1, -0.8)  # Typical Earth field
	
	# Calculate orientation from sensors
	update_device_orientation()
	
	# Light sensor (simulated for now)
	current_sensor_data.light_level = 0.5 + sin(Time.get_ticks_msec() * 0.0005) * 0.3
	
	# Proximity sensor (simulated)
	current_sensor_data.proximity = 0.8 + sin(Time.get_ticks_msec() * 0.003) * 0.2
	
	# Audio level detection
	update_audio_sensors()

func update_simulated_sensors():
	"""Update simulated sensor readings for desktop testing"""
	var time = Time.get_ticks_msec() * 0.001
	
	# Simulate realistic sensor data with some noise
	current_sensor_data.acceleration = Vector3(
		sin(time * 0.5) * 0.2 + randf_range(-0.05, 0.05),
		cos(time * 0.7) * 0.15 + randf_range(-0.05, 0.05),
		9.8 + sin(time * 0.3) * 0.1 + randf_range(-0.1, 0.1)
	)
	
	current_sensor_data.rotation_rate = Vector3(
		sin(time * 0.8) * 0.1 + randf_range(-0.02, 0.02),
		cos(time * 1.2) * 0.08 + randf_range(-0.02, 0.02),
		sin(time * 0.6) * 0.05 + randf_range(-0.01, 0.01)
	)
	
	current_sensor_data.magnetic_field = Vector3(
		0.2 + sin(time * 0.1) * 0.05,
		0.1 + cos(time * 0.15) * 0.03,
		-0.8 + sin(time * 0.08) * 0.02
	)
	
	# Simulate environmental changes
	current_sensor_data.light_level = 0.6 + sin(time * 0.2) * 0.4
	current_sensor_data.proximity = 0.9 + sin(time * 1.5) * 0.1
	
	# Simulate orientation
	current_sensor_data.orientation = Vector3(
		sin(time * 0.3) * 0.2,
		cos(time * 0.4) * 0.15,
		sin(time * 0.25) * 0.1
	)
	
	# Simulate audio
	current_sensor_data.sound_level = 0.3 + sin(time * 2.0) * 0.2 + randf_range(0, 0.1)

func update_device_orientation():
	"""Calculate device orientation from accelerometer and magnetometer"""
	var accel = current_sensor_data.acceleration
	var mag = current_sensor_data.magnetic_field
	
	# Calculate pitch and roll from accelerometer
	var pitch = atan2(accel.x, sqrt(accel.y * accel.y + accel.z * accel.z))
	var roll = atan2(accel.y, accel.z)
	
	# Calculate yaw from magnetometer (simplified)
	var yaw = atan2(mag.y, mag.x)
	
	current_sensor_data.orientation = Vector3(pitch, yaw, roll)

func update_audio_sensors():
	"""Update audio-related sensor data"""
	# For now, simulate audio levels
	# In a real implementation, this would analyze microphone input
	var time = Time.get_ticks_msec() * 0.001
	var base_level = 0.2
	var variation = sin(time * 3.0) * 0.1 + sin(time * 7.0) * 0.05
	var noise = randf_range(-0.02, 0.02)
	
	current_sensor_data.sound_level = clamp(base_level + variation + noise, 0.0, 1.0)
	
	# Simulate frequency spectrum
	current_sensor_data.sound_spectrum = []
	for i in range(32):  # 32 frequency bins
		var freq_energy = sin(time * (i + 1) * 0.5) * 0.1 + randf_range(0, 0.05)
		current_sensor_data.sound_spectrum.append(max(0.0, freq_energy))

func detect_sensor_patterns():
	"""Analyze sensor history for patterns"""
	if sensor_history.size() < pattern_detection_window:
		return
	
	# Get recent readings
	var recent_readings = sensor_history.slice(-pattern_detection_window)
	
	# Detect movement patterns
	detect_movement_patterns(recent_readings)
	
	# Detect environmental changes
	detect_environmental_patterns(recent_readings)
	
	# Detect interaction patterns
	detect_interaction_patterns(recent_readings)

func detect_movement_patterns(readings: Array[Dictionary]):
	"""Detect movement patterns in sensor data"""
	var accel_changes = []
	var rotation_changes = []
	
	for i in range(1, readings.size()):
		var curr = readings[i].acceleration
		var prev = readings[i-1].acceleration
		accel_changes.append(curr.distance_to(prev))
		
		var curr_rot = readings[i].rotation_rate
		var prev_rot = readings[i-1].rotation_rate
		rotation_changes.append(curr_rot.distance_to(prev_rot))
	
	# Calculate average change
	var avg_accel_change = accel_changes.reduce(func(sum, val): return sum + val, 0.0) / accel_changes.size()
	var avg_rotation_change = rotation_changes.reduce(func(sum, val): return sum + val, 0.0) / rotation_changes.size()
	
	# Detect significant patterns
	if avg_accel_change > 0.5:
		emit_signal("sensor_pattern_detected", "high_movement", {
			"type": "acceleration",
			"intensity": avg_accel_change,
			"duration": readings.size() * update_interval
		})
	
	if avg_rotation_change > 0.3:
		emit_signal("sensor_pattern_detected", "rotation_pattern", {
			"type": "rotation",
			"intensity": avg_rotation_change,
			"duration": readings.size() * update_interval
		})

func detect_environmental_patterns(readings: Array[Dictionary]):
	"""Detect environmental changes"""
	if readings.size() < 2:
		return
	
	var first = readings[0]
	var last = readings[-1]
	
	# Light level changes
	var light_change = abs(last.light_level - first.light_level)
	if light_change > 0.3:
		emit_signal("sensor_pattern_detected", "light_change", {
			"type": "environmental",
			"change": light_change,
			"direction": "brighter" if last.light_level > first.light_level else "darker"
		})
	
	# Proximity changes
	var proximity_change = abs(last.proximity - first.proximity)
	if proximity_change > 0.4:
		emit_signal("sensor_pattern_detected", "proximity_change", {
			"type": "proximity",
			"change": proximity_change,
			"direction": "closer" if last.proximity < first.proximity else "farther"
		})

func detect_interaction_patterns(readings: Array[Dictionary]):
	"""Detect user interaction patterns"""
	var total_touches = 0
	var touch_types = {}
	
	for reading in readings:
		total_touches += reading.touch_events.size()
		for event in reading.touch_events:
			var event_type = event.type
			if not touch_types.has(event_type):
				touch_types[event_type] = 0
			touch_types[event_type] += 1
	
	if total_touches > 5:
		emit_signal("sensor_pattern_detected", "active_interaction", {
			"type": "touch",
			"touch_count": total_touches,
			"touch_types": touch_types,
			"interaction_intensity": float(total_touches) / readings.size()
		})

# === PUBLIC API ===

func get_current_sensor_data() -> Dictionary:
	"""Get the current sensor reading"""
	return current_sensor_data.duplicate()

func get_sensor_history(count: int = 10) -> Array[Dictionary]:
	"""Get recent sensor history"""
	var start_index = max(0, sensor_history.size() - count)
	return sensor_history.slice(start_index)

func is_sensor_available(sensor_name: String) -> bool:
	"""Check if a specific sensor is available"""
	match sensor_name:
		"accelerometer":
			return Input.has_method("get_accelerometer") or not is_android_platform
		"gyroscope":
			return Input.has_method("get_gyroscope") or not is_android_platform
		"magnetometer":
			return Input.has_method("get_magnetometer") or not is_android_platform
		"audio":
			return true  # Always available (simulated if needed)
		"touch":
			return true  # Always available
		_:
			return false

func reset_sensor_history():
	"""Reset sensor history"""
	sensor_history.clear()
	touch_events.clear()
	interaction_history.clear()
	print("📱 Sensor history reset")

func set_update_rate(hz: float):
	"""Set sensor update rate"""
	update_interval = 1.0 / max(1.0, hz)
	print("📱 Sensor update rate set to ", hz, " Hz")

func get_sensor_summary() -> Dictionary:
	"""Get a summary of sensor status"""
	return {
		"platform": OS.get_name(),
		"is_android": is_android_platform,
		"permissions_granted": permissions_granted,
		"sensors_available": {
			"accelerometer": is_sensor_available("accelerometer"),
			"gyroscope": is_sensor_available("gyroscope"),
			"magnetometer": is_sensor_available("magnetometer"),
			"audio": is_sensor_available("audio"),
			"touch": is_sensor_available("touch")
		},
		"update_rate": 1.0 / update_interval,
		"history_size": sensor_history.size(),
		"current_time": Time.get_ticks_msec()
	}

# === SIMULATION METHODS ===

func simulate_accelerometer(acceleration: Vector3):
	"""Simulate accelerometer input for testing"""
	current_sensor_data.accelerometer = {
		"x": acceleration.x,
		"y": acceleration.y,
		"z": acceleration.z,
		"magnitude": acceleration.length(),
		"timestamp": Time.get_ticks_msec()
	}
	
	# Emit the sensor data update
	sensor_data_updated.emit(current_sensor_data)
	print("📱 Simulated accelerometer: %s" % acceleration)

func simulate_gyroscope(rotation: Vector3):
	"""Simulate gyroscope input for testing"""
	current_sensor_data.gyroscope = {
		"x": rotation.x,
		"y": rotation.y,
		"z": rotation.z,
		"magnitude": rotation.length(),
		"timestamp": Time.get_ticks_msec()
	}
	
	sensor_data_updated.emit(current_sensor_data)
	print("📱 Simulated gyroscope: %s" % rotation)

func simulate_light_sensor(lux_value: float):
	"""Simulate light sensor input for testing"""
	current_sensor_data.light = {
		"lux": lux_value,
		"brightness_level": "bright" if lux_value > 200 else "dim" if lux_value > 50 else "dark",
		"timestamp": Time.get_ticks_msec()
	}
	
	sensor_data_updated.emit(current_sensor_data)
	print("📱 Simulated light sensor: %.1f lux" % lux_value)