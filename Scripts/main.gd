extends Node2D
@onready var player: CharacterBody2D = $Actors/Player


@onready var camera_2d: Camera2D = $Camera2D


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.position.x > camera_2d.position.x:
		camera_2d.position.x = player.position.x
