class_name Player
extends Character

func handle_input(_delta)->void:
	
	var direction:=Input.get_vector("Left", "Right","Up", "Down" )
	velocity = direction*SPEED
	
	if can_attack() and Input.is_action_just_pressed("Attack"):
		state= STATE.ATTACK
		#""""""""""""""animation logic""""""""""
		handle_animations()


func _on_damage_emitter_area_entered(area: Area2D) -> void:
	print(area)
