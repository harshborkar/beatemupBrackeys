class_name SoundManager
extends Node
@onready var sounds:Array[AudioStreamPlayer] =[ $Punch1, $PunchFinal,$PunchMiss,$PunchMetal  ]
enum SOUND{PUNCH, PUNCH_FINAL, PUNCH_MISS, PUNCH_METAL}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func play(sfx:SOUND, tweak_pitch:bool=false)->void:
	var added_pitch:=0
	if tweak_pitch:
		added_pitch = randf_range(-0.3, 0.3)
	sounds[sfx as int].pitch_scale= 1+added_pitch
	sounds[sfx as int].play()
