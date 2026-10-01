extends CharacterBody3D
@export var player_speed = 17 # meters/second (60 km/h)
@export var player_turn_speed = 100 # m/s
@export var fall_acceleration = 9.81 # meters/second^2
@onready var pivot := $Pivot

var target_velocity = Vector3.ZERO


func _physics_process(delta: float) -> void:	
	# take x/y input from V2 and map to V3 movement. 
	var input_dir = Input.get_vector("move_left", "move_right", 
									"move_forward", "move_back")

	var direction = Vector3(input_dir.x, 0, input_dir.y)

	if direction != Vector3.ZERO:
		pivot.basis = pivot.basis.slerp(Basis.looking_at(direction), 
											player_turn_speed * delta)
	# Ground Velocity
	target_velocity.x = direction.x * player_speed
	target_velocity.z = direction.z * player_speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	
