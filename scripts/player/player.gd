class_name Player

extends CharacterBody3D

@onready var camera = $Camera
@onready var timer = %Timer
@onready var shoot_sound = %ShootSound
@onready var health_bar: ProgressBar = %HealthBar

signal died

const y_rotation_sensitivity = 0.5
const x_rotation_sensitivity = 0.5
const x_rotation_min_limit = -80
const x_rotation_max_limit = 80

var health: int = 100

func shoot_bullet():
	const BULLET = preload("res://scenes/player/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	
	%Marker3D.add_child(new_bullet)
	
	new_bullet.global_transform = %Marker3D.global_transform
	
	timer.start()
	shoot_sound.play()
	
func take_damage():
	if health == 0:
		died.emit()
		
		return
	
	health -= 2
	health_bar.value = health

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	health_bar.value = health

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
	const SPEED := 5.5
	
	var input_direction_2d := Input.get_vector(
		"move_left", "move_right", "move_forward", "move_back"
	)
	var input_direction_3d := Vector3(
		input_direction_2d.x, 0.0, input_direction_2d.y
	)
	var direction := transform.basis * input_direction_3d
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	velocity.y -= 20.0 * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += 10.0
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0.0
	
	move_and_slide()
	
	if Input.is_action_pressed("shoot") && timer.is_stopped():
		shoot_bullet()
		
func _on_game_over() -> void:
	set_physics_process(false)
