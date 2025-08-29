class_name card
extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func flip_card():
	animation_player.play("Flip")
