class_name card
extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

signal hovered_on
signal hovered_off

func _ready() -> void:
	# Create a unique material instance for each card
	sprite_2d.material = sprite_2d.material.duplicate()
	get_parent().connect_card_signal(self)

func flip_card():
	print("flip")
	animation_player.play("Flip")

func on_hover():
	var tween = get_tree().create_tween()
	tween.tween_method(set_rand_trans_power, 1.0, 3.0, 0.2)
	if Input.is_action_just_pressed("Left_Click"):
		flip_card()

func off_hover():
	var tween = get_tree().create_tween()
	tween.tween_method(set_rand_trans_power, 3.0, 1.0, 0.2)

func set_rand_trans_power(value: float):
	sprite_2d.material.set_shader_parameter("rand_trans_power", value)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered_on", self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
