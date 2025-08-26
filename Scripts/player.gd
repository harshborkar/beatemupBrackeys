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
	
func handle_movement()->void:
	if velocity.length() == 0:
		state = STATE.IDLE
	else:
		state = STATE.WALK
		
func handle_animations()->void:
	if state==STATE.IDLE:
		pass
	if state==STATE.WALK:
		pass
	
func handle_flip():
	pass
