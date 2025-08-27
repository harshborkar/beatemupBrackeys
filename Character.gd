class_name Character
extends CharacterBody2D

@export var SPEED: int = 100
@export var HEALTH:int= 20
@export var DAMAGE:int = 20

@onready var damage_emitter: Area2D = $DamageEmitter
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum STATE {IDLE, WALK, ATTACK}

var state:STATE = STATE.IDLE
func _ready() -> void:
	damage_emitter.area_entered.connect(on_emit_damage.bind())
	
func _physics_process(_delta: float) -> void:
	print(state)
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
		animation_player.play("Idle")
	elif state==STATE.WALK:
		animation_player.play("Walk")
	elif state==STATE.ATTACK:
		print("animations")
		animation_player.play("Punch")
		
func can_move()->bool:
	return state==STATE.IDLE or state == STATE.WALK
	
func can_attack()->bool:
	return state == STATE.IDLE or state==STATE.WALK
	
	
func handle_flip() -> void:
	if velocity.x != 0:
		$CharacterSprite.flip_h = velocity.x < 0


func on_emit_damage(DamageReciever:Damage_Reciever):
	var direction = Vector2.LEFT if DamageReciever.global_position.x <global_position.x else Vector2.RIGHT
	DamageReciever.damage_received.emit(DAMAGE, direction)
	

func on_action_completed()->void:
	print("Idled")
	state=STATE.IDLE
	
