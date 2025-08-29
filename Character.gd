class_name Character #base class
extends CharacterBody2D

@export var SPEED: int = 100
@export var MAX_HEALTH:int= 20
@export var DAMAGE:int = 20
@export var knockback_intensity:float=20  # Fixed typo and increased value for better effect

@onready var damage_emitter: Area2D = $DamageEmitter
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_reciever: Damage_Reciever = $DamageReciever
@onready var character_sprite: Sprite2D = $CharacterSprite

enum STATE {IDLE, WALK, ATTACK, HURT, DEATH, TAKEOFF, JUMP, LAND}

var state:STATE = STATE.IDLE
var knockback_velocity: Vector2 = Vector2.ZERO  # Separate variable for knockback

var anim_map:Dictionary={
	STATE.IDLE:"Idle",
	STATE.WALK:"Walk",
	STATE.ATTACK:"Punch",
	STATE.JUMP:"Jump",
	STATE.HURT:"Hurt",
	STATE.DEATH:"Death"
}

var current_health = 0

func _ready() -> void:
	state = STATE.IDLE
	damage_emitter.area_entered.connect(on_emit_damage.bind())
	damage_reciever.damage_received.connect(on_recieve_damage.bind())
	current_health = MAX_HEALTH
	
func _physics_process(delta: float) -> void:  # Added delta parameter
	handle_input(delta)
	handle_flip()
	handle_movement(delta)  # Pass delta to handle_movement
	handle_animations()
	
	move_and_slide()

func handle_input(_delta)->void:
	pass
	
func handle_movement(delta: float)->void:
	if can_move():
		if velocity.length() == 0:
			state = STATE.IDLE
		else:
			state = STATE.WALK
	else:
		# Apply knockback decay when in HURT state
		if state == STATE.HURT:
			knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_intensity * delta)
			velocity = knockback_velocity
		else:
			velocity = Vector2.ZERO
		
func handle_animations()->void:
	if animation_player.has_animation(anim_map[state]):
		animation_player.play(anim_map[state])
	

func can_move()->bool:
	return state==STATE.IDLE or state == STATE.WALK
	
func can_attack()->bool:
	return state == STATE.IDLE or state==STATE.WALK
	
func handle_flip() -> void:
	if velocity.x > 0:
		character_sprite.flip_h = false
		damage_emitter.scale.x = 1
	elif velocity.x < 0:
		character_sprite.flip_h = true
		damage_emitter.scale.x = -1


func on_emit_damage(DamageReciever:Damage_Reciever):
	var direction = Vector2.LEFT if DamageReciever.global_position.x < global_position.x else Vector2.RIGHT
	DamageReciever.damage_received.emit(DAMAGE, direction)
	

func on_action_completed()->void:
	state = STATE.IDLE
	handle_animations()

func on_recieve_damage(damage:int, direction:Vector2):
	current_health = clamp(current_health - damage, 0, MAX_HEALTH) 
	if current_health <= 0:
		state=STATE.DEATH
		#queue_free()
	else:
		# Set knockback velocity and state
		knockback_velocity = knockback_intensity * direction
		state = STATE.HURT
		handle_animations()
