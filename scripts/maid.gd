extends CharacterBody2D
class_name Maid

signal is_digging
signal digging_item
signal call_it_off

@onready var direction = $Direction
@onready var actionable_finder = $Direction/ActionableFinder
@onready var dig_number_label = $"Dig Power"

var minigame_time = false
var digging_time = false

var current_animation : String

var angle = 0

var speed
var cooldown
var dig_power
var total_points

func _unhandled_input(_event: InputEvent) -> void:
	if minigame_time == false:
		if Input.is_action_just_pressed("ACTION"):
			var actionables = actionable_finder.get_overlapping_areas()
			if actionables.size() > 0:
				actionables[0].action()
				set_physics_process(false)
				return
	
	else:
		
		if digging_time == false:
			return
	
		if Input.is_action_just_pressed("ACTION"):
			emit_signal("digging_item")
			return

func _input(_event: InputEvent) -> void:
	if minigame_time == true:
	
		if Input.is_action_just_pressed("CANCEL"):
			emit_signal("call_it_off")
			return
	
	else:
		return

func _physics_process(_delta):
	current_animation = "walk"
	var input_direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	velocity = input_direction * speed

	if input_direction.length() != 0:
		angle = input_direction.angle() / (PI/4)
		angle = wrapi(int(angle), 0, 8)
		direction.rotation = input_direction.angle()
	move_and_slide()
	$AnimatedSprite2D.play(current_animation + str(angle))
	dig()
		
func dig():
	if minigame_time == false:
		return
	
	if Input.is_action_just_pressed("ACTION"):
		emit_signal("is_digging")
		
func dig_label_update():
	dig_number_label.text = str(dig_power)
