extends Node2D
class_name IntroScene

var _save : SaveGame
@onready var maid = $Main/Maid

func _ready() -> void:
	_save = SaveGame.load_savegame() as SaveGame
	_save.saw_intro = true
	maid.global_position = Vector2(-27, 253)
	maid.set_physics_process(false)
