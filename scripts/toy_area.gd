extends Node2D


func _ready() -> void:
	pass

func _on_warm_body_entered(_body: Node2D) -> void:
	SignalBus.is_warm.emit()

func _on_hot_body_entered(_body: Node2D) -> void:
	SignalBus.is_hot.emit()

func _on_boiling_body_entered(_body: Node2D) -> void:
	SignalBus.is_boiling.emit()

func _on_warm_body_exited(_body: Node2D) -> void:
	SignalBus.isnt_warm.emit()

func _on_hot_body_exited(_body: Node2D) -> void:
	SignalBus.isnt_hot.emit()

func _on_boiling_body_exited(_body: Node2D) -> void:
	SignalBus.isnt_boiling.emit()
	SignalBus.isnt_boiling.emit()
