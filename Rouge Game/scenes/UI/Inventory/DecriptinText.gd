extends Control


onready var leb = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	set_text("")


func set_text(text):
	leb.text = text
	leb.update()


func _on_AttackButtons_attack(num):
	pass # Replace with function body.
