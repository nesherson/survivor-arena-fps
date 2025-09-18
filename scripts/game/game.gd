extends Node3D

@onready var score_label = %ScoreLabel

var score := 0

func increase_score():
	score += 1
	score_label.text = "Score: " + str(score)

func _on_mob_spawner_mob_spawned(mob: RigidBody3D) -> void:
	mob.died.connect(increase_score)
