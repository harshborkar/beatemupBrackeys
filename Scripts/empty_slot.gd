class_name EnemySlot
extends Node2D


var occupant:Basic_Enemy = null

func is_free()->bool:
	return occupant==null
	
func free_up()->void:
	occupant = null

func occupy(enemy:Basic_Enemy)->void:
	occupant = enemy
