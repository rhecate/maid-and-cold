extends Control

@onready var master = $Sprite2D
@onready var label = $Label

@export var warmth_text = {
	"cold" : "",
	"warm" : "",
	"hot" : "",
	"boiling" : ""
}

@export var warmth_face = {
	"cold" : "",
	"warm" : "",
	"hot" : "",
	"boiling" : ""
}

func warmth_update(warmth : String):
	label.text = warmth_text[warmth]
	master.play(warmth_face[warmth])
