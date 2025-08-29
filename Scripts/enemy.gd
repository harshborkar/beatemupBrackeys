class_name Basic_Enemy
extends Character

@export var player:Player 
var player_slot:EnemySlot= null



func handle_input(_delta)->void:
	if player!= null and can_move():
		if player_slot==null:
			player_slot=player.reserve_slot(self)
			
		if player_slot!=null:
			var direction:Vector2 = (player_slot.global_position-global_position).normalized()
			if (player_slot.global_position-global_position).length()<1:
				velocity = Vector2.ZERO
			else:
				velocity = SPEED*direction
func on_recieve_damage(damage:int, direction:Vector2):
	super.on_recieve_damage(damage, direction)
	if current_health==0:
		player.free_slot(self)
		
func set_heading():
	if player==null:
		return
	if position.x<player.position.x:
		heading = Vector2.RIGHT
	elif  position.x>player.position.x:
		heading = Vector2.LEFT
	
