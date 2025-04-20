extends Node2D

@onready var toy_scene = preload("res://scenes/toy area.tscn")
@onready var warmth_balloon = preload("res://scenes/warmth.tscn")
@onready var screenSize = get_viewport().get_visible_rect().size
@onready var spawn_zone = $"Room/Toy Spawn Zone"
@onready var roomspace = $Room/RoomArea/CollisionShape2D
@onready var roomsize = roomspace.shape.get_rect().size
@onready var roomorigin = roomspace.global_position - roomsize
@onready var maid = $Maid
@onready var maid_timer = $Maid/Timer
@onready var maid_animation = $Maid/AnimationPlayer
@onready var animaid = $Maid/AnimatedSprite2D
@onready var ui = $CanvasLayer/Control
@onready var item_count_panel = $"CanvasLayer/Control/Item Count"
@onready var item_count_label = $"CanvasLayer/Control/Item Count"
@onready var timer = $"CanvasLayer/Control/Time Label/Timer"
@onready var time_label = $"CanvasLayer/Control/Time Label"
@onready var time_clock = $CanvasLayer/Control/Thewatch
@onready var game_over = $"CanvasLayer/Control/Game Over"
@onready var warmth_status = $"CanvasLayer/Control/Warmth2"
@onready var dig_time = $"CanvasLayer/Control/Dig Time"
@onready var found_items = $"CanvasLayer/Control/Found Items"
@onready var found_item_name = $"CanvasLayer/Control/Found Items/MarginContainer/VBoxContainer/HBox/Item Name Label"
@onready var found_item_points = $"CanvasLayer/Control/Found Items/MarginContainer/VBoxContainer/HBox/Item Points Label"
@onready var dark_screen = $CanvasLayer/ColorRect

var _save : SaveGame

var toy
var item_depth: int = 0
var warm : bool = false
var hot : bool = false
var boiling : bool = false
var bonus_time : bool = false
var gotten_items : Dictionary = {}
var gotten_items_list := []
var item_name : String
var item_points : int
var game_ending : bool = false
var round_points : int = 0


func _ready() -> void:
	_save = SaveGame.load_savegame() as SaveGame
	maid.dig_power = _save.maid_stats.dig_power
	maid.speed = _save.maid_stats.speed
	maid.cooldown = _save.maid_stats.cooldown
	maid.total_points = _save.maid_stats.total_points
	SignalBus.is_warm.connect(_on_is_warm)
	SignalBus.is_hot.connect(_on_is_hot)
	SignalBus.is_boiling.connect(_on_is_boiling)
	SignalBus.isnt_warm.connect(_on_isnt_warm)
	SignalBus.isnt_hot.connect(_on_isnt_hot)
	SignalBus.isnt_boiling.connect(_on_isnt_boiling)
	SignalBus.found_item.connect(_on_found_item)
	SignalBus.play_the_game.connect(_on_play_the_game)
	SignalBus.increase_power.connect(_on_increase_power)
	SignalBus.save_the_game.connect(save_game)
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)

func _process(delta: float) -> void:
	maid.dig_label_update()

func _physics_process(delta: float) -> void:
	
	if game_ending == false:
		return

	if game_ending == true:
		animaid.play("walk2")
		maid.set_physics_process(false)
		

func _on_maid_is_digging() -> void:
	if boiling == true:
		toy.queue_free()
		
		SignalBus.found_item.emit()
		
		maid.set_physics_process(false)
		animaid.play("dig")
		print("there it is")
		warmth_status.visible = true
		warmth_status.warmth_update("boiling")
		
		await get_tree().create_timer(0.5).timeout
		
		warmth_status.visible = false
		
	elif boiling == false and hot == true:
		print("ooh almost")
		warmth_status.visible = true
		warmth_status.warmth_update("hot")
		maid.set_physics_process(false)
		animaid.play("dig")
		await get_tree().create_timer(maid.cooldown).timeout
		maid.set_physics_process(true)
		warmth_status.visible = false
	elif boiling == false and hot == false and warm == true:
		print("oh maybe..")
		warmth_status.visible = true
		warmth_status.warmth_update("warm")
		maid.set_physics_process(false)
		animaid.play("dig")
		await get_tree().create_timer(maid.cooldown).timeout
		maid.set_physics_process(true)
		warmth_status.visible = false
	elif boiling == false and hot == false and warm == false:
		print("nope")
		warmth_status.visible = true
		warmth_status.warmth_update("cold")
		maid.set_physics_process(false)
		animaid.play("dig")
		await get_tree().create_timer(maid.cooldown).timeout
		maid.set_physics_process(true)
		warmth_status.visible = false
	
		
		


