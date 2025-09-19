extends Node3D

@onready var score_label = %ScoreLabel

var score := 0

func increase_score():
	score += 1
	score_label.text = "Score: " + str(score)
	
func show_smoke_puff(mob_global_position: Vector3):
	const SMOKE_PUFF := preload("res://mob/smoke_puff/smoke_puff.tscn")
	var smoke_puff := SMOKE_PUFF.instantiate()
	
	add_child(smoke_puff)
	
	smoke_puff.global_position = mob_global_position
	
func _on_mob_spawner_mob_spawned(mob: RigidBody3D) -> void:
	mob.died.connect(func on_mob_death():
		increase_score()
		show_smoke_puff(mob.global_position)
		)
	
func _on_kill_plane_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()
