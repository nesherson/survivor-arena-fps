extends CharacterBody3D

@onready var camera = $Camera

const y_rotation_sensitivity = 0.5
const x_rotation_sensitivity = 0.5
const x_rotation_min_limit = -80
const x_rotation_max_limit = 80

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * y_rotation_sensitivity
		camera.rotation_degrees.x = clamp(
			camera.rotation_degrees.x - event.relative.y * x_rotation_sensitivity,
			 x_rotation_min_limit,
			 x_rotation_max_limit)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _physics_process(delta: float) -> void:
	const SPEED = 5.5
	
	var input_direction_2d = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_back"
	)
	var input_direction_3d = Vector3(
		input_direction_2d.x, 0.0, input_direction_2d.y
	)
	var direction = transform.basis * input_direction_3d
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	move_and_slide()
		
	
