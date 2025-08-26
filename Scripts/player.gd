extends CharacterBody2D

@export var SPEED: int = 100
@export var HEALTH:int= 20

enum STATE {IDLE, WALK, ATTACK}

var state:STATE = STATE.IDLE
func _physics_process(_delta: float) -> void:
	handle_input()
	handle_flip()
	handle_movement()
	handle_animations()
	
	move_and_slide()

func handle_input()->void:
	
	var direction:=Input.get_vector("Left", "Right","Up", "Down" )
	velocity = direction*SPEED
	
	if can_attack() and Input.is_action_just_pressed("Attack"):
		state= STATE.ATTACK
		#""""""""""""""animation logic""""""""""
		handle_animations()
	
func handle_movement()->void:
	if can_move():
		if velocity.length() == 0:
			state = STATE.IDLE
		else:
			state = STATE.WALK
	else:
		velocity = Vector2.ZERO
		
func handle_animations()->void:
	if state==STATE.IDLE:
		pass
	elif state==STATE.WALK:
		pass
	elif state==STATE.ATTACK:
		pass
		
func can_move()->bool:
	return state==STATE.IDLE or state == STATE.WALK
	
func can_attack()->bool:
	return state == STATE.IDLE or state==STATE.WALK
	
	
	
func handle_flip():
	pass

func on_action_completed()->void:
	state=STATE.IDLE
	
