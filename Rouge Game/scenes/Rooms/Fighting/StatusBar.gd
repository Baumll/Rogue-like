extends Control


onready var Hbox = $HBoxContainer
var status_list = []
export(int) var max_Status = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	for _x in range(max_Status):
		status_list.append(null)

func load_list(list):
	for i in range(status_list.size()):
		if list.size() > i:
			if list[i] != null:
				Hbox.set_icon(list[i].icon, i)
			else:
				Hbox.set_icon(null,i)
		else:
			Hbox.set_icon(null,i)
