class_name card_manager
extends Node2D




func connect_card_signal(Card:card):
	Card.hovered_on.connect(on_hover.bind())
	Card.hovered_off.connect(off_hover.bind())


func on_hover(Card:card):
	Card.on_hover()
	if Input.is_action_just_pressed("Left_Click"):
		Card.flip_card()
	

func off_hover(Card:card):
	Card.off_hover()
