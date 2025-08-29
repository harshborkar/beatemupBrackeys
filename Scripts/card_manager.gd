class_name card_manager
extends Node2D
var card_selected:bool = false

var current_card:card 

func connect_card_signal(Card:card):
	Card.hovered_on.connect(on_hover.bind())
	Card.hovered_off.connect(off_hover.bind())
	
	


func on_hover(Card:card):
	if not card_selected:
		Card.on_hover()
	

func off_hover(Card:card):
	if not card_selected:
		Card.off_hover()

func refused(Card:card):
	card_selected= false
	Card.refused()


func _on_button_pressed() -> void:
	refused(current_card)
