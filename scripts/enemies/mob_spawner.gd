extends Node3D

@export var mob_to_spawn: PackedScene = null

@onready var marker = %Marker3D
@onready var timer = %Timer


func _on_timer_timeout() -> void:
	var new_mob = mob_to_spawn.instantiate()
	
	add_child(new_mob) 
	
	new_mob.global_position = marker.global_position
