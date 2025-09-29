class_name Mob

extends RigidBody3D

signal died

@onready var bat_model = %bat_model
@onready var player = get_node("/root/Game/Player")
@onready var timer = $Timer
@onready var hurt_sound: AudioStreamPlayer3D = $HurtSound
@onready var death_sound: AudioStreamPlayer3D = $DeathSound

const SPEED := 2.5

var health := 3

func take_damage() -> void:
	if health == 0:
		return
		
	bat_model.hurt()
	hurt_sound.play()
	health -= 1
	
	if health == 0:
		set_physics_process(false)
		gravity_scale = 1.0
		
		var direction := -1.0 * global_position.direction_to(player.global_position)
		var random_upward_force = Vector3.UP * randf_range(1.0, 5.0)
		
		apply_central_impulse(direction * 5.0 + random_upward_force)
		bat_model.death()
		timer.start()
		died.emit()
		death_sound.play()

func _physics_process(_delta: float) -> void:
	var direction_to_player := global_position.direction_to(player.global_position)
	
	direction_to_player.y = 0.0
	linear_velocity = direction_to_player * SPEED
	bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction_to_player, Vector3.UP) + PI

func _on_timer_timeout() -> void:
	queue_free()
	died.emit()

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.take_damage()
