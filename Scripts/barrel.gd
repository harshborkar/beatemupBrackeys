extends StaticBody2D

@export var HEALTH: int = 10
@export var knockback_distance: float = 4.0   # how far to move when hit
@export var knockback_duration: float = 0.1   # how fast it snaps back

@onready var damage_receiver: Damage_Reciever = $DamageReciever
@onready var barrel: Sprite2D = $Barrel  # sprite node with shader

func _ready() -> void:
	damage_receiver.damage_received.connect(receive_damage)

func flash_hit(duration: float = 0.12) -> void:
	if barrel.material == null or not (barrel.material is ShaderMaterial):
		push_error("Barrel needs a ShaderMaterial with the flash shader.")
		return

	var mat: ShaderMaterial = barrel.material
	mat.set("shader_parameter/flash", 1.0)

	var t := get_tree().create_tween()
	t.tween_property(mat, "shader_parameter/flash", 0.0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func receive_damage(damage: int, direction: Vector2) -> void:
	flash_hit()
	HEALTH -= damage

	# --- knockback ---
	var offset := direction.normalized() * knockback_distance
	var t := get_tree().create_tween()
	t.tween_property(self, "position", position + offset, knockback_duration/2).set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "position", position, knockback_duration/2).set_trans(Tween.TRANS_SINE)

	# --- damage visuals ---
	if HEALTH <= 5 :
		barrel.frame = 1  # damaged frame

	if HEALTH <= 0:
		var TWEEN=get_tree().create_tween().parallel()
		TWEEN.tween_property(barrel, "modulate:a", 0, 1)
		await TWEEN.finished
		#queue_free()
