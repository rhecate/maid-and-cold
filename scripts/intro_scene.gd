extends Node2D
class_name IntroScene

@export var scene_script : DialogueResource

var _save : SaveGame
@onready var maid = $ScenePlayer/Main/Maid
@onready var animation = $ScenePlayer

func _ready() -> void:
	_save = SaveGame.load_savegame() as SaveGame
	#_save.saw_intro = true
	maid.global_position = Vector2(-27, 253)
	maid.set_physics_process(false)
	animation.play("fillie_walks_in_the_door")

func show_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(scene_script, "start")
	return
