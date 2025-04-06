extends Node2D

@onready var toy_scene = preload("res://scenes/toy area.tscn")
@onready var screenSize = get_viewport().get_visible_rect().size
@onready var spawn_zone = $"Room/Toy Spawn Zone"
@onready var roomspace = $Room/RoomArea/CollisionShape2D
@onready var roomsize = roomspace.shape.get_rect().size.abs()
@onready var roomorigin = roomspace.position


var toy
var item_depth: int = 0

var warm : bool = false
var hot : bool = false
var boiling : bool = false

@onready var maid = $Maid
@onready var maid_timer = $Maid/Timer
@onready var animaid = $Maid/AnimatedSprite2D
var bonus_time : bool = false


@onready var ui = $CanvasLayer/Control
@onready var item_count_label = $"CanvasLayer/Control/Item Count"
@onready var timer = $"CanvasLayer/Control/Time Label/Timer"
@onready var time_label = $"CanvasLayer/Control/Time Label"
@onready var game_over = $"CanvasLayer/Control/Game Over"
@onready var warmth_status = $"CanvasLayer/Control/Warmth"
@onready var dig_time = $"CanvasLayer/Control/Dig Time"

func _ready() -> void:
	SignalBus.is_warm.connect(_on_is_warm)
	SignalBus.is_hot.connect(_on_is_hot)
	SignalBus.is_boiling.connect(_on_is_boiling)
	SignalBus.isnt_warm.connect(_on_isnt_warm)
	SignalBus.isnt_hot.connect(_on_isnt_hot)
	SignalBus.isnt_boiling.connect(_on_isnt_boiling)
	SignalBus.found_item.connect(_on_found_item)
	SignalBus.play_the_game.connect(_on_play_the_game)
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished) 

func _on_play_the_game() -> void:
		spawn_toy()
		time_label.visible = true
		item_count_label.visible = true
		timer.start()
		maid.minigame_time = true

func _on_maid_is_digging() -> void:
	if boiling == true:
		toy.queue_free()
		
		SignalBus.found_item.emit()
		
		maid.set_physics_process(false)
		animaid.play("dig")
		print("there it is")
		warmth_status.visible = true
		ui.warmth_update("there it is")
		
		await get_tree().create_timer(0.5).timeout
		
		warmth_status.visible = false
		
	elif boiling == false and hot == true:
		print("ooh almost")
		warmth_status.visible = true
		ui.warmth_update("ooh almost")
		maid.set_physics_process(false)
		animaid.play("dig")
		await get_tree().create_timer(maid.cooldown).timeout
		maid.set_physics_process(true)
		warmth_status.visible = false
	elif boiling == false and hot == false and warm == true:
		print("oh maybe..")
		warmth_status.visible = true
		ui.warmth_update("oh maybe..")
		maid.set_physics_process(false)
		animaid.play("dig")
		await get_tree().create_timer(maid.cooldown).timeout
		maid.set_physics_process(true)
		warmth_status.visible = false
	elif boiling == false and hot == false and warm == false:
		print("nope")
		warmth_status.visible = true
		ui.warmth_update("nope")
		maid.set_physics_process(false)
		animaid.play("dig")
		await get_tree().create_timer(maid.cooldown).timeout
		maid.set_physics_process(true)
		warmth_status.visible = false
	
	if ui.item_count == 8:
		game_over.visible = true
		get_tree().paused = true
		
		

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

func spawn_toy():
	toy = toy_scene.instantiate()
	add_child(toy)
	var rng = RandomNumberGenerator.new()
	var rndX = rng.randf_range(roomorigin.x, roomsize.x)
	var rndY = rng.randf_range(roomorigin.y, roomsize.y)
	toy.position = Vector2(rndX, rndY)
	await get_tree().create_timer(0.05).timeout
	if $Room.in_spawn_zone == false:
		print("redo spawn")
		toy.queue_free()
		spawn_toy()
	else:
		print("its in the right spot")
		return

func _on_timer_timeout() -> void:
	maid.set_physics_process(false)
	if get_tree().get_root().has_node("Main/toy"):
		toy.queue_free()
	game_over.visible = true
	maid.minigame_time = false
	time_label.visible = false
	item_count_label.visible = false
	dig_time.visible = false
	maid.digging_time = false
	await get_tree().create_timer(1.0).timeout
	game_over.visible = false
	maid.set_physics_process(true)


func _on_found_item():
	ui.link_to_item(ui.item_list.items.pick_random())
	item_depth = ui.linked_item.depth
	dig_time.visible = true
	maid.digging_time = true

func _on_maid_timer_timeout() -> void:
	bonus_time = false


func _on_maid_digging_item() -> void:
	
	item_depth -= maid.dig_power
	ui.dig_depth.text = str(item_depth)
	if item_depth <= 0:

		if bonus_time == true:
			timer.start(timer.time_left + 5.0)
			
		ui.item_count += 1
		
		if ui.item_count == 4:
				timer.start(timer.time_left + 10.0)
				
		maid_timer.start()
		bonus_time = true
		animaid.play("get")
		dig_time.visible = false
		maid.digging_time = false
		await get_tree().create_timer(.75).timeout
		
		maid.set_physics_process(true)
			
		spawn_toy()

func _on_dialogue_finished(_dialogue_resource):
	maid.set_physics_process(true)
