class_name Player
extends Character
@onready var enemy_slots: Array = $EnemySlots.get_children()
@onready var animation_player_mc: AnimationPlayer = $AnimationPlayer

@onready var health_bar: TextureProgressBar = $CanvasLayer/health_bar

func handle_input(_delta)->void:
	
	var direction:=Input.get_vector("Left", "Right","Up", "Down" )
	velocity = direction*SPEED
	
	if can_attack() and Input.is_action_just_pressed("Attack"):
		state= STATE.ATTACK
		#""""""""""""""animation logic""""""""""
		handle_animations()
		
		
func _process(delta: float) -> void:
	pass

func reserve_slot(enemy:Basic_Enemy)->EnemySlot:
	var available_slots:= enemy_slots.filter(
		func(slot): return slot.is_free()
	)
	if available_slots.size()==0:
		return null
	available_slots.sort_custom(
		func(a:EnemySlot, b:EnemySlot):
			var dist_a:=(enemy.global_position-a.global_position)
			var dist_b:=(enemy.global_position-b.global_position)
			return dist_a<dist_b
	)
	available_slots[0].occupy(enemy)
	return available_slots[0]

func free_slot(enemy:Basic_Enemy)->void:
	var target_slot := enemy_slots.filter(
		func(slot: EnemySlot):return slot.occupant ==enemy
	)
	if target_slot.size() == 1:
		target_slot[0].free_up()
	
func set_heading():
	if velocity.x>0:
		heading= Vector2.RIGHT
	elif velocity.x<0:
		heading =Vector2.LEFT

func on_recieve_damage(damage:int, direction:Vector2):
	health_bar.value-=damage
	current_health = clamp(current_health - damage, 0, MAX_HEALTH) 
	if current_health <= 0:
		state=STATE.DEATH
		#queue_free()
	else:
		# Set knockback velocity and state
		SoundPlayer.play(SoundManager.SOUND.PUNCH, true)
		knockback_velocity = knockback_intensity * direction
		state = STATE.HURT
		handle_animations()

func set_health():
	health_bar.value = MAX_HEALTH

func set_max_health():
	health_bar.max_value = MAX_HEALTH
func death():
	
	queue_free()