func spawn_toy():
	toy = toy_scene.instantiate()
	add_child(toy)
	var rng = RandomNumberGenerator.new()
	var rndX = rng.randf_range(roomorigin.x, roomsize.x)
	var rndY = rng.randf_range(roomorigin.y, roomsize.y)
	toy.position = Vector2(rndX, rndY)
	await get_tree().create_timer(0.05).timeout
	if $Room.in_spawn_zone == false:
		if Input.is_action_just_pressed("CANCEL"):
			return
		else: 
			print("redo spawn")
			toy.queue_free()
			spawn_toy()
	else:
		print("its in the right spot")
		return




func _on_maid_digging_item() -> void:
	
	item_depth -= maid.dig_power
	ui.dig_depth.text = str(item_depth)
	if item_depth >= 0:
		maid_animation.play("damage_number")
	else:

		ui.item_count += 1
		
		gotten_items[ui.linked_item.name] = ui.linked_item.points
		print(gotten_items)
		gotten_items_list.append(ui.linked_item.name)
		print(gotten_items_list)
		round_points += ui.linked_item.points
		
		found_item_name.text = ui.linked_item.name
		found_item_points.text = str(ui.linked_item.points)
		found_items.visible = true
		
		animaid.play("get")
		dig_time.visible = false
		maid.digging_time = false
		await get_tree().create_timer(0.75)
			
		if get_tree().get_root().has_node("Main/toy"):
			return
		else:
			
			if ui.item_count == 8:
				end_minigame()

			else:
				if bonus_time == true:
					timer.start(timer.time_left + 5.0)
				
				if ui.item_count == 4:
					timer.start(timer.time_left + 10.0)
			
			
				maid_timer.start()
				bonus_time = true
				spawn_toy()
				dig_time.visible = false
				maid.digging_time = false
				await get_tree().create_timer(0.5).timeout
				maid.set_physics_process(true)
				found_items.visible = false


				


	
func end_minigame() -> void:
	game_ending = true
	maid.set_physics_process(false)
	dark_screen.visible = true
	var tween = create_tween()
	
	tween.tween_property(dark_screen, "color:a", 0.25, 0.5)
	
	if get_tree().get_root().has_node("Main/toy"):
		toy.queue_free()
	game_over.visible = true
	maid.minigame_time = false
	maid.digging_time = false
	dig_time.visible = false
	_save.maid_stats.total_points += round_points
	print(_save.maid_stats.total_points)
	#_save.write_savegame()
	
	await get_tree().create_timer(2.0).timeout
	
	if gotten_items_list.size() >= 0:

		for item in gotten_items_list:
			found_item_name.text = item
			found_item_points.text = str(gotten_items[item])
			found_items.visible = true
			await get_tree().create_timer(1.0).timeout
			found_items.visible = false
			await get_tree().create_timer(1.0).timeout
	
	await get_tree().create_timer(1.0).timeout
	dark_screen.visible = false
	time_clock.visible = false
	time_label.visible = false
	item_count_label.visible = false
	game_over.visible = false
	gotten_items_list.clear()
	round_points = 0
	ui.item_count = 0
	maid.set_physics_process(true)
	game_ending = false
	
	
func _on_play_the_game() -> void:
		spawn_toy()
		time_clock.visible = true
		time_label.visible = true
		item_count_panel.visible = true
		timer.start()
		maid.minigame_time = true
	
func _on_is_warm():
	warm = true
	
func _on_is_hot():
	hot = true

func _on_is_boiling():
	boiling = true
	
func _on_isnt_warm():
	warm = false

func _on_isnt_hot():
	hot = false

func _on_isnt_boiling():
	boiling = false

func _on_dialogue_finished(_dialogue_resource):
	maid.set_physics_process(true)
	
	
func _on_maid_timer_timeout() -> void:
	bonus_time = false
	
	
func _on_timer_timeout() -> void:
	end_minigame()


func _on_found_item():
	ui.link_to_item(ui.item_list.items.pick_random())
	item_depth = ui.linked_item.depth
	dig_time.visible = true
	maid.digging_time = true


func _on_call_it_off() -> void:
	end_minigame()


func _on_increase_power():
	_save.maid_stats.dig_power += 1
	print(_save.maid_stats.dig_power)
	
func save_game():
	_save.write_savegame()
