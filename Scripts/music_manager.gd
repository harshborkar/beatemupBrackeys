class_name MusicManager
extends Node


enum Music {INTRO, MENU, STAGE1, STAGE2}

#const  MUSIC_MAP:Dictionary = {
	#Music.INTRO: preload("music"),
	#Music.MENU: preload("fe"),
	#Music.STAGE1: preload("efe"),
	#Music.STAGE2: preload("fdf"),
	#
