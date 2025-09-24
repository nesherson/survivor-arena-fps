extends Node3D

@export var game_time_limit: int

@onready var score_label = %ScoreLabel
@onready var game_timeout_label = %GameTimeoutLabel
@onready var game_timeout_timer = %GameTimeoutTimer
@onready var game_over_overlay = %GameOverOverlay
@onready var game_won_label = %GameWonLabel

var score := 0
var is_game_won := false

func increase_score():
	score += 1
	score_label.text = "Score: " + str(score)
	
func show_smoke_puff(mob_global_position: Vector3):
	const SMOKE_PUFF := preload("res://mob/smoke_puff/smoke_puff.tscn")
	var smoke_puff := SMOKE_PUFF.instantiate()
	
	add_child(smoke_puff)
	
	smoke_puff.global_position = mob_global_position
	
func show_win_overlay(show: bool):
	game_over_overlay.visible = show
	game_won_label.visible = show
	
func reset_game():
	get_tree().paused = false
	is_game_won = false
	score = 0
		
	show_win_overlay(false)
	game_timeout_timer.start(game_timeout_timer.wait_time)
	
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
		get_viewport().set_input_as_handled()
		is_game_won = true
		
		game_timeout_timer.stop()
		show_win_overlay(true)
		return
		
	game_time_limit -= 1
	game_timeout_label.text = "Time left: " + str(game_time_limit)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && is_game_won == true:
		reset_game()
		
