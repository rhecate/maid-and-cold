extends Control

@onready var master = $Sprite2D
@onready var label = $Label

@export var warmth_text = {
	"cold" : "No.",
	"warm" : "Perhaps..",
	"hot" : "Ooh, maybe...",
	"boiling" : "There it is!!"
}

@export var warmth_face = {
	"cold" : "unamused",
	"warm" : "jovial",
	"hot" : "mirthful",
	"boiling" : "joyous"
}

func warmth_update(warmth : String):
	label.text = warmth_text[warmth]
	master.play(warmth_face[warmth])
