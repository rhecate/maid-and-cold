extends Node

#// HOT N COLD SIGNALS //
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
signal increase_power
signal save_the_game

func emit_this(what : String):
	emit_signal(what)
	
#// CUTSCENE SIGNALS //
