extends Node2D
class_name Introduction

var _save : SaveGame
@onready var maid = $ScenePlayer/Main/Maid
@onready var animation = $ScenePlayer
@export var intro_script = DialogueResource

func _ready() -> void:
	_save = SaveGame.load_savegame() as SaveGame
	_save.saw_intro = true
	_save.write_savegame()
	maid.global_position = Vector2(-27, 253)
	maid.set_physics_process(false)
	animation.play("fillie_walks_in_the_door")
	
