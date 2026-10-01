extends CharacterBody3D
@export var player_speed: float = 17.0 # m/s (~60 km/h)
@export var player_turn_speed: float = 15.0 # m/s
@export var fall_acceleration: float = ProjectSettings.get_setting(
									"physics/3d/default_gravity") # 9.81 m/s
@onready var pivot := $Pivot
var target_velocity: Vector3 = Vector3.ZERO

# Input handler
## Scans direction input through Vect2 and remaps it for Vect3 usage.
func _get_movement_input() -> Vector3:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", 
									"move_forward", "move_back")
	var direction: Vector3 = Vector3(input_dir.x, 0, input_dir.y)
	return direction
	
# Rotation handler
func _apply_rotation(look_target: Vector3, delta: float) -> void:
	if look_target != Vector3.ZERO:
		pivot.basis = pivot.basis.slerp(Basis.looking_at(look_target), 
											player_turn_speed * delta)

# Movement application
func _apply_movement(direction: Vector3, delta: float) -> void:
	# Ground Velocity
	target_velocity.x = direction.x * player_speed
	target_velocity.z = direction.z * player_speed

	# Vertical Velocity
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	else:
		target_velocity.y = -0.1
		
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	
# movement orchestration
func _physics_process(delta: float) -> void:	
	var direction: Vector3 = _get_movement_input()
	var look_target: Vector3 = direction
	_apply_rotation(look_target, delta)
	_apply_movement(direction, delta)
