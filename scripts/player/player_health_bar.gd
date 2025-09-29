extends Control

@onready var health_bar: ProgressBar = %HealthBar

var player_health: int

func update_health_bar(value: int):
	health_bar.value = value
	
func _ready() -> void:
	update_health_bar(player_health)
	
func _on_player_damage_taken(health_remaining: int) -> void:
	update_health_bar(health_remaining)

func _on_player_ready(health: int) -> void:
	player_health = health
