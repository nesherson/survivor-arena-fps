extends Node3D

@export var game_time_limit: int

@onready var score_label: Label = %ScoreLabel
@onready var game_timeout_label: Label = %GameTimeoutLabel
@onready var game_timeout_timer: Timer = %GameTimeoutTimer
@onready var game_over_overlay: ColorRect = %GameOverOverlay
@onready var game_over_label: Label = %GameOverLabel
@onready var player: CharacterBody3D = %Player

signal game_over

var score := 0
var is_game_over := false

enum GAME_OVER_STATE { WIN, LOSE }

func increase_score():
	score += 1
	score_label.text = "Score: " + str(score)
	
func show_smoke_puff(mob_global_position: Vector3):
	const SMOKE_PUFF := preload("res://mob/smoke_puff/smoke_puff.tscn")
	var smoke_puff := SMOKE_PUFF.instantiate()
	
	add_child(smoke_puff)
	
	smoke_puff.global_position = mob_global_position
	
func show_game_over_screen(text: String):
	game_over_overlay.visible = true
	game_over_label.visible = true
	game_over_label.text = text
	
func reset_game():
	get_tree().reload_current_scene.call_deferred()
	get_tree().paused = false
		
func _ready() -> void:
	game_timeout_label.text = "Time left: " + str(game_time_limit)
	
func finish_game(game_over_state: GAME_OVER_STATE, game_over_text: String):
	get_tree().paused = true
	get_viewport().set_input_as_handled()
	game_over.emit()
	game_timeout_timer.stop()
	is_game_over = true
	
	if game_over_state == GAME_OVER_STATE.WIN:
		show_game_over_screen(game_over_text)
	else: 
		show_game_over_screen(game_over_text)
		
	
func _on_mob_spawner_mob_spawned(mob: RigidBody3D) -> void:
	mob.died.connect(func on_mob_death():
		increase_score()
		show_smoke_puff(mob.global_position)
		)
	
func _on_kill_plane_body_entered(body: Node3D) -> void:
	finish_game(GAME_OVER_STATE.LOSE, "You lost! \n Your score was " + str(score))

func _on_game_timeout_timer_timeout() -> void:
	if game_time_limit == 0:
		finish_game(GAME_OVER_STATE.WIN, "Congratulations, you won! \n Your score was " + str(score))
		
		return
		
	game_time_limit -= 1
	game_timeout_label.text = "Time left: " + str(game_time_limit)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_game") && is_game_over:
		reset_game()
		
func _on_player_died() -> void:
	finish_game(GAME_OVER_STATE.LOSE, "You lost! \n Your score was " + str(score))
