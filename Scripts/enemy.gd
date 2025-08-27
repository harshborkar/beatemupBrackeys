class_name Basic_Enemy
extends Character


func handle_input()->void:
	
	var direction:=Input.get_vector("Left", "Right","Up", "Down" )
	velocity = direction*SPEED
	
	if can_attack() and Input.is_action_just_pressed("Attack"):
		state= STATE.ATTACK
		#""""""""""""""animation logic""""""""""
		handle_animations()
