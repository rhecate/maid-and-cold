extends Control
class_name UI

@onready var time_label = $"Time Label"
@onready var timer = $"Time Label/Timer"
@onready var item_count_label = $"Item Count"
@onready var warmth_label = $"Warmth"
@onready var dig_time = $"Dig Time"
@onready var dig_item = $"Dig Time/Item Name"
@onready var dig_depth = $"Dig Time/Item Depth"

@export var item_list : Item_List

var item_count = 0

var linked_item : Item

func _ready() -> void:
	warmth_label.visible = false
	timer.start()
	
func _process(delta: float) -> void:
	update_timer_label()
	update_item_count()
	
func update_timer_label():
	time_label.text = str(int(ceil(timer.time_left)))

func update_item_count():
	item_count_label.text = str(item_count)

func warmth_update(warmth: String):
	warmth_label.text = warmth
	
func link_to_item(item : Item):
	linked_item = item
	_dig_time_info()
	
func _dig_time_info():
	dig_item.text = linked_item.name
	dig_depth.text = str(linked_item.depth)
