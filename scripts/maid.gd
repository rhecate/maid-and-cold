extends CharacterBody2D
class_name Maid

signal is_digging
signal digging_item

var digging_time = false

var current_animation : String

var angle = 0

@export var speed = 50
@export var cooldown = 0.5
@export var dig_power = 2



func _unhandled_input(event: InputEvent) -> void:
	if digging_time == false:
		return
	
	if Input.is_action_just_pressed("ACTION"):
		emit_signal("digging_item")
		

func _physics_process(_delta):
	current_animation = "walk"
	var input_direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	velocity = input_direction * speed

	if input_direction.length() != 0:
		angle = input_direction.angle() / (PI/4)
		angle = wrapi(int(angle), 0, 8)
	move_and_slide()
	$AnimatedSprite2D.play(current_animation + str(angle))
	dig()
		
func dig():
	if Input.is_action_just_pressed("ACTION"):
		emit_signal("is_digging")
		
