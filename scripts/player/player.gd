extends CharacterBody3D

@onready var camera = $Camera

const y_rotation_sensitivity = 0.5
const x_rotation_sensitivity = 0.5
const x_rotation_min_limit = -80
const x_rotation_max_limit = 80

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * y_rotation_sensitivity
		camera.rotation_degrees.x = clamp(
			camera.rotation_degrees.x - event.relative.y * x_rotation_sensitivity,
			 x_rotation_min_limit,
			 x_rotation_max_limit)
