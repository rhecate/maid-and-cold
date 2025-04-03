extends Node2D
class_name Toy

func _ready() -> void:
	pass

func _on_warm_body_entered(body: Node2D) -> void:
	if body is Maid:
		SignalBus.is_warm.emit()

func _on_hot_body_entered(body: Node2D) -> void:
	if body is Maid:
		SignalBus.is_hot.emit()

func _on_boiling_body_entered(body: Node2D) -> void:
	if body is Maid:
		SignalBus.is_boiling.emit()

func _on_warm_body_exited(body: Node2D) -> void:
	if body is Maid:
		SignalBus.isnt_warm.emit()

func _on_hot_body_exited(body: Node2D) -> void:
	if body is Maid:
		SignalBus.isnt_hot.emit()

func _on_boiling_body_exited(_body: Node2D) -> void:
	SignalBus.isnt_boiling.emit()
	SignalBus.isnt_boiling.emit()
