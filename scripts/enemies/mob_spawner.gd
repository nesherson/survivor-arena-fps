extends Node3D

@onready var spawner_model: Node3D = $spawner_model

signal mob_spawned(mob: RigidBody3D)

@export var mob_to_spawn: PackedScene = null
@export var spawn_wait_time: float = 3.0

@onready var marker = %Marker3D
@onready var timer = %Timer

func _ready() -> void:
	timer.start(spawn_wait_time)

func _on_timer_timeout() -> void:
	var new_mob = mob_to_spawn.instantiate()
	
	add_child(new_mob) 
	
	new_mob.global_position = marker.global_position
		
	mob_spawned.emit(new_mob)

func _on_game_over() -> void:
	spawner_model.get_node("AnimationPlayer").stop()
