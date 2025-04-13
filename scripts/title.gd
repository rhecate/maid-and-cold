extends Control

@onready var main = "res://scenes/main.tscn"
@onready var intro = "res://scenes/intro_scene.tscn"

var _save : SaveGame


func _on_new_game_pressed() -> void:
	if SaveGame.save_exists():
		$SaveAlreadyExists.visible = true 
		$"Start or Load".visible = false
	else:
		_save = SaveGame.new()
	
		_save.maid_stats = MaidStats.new()
	
		_save.write_savegame()
	
		await get_tree().create_timer(1.0)
	
		get_tree().change_scene_to_file(intro)

	
func _on_load_game_pressed() -> void:
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
		print("save loaded")
		await get_tree().create_timer(1.0)
	
		get_tree().change_scene_to_file(main)
	else:
		print("save not found")

func _on_save_exists_yes_pressed() -> void:
	$SaveAlreadyExists.visible = false 
	$"Start or Load".visible = true
	
	_save = SaveGame.new()
	_save.maid_stats = MaidStats.new()
	_save.write_savegame()
	await get_tree().create_timer(1.0)
	
	get_tree().change_scene_to_file(intro)
	print(_save.maid_stats.dig_power)

func _on_save_exists_no_pressed() -> void:
	$SaveAlreadyExists.visible = false
	$"Start or Load".visible = true
