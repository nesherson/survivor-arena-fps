extends Node3D

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func hurt():
	animation_tree.set("parameters/Blend2/blend_amount", 0.0)
	animation_tree.set("parameters/IdleHurt/request", true)	
	
func death():
	animation_tree.set("parameters/Blend2/blend_amount", 1.0)
	animation_tree.set("parameters/IdleShrink/request", true)
