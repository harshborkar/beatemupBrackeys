class_name Character
extends CharacterBody2D

@export var SPEED: int = 100
@export var HEALTH:int= 20
@export var DAMAGE:int = 20


@onready var damage_emitter: Area2D = $DamageEmitter
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_reciever: Damage_Reciever = $DamageReciever

enum STATE {IDLE, WALK, ATTACK, JUMP, HURT}

var state:STATE = STATE.IDLE

var anim_map:Dictionary={
	STATE.IDLE:"Idle",
	STATE.WALK:"Walk",
	STATE.ATTACK:"Punch",
	STATE.JUMP:"Jump",
	STATE.HURT:"Hurt",
	
}
func _ready() -> void:
	damage_emitter.area_entered.connect(on_emit_damage.bind())
	damage_reciever.damage_received.connect(on_recieve_damage.bind())
	
func _physics_process(_delta: float) -> void:
	
	handle_input(_delta)
	handle_flip()
	handle_movement()
	handle_animations()
	
	move_and_slide()

func handle_input(_delta)->void:
	pass
	
func handle_movement()->void:
	if can_move():
		if velocity.length() == 0:
			state = STATE.IDLE
		else:
			state = STATE.WALK
	else:
		velocity = Vector2.ZERO
		
func handle_animations()->void:
	animation_player.play(anim_map[state])
	

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
	
	state=STATE.IDLE

func on_recieve_damage(damage:int, direction:Vector2):
	
	state = STATE.HURT
	
	
