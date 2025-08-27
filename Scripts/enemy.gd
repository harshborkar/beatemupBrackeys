class_name Basic_Enemy
extends Character

@export var player:Player 




func handle_input(_delta)->void:
	if player!= null:
		var direction:Vector2 = (player.position-position).normalized()
		velocity = SPEED*direction
	
	
