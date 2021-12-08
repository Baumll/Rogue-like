extends Control

onready var rect_list = [
	$CenterContainer/HBoxContainer/TextureRect
,$CenterContainer/HBoxContainer/TextureRect2
,$CenterContainer/HBoxContainer/TextureRect3
,$CenterContainer/HBoxContainer/TextureRect4
,$CenterContainer/HBoxContainer/TextureRect5
,$CenterContainer/HBoxContainer/TextureRect6]



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_order(list):
	for i in rect_list:
		i.texture = null
	for i in range(list.size()):
		if i < rect_list.size():
			rect_list[i].texture = list[i].icon
