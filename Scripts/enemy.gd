class_name Basic_Enemy
extends Character

@export var duration_between_hits: int
@export var duration_prep_hits:int
@export var player:Player 
var player_slot:EnemySlot= null

var time_since_last_hit:= Time.get_ticks_msec()
var time_since_prep_hit :=Time.get_ticks_msec()

func handle_input(_delta)->void:
	if player!= null and can_move():
		if player_slot==null:
			player_slot=player.reserve_slot(self)
			
		if player_slot!=null:
			var direction:Vector2 = (player_slot.global_position-global_position).normalized()
			if is_player_within_range() :
				velocity = Vector2.ZERO
				if can_attack():
					state = STATE.PREP_ATTACK
					time_since_prep_hit = Time.get_ticks_msec()
				
			else:
				velocity = SPEED*direction
				
				
				
func is_player_within_range()->bool:
	return (player_slot.global_position-global_position).length()<1
	

func can_attack()->bool:
	if(Time.get_ticks_msec() - time_since_last_hit<duration_between_hits):
		return false
	return super.can_attack()


func handle_prep_attack()->void:
	if state == STATE.PREP_ATTACK and (Time.get_ticks_msec() - time_since_prep_hit>duration_prep_hits):
		state = STATE.ATTACK
		time_since_last_hit = Time.get_ticks_msec()
	

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
	
