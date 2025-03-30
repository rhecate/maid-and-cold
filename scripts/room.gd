extends Node2D

@onready var railing = $Railing

func _ready() -> void:
	railing.z_index = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Maid:
		railing.z_index = -1
		#print(railing.z_index)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Maid:
		railing.z_index = 1
		#print(railing.z_index)
