extends Control
@onready var health_bar: TextureProgressBar = $TextureProgressBar




func on_hurt(damage:int)->void:
	health_bar.value-= damage
	
