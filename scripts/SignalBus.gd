extends Node

@warning_ignore("unused_signal")
signal is_warm
signal is_hot
signal is_boiling
signal isnt_warm
signal isnt_hot
signal isnt_boiling

signal found_item
signal bonus_time

signal play_the_game

func emit_play_the_game():
	play_the_game.emit()
