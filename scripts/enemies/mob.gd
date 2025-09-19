extends RigidBody3D

signal died

@onready var bat_model = %bat_model
@onready var player = get_node("/root/Game/Player")
@onready var timer = $Timer

const SPEED := 2.5

var health := 3

func _physics_process(delta: float) -> void:
	var direction_to_player := global_position.direction_to(player.global_position)
	
	direction_to_player.y = 0.0
	linear_velocity = direction_to_player * SPEED
	bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction_to_player, Vector3.UP) + PI

func take_damage() -> void:
	if health == 0:
		return
		
	bat_model.hurt()
	
	health -= 1
	
	if health == 0:
		set_physics_process(false)
		gravity_scale = 1.0
		
		var direction := -1.0 * global_position.direction_to(player.global_position)
		var random_upward_force = Vector3.UP * randf_range(1.0, 5.0)
		
		apply_central_impulse(direction * 5.0 + random_upward_force)
		timer.start()

func _on_timer_timeout() -> void:
	queue_free()
	died.emit()
	
