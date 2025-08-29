class_name card
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

@export_enum("Eyes", "Hand", "Mouth", "Brain", "Leg", "Ears", "Heart", "Blood", "Lungs") 
var sacrifice: String

signal hovered_on
signal hovered_off


enum STATE { IDLE, HOVERED, FLIPPED, CHOSEN, REFUSED }
var state = STATE.IDLE 

func _ready() -> void:
	# Create a unique material instance for each card
	sprite_2d.material = sprite_2d.material.duplicate()
	get_parent().connect_card_signal(self)

func _input(event: InputEvent) -> void:
	handle_input()

func flip_card():
	print("flip")
	animation_player.play("Flip")

func on_hover():
	if state == STATE.FLIPPED:
		return
	print(sacrifice)
	state = STATE.HOVERED
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "scale", Vector2(1.1, 1.1), 0.2)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)

func off_hover():
	if state != STATE.FLIPPED:
		state = STATE.IDLE
		var tween = get_tree().create_tween()
		tween.tween_property(sprite_2d, "scale", Vector2(1, 1), 0.2)\
			.set_trans(Tween.TRANS_CUBIC)\
			.set_ease(Tween.EASE_IN)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered_on", self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)

func handle_input():
	if can_flip() and Input.is_action_just_pressed("Left_Click") and not get_parent().card_selected:
		flip_card()
		state = STATE.FLIPPED
		get_parent().card_selected = true
		get_parent().current_card = self

func refused():
	state = STATE.REFUSED
	animation_player.play("Flip_Again")
	state = STATE.IDLE   # remove this line if you want the card to *stay refused* and never flip again

func burn():
	pass

func can_flip() -> bool:
	return state == STATE.HOVERED
