extends Node2D
class_name Introduction

var _save : SaveGame
@onready var maid = $ScenePlayer/Main/Maid
@onready var animation = $ScenePlayer
@onready var main = "res://scenes/main.tscn"
var intro_script = preload("res://dialogue/intro.dialogue")

func _ready() -> void:
	_save = SaveGame.load_savegame() as SaveGame
	_save.saw_intro = true
	_save.write_savegame()
	maid.global_position = Vector2(-27, 253)
	maid.set_physics_process(false)
	animation.play("fillie_walks_in_the_door")
	await animation.animation_finished
	DialogueManager.show_dialogue_balloon(intro_script, "start")
	await DialogueManager.dialogue_ended
	animation.play("fillie walks down the stairs")
	await animation.animation_finished
	get_tree().change_scene_to_file(main)
