extends Node2D

var talkable : bool = false



func _on_master_body_entered(body: Node2D) -> void:
	talkable = true



func _on_master_body_exited(body: Node2D) -> void:
	talkable = false
