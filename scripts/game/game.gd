extends Node3D

@export var game_time_limit: int

@onready var score_label = %ScoreLabel
@onready var game_timeout_label = %GameTimeoutLabel
@onready var game_timeout_timer = %GameTimeoutTimer
@onready var game_over_overlay = %GameOverOverlay
@onready var game_won_label = %GameWonLabel

var score := 0

func increase_score():
	score += 1
	score_label.text = "Score: " + str(score)
	
func show_smoke_puff(mob_global_position: Vector3):
	const SMOKE_PUFF := preload("res://mob/smoke_puff/smoke_puff.tscn")
	var smoke_puff := SMOKE_PUFF.instantiate()
	
	add_child(smoke_puff)
	
	smoke_puff.global_position = mob_global_position
	
func show_win_overlay():
	game_over_overlay.visible = true
	game_won_label.visible = true
	
func _ready() -> void:
	game_timeout_label.text = "Time left: " + str(game_time_limit)
	
func _on_mob_spawner_mob_spawned(mob: RigidBody3D) -> void:
	mob.died.connect(func on_mob_death():
		increase_score()
		show_smoke_puff(mob.global_position)
		)
	
func _on_kill_plane_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()

func _on_game_timeout_timer_timeout() -> void:
	if game_time_limit == 0:
		get_tree().paused = true
		game_timeout_timer.stop()
		show_win_overlay()
		return
		
	game_time_limit -= 1
	game_timeout_label.text = "Time left: " + str(game_time_limit)
