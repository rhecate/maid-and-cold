extends Node2D

@onready var railing = $Railing

var in_spawn_zone = false

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


func _on_toy_spawn_zone_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("toy"):
		in_spawn_zone = true
	


func _on_toy_spawn_zone_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	in_spawn_zone = false
