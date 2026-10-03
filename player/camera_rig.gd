extends SpringArm3D

@export var mouse_sensitivity: float = 0.01
@export var cam_pitch_min: float = deg_to_rad(10.0)
@export var cam_pitch_max: float = deg_to_rad(20.0)


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clamp(rotation.x, cam_pitch_min, cam_pitch_max)
		
	if OS.is_debug_build() and event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func get_look_direction() -> Vector3:
	return -global_basis.z
	
