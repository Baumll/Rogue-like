extends Control


onready var leb = $Panel/HBoxContainer/Label
onready var lablDMG = $Panel/HBoxContainer/Label2


# Called when the node enters the scene tree for the first time.
func _ready():
	set_text("")

func set_move_text(move):
	set_text(move.description)
	var txt = ""
	if move.physical_dmg > 0:
		txt += "Dmg: " + str(move.physical_dmg) + "\n"
	if move.magical_dmg > 0:
		txt += "Mag: " + str(move.magical_dmg) + "\n"
	if move.heal > 0:
		txt += "Heal: " + str(move.heal)
	lablDMG.text = txt 
	leb.update()

func set_item_text(item):
	set_text(item.description)
	leb.update()

func set_text(text):
	leb.text = text
	leb.update()



